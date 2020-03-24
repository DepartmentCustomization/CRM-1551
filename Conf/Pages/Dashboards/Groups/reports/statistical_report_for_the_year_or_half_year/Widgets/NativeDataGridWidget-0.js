(function() {
    return {
        config: {
            query: {
                code: 'db_Report_7_1',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [
                {
                    caption: 'Кількість звернень',
                    columns: [
                        {
                            caption: 'усіх',
                            alignment: 'center',
                            height: 100,
                            columns: [
                                {
                                    caption: 'previousYear',
                                    dataField: 'qtyPrev',
                                    alignment: 'center'
                                }, {
                                    caption: 'currentYear',
                                    dataField: 'qtyCurrent',
                                    alignment: 'center'
                                }
                            ]
                        }, {
                            caption: 'що надійшли поштою (п. 1.1)*',
                            alignment: 'center',
                            columns: [
                                {
                                    caption: 'previousYear',
                                    dataField: 'qtyMail_prev',
                                    alignment: 'center'
                                }, {
                                    caption: 'currentYear',
                                    dataField: 'qtyMail_curr',
                                    alignment: 'center'
                                }
                            ]
                        }, {
                            caption: 'на особистому прийомі (п. 1.2)*',
                            alignment: 'center',
                            columns: [
                                {
                                    caption: 'previousYear',
                                    dataField: 'qtyPersonal_prev',
                                    alignment: 'center'
                                }, {
                                    caption: 'currentYear',
                                    dataField: 'qtyPersonal_curr',
                                    alignment: 'center'
                                }
                            ]
                        }
                    ]
                }, {
                    caption: 'Результати розгляду звернень:',
                    alignment: 'center',
                    columns: [
                        {
                            caption: 'вирішено позитивно (виконано) п. 9.1',
                            alignment: 'center',
                            columns: [
                                {
                                    caption: 'previousYear',
                                    dataField: 'qtyPos_prev',
                                    alignment: 'center'
                                }, {
                                    dataField: 'qtyPos_curr',
                                    alignment: 'center',
                                    caption: 'currentYear'
                                }
                            ]
                        }, {
                            caption: 'відмолено у задоволенні (не виконано) п. 9.2',
                            alignment: 'center',
                            columns: [
                                {
                                    caption: 'previousYear',
                                    dataField: 'qtyNeg_prev',
                                    alignment: 'center'
                                }, {
                                    dataField: 'qtyNeg_curr',
                                    alignment: 'center',
                                    caption: 'currentYear'
                                }
                            ]
                        }, {
                            caption: 'дано роз’яснення п. 9.3',
                            alignment: 'center',
                            columns: [
                                {
                                    caption: 'previousYear',
                                    dataField: 'qtyExpl_prev',
                                    alignment: 'center'
                                }, {
                                    dataField: 'qtyExpl_curr',
                                    alignment: 'center',
                                    caption: 'currentYear'
                                }
                            ]
                        }, {
                            caption: 'інше п. 9.4 - 9.6',
                            alignment: 'center',
                            columns: [
                                {
                                    caption: 'previousYear',
                                    dataField: 'qtyElse_prev',
                                    alignment: 'center'
                                }, {
                                    dataField: 'qtyElse_curr',
                                    alignment: 'center',
                                    caption: 'currentYear'
                                }
                            ]
                        }
                    ]
                }
            ],
            keyExpr: 'qtyExpl_prev'
        },
        firstLoad: true,
        init: function() {
            this.sub = this.messageService.subscribe('FiltersParams', this.setFilterParams, this);
            this.sub1 = this.messageService.subscribe('ApplyGlobalFilters', this.applyChanges, this);
            this.config.onContentReady = this.afterRenderTable.bind(this);
        },
        setFilterParams: function(message) {
            this.previousYear = message.previousYear;
            this.currentYear = message.currentYear;
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
            const position = 0;
            this.messageService.publish({name, data, columns, position});
            this.render(this.afterRenderTable());
        },
        afterRenderTable: function() {
            this.messageService.publish({ name: 'setStyles'});
            this.setYears();
        },
        setYears: function() {
            this.config.columns.forEach(col => {
                col.columns.forEach(col => {
                    col.columns[0].caption = this.previousYear;
                    col.columns[1].caption = this.currentYear;
                });
            });
        },
        destroy: function() {
            this.sub.unsubscribe();
            this.sub1.unsubscribe();
        }
    };
}());
