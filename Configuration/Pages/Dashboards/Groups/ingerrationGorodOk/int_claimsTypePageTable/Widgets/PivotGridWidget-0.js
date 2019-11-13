(function () {
  return {
    config: {
        query: {
            code: 'int_claims_typePageTable',
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
            },
            // {
            //     dataField: 'id_1551',
            //     caption: 'Назва вулиці у системі 1551',
            //     lookup: {
            //         dataSource: {
            //             store: this.elements
            //         },
            //         displayExpr: "streets",
            //         valueExpr: "Id"
            //     }
            // },
            {
                dataField: 'is_done',
                caption: 'Стан',
                width: 80
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
        groupingAutoExpandAll: null,
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
                queryCode: 'int_btnSaveChange_claims_typeGorodok',
                limit: -1,
                parameterValues: [
                    {
                        key: '@key',
                        value: key
                    },{
                        key: '@is_done',
                        value: is_done
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
    afterLoadDataHandler: function(data) {
        this.render();
        
        // this.createCustomStyle();
    },
    createElement: function(tag, props, ...children) {
        const element = document.createElement(tag);
        Object.keys(props).forEach( key => element[key] = props[key] );
        if(children.length > 0){
            children.forEach( child =>{
                element.appendChild(child);
            });
        } return element;
    },       
    createCustomStyle:function(){
        
        let element = document.querySelector('.dx-datagrid-save-button');
        element.style.marginRight = '9px';
        element.style.backgroundColor = '#5cb85c';
        
        // let spanElement = this.createElement('span', { className: 'dx-button-text', innerText: 'Зберегти'});
        element.firstElementChild.firstElementChild.style.color = '#fff';
        element.firstElementChild.lastElementChild.style.color = '#fff';
        element.parentElement.parentElement.classList.remove('dx-toolbar-text-auto-hide');

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
