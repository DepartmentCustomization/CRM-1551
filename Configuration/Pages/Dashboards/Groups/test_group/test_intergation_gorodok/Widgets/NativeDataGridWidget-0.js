(function () {
  return {
    config: {
        query: {
            code: 'ing_test',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                dataField: 'operation',
                caption: 'Операція',
                width: 110
            },{
                dataField: 'new_id',
                caption: 'Id новий',
                width: 80
            },{
                dataField: 'new_name',
                caption: 'Назва нова',
            },{
                dataField: 'old_id',
                caption: 'Id старий',
                width: 80
            },{
                dataField: 'old_name',
                caption: 'Назва стара',
            }
        ],
        searchPanel: {
            visible: true,
            highlightCaseSensitive: false
        },
        pager: {
            showPageSizeSelector:  false,
            allowedPageSizes: [10, 15, 30],
            showInfo: true,
            pageSize: 10
        },
        export: {
            enabled: true,
            fileName: 'File_name'
        },
        editing: {
            enabled: false,
            // mode: 'row',
            // allowUpdating: true,
            // allowDeleting: true,
            // allowAdding: false,
            // useIcons: true
        },
        filterRow: {
            visible: true,
            applyFilter: "auto"
        },
        height: '550',
        keyExpr: 'Id',
        showBorders: true,
        showColumnLines: true,
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
        showHeaderFilter: true,
        showColumnChooser: true,
        showColumnFixing: true,
        groupingAutoExpandAll: null,
        // sortingMode: 'multiple',
        selection: {
            mode: "multiple"
        }
    },
    
    init: function() {
        this.loadData(this.afterLoadDataHandler);
        // for example
        // this.subscribeToDataGridActions();
    },
    afterLoadDataHandler: function(data) {
        this.render();
    },
    subscribeToDataGridActions: function() {
        // subscribe to data list actions here
        // this.config.onEditorPreparing = this.onDataGridEditorPreparing.bind(this)
    },
    onDataGridEditorPreparing: function(e) {
        // your logic here
    }
};
}());
