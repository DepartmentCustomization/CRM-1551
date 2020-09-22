(function() {
    return {
        config: {
            query: {
                code: 'db_so_MainTable',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            paging: {
                pageSize: 10
            },
            pager: {
                showPageSizeSelector: true,
                allowedPageSizes: [10, 25, 50, 100]
            },
            export: {
                fileName: 'operator statistics'
            },
            focusedRowEnabled: true,
            remoteOperations: false,
            allowColumnReordering: true,
            allowColumnResizing: true,
            wordWrapEnabled: true,
            rowAlternationEnabled: true,
            hoverStateEnabled: true,
            filterRow: { visible: true },
            keyExpr: 'Id',
            columns: [
                {
                    caption:'Оператор',
                    dataField:'user_name',
                    width: 400},
                {
                    caption: 'Загальна кількість прийнятих дзвінків',
                    dataField:'count_call'
                },
                {
                    caption: 'Кількість дзвінків тривалістю до 10 сек',
                    dataField:'count_10sec'
                },
                {
                    caption: 'Загальна кількість зареєстрованих',
                    columns: [
                        {
                            caption: 'Звернень',
                            dataField: 'count_appeals',
                            format: 'fixedPoint'
                        },
                        {
                            caption: 'Питань',
                            dataField: 'count_questions'
                        }]
                },
                {
                    caption: 'Загальна кількість зареєстрованих консультацій',
                    columns: [
                        {
                            caption: 'База знань',
                            dataField: 'consult3',
                            format: 'fixedPoint',
                            sortOrder: 'desc'
                        },
                        {
                            caption: 'Городок',
                            dataField: 'consult2'
                        },
                        {
                            caption: 'Питання',
                            dataField: 'consult1'
                        },
                        {
                            caption: 'Захід',
                            dataField: 'consult4'
                        }
                    ]},
                {
                    caption: 'Час витрачений на консультацію',
                    dataField: 'avg_cons_sec'
                },
                {
                    caption: 'Кількість звернень без реєстрації питання та консультації',
                    dataField: 'count_appeal_call',
                    width: 130
                },
                {
                    caption: '% інформації що залишився не зареєстрованою',
                    dataField: 'pro_appeal_call',
                    width: 150,
                    format: {
                        type: 'percent',
                        precision: 1
                    }
                }],
            summary: {
                totalItems: [
                    {
                        column: 'count_call',
                        summaryType: 'sum',
                        customizeText: function(data) {
                            return 'Разом: ' + data.value;
                        }
                    }, {
                        column: 'count_10sec',
                        summaryType: 'sum',
                        customizeText: function(data) {
                            return 'Разом: ' + data.value;
                        }
                    }, {
                        column: 'count_appeals',
                        summaryType: 'sum',
                        customizeText: function(data) {
                            return 'Разом: ' + data.value;
                        }
                    }, {
                        column: 'count_questions',
                        summaryType: 'sum',
                        customizeText: function(data) {
                            return 'Разом: ' + data.value;
                        }
                    }, {
                        column: 'consult3',
                        summaryType: 'sum',
                        customizeText: function(data) {
                            return 'Разом: ' + data.value;
                        }
                    }, {
                        column: 'consult2',
                        summaryType: 'sum',
                        customizeText: function(data) {
                            return 'Разом: ' + data.value;
                        }
                    }, {
                        column: 'consult1',
                        summaryType: 'sum',
                        customizeText: function(data) {
                            return 'Разом: ' + data.value;
                        }
                    }, {
                        column: 'consult4',
                        summaryType: 'sum',
                        customizeText: function(data) {
                            return 'Разом: ' + data.value;
                        }
                    }, {
                        column: 'avg_cons_sec',
                        summaryType: 'sum',
                        customizeText: function(data) {
                            return 'Разом: ' + data.value;
                        }
                    }
                ]
            },
            showBorders: true
        },
        init: function() {
            this.summary = [];
            this.subscribers.push(this.messageService.subscribe('GlobalFilterChanged', this.getFiltersParams, this));
            this.sendQuery = true;
            this.subscribers.push(this.messageService.subscribe('ApplyGlobalFilters', this.applyCallBack, this));
            this.config.onToolbarPreparing = this.createTableButton.bind(this);
            this.config.onContentReady = this.afterRenderTable.bind(this);
        },
        applyCallBack() {
            const msg = {
                name: 'SetFilterPanelState',
                package: {
                    value: false
                }
            };
            this.messageService.publish(msg);
            this.config.query.parameterValues = [
                {key: '@date_from' , value: this.dateFrom },
                {key: '@date_to', value: this.dateTo },
                {key: '@organizations_Id', value: this.deptsValue}
            ];
            this.loadData(this.afterLoadDataHandler);
        },
        afterRenderTable: function() {
            this.summary = [];
            const collections = document.querySelectorAll('.dx-row');
            collections.forEach(collection => {
                const summary = Array.prototype.slice.call(collection.cells, 0);
                summary.forEach(cell => {
                    const sum = cell.innerText.slice(0, 5);
                    if(sum === 'Разом' || sum === 'Серед') {
                        this.summary.push(cell.innerText);
                    }
                });
            });
        },
        createTableButton: function(e) {
            let toolbarItems = e.toolbarOptions.items;
            toolbarItems.push({
                widget: 'dxButton',
                location: 'after',
                options: {
                    icon: 'exportxlsx',
                    type: 'default',
                    text: 'Excel',
                    onClick: function() {
                        this.dataGridInstance.instance.exportToExcel();
                    }.bind(this)
                }
            });
        },
        createExcelWorkbook: function(data) {
            let workbook = this.createExcel();
            let worksheet = workbook.addWorksheet('Статистика по операторах', {
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
            this.setTableValues(data, columns, worksheet, rows);
            this.setTableRowsStyles(worksheet, rows);
            this.setSummaryValues(worksheet);
            this.helperFunctions.excel.save(workbook, 'Статистика по операторах', this.hidePagePreloader);
        },
        setColumnsProperties: function(columns, columnsProperties, worksheet) {
            for (let i = 0; i < columns.length; i++) {
                const column = columns[i];
                let header;
                let index = 0;
                let width = 10;
                let columnProp = { header, width, index };
                if(column.columns) {
                    for (let j = 0; j < column.columns.length; j++) {
                        const subColumn = column.columns[j];
                        columnProp.index += 1;
                        header = subColumn.caption;
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
            title.value = 'Статистика по операторах';
        },
        setTableHeader: function(columns, worksheet) {
            let position = 0;
            for (let i = 0; i < columns.length; i++) {
                const column = columns[i];
                if(column.columns) {
                    let headerPositionTo = position + column.columns.length;
                    let headerPositionFrom = position + 1;
                    worksheet.mergeCells(3, headerPositionFrom, 3, headerPositionTo);
                    let headerCaption = worksheet.getCell(3, headerPositionFrom);
                    headerCaption.value = column.caption;
                    for (let j = 0; j < column.columns.length; j++) {
                        const element = column.columns[j];
                        position += 1;
                        worksheet.mergeCells(4, position, 4, position);
                        let caption = worksheet.getCell(4, position);
                        caption.value = element.caption;
                    }
                } else {
                    position += 1;
                    worksheet.mergeCells(3, position, 4, position);
                    let caption = worksheet.getCell(4, position);
                    caption.value = column.caption;
                }
            }
            this.lastPosition = position;
        },
        setTableValues: function(data, columns, worksheet, rows) {
            for (let i = 0; i < data.rows.length; i++) {
                let rowData = data.rows[i];
                let rowValues = [];
                rows.push(i + 5);
                for (let j = 2; j < rowData.values.length; j++) {
                    const value = rowData.values[j];
                    rowValues.push(value);
                }
                worksheet.addRow(rowValues);
                this.summaryStartRow = i + 7;
            }
        },
        setTableRowsStyles: function(worksheet, rows) {
            worksheet.getRow(1).font = { name: 'Times New Roman', family: 4, size: 14, underline: false, bold: true , italic: false};
            worksheet.getRow(1).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };
            worksheet.getRow(3).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
            worksheet.getRow(3).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };
            worksheet.getRow(4).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
            worksheet.getRow(4).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };
            worksheet.getRow(1).height = 50;
            worksheet.getRow(3).height = 70;
            worksheet.getRow(4).height = 70;
            rows.forEach(row => {
                worksheet.getRow(row).height = 100;
                worksheet.getRow(row).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, italic: false};
                worksheet.getRow(row).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };
                worksheet.getCell('A' + row).alignment = { vertical: 'middle', horizontal: 'left', wrapText: true };
            });
        },
        setSummaryValues: function(worksheet) {
            const values = [ ' ' ];
            this.summary.forEach(value => values.push(value));
            worksheet.addRow(values);
            const number = this.summaryStartRow - 1;
            this.setSummaryStyle(worksheet, number);
        },
        setSummaryStyle: function(worksheet, number) {
            worksheet.getRow(number).height = 50;
            worksheet.getRow(number).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, italic: false};
            worksheet.getRow(number).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };
        },
        getFiltersParams: function(message) {
            const period = message.package.value.values.find(f => f.name === 'period').value;
            const kbuDepts = message.package.value.values.find(f => f.name === 'kbu-depts').value;

            if(period !== null) {
                if(period.dateFrom !== '' && period.dateTo !== '') {
                    this.deptsValue = null;
                    if(kbuDepts.length) {
                        this.deptsValue = kbuDepts.map(e=>{
                            return e.value
                        }).join(', ')
                    }
                    this.dateFrom = period.dateFrom;
                    this.dateTo = period.dateTo;
                    if(this.sendQuery) {
                        this.sendQuery = false;
                        this.applyCallBack();
                    }
                }
            }
        },
        extractValues: function(items) {
            if(items.length && items !== '') {
                const valuesList = [];
                items.forEach(item => valuesList.push(item.value));
                return valuesList;
            }
            return [];
        },
        afterLoadDataHandler: function(data) {
            this.messageService.publish({name: 'setData', rep1_data: data});
            this.render();
        }
    };
}());
