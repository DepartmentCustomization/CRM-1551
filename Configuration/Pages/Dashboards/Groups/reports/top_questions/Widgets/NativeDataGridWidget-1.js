(function () {
  return {
    config: {
        query: {
            code: 'ys_List_QuestionTypes_SelectRows',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        keyExpr: 'Id',
        parentIdExpr: 'ParentId',
        expandedRowKeys: [ 1 ],
        selectedRowKeys: [],
        columnAutoWidth: true,
        wordWrapEnabled: true,
        showRowLines: true,
        allowColumnReordering: false,
        allowColumnResizing: true,
        columnMinWidth: '50',
        showBorders: false,
        filterValue: null,
        columns: [
            {
                dataField: 'Name',
                caption: 'Назва питання',
            }, 
        ],
        
        sorting: {
            mode: "none"
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
            allowSelectAll: false,
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
	    this.treeListInstance.height = window.innerHeight - 150;
        document.getElementById('rep_2_2_classifier_questions').style.display = 'none';
        this.sub = this.messageService.subscribe('showClassifierQuestions', this.showClassifierQuestionsTable, this);
        
	    let self = this;
        this.treeListInstance.onToolbarPreparing.subscribe( e => {
            e.toolbarOptions.items.push({
                
                widget: "dxButton", 
                location: "before",
                options: {
                    type: "default",
                    text: "До питань",
                    icon: "arrowleft",
                    onClick: function() { 
                        self.messageService.publish({ name: 'showTopQuestions' });
                    } 
                },
            })
        });
        this.loadData(); 
    },
    showClassifierQuestionsTable: function(){
        document.getElementById('rep_2_1_top_questions').style.display = 'none';
        document.getElementById('rep_2_2_classifier_questions').style.display = 'block';
    },
    destroy: function(){
        this.sub.unsubscribe();
    },     
};
}());
