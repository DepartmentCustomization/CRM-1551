(function() {
    return {
        config: {
            query: {
                code: 'DepartmentUGL_ExcelSelectRows',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [
                {
                    dataField: 'EnterNumber',
                    caption: 'Вхiдний номер УГЛ'
                },{
                    dataField: 'RegistrationDate',
                    caption: 'Дата реєстрації'
                },{
                    dataField: 'Applicant',
                    caption: 'Заявник'
                },{
                    dataField: 'Address',
                    caption: 'Адреса'
                },{
                    dataField: 'Content',
                    caption: 'Змiст'
                },{
                    dataField: 'QuestionNumber',
                    caption: 'Номер питання'
                }
            ],
            pager: {
                showPageSizeSelector: true,
                allowedPageSizes: [50, 100, 500],
                showInfo: true
            },
            paging: {
                pageSize: 50
            },
            keyExpr: 'Id'
        },
        init: function() {
            this.dataGridInstance.height = window.innerHeight - 200;
            this.sub = this.messageService.subscribe('GlobalFilterChanged', this.getFiltersParams, this);
            this.sub1 = this.messageService.subscribe('ApplyGlobalFilters', this.applyChanges, this);
            this.sub2 = this.messageService.subscribe('showTable', this.showTable, this);
            this.dataGridInstance.onCellClick.subscribe(e => {
                if(e.column) {
                    if(e.column.dataField === 'EnterNumber' && e.row !== undefined) {
                        window.open(location.origin +
                        localStorage.getItem('VirtualPath') +
                        '/sections/CreateAppeal_UGL/add?uglId=' + e.data.Id);
                    }
                }
            });
        },
        getFiltersParams: function(message) {
            this.config.query.filterColumns = [];
            let period = message.package.value.values.find(f => f.name === 'period').value;
            let processed = message.package.value.values.find(f => f.name === 'processed').value;
            let users = message.package.value.values.find(f => f.name === 'users').value;
            if(period !== null) {
                if(period.dateFrom !== '' && period.dateTo !== '') {
                    this.dateFrom = period.dateFrom;
                    this.dateTo = period.dateTo;
                    this.users = extractOrgValues(users);
                    this.processed = processed === null ? null : processed === '' ? null : processed.value;
                    this.config.query.parameterValues = [
                        {key: '@dateFrom' , value: this.dateFrom },
                        {key: '@dateTo', value: this.dateTo },
                        {key: '@is_worked', value: this.processed }
                    ];
                    if (this.users.length > 0) {
                        let filter = {
                            key: 'users',
                            value: {
                                operation: 0,
                                not: false,
                                values: this.users
                            }
                        };
                        this.config.query.filterColumns.push(filter);
                    }
                    this.loadData(this.afterLoadDataHandler);
                }
            }
            function extractOrgValues(val) {
                if(val !== null) {
                    let valuesList = [];
                    if (val.length > 0) {
                        for (let i = 0; i < val.length; i++) {
                            valuesList.push(val[i].value);
                        }
                    }
                    return valuesList.length > 0 ? valuesList : [];
                }
                return [];
            }
        },
        changeDateTimeValues: function(value) {
            let date = new Date(value);
            let dd = date.getDate().toString();
            let mm = (date.getMonth() + 1).toString();
            let yyyy = date.getFullYear().toString();
            dd = dd.length === 1 ? '0' + dd : dd;
            mm = mm.length === 1 ? '0' + mm : mm;
            return dd + '.' + mm + '.' + yyyy;
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
        showTable: function() {
            this.loadData(this.afterLoadDataHandler);
        },
        afterLoadDataHandler: function() {
            this.render();
        },
        destroy: function() {
            this.sub.unsubscribe();
            this.sub1.unsubscribe();
            this.sub2.unsubscribe();
        }
    };
}());