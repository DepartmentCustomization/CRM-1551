(function () {
  return {
    config: {
        query: {
            code: 'table2',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                dataField: 'navigation',
                caption: 'Район',
                dataType: null,
                format: null,
                width: null,
                alignment: null,
                groupIndex: null,
                fixed: true,
                sortOrder: 'asc',
                allowSorting: true,
                subColumns: []
            }, {
                dataField: 'uvaga',
                caption: 'ГВП',
                dataType: null,
                format: null,
                width: null,
                alignment: null,
                groupIndex: null,
                fixed: true,
                sortOrder: 'asc',
                allowSorting: true,
                subColumns: []
            }, {
                dataField: 'dovidoma',
                caption: 'ХВП',
                dataType: null,
                format: null,
                width: null,
                alignment: null,
                groupIndex: null,
                fixed: true,
                sortOrder: 'asc',
                allowSorting: true,
                subColumns: []
            }, {
                dataField: 'dovidoma',
                caption: 'ЦО',
                dataType: null,
                format: null,
                width: null,
                alignment: null,
                groupIndex: null,
                fixed: true,
                sortOrder: 'asc',
                allowSorting: true,
                subColumns: []
            }, {
                dataField: 'dovidoma',
                caption: 'Електроенергія',
                dataType: null,
                format: null,
                width: null,
                alignment: null,
                groupIndex: null,
                fixed: true,
                sortOrder: 'asc',
                allowSorting: true,
                subColumns: []
            }
        ],
        export: {
            enabled: false,
            fileName: 'File_name'
        },
        searchPanel: {
            visible: true,
            highlightCaseSensitive: true
        },
        pager: {},
        scrolling: {
            // mode = null,
            // rowRenderingMode = null,
            // columnRenderingMode = null,
            // showScrollbar = null
        },
        editing: {
            // mode: 'row',
            // allowUpdating: true,
            // allowDeleting: true,
            // allowAdding: true,
            // useIcons: true
        },
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
        showFilterRow: false,
        showHeaderFilter: false,
        showColumnChooser: false,
        showColumnFixing: true,
        // sortingMode: 'multiple',
        // selectionMode: 'multiple',
        groupingAutoExpandAll: null,
        masterDetail: null,
        onRowUpdating: function(data) {},
        onRowExpanding: function(data) {},
        onRowInserting: function(data) {},
        onRowRemoving: function(data) {},
        onCellClick: function(data) {},
        onRowClick: function(data) {},
        selectionChanged: function(data) {}
    },
    init: function() {
        this.loadData();
    }
};
}());
