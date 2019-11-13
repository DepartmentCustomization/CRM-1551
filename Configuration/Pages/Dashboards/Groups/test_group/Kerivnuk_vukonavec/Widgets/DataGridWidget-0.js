(function () {
  return {
    config: {
        query: {
            code: 'events',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [
                        { key: '@pageOffsetRows', value: 50},
                        { key: '@pageLimitRows', value: 5}
                ],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                dataField: 'type',
                caption: ' ',
                width: 50,
                fixed: true,
                allowSorting: true,                
            },{
                dataField: 'Systems',
                caption: 'Система',
                width: 50,
                fixed: true,
                allowSorting: true,                
            },{
                dataField: 'Gorodok',
                caption: 'Городок',
                width: 50,
                fixed: true,
                allowSorting: true,                
            }
        ],
        export: {
            enabled: false,
            fileName: 'Events_'
        },
        searchPanel: {
            visible: false,
            highlightCaseSensitive: true
        },
        pager: {
            showPageSizeSelector: false,
            allowedPageSizes: [10, 15, 30],
            showInfo: false,
            pageSize: 15
        },
        editing: {
            enabled: false,
        },
        scrolling: {
            mode: 'standart',
            rowRenderingMode: null,
            columnRenderingMode: null,
            showScrollbar: null
        },
        keyExpr: 'type',
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
        showHeaderFilter: false,
        showColumnChooser: false,
        showColumnFixing: true,
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
    sub: [],
    organizationId: [],
    containerCell: [],
    init: function() {
        this.sub = this.messageService.subscribe('organizationId', this.orgId, this);
        
        this.loadData(this.afterLoadDataHandler);
        this.dataGridInstance.onCellClick.subscribe(e => {
            if(this.containerCell[0]){
                this.containerCell[0].style.removeProperty("background-color");
            }
            this.containerCell = [];
            this.containerCell.push(e.cellElement);
            this.containerCell[0].style.backgroundColor = '#aba8aa';
            var orgId = this.organizationId[0];
            if(e.row != undefined && e.column.dataField != 'navigation'){
                this.sendMesOnBtnClick('clickOnTable2', e.column.caption, e.row.data.type, orgId);
            }
            if( e.row == undefined ){
                const all = 'Усі';
                this.sendMesOnBtnClick('clickOnTable2', e.column.caption, all);                
            }
        });
    },
    sendMesOnBtnClick: function(message, columnIndex, rowName, orgName, orgId){
        this.messageService.publish({name: message, column: columnIndex, row: rowName, orgId: this.organizationId});
    }, 
    orgId: function(message){
        this.organizationId = message.value;  
    },
	afterLoadDataHandler: function(data) {
		this.render();
	},    
    destroy: function() {
        this.sub.unsubscribe();
    }
};
}());
