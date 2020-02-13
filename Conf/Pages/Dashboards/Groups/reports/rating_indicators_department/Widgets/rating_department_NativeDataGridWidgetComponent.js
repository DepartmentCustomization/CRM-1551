(function() {
    return {
        config: {
            query: {
                code: 'ak_Rating_Department',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [
                {
                    dataField: 'Organization_name',
                    caption: 'Назва організації',
                    width: 400
                }, {
                    caption: 'Загальна кількість',
                    alignItems: 'middle',
                    columns: [
                        {
                            dataField: 'ReestrZKMM',
                            caption: 'Минулий період'
                        }, {
                            dataField: 'ReestrZKPM',
                            caption: 'Поточний місяць'
                        }
                    ]
                }, {
                    dataField: 'ReestrZNZ',
                    caption: 'з них, Зареєстровано'
                }, {
                    dataField: 'ReestrZNVR',
                    caption: 'з них, В роботі'
                }, {
                    caption: 'Закриття виконавцем',
                    alignItems: 'middle',
                    columns: [
                        {
                            dataField: 'ReestrZVV',
                            caption: 'Вчасно'
                        }, {
                            dataField: 'ReestrZVNV',
                            caption: 'Не вчасно'
                        }, {
                            dataField: 'ReestrZVP',
                            caption: 'Прострочено'
                        }
                    ]
                }, {
                    dataField: 'Vids_vz',
                    caption: '% вчасно закритих'
                }
            ],
            keyExpr: 'Id',
            showBorders: false,
            showColumnLines: true,
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
        init: function() {
            this.dataGridInstance.height = window.innerHeight - 100;
            this.sub = this.messageService.subscribe('setFiltersParams', this.setQueryParams, this);
            this.config.onToolbarPreparing = this.createTableButton.bind(this);
            this.config.onContentReady = this.afterRenderTable.bind(this);
            this.config.columns.forEach(col => {
                if (col.columns) {
                    col.columns.forEach(col => setColStyles(col));
                }
                setColStyles(col);
                function setColStyles(col) {
                    col.alignment = col.dataField === 'Organization_name' ? 'left' : 'center';
                    col.verticalAlignment = 'Bottom';
                }
            });
            this.dataGridInstance.onCellClick.subscribe(e => {
                e.event.stopImmediatePropagation();
                if(e.column) {
                    if (e.row !== undefined
						&& e.column.dataField !== 'Organization_name'
                        && e.column.dataField !== 'Vids_vz'
                    ) {
                        const orgId = e.data.Id;
                        const date = this.date;
                        const query = e.column.dataField;
                        const string = 'orgId=' + orgId + '&date=' + date + '&query=' + query;
                        window.open(
                            location.origin + localStorage.getItem('VirtualPath') +
                            '/dashboard/page/rating_indicators_department_organization?' + string
                        );
                    }
                }
            });
        },
        afterRenderTable: function() {
            this.messageService.publish({ name: 'setStyles'});
        },
        createTableButton: function(e) {
            const toolbarItems = e.toolbarOptions.items;
            toolbarItems.push({
                widget: 'dxButton',
                location: 'after',
                options: {
                    icon: 'exportxlsx',
                    type: 'default',
                    text: 'Excel',
                    onClick: function(e) {
                        e.event.stopImmediatePropagation();
                        this.showPagePreloader('Зачекайте, формується документ');
                        let exportQuery = {
                            queryCode: this.config.query.code,
                            limit: -1,
                            parameterValues: this.config.query.parameterValues
                        }
                        this.queryExecutor(exportQuery, this.createExcelWorkbook, this);
                        this.showPreloader = false;
                    }.bind(this)
                }
            });
        },
        createExcelWorkbook: function(data) {
            const workbook = this.createExcel();
            let worksheet = workbook.addWorksheet('Заявки', {
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
                let width = column.dataField === 'Organization_name' ? 22 : 13;
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
        setWorksheetTitle: function(worksheet) {
            worksheet.mergeCells(1, 1, 1, this.lastPosition);
            let title = worksheet.getCell(1, 1);
            title.value = 'Показники рейтингу Департаментів';
        },
        setTableHeader: function(columns, worksheet) {
            let position = 0;
            for (let i = 0; i < columns.length; i++) {
                const column = columns[i];
                if (column.columns) {
                    let headerPositionTo = position + column.columns.length;
                    let headerPositionFrom = position + 1;
                    worksheet.mergeCells(3, headerPositionFrom, 3, headerPositionTo);
                    let headerCaption = worksheet.getCell(3, headerPositionFrom);
                    headerCaption.value = column.caption;
                    this.setCellStyle(headerCaption);
                    for (let j = 0; j < column.columns.length; j++) {
                        const element = column.columns[j];
                        position += 1;
                        worksheet.mergeCells(4, position, 4, position);
                        const cell = worksheet.getCell(4, position);
                        cell.value = element.caption;
                        this.setCellStyle(cell);
                    }
                } else {
                    position += 1;
                    worksheet.mergeCells(3, position, 4, position);
                    const cell = worksheet.getCell(4, position);
                    cell.value = column.caption;
                    this.setCellStyle(cell);
                }
            }
            this.lastPosition = position;
        },
        setTableValues: function(data, worksheet, rowNumbers) {
            for (let i = 0; i < data.rows.length; i++) {
                const rowData = data.rows[i];
                const rowStart = i + 5;
                rowNumbers.push(rowStart);
                for (let j = 1; j < rowData.values.length; j++) {
                    const value = rowData.values[j];
                    const cell = worksheet.getCell(rowStart, j);
                    cell.value = value;
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
            worksheet.getRow(3).height = 40;
            worksheet.getRow(4).height = 40;
            rowNumbers.forEach(number => {
                worksheet.getRow(number).height = 50;
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
        setQueryParams: function(message) {
            this.date = message.date;
            this.config.query.parameterValues = [ { key: '@Date', value: this.date}];
            this.loadData(this.afterLoadDataHandler);
        },
        afterLoadDataHandler: function() {
            this.render();
        },
        destroy: function() {
            this.sub.unsubscribe();
        }
    };
}());
