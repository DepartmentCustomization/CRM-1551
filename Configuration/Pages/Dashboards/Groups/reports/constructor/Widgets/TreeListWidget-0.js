(function () {
  return {
    config: {
        query: {
            code: 'ys_List_QuestionTypes2_SelectRows',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        keyExpr: 'Id',
        parentIdExpr: 'ParentId',
        expandedRowKeys: [1],
        selectedRowKeys: [2],
        columnAutoWidth: true,
        wordWrapEnabled: true,
        showRowLines: false,
        allowColumnReordering: true,
        allowColumnResizing: true,
        columnMinWidth: '50',
        showBorders: false,
        filterValue: null,
        columns: [
             {
                dataField: 'Name',
                caption: 'Назва питання',
            }
        ],
        scrolling: {
            mode: "virtual"
        }, 
        columnFixing: {
            enabled: false
        },
        searchPanel: {
            visible: false,
            width: null
        },
        headerFilter: {
            visible: false
        },
        filterRow: {
            visible: false
        },
        filterPanel: {
            visible: false
        },
        selection: {
            mode: 'single',
            allowSelectAll: true,
            recursive: false
        },
        columnChooser: {
            enabled: false,
            allowSearch: 'allowSearch'
        },
        paging: {
            enabled: false,
            pageSize: null
        },
        pager: {
            showPageSizeSelector: false,
            allowedPageSizes: [],
            showInfo: false
        },
        onSelectionChanged: function(e) {
        },
    },
    init: function() {
        
        this.treeListInstance.height = window.innerHeight - 200 + '';
        document.getElementById('question_classificatory').style.display = 'none';
        this.sub = this.messageService.subscribe('showTable', this.showTable, this);
        
        let self = this;
        this.treeListInstance.onToolbarPreparing.subscribe( e => {
            e.toolbarOptions.items.push({
                
                widget: "dxButton", 
                location: "after",
                options: {
                    type: "default",
                    icon: "add",
                    onClick: function() {
                        event.stopImmediatePropagation();
                        self.sendSelectItem();
                    } 
                },
            })
        });
        this.loadData();
    },    
    sendSelectItem: function(){
        let selectedRow = this.treeListInstance.instance.getSelectedRowsData();
        this.messageService.publish( { name: 'sendSelectedRow', value: selectedRow, position: 'clissificator' });
    },    
    showTable: function(message){
        if( message.value === 'group' ){
            document.getElementById('question_classificatory').style.display = 'none';
        }else if( message.value === 'default'){
            document.getElementById('question_classificatory').style.display = 'block';
        }
    },
    destroy: function(){
        this.sub.unsubscribe();
    },
};
}());
