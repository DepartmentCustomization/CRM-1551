(function () {
  return {
    config: {
        query: {
            code: 'Coordinator_Poshuk',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                dataField: 'id',
                caption: '',
                width: '0',
                fixed: true,

            }, {
                dataField: 'navigation',
                caption: 'Джерело надходження',
                fixed: true,
            }, {
                dataField: 'registration_number',
                caption: 'Номер питання',
                fixed: true,
                sortOrder: 'asc',
            }, {
                dataField: 'QuestionType',
                caption: 'Тип питання',
                fixed: true,
            }, {
                dataField: 'zayavnyk',
                caption: 'Заявник',
                fixed: true,
            }, {
                dataField: 'adress',
                caption: 'Місце проблеми',
                fixed: true,
            }, {
                dataField: 'vykonavets',
                caption: 'Виконавець',
                fixed: true,
            }
        ],
        export: {
            enabled: false,
            fileName: 'Пошук__'
        },
        searchPanel: {
            visible: false,
            highlightCaseSensitive: true
        },
		pager: {
            showPageSizeSelector:  true,
            allowedPageSizes: [10, 15, 30],
            showInfo: true,
            pageSize: 10
        },
        paging: {
            pageSize: 10
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
            this.config.query.queryCode = 'Coordinator_Poshuk';
            this.config.query.parameterValues = [{ key: '@appealNum',  value: message.value}];
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
