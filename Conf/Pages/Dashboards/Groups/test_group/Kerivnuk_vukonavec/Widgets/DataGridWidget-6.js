(function () {
  return {
    config: {
        query: {
            code: 'table3',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                dataField: 'OrganizationName',
                caption: '',
                width: 200,
                fixed: true,
                sortOrder: 'asc',
            },{
                dataField: 'nadiyshlo',
                caption: 'Надійшло',
                fixed: true,
            },{
                dataField: 'prostrocheni',
                caption: 'Прострочені',
                // width: 50,
                fixed: true,
            },{
                dataField: 'uvaga',
                caption: 'Увага',
                // width: 50,
                fixed: true,
            },{
                dataField: 'vroboti',
                caption: 'В роботі',
                // width: 50,
                fixed: true,
            },{
                dataField: 'dovidoma',
                caption: 'До відома',
                // width: 50,
                fixed: true,
            }
        ],
        export: {
            enabled: false,
            fileName: 'File_name'
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
        keyExpr: 'OrganizationId',
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
    init: function() {
        document.getElementById('table3__organization').style.display = 'none';
        this.sub = this.messageService.subscribe('reloadMainTable', this.changeOnTable, this);
        
        this.dataGridInstance.onCellClick.subscribe(e => {
            if( e.column.caption  == '' && e.row != undefined){
                this.goToChildOrg('clickOnTable3', e.row.data.OrganizationId );    
            }
        });
    },
    changeOnTable: function(message){
        document.getElementById('table2__mainTable').style.display = 'none';
        document.getElementById('table3__organization').style.display = 'block';
        
        this.config.query.queryCode = 'table3';
        this.config.query.parameterValues = [ { key: '@organization_id',  value: message.orgId} ];
        this.loadData(this.afterLoadDataHandler);
    },
    goToChildOrg: function(message, orgId){
        this.messageService.publish( { name: message, value: orgId } );
    },
	afterLoadDataHandler: function(data) {
		this.render();
	},    
    destroy: function() {
        this.sub.unsubscribe();
    }

};
}());
