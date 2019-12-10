(function () {
    return {
        config: {
            query: {
                code: 'db_Report_4',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [
                {
                    dataField: 'orgName',
                    caption: 'Назва установи',
                    width: 400,
                },  {
                    dataField: 'AllCount',
                    caption: 'Кількість звернень',
                    alignment: 'center',
                },  {
                    caption: 'Закриття виконавцем',
                    columns: [
                        {
                            caption: "Вчасно",
                            dataField: "inTimeQty",
                            alignment: 'center'
                        }, {
                            caption: "Не вчасно",
                            dataField: "outTimeQty",
                            alignment: 'center'
                        }, {
                            caption: "Прострочено",
                            dataField: "waitTimeQty",
                            alignment: 'center'
                        }
                    ]
                },  {
                    caption: 'Виконання звернень',
                    columns: [
                        {
                            caption: "Виконано",
                            dataField: "doneClosedQty",
                            alignment: 'center'
                        }, {
                            caption: "Не виконано",
                            dataField: "notDoneClosedQty",
                            alignment: 'center'
                        }, {
                            caption: "План/Програма",
                            dataField: "PlanProg",
                            alignment: 'center'
                        }, {
                            caption: "На перевірці",
                            dataField: "doneOnCheckQty",
                            alignment: 'center'
                        }
                    ]
                },  {
                    dataField: 'inWorkQty',
                    caption: 'В роботі',
                    alignment: 'center',
                },  {
                    dataField: 'inTimePercent',
                    caption: '% вчасно закритих',
                    alignment: 'center',
                    format: function(value){
                        return value + '%';
                    },        
                },  {
                    dataField: 'donePercent',
                    caption: '% виконання без План/Програма',
                    alignment: 'center',
                    format: function(value){
                        return value + '%';
                    },
                },  {
                    dataField: 'withPlanPercent',
                    caption: '% виконання з План/Програма',
                    alignment: 'center',
                    format: function(value){
                        return value + '%';
                    },
                } 
            ],
            summary: {
                totalItems: [
                    {
                        column: "AllCount",
                        summaryType: "sum",
                        customizeText: function(data) {
                            return "Разом: " + data.value;
                        }
                    },  {
                        column: "inTimeQty",
                        summaryType: "sum",
                        customizeText: function(data) {
                            return "Разом: " + data.value;
                        }
                    },  {
                        column: "outTimeQty",
                        summaryType: "sum",
                        customizeText: function(data) {
                            return "Разом: " + data.value;
                        }
                    },  {
                        column: "waitTimeQty",
                        summaryType: "sum",
                        customizeText: function(data) {
                            return "Разом: " + data.value;
                        }
                    },  {
                        column: "doneClosedQty",
                        summaryType: "sum",
                        customizeText: function(data) {
                            return "Разом: " + data.value;
                        }
                    },  {
                        column: "notDoneClosedQty",
                        summaryType: "sum",
                        customizeText: function(data) {
                            return "Разом: " + data.value;
                        }
                    },  {
                        column: "PlanProg",
                        summaryType: "sum",
                        customizeText: function(data) {
                            return "Разом: " + data.value;
                        }
                    },  {
                        column: "doneOnCheckQty",
                        summaryType: "sum",
                        customizeText: function(data) {
                            return "Разом: " + data.value;
                        }
                    },  {
                        column: "inWorkQty",
                        summaryType: "sum",
                        customizeText: function(data) {
                            return "Разом: " + data.value;
                        }
                    },  {
                        column: "inTimePercent",
                        summaryType: "avg",
                        format: "percent",
                        customizeText: function(data) {
                            return "Середнє: " + data.value.toFixed(2);
                        }
                    },  {
                        column: "donePercent",
                        summaryType: "avg",
                        format: "percent",
                        customizeText: function(data) {
                            return "Середнє: " + data.value.toFixed(2);
                        }
                    },  {
                        column: "withPlanPercent",
                        summaryType: "avg",
                        format: "percent",
                        customizeText: function(data) {
                            return "Середнє: " + data.value.toFixed(2);
                        }
                    }
                ]
                
            },
            keyExpr: 'Id',
            scrolling: {
                mode: 'virtual'
            },
            filterRow: {
                visible: true,
                applyFilter: "auto"
            },
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
            groupingAutoExpandAll: null,
        },

        summary: [],

        init: function() {
            this.summary = [];
            this.dataGridInstance.height = window.innerHeight - 200;
            this.sub = this.messageService.subscribe( 'GlobalFilterChanged', this.getFiltersParams, this );
            this.config.onToolbarPreparing = this.createTableButton.bind(this);

            this.config.onContentReady = this.afterRenderTable.bind(this);
        },

        afterRenderTable: function (data) {
            this.summary = [];
            const collections = document.querySelectorAll('.dx-row');
            collections.forEach( collection => {
                const summary = Array.prototype.slice.call(collection.cells, 0 );
                summary.forEach( cell => {
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
                widget: "dxButton", 
                location: "after",
                options: { 
                    icon: "exportxlsx",
                    type: "default",
                    text: "Excel",
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
                },
            });
        },

        createExcelWorkbook: function (data) {
            
              workbook = this.createExcel();
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
            this.setTableValues(data, columns, worksheet, rows);
            this.setTableRowsStyles(worksheet, rows);
            this.setSummaryValues(worksheet);
            
            this.helperFunctions.excel.save(workbook, 'Заявки', this.hidePagePreloader);
        },

        setColumnsProperties: function (columns, columnsProperties, worksheet) {
            for (let i = 0; i < columns.length; i++) {
                const column = columns[i];
                
                let header ;
                let index = 0;
                let width = column.dataField === 'orgName' ? 20 : 9;
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

        setWorksheetTitle: function (worksheet) {
            worksheet.mergeCells( 1, 1, 1, this.lastPosition );
            let title = worksheet.getCell(1, 1);
            title.value = 'Моніторинг та реагування на звернення громадян';
        },

        setTableHeader: function (columns, worksheet) {
            let position = 0;
            for (let i = 0; i < columns.length; i++) {
                const column = columns[i];
                
                if(column.columns) {
                    let headerPositionTo = position + column.columns.length;
                    let headerPositionFrom = position + 1;
                    worksheet.mergeCells( 3, headerPositionFrom, 3, headerPositionTo );
                    let headerCaption = worksheet.getCell(3, headerPositionFrom);
                    headerCaption.value = column.caption;
                    for (let j = 0; j < column.columns.length; j++) {
                        const element = column.columns[j];
                        position += 1;
                        worksheet.mergeCells( 4, position, 4, position );
                        let caption = worksheet.getCell(4, position);
                        caption.value = element.caption;
                    }
                } else {
                    position += 1;
                    worksheet.mergeCells( 3, position, 4, position );
                    let caption = worksheet.getCell(4, position);
                    caption.value = column.caption;
                }
            }
            this.lastPosition = position;
        },

        setTableValues: function (data, columns, worksheet, rows) {
            for (let i = 0; i < data.rows.length; i++) {
                let rowData = data.rows[i];
                let rowValues = [];
                rows.push( i + 5);
                for (let j = 2; j < rowData.values.length; j++) {
                    const value = rowData.values[j];
                    rowValues.push(value);
                }
                worksheet.addRow(rowValues);
                this.summaryStartRow = i + 7;
            }
        },

        setTableRowsStyles: function (worksheet, rows) {

            worksheet.getRow(1).font = { name: 'Times New Roman', family: 4, size: 14, underline: false, bold: true , italic: false};
            worksheet.getRow(1).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };    
            worksheet.getRow(3).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
            worksheet.getRow(3).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };    
            worksheet.getRow(4).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
            worksheet.getRow(4).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };  
            worksheet.getRow(1).height = 50;
            worksheet.getRow(3).height = 70;
            worksheet.getRow(4).height = 70;

            rows.forEach( row => {
                worksheet.getRow(row).height = 100;
                worksheet.getRow(row).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, italic: false};
                worksheet.getRow(row).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true }; 
                worksheet.getCell('A' + row).alignment = { vertical: 'middle', horizontal: 'left', wrapText: true };
            });
        },

        setSummaryValues: function (worksheet) {
            const values = [ " " ];
            this.summary.forEach( value => values.push(value));
            worksheet.addRow(values);
            const number = this.summaryStartRow - 1;
            this.setSummaryStyle(worksheet, number);
        },

        setSummaryStyle: function (worksheet, number) {
            worksheet.getRow(number).height = 50;
            worksheet.getRow(number).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, italic: false};
            worksheet.getRow(number).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true }; 
        },

        getFiltersParams: function(message) {
            let period = message.package.value.values.find(f => f.name === 'period').value;
            let questionType = message.package.value.values.find(f => f.name === 'questionType').value;
            let organization = message.package.value.values.find(f => f.name === 'organization').value;
            if( period !== null ){
                if( period.dateFrom !== '' && period.dateTo !== ''){
                        
                    this.dateFrom =  period.dateFrom;
                    this.dateTo = period.dateTo;
                    this.questionType = questionType === null ? 0 : questionType === '' ? 0 : questionType.value;
                    this.organization = organization === null ? 0 : organization === '' ? 0 : organization.value ;
                    this.config.query.parameterValues = [ 
                        {key: '@dateFrom' , value: this.dateFrom },  
                        {key: '@dateTo', value: this.dateTo },  
                        {key: '@question_type_id', value: this.questionType },  
                        {key: '@org', value: this.organization }  
                    ];
                    this.loadData(this.afterLoadDataHandler);
                }
            }
        },

        extractOrgValues: function(val) {
            if(val !== ''){
                const valuesList = [];
                valuesList.push(val.value);
                return  valuesList.length > 0 ? valuesList : [];
            } else {
                return [];
            };
        },    
        
        afterLoadDataHandler: function(data) {
            this.render();
        },

        destroy: function() {
            this.sub.unsubscribe();
        }, 
        
    };
}());
