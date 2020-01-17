(function () {
  return {
    config: {
        query: {
            code: 'ListQuestionTypesForConstructor',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                dataField: 'Name',
                caption: 'Тип питання',
            }
        ],
        filterRow: { 
            visible: true
        },
        editing: {
            refreshMode: "reshape",
            mode: "cell",
            allowAdding: true,
            allowUpdating: true,
            allowDeleting: true,
            useIcons: true
        },
        keyExpr: 'Id',
    },
    init: function() {
        this.selectedRows = [];
        this.dataGridInstance.height = window.innerHeight - 200 + '';
        this.sub = this.messageService.subscribe('sendSelectedRow', this.setReceivedData, this);
        this.sub1 = this.messageService.subscribe('sendDataCleanup', this.clearData, this);
        this.config.onToolbarPreparing = this.createTableButton.bind(this);
        this.config.query.parameterValues = [ { key: '@GroupQuestionId', value: 0}],
        this.config.onContentReady = this.afterRenderTable.bind(this);
        this.loadData(this.afterLoadDataHandler);
    },
    createTableButton: function(e) {
        let toolbarItems = e.toolbarOptions.items;
        
        toolbarItems.push({
            widget: "dxButton", 
            location: "after",
            options: { 
                icon: "clear",
                type: "default",
                onClick: function(e) {
                    e.event.stopImmediatePropagation();
                    this.clearData();
                }.bind(this)
            },
        });
    },
    sendMessToRenderTable: function(){
        let sendData = [];
        this.dataGridInstance.dataSource.forEach( row => {
            sendData.push(row.Id);
        });
        sendData = this.GroupQuestionId === null ? sendData : [] ;
        this.messageService.publish( { name: 'renderTable', questionGroupId: this.GroupQuestionId, questionTypesArr: sendData});
    },
    clearData: function(){
        this.selectedRows = [];
        this.config.query.parameterValues = [ { key: '@GroupQuestionId', value: 0}],
        this.config.query.filterColumns = [ ],
        this.loadData(this.afterLoadDataHandler);
    },
    setReceivedData: function(message){
        if(message.value.length > 0){
            if( message.position === 'clissificator' ){
                this.GroupQuestionId = null;
                this.config.query.filterColumns = [];
                let data = this.selectedRows;
                let index = data.indexOf(message.value[0].Id);
                if( index === -1){
                    data.push(message.value[0].Id);
                }
                let filter = {
                    key: "Id",
                    value: {
                        operation: 0,
                        not: false,
                        values: data
                    }
                };
                this.config.query.filterColumns.push(filter);
                this.config.query.parameterValues = [ { key: '@GroupQuestionId', value: null } ],
                this.loadData(this.afterLoadDataHandler);
            }else if( message.position === 'groups' ){
                this.GroupQuestionId = message.value[0].Id;
                this.config.query.parameterValues = [ { key: '@GroupQuestionId', value: this.GroupQuestionId}],
                this.config.query.filterColumns = [];
                this.loadData(this.afterLoadDataHandler);
            }
        }
    },     
    afterLoadDataHandler: function(data) {
        this.render();
    },
    afterRenderTable: function(){
        document.querySelectorAll('.dx-toolbar-after')[2].firstElementChild.style.display = 'none';
        
        if( this.GroupQuestionId !== undefined ){
            let sendData = [];
            this.dataGridInstance.dataSource.forEach( row => {
                sendData.push(row.Id);
            });
            sendData = this.GroupQuestionId === null ? sendData : [] ;
            this.messageService.publish( { name: 'renderTable', questionGroupId: this.GroupQuestionId, questionTypesArr: sendData});
        }
    },
    destroy: function(){
        this.sub.unsubscribe();
        this.sub1.unsubscribe();
    },
};
}());
