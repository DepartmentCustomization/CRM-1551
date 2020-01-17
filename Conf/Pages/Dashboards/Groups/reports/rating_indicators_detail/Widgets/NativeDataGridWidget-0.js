(function () {
    return {
        config: {
            query: {
                code: 'db_ReestrRating1_Detail',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [
                {
                    dataField: 'OrgName',
                    caption: 'Назва установи',
                    fixed: true
                }, {    
                    caption: 'Зареєстровано, В роботі, На доопрацюванні, На перевірці за попередній період',
                    alignItems: 'middle',
                    columns: [
                        {
                            dataField: 'PreviousPeriod_Total',
                            caption: 'Всього',
                        }, {
                            dataField: 'PreviousPeriod_Registered',
                            caption: 'Зареєстровано',
                        }, {
                            dataField: 'PreviousPeriod_InTheWorks',
                            caption: 'В роботі',
                        }, {
                            dataField: 'PreviousPeriod_InTest',
                            caption: 'На перевірці',
                        }, {
                            dataField: 'PreviousPeriod_ForRevision',
                            caption: 'На доопрацюванні',
                        }, {
                            dataField: 'PreviousPeriod_Closed',
                            caption: 'Закрито',
                        } 
                    ]
                }, {
                    dataField: 'CurrentMonth_Total',
                    caption: 'Загальна кількість звернень за поточний місяць',
                }, {
                    caption: 'За поточний місяць',
                    alignItems: 'middle',
                    columns: [
                        {
                            dataField: 'CurrentMonth_Registered',
                            caption: 'Зареєстровано',
                        }, {
                            dataField: 'CurrentMonth_InTheWorks',
                            caption: 'В роботі',
                        }, {
                            dataField: 'CurrentMonth_InTest',
                            caption: 'На перевірці',
                        }, {
                            dataField: 'CurrentMonth_ForRevision',
                            caption: 'На доопрацюванні',
                        }, {
                            dataField: 'CurrentMonth_Closed',
                            caption: 'Закрито',
                        } 
                    ]
                }, {
                    dataField: 'OfThem_Registered',
                    caption: 'з них, Зареєстровано',
                }, {
                    dataField: 'OfThem_AtWork',
                    caption: 'з них, В роботі',
                }, {
                    caption: 'На перевірці',
                    alignItems: 'middle',
                    columns: [
                        {
                            dataField: 'OnTest_Done',
                            caption: 'Виконано',
                        }, {
                            dataField: 'OnTest_Explained',
                            caption: 'Роз\'яснено',
                        }, {
                            dataField: 'OnTest_CannotBeExecutedAtThisTime',
                            caption: 'Не можливо виконанти в даний період',
                        }
                    ]
                }, {
                    caption: 'Результат виконання ( поточний місяць) (Закриті)',
                    alignItems: 'middle',
                    columns: [
                        {
                            dataField: 'ResultOfExecution_Done',
                            caption: 'Виконано',
                        }, {
                            dataField: 'ResultOfExecution_Explained',
                            caption: 'Роз\'яснено',
                        }, {
                            dataField: 'ResultOfExecution_Others',
                            caption: 'Інші',
                        }
                    ]
                }, {
                    dataField: 'ForRevision_All',
                    caption: 'На доопрацювання (Всього)',
                }, {
                    dataField: 'ForRevision_Total',
                    caption: 'На доопрацювання (прозвон)',
                }, {
                    caption: 'На доопрацювання (прозвон)',
                    alignItems: 'middle',
                    columns: [
                        {
                            dataField: 'ForRevision_1Time',
                            caption: '1 раз',
                        }, {
                            dataField: 'ForRevision_2Times',
                            caption: '2 рази',
                        }, {
                            dataField: 'ForRevision_3AndMore',
                            caption: '3 і більше',
                        }
                    ]
                }, {
                    caption: 'Розглянуті виконавцем',
                    alignItems: 'middle',
                    columns: [
                        {
                            dataField: 'ViewedByArtist_Total',
                            caption: 'Всі',
                        }, {
                            dataField: 'ViewedByArtist_WrongTime',
                            caption: 'Не вчасно',
                        }
                    ]
                }, {
                    dataField: 'PercentClosedOnTime',
                    caption: '% вчасно закритих',
                    format: function (value) {
                        return value.toFixed(2);
                    }
                }, {
                    dataField: 'PercentOfExecution',
                    caption: '% виконання',
                    format: function (value) {
                        return value.toFixed(2);
                    }
                }, {
                    dataField: 'PercentOnVeracity',
                    caption: '% достовірності',
                    format: function (value) {
                        return value.toFixed(2);
                    }
                }, {
                    dataField: 'IndexOfSpeedToExecution',
                    caption: 'Індекс швидкості виконання',
                    format: function (value) {
                        return value.toFixed(2);
                    }
                }, {
                    dataField: 'IndexOfSpeedToExplain',
                    caption: 'Індекс швидкості роз\'яснення',
                    format: function (value) {
                        return value.toFixed(2);
                    }
                }, {
                    dataField: 'IndexOfFactToExecution',
                    caption: 'Індекс фактичного виконання',
                    format: function (value) {
                        return value.toFixed(2);
                    }
                }, {
                    dataField: 'PercentPleasureOfExecution',
                    caption: '% задоволеність виконанням',
                    format: function (value) {
                        return value.toFixed(2);
                    }
                }, {
                    dataField: 'IntegratedMetric_PerformanceLevel',
                    caption: 'Рівень виконання',
                    format: function (value) {
                        return value.toFixed(2);
                    }
                }    
            ],
            columnChooser: {
                enabled: true
            },   
            showBorders: false,
            showColumnLines: true,
            showRowLines: true,
            remoteOperations: null,
            allowColumnReordering: null,
            rowAlternationEnabled: null,
            columnAutoWidth: true,
            hoverStateEnabled: true,
            columnWidth: null,
            wordWrapEnabled: true,
            allowColumnResizing: true,
            showFilterRow: true,
            showHeaderFilter: false,
            showColumnChooser: true,
            showColumnFixing: true,
            groupingAutoExpandAll: null,

        },
        init: function() {
            
        
            const getDataFromLink = window
                .location
                .search
                .replace('?', '')
                .split('&')
                .reduce(
                    function(p, e) {
                        var a = e.split('=');
                        p[decodeURIComponent(a[0])] = decodeURIComponent(a[1]);
                        return p;
                    }, {}
                );
    
            this.period = getDataFromLink["DateCalc"];
            this.executor = getDataFromLink["RDAId"] === null ? 0 :  getDataFromLink["RDAId"] === '' ? 0 : getDataFromLink["RDAId"];
            this.rating = getDataFromLink["RatingId"] === null ? 0 :  getDataFromLink["RatingId"] === '' ? 0 : getDataFromLink["RatingId"];
    
                
            this.renderTable();
        

            this.config.columns.forEach( col => {
                function setColStyles(col){
                    col.width = '120';
                    col.alignment = 'center';
                    col.verticalAlignment = 'Bottom';
                }
                if(col.columns){
                    setColStyles(col);
                    col.columns.forEach( col => setColStyles(col));
                }else{
                    setColStyles(col);
                }
            });
            

            this.dataGridInstance.height = window.innerHeight - 90;
            this.config.onContentReady = this.onMyContentReady.bind(this);
            this.config.onToolbarPreparing = this.createTableButton.bind(this);
        },
        renderTable: function (message) {
            this.config.query.parameterValues = [ 
                {key: '@DateCalc' , value: this.period },
                {key: '@RDAId', value: this.executor },  
                {key: '@RatingId', value: this.rating } 
            ];
            this.loadData(this.afterLoadDataHandler);
        },
        
        createTableButton: function (e) {
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
                        let exportQuery = {
                            queryCode: this.config.query.code,
                            limit: -1,
                            parameterValues: [
                                {key: '@DateCalc' , value: this.period },
                                {key: '@RDAId', value: this.executor },
                                {key: '@RatingId', value: this.rating }
                            ]
                        };
                        this.queryExecutor(exportQuery, this.myCreateExcel, this);
                    }.bind(this)
                },
            });
        },
        myCreateExcel: function (data) {
            this.showPagePreloader('Зачекайте, формується документ');
            let visibleColumns = this.visibleColumns;
            this.columnsWithoutSub = [];
            let workbook = this.createExcel();
            let worksheet = workbook.addWorksheet('Заявки', {
                pageSetup:{
                    orientation: 'landscape',
                    fitToPage: false,
                }
            });
            worksheet.pageSetup.margins = {
                left: 0.4, right: 0.3,
                top: 0.4, bottom: 0.4,
                header: 0.0, footer: 0.0
            };
            let cellInfoCaption = worksheet.getCell('A1');
            cellInfoCaption.value = 'Показники рейтингів';
            let cellInfoDate = worksheet.getCell('A2');
            cellInfoDate.value = 'за: ' + this.changeDateTimeValues(this.period);
            let emptyCellInfoCaption = worksheet.getCell('A3');
            // cellInfoDate.value = 'з: ' + this.changeDateTimeValues(this.period)+' , по: ' + this.changeDateTimeValues(this.dateTo);
            emptyCellInfoCaption.value = ' ';
            worksheet.mergeCells(1,visibleColumns.length,1,1); // top,left,bottom,right
            worksheet.mergeCells(2,visibleColumns.length,2,1); // top,left,bottom,right
            worksheet.mergeCells(3,visibleColumns.length,3,1); // top,left,bottom,right

            worksheet.getRow(1).font = { name: 'Times New Roman', family: 4, size: 16, underline: false, bold: true , italic: false};
            worksheet.getRow(1).alignment = { vertical: 'middle', horizontal: 'center' };
            worksheet.getRow(2).font = { name: 'Times New Roman', family: 4, size: 16, underline: false, bold: true , italic: false};
            worksheet.getRow(2).alignment = { vertical: 'middle', horizontal: 'center' };

            let captions = [];
            let columnsHeader = [];      
            for (let i = 0; i < visibleColumns.length; i++) {
                let column = visibleColumns[i];
                let caption = column.caption;
                captions.push(caption);

                let header = column.caption;
                let key = column.dataField;
                let width = 15;
                let index = 10;
                let columnProp = { header, key, width, index };
                columnsHeader.push(columnProp);    
            }
        
            worksheet.columns = columnsHeader;
            worksheet.getRow(5).values = captions;
            worksheet.getRow(5).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
            worksheet.getRow(4).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
            worksheet.getRow(5).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };
            worksheet.getRow(4).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };
            worksheet.getRow(4).height = 70;
            worksheet.getRow(5).height = 70;


            this.subColumnCaption = [];
            this.allColumns = [];
            this.subIndex = 0;
            let resultColumns = [];
            let lengthArray = [];

            for (let i = 0; i < this.config.columns.length; i++) {
                let column = this.config.columns[i];
                let colCaption = column.caption;
                if( !column.dataField ) {
                    column.columns.forEach( col => {
                        let length = 0;
                        let colIndexTo = 0;
                        if(this.subColumnCaption.length > 0){
                            if(this.subColumnCaption[this.subColumnCaption.length - 1].colCaption !== colCaption){
                                let obj = {
                                    colCaption,
                                    length,
                                    colIndexTo
                                }
                                this.subColumnCaption.push(obj);
                                this.subIndex++;
                            }
                        }
                        else{
                            let obj = {
                                colCaption,
                                length,
                                colIndexTo
                            }
                            this.subColumnCaption.push(obj);
                        }
                        let obj = {
                            isSub: true,
                            index: this.subIndex,
                            dataField: col.dataField,
                            caption: colCaption
                        }
                        this.allColumns.push(obj);
                    });
                }else{
                    let obj = {
                        isSub: false,
                        dataField: column.dataField,
                        caption: colCaption
                    }
                    this.allColumns.push(obj);
                }
            }
            for (let i = 0; i < visibleColumns.length; i++) {
                const visCol = visibleColumns[i];
                let df = visCol.dataField;
                let index = this.allColumns.findIndex( el => el.dataField === df ); 
                resultColumns.push(this.allColumns[index]);
            }
            
            for (let i = 0; i < resultColumns.length; i++) {
                const resCol = resultColumns[i];
                const colIndexTo = i+1;
                let indexCaptionFrom ;
                if( resCol.isSub === true ){
                    if(this.subColumnCaption.length > 0) {
                        let group = this.subColumnCaption[resCol.index];
                        if(group.colCaption === resCol.caption){
                            group.length ++;
                            group.colIndexTo = colIndexTo;
                        }
                    }
                    indexCaptionFrom = 5;
                }else{
                    let caption = resCol.caption;        
                    let column = { caption, colIndexTo }
                    indexCaptionFrom = 4;
                    this.columnsWithoutSub.push(column);
                }
                worksheet.mergeCells(indexCaptionFrom, colIndexTo, 5, colIndexTo );
            }
            
            this.subColumnCaption.forEach( col => {
                let indexFrom = col.colIndexTo - col.length + 1;
                let indexTo = col.colIndexTo;
                if( col.length > 0 ){
                    worksheet.mergeCells( 4, indexFrom, 4, indexTo );
                    let caption = worksheet.getCell(4, indexFrom);
                    caption.value = col.colCaption;
                }
            });

            for (let i = 0; i < this.columnsWithoutSub.length; i++) {
                let element = this.columnsWithoutSub[i];
                let caption = worksheet.getCell(4, element.colIndexTo);
                caption.value = element.caption;
            }

            for (let i = 0; i < data.rows.length; i++) {
                let rowData = data.rows[i];
                let rowValues = [];
                for (let j = 0; j < resultColumns.length; j++) {
                    const element = resultColumns[j];
                    let index = data.columns.findIndex(el => el.code === element.dataField );
                    let value = rowData.values[index];
                    if( typeof(value) === 'string' ) {
                        rowValues[j] = value;
                    }else{
                        let int = isInt(value);
                        rowValues[j] =  int === false ?  +value.toFixed(2) : value;
                    }
                }
                worksheet.addRow(rowValues);
            }
            function isInt(n) {
            return n % 1 === 0;
            }
            this.helperFunctions.excel.save(workbook, 'Заявки', this.hidePagePreloader);
        },
        
        changeDateTimeValues: function(value){
            
            let date = new Date(value);
            let dd = date.getDate().toString();
            let mm = (date.getMonth() + 1).toString();
            let yyyy = date.getFullYear().toString();
            let HH = date.getHours().toString();
            let MM = date.getMinutes().toString();

            dd = dd.length === 1 ? '0' + dd : dd;
            mm = mm.length === 1 ? '0' + mm : mm;
            HH = HH.length === 1 ? '0' + HH : HH;
            MM = MM.length === 1 ? '0' + MM : MM;
            return  dd + '.' + mm + '.' + yyyy + ' ' + HH + ':' + MM;
        },
        afterLoadDataHandler: function(data) {
            this.render();
        },
        onMyContentReady: function () {
            this.visibleColumns = this.dataGridInstance.instance.getVisibleColumns();
        }
    };
}());
