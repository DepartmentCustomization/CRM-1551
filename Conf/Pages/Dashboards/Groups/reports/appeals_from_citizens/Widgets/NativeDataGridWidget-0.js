(function() {
    return {
        config: {
            query: {
                code: 'db_Report_1',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [
                {
                    dataField: 'oper',
                    caption: 'ПІП користувача'
                }, {
                    dataField: 'questionQ',
                    caption: 'Звернень',
                    alignment: 'center'
                }, {
                    dataField: 'assignmentQ',
                    caption: 'Доручень',
                    alignment: 'center'
                }, {
                    dataField: 'doneQ',
                    caption: 'Виконано',
                    alignment: 'center'
                }, {
                    dataField: 'reworkQ',
                    caption: 'На доопрацювання',
                    alignment: 'center'
                }, {
                    dataField: 'notCallQ',
                    caption: 'Недозвон',
                    alignment: 'center'
                }
            ],
            summary: {
                totalItems: [{
                    column: 'questionQ',
                    summaryType: 'sum',
                    customizeText: function(data) {
                        return 'Сума: ' + data.value;
                    }
                }, {
                    column: 'assignmentQ',
                    summaryType: 'sum',
                    customizeText: function(data) {
                        return 'Сума: ' + data.value;
                    }
                }, {
                    column: 'doneQ',
                    summaryType: 'sum',
                    customizeText: function(data) {
                        return 'Сума: ' + data.value;
                    }
                }, {
                    column: 'reworkQ',
                    summaryType: 'sum',
                    customizeText: function(data) {
                        return 'Сума: ' + data.value;
                    }
                }, {
                    column: 'notCallQ',
                    summaryType: 'sum',
                    customizeText: function(data) {
                        return 'Сума: ' + data.value;
                    }
                }]
            },
            keyExpr: 'Id',
            scrolling: {
                mode: 'virtual'
            },
            filterRow: {
                visible: true,
                applyFilter: 'auto'
            },
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
        init: function() {
            this.dataGridInstance.height = window.innerHeight - 200;
            this.sub = this.messageService.subscribe('GlobalFilterChanged', this.getFiltersParams, this);
            this.sub1 = this.messageService.subscribe('ApplyGlobalFilters', this.applyChanges, this);
        },
        getFiltersParams: function(message) {
            let period = message.package.value.values.find(f => f.name === 'period').value;
            let citizenName = message.package.value.values.find(f => f.name === 'citizen_name').value;
            if(period !== null) {
                if(period.dateFrom !== '' && period.dateTo !== '') {
                    this.dateFrom = period.dateFrom;
                    this.dateTo = period.dateTo;
                    this.citizenName = this.extractOrgValues(citizenName);
                    this.config.query.parameterValues = [
                        {key: '@dateFrom' , value: this.dateFrom },
                        {key: '@dateTo', value: this.dateTo }
                    ];
                    this.config.query.filterColumns = [];
                    if (this.citizenName.length > 0) {
                        const filter = {
                            key: 'operId',
                            value: {
                                operation: 0,
                                not: false,
                                values: this.citizenName
                            }
                        };
                        this.config.query.filterColumns.push(filter);
                    }
                }
            }
        },
        applyChanges: function() {
            const msg = {
                name: 'SetFilterPanelState',
                package: {
                    value: false
                }
            };
            this.messageService.publish(msg);
            this.loadData(this.afterLoadDataHandler);
        },
        extractOrgValues: function(items) {
            if(items.length && items !== '') {
                const valuesList = [];
                items.forEach(item => valuesList.push(item.value));
                return valuesList;
            }
            return [];
        },
        afterLoadDataHandler: function() {
            this.render();
        },
        destroy: function() {
            this.sub.unsubscribe();
        }
    };
}());
