(function() {
    return {
        config: {
            query: {
                code: 'ak_db_doubles_table1',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [
                {
                    dataField: 'Phone_number',
                    caption: 'Номер телефону'
                }, {
                    dataField: 'Count_applicants',
                    caption: 'Кількість заявникiв'
                }
            ],
            filterRow: {
                visible: true,
                applyFilter: 'auto'
            },
            keyExpr: 'Id',
            focusedRowEnabled: true
        },
        init: function() {
            this.loadData(this.afterLoadDataHandler);
            this.dataGridInstance.onCellClick.subscribe(e => {
                if(e.column) {
                    const dataField = this.config.columns[0].dataField;
                    if(e.column.dataField === dataField && e.row !== undefined) {
                        this.messageService.publish({ name: 'showApplicants', id: e.data.Id});
                    }
                }
            });
        },
        afterLoadDataHandler: function() {
            this.render();
        },
        destroy: function() {
        }
    };
}());
