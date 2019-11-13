(function () {
  return {
    config: {
        query: {
            code: 'db_Report_metro1',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                dataField: 'source',
                caption: 'Показники',
            }, {
                dataField: 'val',
                caption: 'Кількість ',
            }, 
        ],
        keyExpr: 'Id'
    },
    init: function() {
        this.sub = this.messageService.subscribe('GlobalFilterChanged', this.getFiltersParams , this );
        this.loadData(this.afterLoadDataHandler);
    },
    getFiltersParams: function(message){
    	let period = message.package.value.values.find(f => f.name === 'period').value;
    	if( period !== null ){
    		if( period.dateFrom !== '' && period.dateTo !== ''){
        		this.dateFrom =  period.dateFrom;
        		this.dateTo = period.dateTo;
        		this.config.query.parameterValues = [ 
        			{key: '@dateFrom' , value: this.dateFrom },  
        			{key: '@dateTo', value: this.dateTo },   
        		];
        		this.loadData(this.afterLoadDataHandler);
    		}
    	}
    },    
    afterLoadDataHandler: function(data) {
        this.messageService.publish( {name: 'setData', rep1_data: data} );
        this.render();
    },
};
}());
