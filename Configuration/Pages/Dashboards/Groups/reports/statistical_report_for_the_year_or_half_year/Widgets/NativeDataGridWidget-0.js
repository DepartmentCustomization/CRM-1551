(function () {
  return {
    config: {
        query: {
            code: 'db_Report_7_1',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
               caption: 'Кількість звернень',
               columns: [
                    {
                        caption: 'усіх',
                        alignment: 'center',
                        height: 100,
                        columns: [
                            {
                                caption: '2018',
                                dataField: 'qtyPrev',
                                alignment: 'center',
                            }, {
                                caption: '2019',
                                dataField: 'qtyCurrent',
                                alignment: 'center',
                            }
                        ]
                    }, {
                        caption: 'що надійшли поштою (п. 1.1)*',
                        alignment: 'center',
                        columns: [
                            {
                                caption: '2018',
                                dataField: 'qtyMail_prev',
                                alignment: 'center',
                                
                            }, {
                                caption: '2019',
                                dataField: 'qtyMail_curr',
                                alignment: 'center',
                            }
                        ]
                        
                    }, {
                        caption: 'на особистому прийомі (п. 1.2)*',
                        alignment: 'center',
                        columns: [
                            {
                                caption: '2018',
                                dataField: 'qtyPersonal_prev',
                                alignment: 'center',
                                
                            }, {
                                caption: '2019',
                                dataField: 'qtyPersonal_curr',
                                alignment: 'center',
                            }
                            
                        ]
                    },
               ]
            }, {
                caption: 'Результати розгляду звернень:',
                alignment: 'center',
                columns: [
                    {
                        caption: 'вирішено позитивно (виконано) п. 9.1',
                        alignment: 'center',
                        columns: [
                            {
                                caption: '2018',
                                dataField: 'qtyPos_prev',
                                alignment: 'center',
                            }, {
                                dataField: 'qtyPos_curr',
                                alignment: 'center',
                                caption: '2019',
                            }
                        ]
                    }, {
                        
                        caption: 'відмолено у задоволенні (не виконано) п. 9.2',
                        alignment: 'center',
                        columns: [
                            {
                                caption: '2018',
                                dataField: 'qtyNeg_prev',
                                alignment: 'center',
                            }, {
                                dataField: 'qtyNeg_curr',
                                alignment: 'center',
                                caption: '2019',
                            }
                        ]
                    }, {
                        caption: 'дано роз’яснення п. 9.3',
                        alignment: 'center',
                        columns: [
                            {
                                caption: '2018',
                                dataField: 'qtyExpl_prev',
                                alignment: 'center',
                            }, {
                                dataField: 'qtyExpl_curr',
                                alignment: 'center',
                                caption: '2019',
                            }
                        ]
                    }, {
                        caption: 'інше п. 9.4 - 9.6',
                        alignment: 'center',
                        columns: [
                            {
                                caption: '2018',
                                dataField: 'qtyElse_prev',
                                alignment: 'center',
                            }, {
                                dataField: 'qtyElse_curr',
                                alignment: 'center',
                                caption: '2019',
                            }
                        ]
                    }
                ]
            }
        ],
        keyExpr: 'qtyExpl_prev'
    },
    init: function() {
		let date = new Date();
        let yyyy = date.getFullYear();
	    this.currentYear = yyyy
        this.previousYear = yyyy - 1;
        this.sub =  this.messageService.subscribe( 'GlobalFilterChanged', this.getFilterParams, this );
        this.config.onContentReady = this.afterRenderTable.bind(this);
        this.dataGridInstance.onContentReady = this.onContentReady();
    },
	afterRenderTable: function(){
	    this.config.columns.forEach( el => {
			el.columns[0].caption = this.previousYear;
			el.columns[1].caption = this.currenYear;
        });
		let tds = document.querySelectorAll('td');
		tdsArr = Array.from(tds);
		tdsArr.forEach( el => {
		   el.style.whiteSpace = "pre-wrap";
		});
		
        let noWrapTdCollection = document.querySelectorAll('.dx-datagrid-text-content');
        let noWrapTdArr = Array.from(noWrapTdCollection);
        noWrapTdArr.forEach( td => {
            td.style.whiteSpace = "pre-wrap";
            td.parentElement.style.verticalAlign = "middle";
        });	
	},    
	getFilterParams: function(message){
        let period = message.package.value.values.find(f => f.name === 'period').value;
        
	    if( period !== null ){
    		if( period.dateFrom !== '' && period.dateTo !== ''){
                this.dateFrom =  period.dateFrom;
                this.dateTo = period.dateTo;
                
        	    this.previousYear = this.changeDateTimeValues(this.dateFrom);
        	    this.currentYear = this.changeDateTimeValues(this.dateTo);
        	    if( this.previousYear === this.currentYear){
        	        this.previousYear -= 1;
                    this.config.query.parameterValues = [ 
                        {key: '@dateFrom' , value: this.dateFrom },  
                        {key: '@dateTo', value: this.dateTo },  
                    ];
                    this.loadData(this.afterLoadDataHandler);
        	    }else{
                    this.messageService.publish( { name: 'showWarning' });
        	    }
	        }
	    }
    },
	changeDateTimeValues: function(value){
        let date = new Date(value);
        let yyyy = date.getFullYear();
        return yyyy;
    },      
    afterLoadDataHandler: function(data) {
        this.messageService.publish( {name: 'setData', rep1_data: data} );
        this.render(this.onContentReady());
    },
	onContentReady: function(){
		this.config.columns.forEach( el => {
		    el.columns.forEach( elem =>  {
			    elem.columns[0].caption = this.previousYear;
			    elem.columns[1].caption = this.currentYear;
		        
		    });
		});
	},    
    destroy: function(){
        this.sub.unsubscribe();
    },
};
}());
