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
                    dataField: 'linkTo',
                    caption: 'Перехiд',
                    width: 70,
                    alignment: 'center'
                }, {
                    dataField: 'EnterNumber',
                    caption: 'Вхiдний номер УГЛ',
                    width: 120
                },{
                    dataField: 'RegistrationDate',
                    caption: 'Дата реєстрації',
                    width: 110
                },{
                    dataField: 'Applicant',
                    caption: 'Заявник',
                    width: 100
                },{
                    dataField: 'Address',
                    caption: 'Адреса',
                    width: 160
                },{
                    dataField: 'Content',
                    caption: 'Змiст'
                },{
                    dataField: 'QuestionNumber',
                    caption: 'Номер питання',
                    width: 100
                }
            ],
            filterRow: {
                visible: true,
                applyFilter: 'auto'
            },
            wordWrapEnabled: true,
            selection: {
                mode: 'multiple'
            },
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
        firstLoad: true,
        init: function() {
            this.dataGridInstance.height = window.innerHeight - 200;
            this.sub = this.messageService.subscribe('GlobalFilterChanged', this.getFiltersParams, this);
            this.sub1 = this.messageService.subscribe('ApplyGlobalFilters', this.applyChanges, this);
            this.sub2 = this.messageService.subscribe('showTable', this.showTable, this);
            this.config.onToolbarPreparing = this.createTableButton.bind(this);
            this.dataGridInstance.onCellClick.subscribe(e => {
                if(e.column) {
                    if(e.column.dataField === 'linkTo' && e.row !== undefined) {
                        window.open(location.origin +
                        localStorage.getItem('VirtualPath') +
                        '/sections/CreateAppeal_UGL/add?uglId=' + e.data.Id);
                    }
                }
            });
            this.dataGridInstance.onCellPrepared.subscribe(e => {
                if(e.column.dataField === 'linkTo' && e.data !== undefined) {
                    let icon = this.createElement('span', { className: 'iconToLink dx-icon-arrowright dx-icon-custom-style'});
                    e.cellElement.appendChild(icon);
                }
            });
        },
        getFiltersParams: function(message) {
            this.config.query.filterColumns = [];
            let period = message.package.value.values.find(f => f.name === 'period').value;
            let processed = message.package.value.values.find(f => f.name === 'processed').value;
            let processedUser = message.package.value.values.find(f => f.name === 'processedUser').value;
            let uploaded = message.package.value.values.find(f => f.name === 'uploaded').value;
            if(period !== null) {
                if(period.dateFrom !== '' && period.dateTo !== '') {
                    this.dateFrom = period.dateFrom;
                    this.dateTo = period.dateTo;
                    this.processed = processed === null ? null : processed === '' ? null : processed.value;
                    this.uploaded = this.extractOrgValues(uploaded);
                    this.processedUser = this.extractOrgValues(processedUser);
                    this.config.query.parameterValues = [
                        {key: '@dateFrom' , value: this.dateFrom},
                        {key: '@dateTo', value: this.dateTo},
                        {key: '@is_worked', value: this.processed}
                    ];
                    if (this.uploaded.length > 0) {
                        let filter = {
                            key: 'Uploaded',
                            value: {
                                operation: 0,
                                not: false,
                                values: this.uploaded
                            }
                        };
                        this.config.query.filterColumns.push(filter);
                    }
                    if (this.processedUser.length > 0) {
                        let filter = {
                            key: 'Processed',
                            value: {
                                operation: 0,
                                not: false,
                                values: this.processedUser
                            }
                        };
                        this.config.query.filterColumns.push(filter);
                    }
                    if(this.firstLoad) {
                        this.firstLoad = false;
                        this.loadData(this.afterLoadDataHandler);
                    }
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
        createTableButton: function(e) {
            let toolbarItems = e.toolbarOptions.items;
            toolbarItems.push({
                widget: 'dxButton',
                options: {
                    icon: 'clear',
                    type: 'default',
                    text: 'Очистити',
                    onClick: function(e) {
                        e.event.stopImmediatePropagation();
                        this.deleteSelectedRows();
                    }.bind(this)
                },
                location: 'after'
            });
        },
        deleteSelectedRows: function() {
            const selectedRows = this.dataGridInstance.instance.getSelectedRowsData();
            if(selectedRows.length) {
                this.showPagePreloader('Зачекайте, видалення даних');
                let IDs = '';
                selectedRows.forEach(row => {
                    const id = row.Id;
                    IDs = IDs + id + ', ';
                });
                const paramIds = IDs.slice(0, -2);
                this.executeDeleteROws(paramIds);
            }
        },
        executeDeleteROws: function(paramIds) {
            let deleteRowsQuery = {
                queryCode: 'DepartmentUGL_ButtonDel',
                parameterValues: [
                    { key: '@Ids', value: paramIds }
                ],
                limit: -1
            }
            this.queryExecutor(deleteRowsQuery, this.showTable, this);
            this.showPreloader = false;
        },
        createElement: function(tag, props, ...children) {
            const element = document.createElement(tag);
            Object.keys(props).forEach(key => element[key] = props[key]);
            if(children.length > 0) {
                children.forEach(child =>{
                    element.appendChild(child);
                });
            } return element;
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
            this.sendMessageFilterPanelState(false);
            this.loadData(this.afterLoadDataHandler);
        },
        sendMessageFilterPanelState: function(state) {
            const msg = {
                name: 'SetFilterPanelState',
                package: {
                    value: state
                }
            };
            this.messageService.publish(msg);
        },
        showTable: function() {
            this.hidePagePreloader();
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
