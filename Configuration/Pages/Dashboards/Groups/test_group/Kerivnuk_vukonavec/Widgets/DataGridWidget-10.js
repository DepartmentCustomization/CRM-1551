(function () {
  return {
    config: {
        query: {
            code: 'NaDooprNemaMozhlVyk',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                dataField: 'registration_number',
                caption: 'Номер питання',
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
                dataField: 'control_date',
                caption: 'Дата контролю',
            }
        ],
        export: {
            enabled: false,
            fileName: 'На доопрацюванні_Не виконано/Немає можливісті виконати в данний період'
        },
        searchPanel: {
            visible: false,
            highlightCaseSensitive: true
        },
        masterDetail: {
            enabled: true,
        },
        pager: {
            showPageSizeSelector: false,
            allowedPageSizes: [10, 15, 30],
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
        showFilterRow: true,
        showHeaderFilter: false,
        showColumnChooser: false,
        showColumnFixing: true,
        groupingAutoExpandAll: null,
        sortingMode: 'multiple',
        selection: {
            mode: "multiple"
        },
        onRowUpdating: function(data) {},
        onRowExpanding: function(data) {},
        onRowInserting: function(data) {},
        onRowRemoving: function(data) {},
        onCellClick: function(data) {},
        onRowClick: function(data) {},
        selectionChanged: function(data) {}
    },
    sub: [],
    containerForChackedBox: [],
    init: function() {
        document.getElementById('table10_nemaMozhl').style.display = 'none';
        this.sub = this.messageService.subscribe('clickOnTable2', this.changeOnTable, this);
        
        this.dataGridInstance.onCellClick.subscribe(e => {
            if(e.column.dataField == "registration_number" && e.row != undefined){
                this.goToSection('Assignments/edit/'+e.row.data.Id+'');
            }
        });
    },
    changeOnTable: function(message){
        if( message.column != 'План/Програма'){
            document.getElementById('table10_nemaMozhl').style.display = 'none';
        }else{
            document.getElementById('table10_nemaMozhl').style.display = 'block';
            this.config.query.queryCode = 'NaDooprNemaMozhlVyk';
            this.config.query.parameterValues = [{ key: '@organization_id',  value: message.orgId},
                                                 { key: '@column', value: message.column},
                                                 { key: '@navigation', value: message.row}];
            this.loadData(this.afterLoadDataHandler);          
        }
    },
	afterLoadDataHandler: function(data) {
		this.render();
	},	    
    destroy: function() {
        this.sub.unsubscribe();
    }
};
}());
