(function () {
  return {
    config: {
        query: {
            code: 'Poshuk',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                dataField: 'navigation',
                caption: 'Джерело надходження',
            }, {
                dataField: 'registration_number',
                caption: 'Номер питання',
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
                dataField: 'QuestionType',
                caption: 'Тип питання',
            }, {
                dataField: 'zayavnyk',
                caption: 'Заявник',
            }, {
                dataField: 'adress',
                caption: 'Місце проблеми',
            }, {
                dataField: 'vykonavets',
                caption: 'Виконавець',
            }
        ],
        export: {
            enabled: false,
            fileName: 'Надійшло__'
        },
        searchPanel: {
            visible: false,
            highlightCaseSensitive: true
        },
		pager: {
            showPageSizeSelector:  true,
            allowedPageSizes: [5, 10, 15, 30],
            showInfo: true,
            pageSize: 10
        },
        paging: {
            pageSize: 10
        }, 
        scrolling: {
            mode: 'standart',
            rowRenderingMode: null,
            columnRenderingMode: null,
            showScrollbar: null
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
        showFilterRow: true,
        showHeaderFilter: false,
        showColumnChooser: false,
        showColumnFixing: true,
        groupingAutoExpandAll: null,
        onRowUpdating: function(data) {},
        onRowExpanding: function(data) {},
        onRowInserting: function(data) {},
        onRowRemoving: function(data) {},
        onCellClick: function(data) {},
        onRowClick: function(data) {},
        selectionChanged: function(data) {}
    },
    sub: [],
    sub1: [],
    init: function() {
        document.getElementById('searchTable').style.display = 'none';
        this.sub = this.messageService.subscribe('resultSearch', this.changeOnTable, this);
        this.sub1 = this.messageService.subscribe('clearInput', this.hideTable, this);
    },
    changeOnTable: function(message){
        if(message.value != ''){
            document.getElementById('searchTable').style.display = 'block';
            this.config.query.queryCode = 'Poshuk';
            this.config.query.parameterValues = [ { key: '@appealNum',  value: message.value},
                                                  { key: '@organization_id', value: message.orgId}
                                                  ];
            this.loadData(this.afterLoadDataHandler); 
            
            this.dataGridInstance.onCellClick.subscribe(e => {
                if(e.column.dataField == "registration_number" && e.row != undefined){
                    this.goToSection('Assignments/edit/'+e.row.data.Id+'');
                }
            });
        }
    },
    hideTable: function(message){
        document.getElementById('searchTable').style.display = 'none';
    },
	afterLoadDataHandler: function(data) {
		this.render();
	},    
    destroy: function() {
        this.sub.unsubscribe();
        this.sub1.unsubscribe();
    }
};
}());
