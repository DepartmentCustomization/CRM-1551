(function () {
  return {
    title: 'Кількість відключених будинків',
    config: {
        query: {
            code: 'db_Report_6_2',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
           {
                dataField: 'district',
                caption: 'Район',
            }, {
                dataField: 'gvpQty',
                caption: 'Відсутність ГВП',
            }, {
                dataField: 'hvpQty',
                caption: 'Відсутність ХВП',
            }, {
                dataField: 'heatingQty',
                caption: 'Відсутність опалення',
            }, {
                dataField: 'electricityQty',
                caption: 'Відсутність електроенергії',
            }
        ],
        keyExpr: 'Id',
        showBorders: false,
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
    },
    init: function() {
        this.dataGridInstance.height = window.innerHeight / 2 - 150;
        this.sub = this.messageService.subscribe( 'GlobalFilterChanged', this.getFiltersParams, this );
    },
    getFiltersParams: function(message){
        let period = message.package.value.values.find(f => f.name === 'period').value;
        if( period !== null ){
            this.dateFrom =  period.dateFrom;
    	    this.dateTo = period.dateTo;
    	    
            this.config.query.parameterValues = [ 
                {key: '@dateFrom' , value: this.dateFrom },  
                {key: '@dateTo', value: this.dateTo },  
            ];
            this.loadData(this.afterLoadDataHandler);
        }
    }, 
    afterLoadDataHandler: function(data) {
        this.render();
    },
    destroy: function(){
        this.sub.unsubscribe();
    },
};
}());
