(function() {
    return {
        config: {
            query: {
                code: 'db_ReestrRating1',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [
                {
                    dataField: 'RDAName',
                    caption: 'Назва установи',
                    fixed: true,
                    width: 200
                }, {
                    caption: 'Зареєстровано, В роботі, На доопрацюванні, На перевірці за попередній період',
                    alignItems: 'middle',
                    columns: [
                        {
                            dataField: 'PreviousPeriod_Total',
                            caption: 'Всього'
                        }, {
                            dataField: 'PreviousPeriod_Registered',
                            caption: 'Зареєстровано'
                        }, {
                            dataField: 'PreviousPeriod_InTheWorks',
                            caption: 'В роботі'
                        }, {
                            dataField: 'PreviousPeriod_InTest',
                            caption: 'На перевірці'
                        }, {
                            dataField: 'PreviousPeriod_ForRevision',
                            caption: 'На доопрацюванні'
                        }, {
                            dataField: 'PreviousPeriod_Closed',
                            caption: 'Закрито'
                        }
                    ]
                }, {
                    dataField: 'CurrentMonth_Total',
                    caption: 'Загальна кількість звернень за поточний місяць'
                }, {
                    caption: 'За поточний місяць',
                    alignItems: 'middle',
                    columns: [
                        {
                            dataField: 'CurrentMonth_Registered',
                            caption: 'Зареєстровано'
                        }, {
                            dataField: 'CurrentMonth_InTheWorks',
                            caption: 'В роботі'
                        }, {
                            dataField: 'CurrentMonth_InTest',
                            caption: 'На перевірці'
                        }, {
                            dataField: 'CurrentMonth_ForRevision',
                            caption: 'На доопрацюванні'
                        }, {
                            dataField: 'CurrentMonth_Closed',
                            caption: 'Закрито'
                        }
                    ]
                }, {
                    dataField: 'OfThem_Registered',
                    caption: 'з них, Зареєстровано'
                }, {
                    dataField: 'OfThem_AtWork',
                    caption: 'з них, В роботі'
                }, {
                    caption: 'На перевірці',
                    alignItems: 'middle',
                    columns: [
                        {
                            dataField: 'OnTest_Done',
                            caption: 'Виконано'
                        }, {
                            dataField: 'OnTest_Explained',
                            caption: 'Роз\'яснено'
                        }, {
                            dataField: 'OnTest_CannotBeExecutedAtThisTime',
                            caption: 'Не можливо виконанти в даний період'
                        }
                    ]
                }, {
                    caption: 'Результат виконання ( поточний місяць) (Закриті)',
                    alignItems: 'middle',
                    columns: [
                        {
                            dataField: 'ResultOfExecution_Done',
                            caption: 'Виконано'
                        }, {
                            dataField: 'ResultOfExecution_Explained',
                            caption: 'Роз\'яснено'
                        }, {
                            dataField: 'ResultOfExecution_Others',
                            caption: 'Інші'
                        }
                    ]
                }, {
                    dataField: 'ForRevision_All',
                    caption: 'На доопрацювання (Всього)'
                }, {
                    dataField: 'ForRevision_Total',
                    caption: 'На доопрацювання (прозвон)'
                }, {
                    caption: 'На доопрацювання (прозвон)',
                    alignItems: 'middle',
                    columns: [
                        {
                            dataField: 'ForRevision_1Time',
                            caption: '1 раз'
                        }, {
                            dataField: 'ForRevision_2Times',
                            caption: '2 рази'
                        }, {
                            dataField: 'ForRevision_3AndMore',
                            caption: '3 і більше'
                        }
                    ]
                }, {
                    caption: 'Розглянуті виконавцем',
                    alignItems: 'middle',
                    columns: [
                        {
                            dataField: 'ViewedByArtist_Total',
                            caption: 'Всі'
                        }, {
                            dataField: 'ViewedByArtist_WrongTime',
                            caption: 'Не вчасно'
                        }
                    ]
                }, {
                    dataField: 'PercentClosedOnTime',
                    caption: '% вчасно закритих',
                    format: function(value) {
                        return value.toFixed(2);
                    }
                }, {
                    dataField: 'PercentOfExecution',
                    caption: '% виконання',
                    format: function(value) {
                        return value.toFixed(2);
                    }
                }, {
                    dataField: 'PercentOnVeracity',
                    caption: '% достовірності',
                    format: function(value) {
                        return value.toFixed(2);
                    }
                }, {
                    dataField: 'IndexOfSpeedToExecution',
                    caption: 'Індекс швидкості виконання',
                    format: function(value) {
                        return value.toFixed(2);
                    }
                }, {
                    dataField: 'IndexOfSpeedToExplain',
                    caption: 'Індекс швидкості роз\'яснення',
                    format: function(value) {
                        return value.toFixed(2);
                    }
                }, {
                    dataField: 'IndexOfFactToExecution',
                    caption: 'Індекс фактичного виконання',
                    format: function(value) {
                        return value.toFixed(2);
                    }
                }, {
                    dataField: 'PercentPleasureOfExecution',
                    caption: '% задоволеність виконанням',
                    format: function(value) {
                        return value.toFixed(2);
                    }
                }, {
                    dataField: 'IntegratedMetric_PerformanceLevel',
                    caption: 'Рівень виконання',
                    format: function(value) {
                        return value.toFixed(2);
                    }
                }
            ],
            columnChooser: {
                enabled: true
            },
            sorting: {
                mode: 'multiple'
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
            groupingAutoExpandAll: null
        },
        init: function() {
            let msg = {
                name: 'SetFilterPanelState',
                package: {
                    value: true
                }
            };
            this.messageService.publish(msg);
            this.sub = this.messageService.subscribe('FiltersParams', this.setFiltersParams, this);
            this.sub1 = this.messageService.subscribe('ApplyGlobalFilters', this.renderTable, this);
            this.dataGridInstance.onCellClick.subscribe(e => {
                e.event.stopImmediatePropagation();
                if(e.column) {
                    if (e.row !== undefined
						&& e.column.dataField !== 'RDAName'
                        && e.column.dataField !== 'IntegratedMetric_PerformanceLevel'
                        && e.column.dataField !== 'PercentPleasureOfExecution'
                        && e.column.dataField !== 'IndexOfFactToExecution'
                        && e.column.dataField !== 'IndexOfSpeedToExplain'
                        && e.column.dataField !== 'IndexOfSpeedToExecution'
                        && e.column.dataField !== 'PercentOnVeracity'
                        && e.column.dataField !== 'PercentOfExecution'
                        && e.column.dataField !== 'PercentClosedOnTime'
                    ) {
                        const rdaid = e.data.RDAId;
                        const ratingid = e.data.RatingId;
                        const columncode = e.column.dataField;
                        const date = this.date;
                        const string = 'rdaid=' + rdaid + '&ratingid=' + ratingid + '&columncode=' + columncode + '&date=' + date;
                        window.open(
                            location.origin +
                            localStorage.getItem('VirtualPath') +
                            '/dashboard/page/district_rating_indicator?' +
                            string
                        );
                    }
                    if (e.row !== undefined && e.column.dataField === 'IntegratedMetric_PerformanceLevel') {
                        this.showPagePreloader('');
                        this.messageService.publish({ name: 'showInfo'});
                    }
                    if (e.row !== undefined &&
                        (
                            e.column.dataField === 'IndexOfSpeedToExecution' ||
                            e.column.dataField === 'IndexOfSpeedToExplain' ||
                            e.column.dataField === 'IndexOfFactToExecution'
                        )
                    ) {
                        window.open(
                            location.origin +
                            localStorage.getItem('VirtualPath') +
                            '/dashboard/page/rating_indexes'
                        );
                    }
                    if (e.column.dataField === 'RDAName') {
                        let rdaid = e.data.RDAId;
                        let ratingid = e.data.RatingId;
                        let date = this.date;
                        let string = 'RDAId=' + rdaid + '&RatingId=' + ratingid + '&DateCalc=' + date;
                        window.open(
                            location.origin +
                            localStorage.getItem('VirtualPath') +
                            '/dashboard/page/rating_indicators_detail?' +
                            string
                        );
                    }
                }
            });
            this.config.columns.forEach(col => {
                function setColStyles(col) {
                    col.width = col.dataField === 'RDAName' ? '200' : '120';
                    col.alignment = 'center';
                    col.verticalAlignment = 'Bottom';
                }
                if(col.columns) {
                    setColStyles(col);
                    col.columns.forEach(col => setColStyles(col));
                }else{
                    setColStyles(col);
                }
            });
            this.config.onContentReady = this.onMyContentReady.bind(this);
            this.config.onToolbarPreparing = this.createTableButton.bind(this);
        },
        setFiltersParams: function(message) {
            this.date = message.date;
            this.executor = message.executor;
            this.rating = message.rating;
            this.config.query.parameterValues = [
                {key: '@DateCalc' , value: this.date },
                {key: '@RDAId', value: this.executor },
                {key: '@RatingId', value: this.rating }
            ];
        },
        renderTable: function() {
            let msg = {
                name: 'SetFilterPanelState',
                package: {
                    value: false
                }
            };
            this.messageService.publish(msg);
            this.loadData(this.afterLoadDataHandler);
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
                    onClick: function(e) {
                        e.event.stopImmediatePropagation();
                        let exportQuery = {
                            queryCode: this.config.query.code,
                            limit: -1,
                            parameterValues: this.config.query.parameterValues
                        };
                        this.queryExecutor(exportQuery, this.myCreateExcel, this);
                        this.showPreloader = false;
                    }.bind(this)
                }
            });
        },
        myCreateExcel: function(data) {
            this.showPagePreloader('Зачекайте, формується документ');
            let visibleColumns = this.visibleColumns;
            this.columnsWithoutSub = [];
            let workbook = this.createExcel();
            let worksheet = workbook.addWorksheet('Заявки', {
                pageSetup:{
                    orientation: 'landscape',
                    fitToPage: false
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
            cellInfoDate.value = 'за: ' + this.date;
            let emptyCellInfoCaption = worksheet.getCell('A3');
            emptyCellInfoCaption.value = ' ';
            worksheet.mergeCells(1,visibleColumns.length,1,1);
            worksheet.mergeCells(2,visibleColumns.length,2,1);
            worksheet.mergeCells(3,visibleColumns.length,3,1);
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
            for (let i = 0; i < this.config.columns.length; i++) {
                let column = this.config.columns[i];
                let colCaption = column.caption;
                if(!column.dataField) {
                    column.columns.forEach(col => {
                        let length = 0;
                        let colIndexTo = 0;
                        if(this.subColumnCaption.length > 0) {
                            if(this.subColumnCaption[this.subColumnCaption.length - 1].colCaption !== colCaption) {
                                let obj = {
                                    colCaption,
                                    length,
                                    colIndexTo
                                }
                                this.subColumnCaption.push(obj);
                                this.subIndex++;
                            }
                        } else{
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
                let index = this.allColumns.findIndex(el => el.dataField === df);
                resultColumns.push(this.allColumns[index]);
            }
            for (let i = 0; i < resultColumns.length; i++) {
                const resCol = resultColumns[i];
                const colIndexTo = i + 1;
                let indexCaptionFrom;
                if(resCol.isSub === true) {
                    if(this.subColumnCaption.length > 0) {
                        let group = this.subColumnCaption[resCol.index];
                        if(group.colCaption === resCol.caption) {
                            group.length++;
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
                worksheet.mergeCells(indexCaptionFrom, colIndexTo, 5, colIndexTo);
            }
            this.subColumnCaption.forEach(col => {
                let indexFrom = col.colIndexTo - col.length + 1;
                let indexTo = col.colIndexTo;
                if(col.length > 0) {
                    worksheet.mergeCells(4, indexFrom, 4, indexTo);
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
                    let index = data.columns.findIndex(el => el.code === element.dataField);
                    rowValues[j] = rowData.values[index];
                }
                worksheet.addRow(rowValues);
            }
            this.helperFunctions.excel.save(workbook, 'Заявки', this.hidePagePreloader);
        },
        afterLoadDataHandler: function() {
            this.render();
        },
        onMyContentReady: function() {
            this.visibleColumns = this.dataGridInstance.instance.getVisibleColumns();
        },
        destroy: function() {
            this.sub.unsubscribe();
            this.sub1.unsubscribe();
        }
    };
}());
