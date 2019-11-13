(function () {
  return {
    config: {
        query: {
            code: 'CoordinatorController_table',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                dataField: 'navigation',
                caption: '',
                width: 200,
                fixed: true,
            }, {
                dataField: 'neVKompetentsii',
                caption: 'Не в компетенції', 
                width: 50,
                fixed: true,
            }, {
                dataField: 'doopratsiovani',
                caption: 'Доопрацьовані',
                width: 50,
                fixed: true,                
            }, {
                dataField: 'rozyasneno',
                caption: 'Роз`яcнено',
                width: 50,
                fixed: true,                
            }, {
                dataField: 'prostrocheni',
                caption: 'Прострочені',
                width: 50,
                fixed: true,                
            }, {
                dataField: 'neVykonNeMozhl',
                caption: 'Не можливо виконати в даний період',
                width: 50,
                fixed: true,                
            }
        ],
        summary: [
            {
                column: "neVKompetentsii",
                summaryType: "sum",
                customizeText: function(data) {
                    return "Всього: " + (data.value);
                }
            }, {
                column: "doopratsiovani",
                summaryType: "sum",
                customizeText: function(data) {
                    return "Всього: " + (data.value);
                }
            }, {
                column: "rozyasneno",
                summaryType: "sum",
                customizeText: function(data) {
                    return "Всього: " + (data.value);
                }
            }, {
                column: "prostrocheni",
                summaryType: "sum",
                customizeText: function(data) {
                    return "Всього: " + (data.value);
                }
            }, {
                column: "neVykonNeMozhl",
                summaryType: "sum",
                customizeText: function(data) {
                    return "Всього: " + (data.value);
                }
            },
        ],
        export: {
            enabled: false,
            fileName: 'File_name'
        },
        
        searchPanel: {
            visible: false,
            highlightCaseSensitive: false
        },
        pager: {
            showPageSizeSelector:  false,
            allowedPageSizes: [5, 10, 15],
            showInfo: false,
            pageSize: 10
        },
        editing: {
            enabled: false,
            allowAdding: false,
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
        showFilterRow: false,
        showHeaderFilter: false,
        showColumnChooser: false,
        showColumnFixing: true,
        groupingAutoExpandAll: null,
        masterDetail: null,
        sortingMode: 'multiple',
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
    containerCell: [],
    Obj: { key: 'color', value: 'red'},
    init: function() {
        
        this.sub = this.messageService.subscribe('reloadAssignmentsTable', this.reloadMainTable, this);
        this.config.query.queryCode = 'CoordinatorController_table';
        this.config.query.parameterValues = [ ];
        this.loadData(this.afterLoadDataHandler);
        
        this.dataGridInstance.onCellClick.subscribe(e => {
            if(this.containerCell[0]){
                this.containerCell[0].style.removeProperty("background-color");
                this.containerCell[0].style.removeProperty("color");
            }
            this.containerCell = [];
            this.containerCell.push(e.cellElement);
            this.containerCell[0].style.backgroundColor = '#5cb85c';
            this.containerCell[0].style.color = '#fff';
            if(e.row != undefined && e.column.dataField != 'navigation'){
                this.sendMesOnBtnClick('clickOnСoordinator_table', e.column.caption, e.row.data.navigation);
            }
            if( e.row == undefined ){
                const all = 'Усі';
                this.sendMesOnBtnClick('clickOnСoordinator_table', e.column.caption, all);                
            }
        });
    },
    reloadMainTable: function(){
        this.config.query.queryCode = 'CoordinatorController_table';
        this.config.query.parameterValues = [];
        this.loadData(this.afterLoadDataHandler);
    },
    sendMesOnBtnClick: function(message, column, navigator){
        this.messageService.publish({name: message, column: column,  value: navigator });
    },
    afterLoadDataHandler: function(data) {
        this.render();
    },    
    destroy: function() {
    }
};
}());
