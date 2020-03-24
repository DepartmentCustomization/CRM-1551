(function() {
    return {
        config: {
            query: {
                code: 'db_Report_7_5',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [
                {
                    dataField: 'source',
                    caption: ' ',
                    width: 200
                },
                {
                    caption: 'у тому числі питання:',
                    columns: [
                        {
                            caption: 'діяльність об’єднань громадян, релігії та міжконфесійних відносин',
                            alignment: 'center',
                            height: 150,
                            columns: [
                                {
                                    caption: 'previousYear',
                                    dataField: 'prevReligy',
                                    alignment: 'center',
                                    customizeText: function(cellInfo) {
                                        let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                        return value;
                                    }
                                }, {
                                    caption: 'currentYear',
                                    dataField: 'curReligy',
                                    alignment: 'center',
                                    customizeText: function(cellInfo) {
                                        let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                        return value;
                                    }
                                }
                            ]
                        }, {
                            caption: 'діяльність центральних органів виконавчої влади',
                            alignment: 'center',
                            columns: [
                                {
                                    caption: 'previousYear',
                                    dataField: 'prevCentralExecutePower',
                                    alignment: 'center',
                                    customizeText: function(cellInfo) {
                                        let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                        return value;
                                    }
                                }, {
                                    caption: 'currentYear',
                                    dataField: 'curCentralExecutePower',
                                    alignment: 'center',
                                    customizeText: function(cellInfo) {
                                        let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                        return value;
                                    }
                                }
                            ]
                        }, {
                            caption: 'діяльність місцевих органів виконавчої влади',
                            alignment: 'center',
                            columns: [
                                {
                                    caption: 'previousYear',
                                    dataField: 'prevLocalExecutePower',
                                    alignment: 'center',
                                    customizeText: function(cellInfo) {
                                        let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                        return value;
                                    }
                                }, {
                                    caption: 'currentYear',
                                    dataField: 'curLocalExecutePower',
                                    alignment: 'center',
                                    customizeText: function(cellInfo) {
                                        let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                        return value;
                                    }
                                }
                            ]
                        }, {
                            caption: 'діяльність органів місцевого самоврядування',
                            alignment: 'center',
                            columns: [
                                {
                                    caption: 'previousYear',
                                    dataField: 'prevLocalMunicipalitet',
                                    alignment: 'center',
                                    customizeText: function(cellInfo) {
                                        let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                        return value;
                                    }
                                }, {
                                    caption: 'currentYear',
                                    dataField: 'curLocalMunicipalitet',
                                    alignment: 'center',
                                    customizeText: function(cellInfo) {
                                        let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                        return value;
                                    }
                                }
                            ]
                        }, {
                            caption: 'державного будівництва, адміністративно-територіального устрою',
                            alignment: 'center',
                            columns: [
                                {
                                    caption: 'previousYear',
                                    dataField: 'prevStateConstruction',
                                    alignment: 'center',
                                    customizeText: function(cellInfo) {
                                        let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                        return value;
                                    }
                                }, {
                                    caption: 'currentYear',
                                    dataField: 'curStateConstruction',
                                    alignment: 'center',
                                    customizeText: function(cellInfo) {
                                        let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                        return value;
                                    }
                                }
                            ]
                        }, {
                            caption: 'інші',
                            alignment: 'center',
                            columns: [
                                {
                                    caption: 'previousYear',
                                    dataField: 'prevOther',
                                    alignment: 'center',
                                    customizeText: function(cellInfo) {
                                        let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                        return value;
                                    }
                                }, {
                                    caption: 'currentYear',
                                    dataField: 'curOther',
                                    alignment: 'center',
                                    customizeText: function(cellInfo) {
                                        let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                        return value;
                                    }
                                }
                            ]
                        }, {
                            caption: 'Штатна чисельність роботи підрозділу зі зверненнями громадян',
                            alignment: 'center',
                            columns: [
                                {
                                    caption: 'previousYear',
                                    dataField: 'prevEmployees',
                                    alignment: 'center',
                                    customizeText: function(cellInfo) {
                                        let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                        return value;
                                    }
                                }, {
                                    caption: 'currentYear',
                                    dataField: 'curEmployees',
                                    alignment: 'center',
                                    customizeText: function(cellInfo) {
                                        let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                        return value;
                                    }
                                }
                            ]
                        }
                    ]
                }
            ],
            keyExpr: 'source'
        },
        firstLoad: true,
        init: function() {
            this.sub = this.messageService.subscribe('FiltersParams', this.setFilterParams, this);
            this.sub1 = this.messageService.subscribe('ApplyGlobalFilters', this.applyChanges, this);
            this.config.onContentReady = this.afterRenderTable.bind(this);
        },
        setFilterParams: function(message) {
            this.config.query.parameterValues = [
                {key: '@dateFrom' , value:  message.dateFrom },
                {key: '@dateTo', value: message.dateTo }
            ];
            if (this.firstLoad) {
                this.firstLoad = false;
                this.loadData(this.afterLoadDataHandler);
            }
        },
        applyChanges: function() {
            const self = this;
            const name = 'applyTableChanges';
            this.messageService.publish({ name, self });
        },
        afterLoadDataHandler: function(data) {
            const name = 'setData';
            const columns = this.config.columns;
            const position = 4;
            this.messageService.publish({name, data, columns, position});
            this.render(this.afterRenderTable());
        },
        afterRenderTable: function() {
            this.messageService.publish({ name: 'setStyles'});
            this.messageService.publish({
                name: 'setYears',
                columns: this.config.columns[1].columns
            });
        },
        destroy: function() {
            this.sub.unsubscribe();
            this.sub1.unsubscribe();
        }
    };
}());
