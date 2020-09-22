(function() {
    return {
        config: {
            query: {
                code: 'db_ReferenceEtalonDays',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [
                {
                    dataField: 'QuestionTypes_Name',
                    caption: 'Тип питання'
                }, {
                    dataField: 'EtalonDaysToExecution',
                    caption: 'Еталон виконання'
                }, {
                    dataField: 'avg_EtalonDaysToExecution',
                    caption: 'Седернє еталону виконання'
                }, {
                    dataField: 'avg_EtalonDaysToExecution_change',
                    caption: 'Новий еталон виконання'
                }, {
                    dataField: 'EtalonDaysToExplain',
                    caption: 'Еталон Роз\'яснення'
                }, {
                    dataField: 'avg_EtalonDaysToExplain',
                    caption: 'Седернє еталону виконання'
                }, {
                    dataField: 'avg_EtalonDaysToExplain_change',
                    caption: 'Новий еталон роз\'яснення'
                }, {
                    dataField: 'DateStart',
                    caption: 'Використовується з',
                    dataType: 'date',
                    format: 'dd.MM.yyyy'
                }
            ],
            allowColumnResizing: true,
            columnMinWidth: 50,
            columnAutoWidth: true,
            allowColumnReordering: true,
            pager: {
                showPageSizeSelector: true,
                allowedPageSizes: [50, 100],
                showInfo: true
            },
            paging: {
                pageSize: 100
            },
            export: {
                enabled: true,
                fileName: 'Еталонні дні'
            },
            selection: {
                mode: 'multiple'
            },
            editing: {
                mode: 'cell',
                allowUpdating: true
            },
            columnFixing: {
                enabled: true
            },
            showBorders: false,
            showColumnLines: false,
            showRowLines: true,
            wordWrapEnabled: true,
            keyExpr: 'Id'
        },
        init: function() {
            this.dataGridInstance.height = window.innerHeight - 100;
            this.subscribers.push(this.messageService.subscribe('GlobalFilterChanged', this.setFiltersParams, this));
            this.subscribers.push(this.messageService.subscribe('ApplyGlobalFilters', this.applyGlobalFilters, this));
            this.config.onToolbarPreparing = this.createTableButton.bind(this);
        },
        setFiltersParams: function(message) {
            const period = message.package.value.values.find(f => f.name === 'period').value;
            if(period !== null) {
                if(period.dateFrom !== '' && period.dateTo !== '') {
                    const dateFrom = period.dateFrom;
                    const dateTo = period.dateTo;
                    this.config.query.parameterValues = [
                        {key: '@dateFrom' , value: dateFrom },
                        {key: '@dateTo', value: dateTo }
                    ];
                }
            }
        },
        createTableButton: function(e) {
            let toolbarItems = e.toolbarOptions.items;
            toolbarItems.push({
                widget: 'dxButton',
                options: {
                    icon: 'check',
                    type: 'default',
                    text: 'Застосувати',
                    onClick: () => {
                        this.applyRowsChanges();
                    }
                },
                location: 'after'
            });
        },
        applyRowsChanges: function() {
            const rows = this.dataGridInstance.instance.getSelectedRowsData();
            if(rows.length) {
                this.showPagePreloader('Зачекайте, дані обробляються');
                this.promiseAll = [];
                rows.forEach(row => {
                    const promise = new Promise((resolve) => {
                        const executeApplyRowsChanges = this.createExecuteApplyRowsChanges(row);
                        this.queryExecutor(executeApplyRowsChanges, this.applyRequest.bind(this, resolve), this);
                        this.showPreloader = false;
                    });
                    this.promiseAll.push(promise);
                });
                this.afterApplyAllRequests();
            }
        },
        createExecuteApplyRowsChanges: function(row) {
            return {
                queryCode: 'db_ReferenceEtalonDays_apply',
                limit: -1,
                parameterValues: [
                    { key: '@QuestionTypes_Id', value: row.QuestionTypes_Id },
                    { key: '@DateStart', value: new Date(row.DateStart) },
                    { key: '@avg_EtalonDaysToExplain_change', value: row.avg_EtalonDaysToExplain_change },
                    { key: '@avg_EtalonDaysToExecution_change', value: row.avg_EtalonDaysToExecution_change }
                ]
            };
        },
        applyRequest: function(resolve, data) {
            resolve(data);
        },
        afterApplyAllRequests: function() {
            Promise.all(this.promiseAll).then(() => {
                this.promiseAll = [];
                this.dataGridInstance.instance.deselectAll();
                this.loadData(this.afterLoadDataHandler);
                this.hidePagePreloader();
            });
        },
        applyGlobalFilters: function() {
            const msg = {
                name: 'SetFilterPanelState',
                package: {
                    value: false
                }
            };
            this.messageService.publish(msg);
            this.loadData(this.afterLoadDataHandler);
        },
        afterLoadDataHandler: function() {
            this.render();
        }
    };
}());
