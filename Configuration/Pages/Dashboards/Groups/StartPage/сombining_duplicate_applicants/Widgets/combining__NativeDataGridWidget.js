(function () {
  return {
    config: {
        query: {
            code: 'ak_db_doubles_table2',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                dataField: 'Phone_number',
                caption: 'Номер телефону',
            }, {
                dataField: 'Full_name',
                caption: 'ПІБ',
            }, {
                dataField: 'Address',
                caption: 'Адреса',
            }, {
                dataField: 'Privilege',
                caption: 'Пільга',
            }, {
                dataField: 'SocialState',
                caption: 'Соц. стан',
            }, {
                dataField: 'Years',
                caption: 'Вік',
            }, {
                dataField: 'Check',
                caption: 'Головний',
                dataType: 'boolean',
            }
        ],
        editing: {
            allowUpdating: true,
            mode: 'Row',
            useIcons: true
        },
        selection: {
            mode: 'multiple'
        },
        keyExpr: 'Id'
    },

    init: function() {
        this.mainRowId = undefined;
        this.tableId = undefined;
        this.loadData(this.afterLoadDataHandler);
        this.sub = this.messageService.subscribe('showApplicants', this.showApplicants, this);
        this.config.onToolbarPreparing = this.createTableButton.bind(this);
        this.dataGridInstance.onRowUpdating.subscribe( row => {
            this.mainRowId = row.key;
        });
    },

    createTableButton: function(e) {
        var toolbarItems = e.toolbarOptions.items;
        toolbarItems.push(
            {
                widget: "dxButton", 
                location: "after",
                options: { 
                    icon: "collapse",
                    type: "default",
                    text: 'Об\'єднати',
                    onClick: function(e) {
                        e.event.stopImmediatePropagation();
                        if(this.mainRowId) {
                            const keys = this.dataGridInstance.selectedRowKeys;
                            const index = keys.findIndex(value => value === this.mainRowId );
                            if(index !== -1) {
                                const rowsId = this.dataGridInstance.selectedRowKeys.join(",");
                                this.showPagePreloader('Триває об\'єднання');
                                this.executeQueryCombining(rowsId);
                            }
                        }
                    }.bind(this)
                },
            }, {
                widget: "dxButton", 
                location: "after",
                options: { 
                    icon: "clear",
                    type: "default",
                    text: 'Пропустити',
                    onClick: function(e) {
                        e.event.stopImmediatePropagation();
                        if(this.tableId) {
                            this.showPagePreloader('Триває об\'єднання');
                            this.executeQueryMissing();
                        }
                    }.bind(this)
                },
            }
        );
    },

    showApplicants: function (message) {
        this.tableId = message.id;
        this.config.query.parameterValues = [
            { key: '@Id', value: this.tableId }
        ];
        this.loadData(this.afterLoadDataHandler);
    },

    executeQueryCombining: function (rowsId) {
        let query = {
            queryCode: 'ak_db_doubles_ButtonCombine',
            limit: -1,
            parameterValues: [
                { key: '@true_applicant_id',  value: this.mainRowId},
                { key: '@Id_table',  value: this.tableId},
                { key: '@Ids',  value: rowsId}
            ]
        };
        this.queryExecutor(query, this.response, this);
        this.showPreloader = false;
    },

    executeQueryMissing: function () {
        let query = {
            queryCode: 'ak_db_doubles_ButtonSkip',
            limit: -1,
            parameterValues: [
                { key: '@Id_table',  value: this.tableId}
            ]
        };
        this.queryExecutor(query, this.response, this);
        this.showPreloader = false;
    },

    response: function () {
        window.location.reload();
    },

    afterLoadDataHandler: function(data) {
        this.data = data;
        this.render();
    },

    destroy: function(data) {
        this.sub.unsubscribe();
    },
};
}());
