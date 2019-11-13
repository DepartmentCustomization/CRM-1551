(function () {
  return {
    config: {
        query: {
            code: 'int_housesPageTable',
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
                width: 120,
                alignment: 'center'
            },{
              caption: 'ГородОк',
              alignment: 'center',
              columns: [
                        {   caption: 'Було',
                            alignment: 'center',
                            columns:[
                                {
                                    dataField: 'become_district_name',
                                    caption: 'Район',
                                    alignment: 'center',
                                    width: 140
                                },{
                                   dataField: 'become',
                                   caption: 'Будинок',
                                   alignment: 'center'
                                }]
                        },
                        {   caption: 'Стало',
                            alignment: 'center',
                            columns:[
                                {
                                    dataField: 'it_was_district_name',
                                    caption: 'Район',
                                    width: 140,
                                    alignment: 'center'
                                },{
                                   dataField: 'it_was',
                                   caption: 'Будинок',
                                   alignment: 'center'
                                }]
                        }
                    ]  
                        },{
              caption: '1551',
              alignment: 'center',
              columns:[
                  {
                        dataField: 'district_id',
                        alignment: 'left',
                        caption: 'Район',
                        setCellValue: function(rowData, value) {
                            // debugger;
                            rowData.district_id = value;
                            rowData.id_1551 = null;
                        },
                        lookup: {
                            dataSource: {
                                paginate: true,
                                store: this.elements_dis
                            },
                            displayExpr: "name",
                            valueExpr: "Id"
                        }
                    },{
                        dataField: 'id_1551',
                        alignment: 'left',
                        caption: 'Вулиці у системі 1551',
                        lookup: {
                            dataSource: function(options){
                                return{
                                    paginate: true,
                                    store: this.elements,
                                    
                                    filter: options.data ? ['district_id', '=', options.data.district_id] : null
                                }
                            },
                            displayExpr: "name",
                            valueExpr: "Id"
                        }
                    }
                ]
            },{
                dataField: 'is_done',
                caption: 'Стан',
                width: 100
            },{
                dataField: 'comment',
                caption: 'Коментар'
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
            // mode: 'row',
            allowUpdating: true,
            useIcons: true,
            text: [
                {
                    editRow: "Editdfdsf",
                    saveAllChanges: "Save changes 123",
                    saveRowChanges: "Save",
                }
            ]
        },
        onEditorPreparing: function(e) {
            // console.log(e);
            if(e.parentType === "dataRow" && e.dataField === 'id_1551') {
                e.editorOptions.disabled = (typeof e.row.data.district_id !== "number");
            }
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
        groupingAutoExpandAll: null,
        // onContentReady: function (e) {
        //     debugger;
        //     e.component.element().find(".dx-datagrid-header-panel").hide();         
        // }
        toolbarPreparing: function(data) {
                    debugger;
            var indexSaveButton = data.toolbarOptions.items.indexOf(data.toolbarOptions.items.find(function (item) {
                return item.name == "saveButton";
            }));
            if (indexSaveButton != -1)
                data.toolbarOptions.items.splice(indexSaveButton, 1);
            var indexRevertButton = data.toolbarOptions.items.indexOf(data.toolbarOptions.items.find(function (item) {
                return item.name == "revertButton";
            }));
            if (indexRevertButton != -1)
                data.toolbarOptions.items.splice(indexRevertButton, 1);
        },
    },
    myFunc: function(options) {
        return{
            paginate: true,
            store: this.elements,
            filter: options.data ? ['district_id', '=', options.data.district_id] : null
        }
    },
    elements: [],
    init: function() {
        this.loadData(this.afterLoadDataHandler);
        // for example
        // this.subscribeToDataGridActions();
        
        // this.sub = this.messageService.subscribe('clickOnStreets', this.changeOnTable, this);
        // debugger;
        
        let executeQuery_dis = {
                queryCode: 'int_list_district_1551',
                parameterValues: [],
                limit: -1
            };
        this.queryExecutor(executeQuery_dis, this.lookupFoo_dis, this);
            
        let executeQuery = {
                queryCode: 'int_list_houses_1551',
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
            
            let saveChange = {
                queryCode: 'int_btnSaveChange_housesGorodok',
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
    lookupFoo_dis: function(data) {
                // debugger;
        this.elements_dis = [];
        for( i = 0; i < data.rows.length; i++){
            let el = data.rows[i];
            let obj = {
                "Id": el.values[0],
                "name": el.values[1],
            } 
            this.elements_dis.push(obj);
        };
        this.config.columns[2].columns[0].lookup.dataSource.store = this.elements_dis;
        // this.config.columns[2].lookup.dataSource.store = this.elements_dis;
        console.log( this.elements_dis);
        this.loadData(this.afterLoadDataHandler);
    },
    
    lookupFoo: function(data) {
                  
        this.elements = [];
        for( i = 0; i < data.rows.length; i++){
            let el = data.rows[i];
            let obj = {
                "Id": el.values[0],
                "name": el.values[1],
                "district_id": el.values[2]
            } 
            this.elements.push(obj);
        };
        this.config.columns[2].columns[1].lookup.dataSource.store = this.elements;
        // this.config.columns[3].lookup.items = this.elements;
        // this.config.columns[3].lookup.dataSource.store = this.elements;
        
        // this.config.columns[3].lookup.dataSource = this.myFunc.bind(this);
        this.config.columns[2].columns[1].lookup.dataSource = this.myFunc.bind(this);
        
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
