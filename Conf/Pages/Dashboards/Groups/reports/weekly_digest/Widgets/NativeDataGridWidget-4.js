(function() {
    return {
        title: ' ',
        config: {
            query: {
                code: 'db_Report_5_2',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [
                {
                    dataField: 'orgName',
                    caption: 'Назва'
                }, {
                    dataField: 'questionQty',
                    caption: 'Кiлькiсть',
                    width: 100
                }
            ],
            summary: {
                totalItems: [{
                    column: 'questionQty',
                    summaryType: 'sum',
                    customizeText: function(data) {
                        return 'Разом: ' + data.value;
                    }
                }]
            },
            keyExpr: 'orgIdId',
            showColumnHeaders: false
        },
        init: function() {
            this.sub = this.messageService.subscribe('ApplyGlobalFilters', this.getFiltersParams, this);
        },
        setTitle: function(dayFrom, dayTo) {
            return 'Звернення, що закритi з порушенням термiну виконання  за тиждень з ' + dayFrom + ' по ' + dayTo;
        },
        getFiltersParams: function(message) {
            this.config.query.filterColumns = [];
            this.counter = 0;
            this.organization = [];
            message.package.value.forEach(filter => {
                if(filter.active === true) {
                    if(filter.name === 'position') {
                        this.position = filter.value.value;
                        this.counter += 1;
                    }else if(filter.name === 'week') {
                        if(filter.value.dateFrom !== '' && filter.value.dateTo !== '') {
                            this.dateFrom = filter.value.dateFrom;
                            this.dateTo = filter.value.dateTo;
                            let dayFrom = this.changeDateTimeValues(this.dateFrom);
                            let dayTo = this.changeDateTimeValues(this.dateTo);
                            this.title = this.setTitle(dayFrom, dayTo);
                            this.counter += 2;
                        }
                    }else if(filter.name === 'organization') {
                        this.organization = this.extractOrgValues(message.package.value.find(f => f.name === 'organization').value);
                    }
                }
            });
            if(this.counter === 3) {
                if(this.position !== 0 && this.organization.length > 0) {
                    this.config.query.parameterValues = [
                        {key: '@dateFrom' , value: this.dateFrom },
                        {key: '@dateTo', value: this.dateTo },
                        {key: '@pos', value: this.position }
                    ];
                    let filter = {
                        key: 'orgId',
                        value: {
                            operation: 0,
                            not: false,
                            values: this.organization
                        }
                    };
                    this.config.query.filterColumns.push(filter);
                    this.loadData(this.afterLoadDataHandler);
                }else if(this.position !== 0 && this.organization.length === 0) {
                    this.config.query.parameterValues = [
                        {key: '@dateFrom' , value: this.dateFrom },
                        {key: '@dateTo', value: this.dateTo },
                        {key: '@pos', value: this.position }
                    ];
                    this.config.query.filterColumns = [];
                    this.loadData(this.afterLoadDataHandler);
                }
            }
        },
        extractOrgValues: function(items) {
            if(items.length && items !== '') {
                const valuesList = [];
                items.forEach(item => valuesList.push(item.value));
                return valuesList;
            }
            return [];
        },
        changeDateTimeValues: function(value) {
            if (value === null) {
                return ' '
            }
            let date = new Date(value);
            let dd = date.getDate().toString();
            let mm = (date.getMonth() + 1).toString();
            let yyyy = date.getFullYear().toString();
            dd = dd.length === 1 ? '0' + dd : dd;
            mm = mm.length === 1 ? '0' + mm : mm;
            return dd + '.' + mm + '.' + yyyy;
        },
        afterLoadDataHandler: function(data) {
            this.messageService.publish({name: 'setData', rep5_data: data, rep5_title: this.title});
            this.render();
        },
        destroy: function() {
            this.sub.unsubscribe();
        }
    };
}());
