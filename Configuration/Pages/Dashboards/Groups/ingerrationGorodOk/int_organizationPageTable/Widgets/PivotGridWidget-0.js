(function () {
  return {
    config: {
        query: {
            code: 'int_organizationPageTable',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns:[
            {
                dataField: 'operation',
                caption: 'Операція',
                width: 100
            },{
              caption: 'ГородОк',
              alignment: 'center',
              columns: [
                        {
                        dataField: 'become',
                        caption: 'Було',
                        alignment: 'left',
                    },{
                        dataField: 'it_was',
                        caption: 'Стало',
                        alignment: 'left',
                    }
            ]  
            },{
                dataField: 'id_1551',
                caption: 'Назва організації у системі 1551',
                lookup: {
                    dataSource: {
                        paginate: true,
                        store: this.elements
                    },
                    displayExpr: "short_name",
                    valueExpr: "Id"
                }
            },{
                dataField: 'is_done',
                caption: 'Стан',
                width: 80
            },{
                dataField: 'comment',
                caption: 'Коментар'
            }
        ],  searchPanel: {
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
            visible: false,
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
        groupingAutoExpandAll: null
        // selection: {
        //     mode: "multiple"
        // }
    },
    elements: [],
    init: function() {
        this.loadData(this.afterLoadDataHandler);
        // for example
        // this.subscribeToDataGridActions();
        
        // this.sub = this.messageService.subscribe('clickOnStreets', this.changeOnTable, this);
        
        let executeQuery = {
                queryCode: 'int_list_organization_1551',
                parameterValues: [],
                limit: -1
            };
            this.queryExecutor(executeQuery, this.lookupFoo, this);
            
        var that = this;    
        this.dataGridInstance.onRowUpdating.subscribe( function(e) {
            console.log(e.key);
            console.log(e.oldData);
            console.log(e.newData);
            
            let is_done = e.newData.is_done;
            let key = e.key;
            let id_1551 = e.oldData.id_1551;
            let id_1551_new = e.newData.id_1551;
            let comment = e.newData.comment;
            let cat_id = e.oldData.cat_id;
            console.log ('Is_done: ' + is_done + '  key: '+ key + '  id_1551: ' + id_1551 + '  comment: ' + comment);
            
            // debugger;
            let saveChange = {
                queryCode: 'int_btnSaveChange_organizationGorodok',
                limit: -1,
                parameterValues: [
                    {
                        key: '@key',
                        value: key
                    },{
                        key: '@is_done',
                        value: is_done
                    },{
                        key: '@id_1551',
                        value: id_1551
                    },{
                        key: '@id_1551_new',
                        value: id_1551_new
                    },{
                        key: '@comment',
                        value: comment
                    },{
                        key: '@cat_id',
                        value: cat_id
                    }
                ]
            };
            
            this.queryExecutor(saveChange);
        // this.loadData(this.afterLoadDataHandler);
            
        }.bind(this));
    },
     lookupFoo: function(data) {
         
        this.elements = [];
        for( i = 0; i < data.rows.length; i++){
            let el = data.rows[i];
            let obj = {
                "Id": el.values[0],
                "short_name": el.values[1],
            } 
            this.elements.push(obj);
        };
        this.config.columns[2].lookup.dataSource.store = this.elements;
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
    },
    destroy: function() {
    // this.sub.unsubscribe();
} 
};
}());
