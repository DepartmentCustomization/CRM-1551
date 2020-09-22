(function() {
    return {
        config: {
            query: {
                code: 'h_DB_ProApp_SubTable',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [
                {
                    dataField: 'registration_number',
                    caption: 'Номер питання'
                }, {
                    dataField: 'registration_date',
                    caption: 'Дата реєстрації',
                    sortOrder: 'asc'
                }, {
                    dataField: 'QuestionType',
                    caption: 'Тип питання'
                }, {
                    dataField: 'place_problem',
                    caption: 'Місце проблеми'
                }, {
                    dataField: 'control_date',
                    caption: 'Дата контролю'
                }, {
                    dataField: 'vykonavets',
                    caption: 'Виконавець'
                }, {
                    dataField: 'comment',
                    caption: 'Коментар'
                }
            ],
            masterDetail: {
                enabled: true
            },
            filterRow: {
                visible: true,
                applyFilter: 'auto'
            },
            pager: {
                showPageSizeSelector:  true,
                allowedPageSizes: [10, 50, 100, 500],
                showInfo: true
            },
            paging: {
                pageSize: 500
            },
            scrolling: {
                mode: 'standart',
                rowRenderingMode: null,
                columnRenderingMode: null,
                showScrollbar: null
            },
            searchPanel: {
                visible: false,
                highlightCaseSensitive: true
            },
            sorting: {
                mode: 'multiple'
            },
            editing: {
                mode: 'cell',
                allowUpdating: true,
                useIcons: false
            },
            selection: {},
            keyExpr: 'Id',
            focusedRowEnabled: true,
            showBorders: false,
            showColumnLines: false,
            showRowLines: true,
            remoteOperations: null,
            allowColumnReordering: null,
            rowAlternationEnabled: null,
            columnAutoWidth: null,
            hoverStateEnabled: true,
            columnWidth: null,
            wordWrapEnabled: true,
            allowColumnResizing: true,
            showFilterRow: true,
            showHeaderFilter: false,
            showColumnChooser: false,
            showColumnFixing: true,
            groupingAutoExpandAll: null
        },
        arrivedColumn: 'arrived',
        isEvent: false,
        event: 'Заходи',
        init: function() {
            this.dataGridInstance.height = window.innerHeight - 405;
            this.tableContainer = document.getElementById('subTable');
            this.setVisibilityTableContainer('none');
            this.subscribers.push(this.messageService.subscribe('clickOnHeaderTable', this.changeOnTable, this));
            this.subscribers.push(this.messageService.subscribe('hideSubTable', this.hideTable, this));
            this.config.masterDetail.template = this.createMasterDetail.bind(this);
            this.config.onContentReady = this.afterRenderTable.bind(this);
            this.dataGridInstance.onCellClick.subscribe(e => {
                if(e.column.dataField === 'registration_number' && e.row !== undefined) {
                    const id = this.isEvent ? e.data.registration_number : e.data.Id;
                    const form = this.Event ? 'Assignments' : 'Assignments';
                    window.open(`${location.origin}${localStorage.getItem('VirtualPath')}/sections/${form}/edit/${id}`);
                }
            });
        },
        createMasterDetail: function(container, options) {
            const currentEmployeeData = options.data;
            const name = 'createMasterDetail';
            const fields = {
                zayavnyk: 'Заявник',
                ZayavnykAdress: 'Адреса заявника',
                content: 'Зміст'
            };
            this.messageService.publish({
                name, currentEmployeeData, fields, container
            });
        },
        setVisibilityTableContainer: function(status) {
            this.tableContainer.style.display = status;
        },
        changeOnTable: function(message) {
            if (message.code && message.navigator) {
                this.isEvent = message.navigator === this.event ? true : false;
                this.config.selection.mode = 'single';
                if (message.code === this.arrivedColumn) {
                    this.config.selection.mode = 'multiple';
                }
                this.config.onToolbarPreparing = this.createTableButton.bind(this, message.code);
                this.setVisibilityTableContainer('block');
                this.config.query.parameterValues = [
                    { key: '@navigator', value: message.navigator},
                    { key: '@column', value: message.code}
                ];
                this.loadData(this.afterLoadDataHandler);
            } else {
                this.hideTable();
            }

        },
        createTableButton: function(code, e) {
            let toolbarItems = e.toolbarOptions.items;
            toolbarItems.push({
                widget: 'dxButton',
                location: 'after',
                options: {
                    icon: 'exportxlsx',
                    type: 'default',
                    text: 'Excel',
                    onClick: function() {
                        this.executeExportExcelQuery();
                    }.bind(this)
                }
            });
            if (code === this.arrivedColumn) {
                toolbarItems.push({
                    widget: 'dxButton',
                    name: 'transfer',
                    options: {
                        icon: 'upload',
                        type: 'default',
                        text: 'Передано',
                        onClick: function() {
                            this.findAllSelectedRows();
                        }.bind(this)
                    },
                    location: 'after'
                });
            }
        },
        executeExportExcelQuery: function() {
            this.showPagePreloader('Зачекайте, формується документ');
            let exportQuery = {
                queryCode: this.config.query.code,
                limit: -1,
                parameterValues: this.config.query.parameterValues
            }
            this.queryExecutor(exportQuery, this.createExcelWorkbook, this);
            this.showPreloader = false;
        },
        findAllSelectedRows: function() {
            const selectedRows = this.dataGridInstance.instance.getSelectedRowsData();
            if (selectedRows.length) {
                this.promiseAll = [];
                this.messageService.publish({name: 'showPagePreloader'});
                selectedRows.forEach(row => {
                    const queryPromise = new Promise((resolve) => {
                        let executeQuery = {
                            queryCode: 'h_ButtonTransferred',
                            parameterValues: [
                                {key: '@Id', value: row.Id},
                                {key: '@comment', value: row.comment}
                            ],
                            limit: -1
                        };
                        this.queryExecutor(executeQuery, this.changeRowDataCallBack.bind(this, resolve), this);
                    });
                    this.promiseAll.push(queryPromise);
                });
                Promise.all(this.promiseAll).then(() => {
                    this.promiseAll = [];
                    this.dataGridInstance.instance.deselectAll();
                    this.loadData(this.afterLoadDataHandler);
                    this.hideTable();
                    this.messageService.publish({
                        name: 'reloadMainTable'
                    });
                });
            }
        },
        hideTable: function() {
            this.setVisibilityTableContainer('none');
        },
        changeRowDataCallBack: function(resolve, data) {
            resolve(data);
        },
        afterLoadDataHandler: function() {
            this.render();
        },
        afterRenderTable: function() {
            this.messageService.publish({ name: 'afterRenderTable', code: this.config.query.code });
        },
        createElement: function(tag, props, ...children) {
            const element = document.createElement(tag);
            Object.keys(props).forEach(key => element[key] = props[key]);
            if(children.length > 0) {
                children.forEach(child =>{
                    element.appendChild(child);
                });
            } return element;
        },
        createExcelWorkbook: function(data) {
            const workbook = this.createExcel();
            const worksheet = workbook.addWorksheet('Заявки', {
                pageSetup:{
                    orientation: 'landscape',
                    fitToPage: false,
                    margins: {
                        left: 0.4, right: 0.3,
                        top: 0.4, bottom: 0.4,
                        header: 0.0, footer: 0.0
                    }
                }
            });
            this.excelHeadRowStart = 4;
            this.excelHeadRowEnd = 4;
            const columns = this.config.columns;
            const columnsProperties = [];
            const rows = [];
            this.setColumnsProperties(columns, columnsProperties, worksheet);
            this.setTableHeader(columns, worksheet);
            this.setWorksheetTitle(worksheet);
            this.setTableValues(data, worksheet, rows);
            this.setTableRowsStyles(worksheet, rows);
            this.helperFunctions.excel.save(workbook, 'Заявки', this.hidePagePreloader);
        },
        setColumnsProperties: function(columns, columnsProperties, worksheet) {
            for (let i = 0; i < columns.length; i++) {
                const column = columns[i];
                let header;
                let index = 0;
                let width = 19;
                let columnProp = { header, width, index };
                if(column.columns) {
                    for (let j = 0; j < column.columns.length; j++) {
                        const subColumn = column.columns[j];
                        columnProp.index += 1;
                        columnProp.header = subColumn.caption;
                        columnsProperties.push(columnProp);
                    }
                } else {
                    columnProp.header = column.caption;
                    columnProp.index += 1;
                    columnsProperties.push(columnProp);
                }
            }
            worksheet.columns = columnsProperties;
        },
        setTableHeader: function(columns, worksheet) {
            let position = 0;
            for (let i = 0; i < columns.length; i++) {
                const column = columns[i];
                position += 1;
                worksheet.mergeCells(this.excelHeadRowStart, position, this.excelHeadRowEnd, position);
                const cell = worksheet.getCell(this.excelHeadRowEnd, position);
                cell.value = column.caption;
                this.setCellStyle(cell);
            }
            this.lastPosition = position;
        },
        setWorksheetTitle: function(worksheet) {
            worksheet.mergeCells(1, 1, 1, 7);
            const title = worksheet.getCell(1, 1);
            title.value = 'Інформація';
            worksheet.mergeCells(2, 1, 2, 7);
            const description = worksheet.getCell(2, 1);
            description.value = 'про звернення громадян, що надійшли до Служби мера'
        },
        setTableValues: function(data, worksheet, rowNumbers) {
            for (let i = 0; i < data.rows.length; i++) {
                const rowData = data.rows[i];
                const rowStart = this.excelHeadRowStart + 1 + i;
                rowNumbers.push(rowStart);
                for (let j = 1; j < rowData.values.length - 3; j++) {
                    const value = rowData.values[j];
                    const cell = worksheet.getCell(rowStart, j);
                    if (j === 2 || j === 5) {
                        cell.value = this.changeDateTimeValues(value);
                    } else {
                        cell.value = value;
                    }
                    this.setCellStyle(cell);
                }
            }
        },
        setTableRowsStyles: function(worksheet, rowNumbers) {
            worksheet.getRow(1).font = {
                name: 'Times New Roman',
                family: 4,
                size: 14,
                underline: false,
                bold: true,
                italic: false
            };
            worksheet.getRow(1).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };
            worksheet.getRow(2).font = {
                name: 'Times New Roman',
                family: 4,
                size: 14,
                underline: false,
                bold: true,
                italic: false
            };
            worksheet.getRow(2).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };
            worksheet.getRow(3).font = {
                name: 'Times New Roman',
                family: 4,
                size: 10,
                underline: false,
                bold: true,
                italic: false
            };
            worksheet.getRow(3).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };
            worksheet.getRow(4).font = {
                name: 'Times New Roman',
                family: 4,
                size: 10,
                underline: false,
                bold: true,
                italic: false
            };
            worksheet.getRow(4).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };
            worksheet.getRow(1).height = 30;
            worksheet.getRow(2).height = 30;
            worksheet.getRow(3).height = 40;
            worksheet.getRow(4).height = 40;
            rowNumbers.forEach(number => {
                worksheet.getRow(number).height = 90;
                worksheet.getRow(number).font = {
                    name: 'Times New Roman',
                    family: 4,
                    size: 10,
                    underline: false,
                    italic: false
                };
                worksheet.getRow(number).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };
                worksheet.getCell('A' + number).alignment = { vertical: 'middle', horizontal: 'left', wrapText: true };
            });
        },
        setCellStyle: function(cell) {
            cell.border = { top: {style:'thin'}, left: {style:'thin'}, bottom: {style:'thin'}, right: {style:'thin'} };
            cell.alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };
            cell.font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: false , italic: false };
        },
        changeDateTimeValues: function(value) {
            let date = new Date(value);
            let dd = date.getDate().toString();
            let mm = (date.getMonth() + 1).toString();
            let yyyy = date.getFullYear().toString();
            dd = dd.length === 1 ? '0' + dd : dd;
            mm = mm.length === 1 ? '0' + mm : mm;
            return `${dd}.${mm}.${yyyy}`;
        }
    };
}());
