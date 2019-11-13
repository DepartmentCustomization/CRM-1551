(function () {
  return {
    config: {
        query: {
            code: 'int_StreetsFrom1551',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                dataField: 'Id',
                caption: 'Id',
                width: 100
            },{
                dataField: 'id_str_gor',
                caption: 'Id вулиці Городок'
            },{
                dataField: 'name_str_gor',
                caption: 'Назва вулиці Городок'
            },{
                dataField: 'id_str_1551',
                caption: 'Id вулиці 1551'
            },{
                dataField: 'name_str_1551',
                caption: 'Назва вулиці 1551'
            },{
                dataField: 'Id',
                caption: 'Назва вулиці 1551',
                lookup: {
                    dataSource:  {
                        store: this.elements
                    },
                    displayExpr: "streets",
                    valueExpr: "Id"
                }
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
            mode: 'batch',
            allowUpdating: true,
            useIcons: true
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
        showFilterRow: false,
        showHeaderFilter: false,
        showColumnChooser: true,
        showColumnFixing: true,
        groupingAutoExpandAll: null,
        selection: {
            mode: "multiple"
        }
    },
    elements: [],
    init: function() {
        this.loadData(this.afterLoadDataHandler);
        // for example
        // this.subscribeToDataGridActions();
        
        // this.sub = this.messageService.subscribe('clickOnTable2', this.changeOnTable, this);
        let executeQuery = {
                queryCode: 'int_list_streets_1551',
                parameterValues: [],
                limit: -1
            };
            this.queryExecutor(executeQuery, this.lookupFoo, this);
    },
     lookupFoo: function(data) {
         
        this.elements = [];
        for( i = 0; i < data.rows.length; i++){
            let el = data.rows[i];
            let obj = {
                "Id": el.values[0],
                "streets": el.values[1],
            } 
            this.elements.push(obj);
        }
        
        this.config.columns[5].lookup.dataSource.store = this.elements;
        debugger;
        console.log( this.elements);
        this.loadData(this.afterLoadDataHandler);
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
