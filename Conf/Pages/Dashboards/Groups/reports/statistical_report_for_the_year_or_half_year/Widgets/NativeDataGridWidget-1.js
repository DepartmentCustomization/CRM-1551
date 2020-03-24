(function() {
    return {
        config: {
            query: {
                code: 'db_Report_7_2',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [
                {
                    caption: 'Повторних (п. 2.2)',
                    columns: [
                        {
                            caption: 'previousYear',
                            dataFields: 'qtyRepeated_prev',
                            alignment: 'center',
                            customizeText: function(cellInfo) {
                                let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                return value;
                            }
                        }, {
                            caption: 'currentYear',
                            dataFields: 'qtyRepeated_curr',
                            alignment: 'center',
                            customizeText: function(cellInfo) {
                                let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                return value;
                            }
                        }
                    ]
                }, {
                    caption: 'колективних (п. 5.2)',
                    columns: [
                        {
                            caption: 'previousYear',
                            dataFields: 'qtyСollective_prev',
                            alignment: 'center',
                            customizeText: function(cellInfo) {
                                let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                return value;
                            }
                        }, {
                            caption: 'currentYear',
                            dataFields: 'qtyСollective_curr',
                            alignment: 'center',
                            customizeText: function(cellInfo) {
                                let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                return value;
                            }
                        }
                    ]
                }, {
                    caption: 'від учасників та інвалідів війни, учасників бойових дій (п. 7.1, 7.3, 7.4, 7.5)',
                    columns: [
                        {
                            caption: 'previousYear',
                            dataFields: 'qtyWarsParticipants_prev',
                            alignment: 'center',
                            customizeText: function(cellInfo) {
                                let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                return value;
                            }
                        }, {
                            caption: 'currentYear',
                            dataFields: 'qtyWarsParticipants_curr',
                            alignment: 'center',
                            customizeText: function(cellInfo) {
                                let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                return value;
                            }
                        }
                    ]
                }, {
                    caption: 'від інвалідів I, II, III групи (п. 7.7, 7.8, 7.9)',
                    columns: [
                        {
                            caption: 'previousYear',
                            dataFields: 'qtyInvalids_prev',
                            alignment: 'center',
                            customizeText: function(cellInfo) {
                                let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                return value;
                            }
                        }, {
                            caption: 'currentYear',
                            dataFields: 'qtyInvalids_curr',
                            alignment: 'center',
                            customizeText: function(cellInfo) {
                                let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                return value;
                            }
                        }
                    ]
                }, {
                    caption: 'від ветеранів праці (п. 7.6)',
                    columns: [
                        {
                            caption: 'previousYear',
                            dataFields: 'qtyWorkVeterans_prev',
                            alignment: 'center',
                            customizeText: function(cellInfo) {
                                let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                return value;
                            }
                        }, {
                            caption: 'currentYear',
                            dataFields: 'qtyWorkVeterans_curr',
                            alignment: 'center',
                            customizeText: function(cellInfo) {
                                let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                return value;
                            }
                        }
                    ]
                }, {
                    caption: 'від дітей війни (п. 7.2)',
                    columns: [
                        {
                            caption: 'previousYear',
                            dataFields: 'qtyWarKids_prev',
                            alignment: 'center',
                            customizeText: function(cellInfo) {
                                let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                return value;
                            }
                        }, {
                            caption: 'currentYear',
                            dataFields: 'qtyWarKids_curr',
                            alignment: 'center',
                            customizeText: function(cellInfo) {
                                let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                return value;
                            }
                        }
                    ]
                }, {
                    caption: 'від членів багатодітних сімей, одиноких матерів, матерів-героїнь (п. 7.11, 7.12, 7.13)',
                    columns: [
                        {
                            caption: 'previousYear',
                            dataFields: 'qtyFamily_prev',
                            alignment: 'center',
                            customizeText: function(cellInfo) {
                                let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                return value;
                            }
                        }, {
                            caption: 'currentYear',
                            dataFields: 'qtyFamily_curr',
                            alignment: 'center',
                            customizeText: function(cellInfo) {
                                let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                return value;
                            }
                        }
                    ]
                }, {
                    caption: 'від учасників ліквідації аварії на ЧАЕС та осіб, що потерпіли від Чорнобильської катастрофи (п. 7.14, 7.15)',
                    columns: [
                        {
                            caption: 'previousYear',
                            dataFields: 'qtyChernobyl_prev',
                            alignment: 'center',
                            customizeText: function(cellInfo) {
                                let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                return value;
                            }
                        }, {
                            caption: 'currentYear',
                            dataFields: 'qtyChernobyl_curr',
                            alignment: 'center',
                            customizeText: function(cellInfo) {
                                let value = cellInfo.value === null ? ' - ' : cellInfo.value;
                                return value;
                            }
                        }
                    ]
                }
            ],
            keyExpr: 'qtyRepeated_prev'
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
        afterLoadDataHandler: function(data) {
            const name = 'setData';
            const columns = this.config.columns;
            const position = 1;
            this.messageService.publish({name, data, columns, position});
            this.render(this.afterRenderTable());
        },
        applyChanges: function() {
            const self = this;
            const name = 'applyTableChanges';
            this.messageService.publish({ name, self });
        },
        afterRenderTable: function() {
            this.messageService.publish({ name: 'setStyles'});
            this.messageService.publish({
                name: 'setYears',
                columns: this.config.columns
            });
        },
        destroy: function() {
            this.sub.unsubscribe();
            this.sub1.unsubscribe();
        }
    };
}());
