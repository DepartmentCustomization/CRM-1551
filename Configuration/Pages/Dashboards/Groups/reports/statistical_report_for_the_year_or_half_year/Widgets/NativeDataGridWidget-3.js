(function () {
  return {
    config: {
        query: {
            code: 'db_Report_7_3',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                dataField: 'source',
                caption: ' ',
                width: 200,
                wordWrapEnabled: true,
                height: 150
            }, 
            {
                caption: 'у тому числі питання:',
                columns: [
                    {
                        caption: 'Кількість питань,порушених у зверненнях громадян',
                        alignment: 'center',
                        height: 150,
                        columns: [
                            {
                                caption: 'previousYear',
                                dataField: 'prevAll',
                                alignment: 'center',
                                
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }, {
                                caption: 'currentYear',
                                dataField: 'curAll',
                                alignment: 'center',
                                wordWrapEnabled: true,
                                height: 150,                                
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }
                        ]
                    }, {
                        caption: 'аграрної політики і земельних відносин',
                        alignment: 'center',
                        columns: [
                            {
                                caption: 'previousYear',
                                dataField: 'prevAgr',
                                alignment: 'center',
                                wordWrapEnabled: true,
                                height: 150,
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }, {
                                caption: 'currentYear',
                                dataField: 'curAgr',
                                alignment: 'center',
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }
                        ]
                    }, {
                        caption: 'транспорту і зв’язку',
                        alignment: 'center',
                        columns: [
                            {
                                caption: 'previousYear',
                                dataField: 'prevTrans',
                                alignment: 'center',
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }, {
                                caption: 'currentYear',
                                dataField: 'curTrans',
                                alignment: 'center',
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }
                        ]
                    }, {
                        caption: 'фінансової, податкової,митної політики',
                        alignment: 'center',
                        columns: [
                            {
                                caption: 'previousYear',
                                dataField: 'prevFinance',
                                alignment: 'center',
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }, {
                                caption: 'currentYear',
                                dataField: 'curFinance',
                                alignment: 'center',
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }
                        ]
                    }, {
                        caption: 'соціального захисту',
                        alignment: 'center',
                        columns: [
                            {
                                caption: 'previousYear',
                                dataField: 'prevSocial',
                                alignment: 'center',
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }, {
                                caption: 'currentYear',
                                dataField: 'curSocial',
                                alignment: 'center',
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }
                        ]
                    }, {
                        caption: 'праціі заробітної плати, охорони праці, промислової безпеки',
                        alignment: 'center',
                        columns: [
                            {
                                caption: 'previousYear',
                                dataField: 'prevWork',
                                alignment: 'center',
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }, {
                                caption: 'currentYear',
                                dataField: 'curWork',
                                alignment: 'center',
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }
                        ]
                    }, {
                        caption: 'охорони здоров’я',
                        alignment: 'center',
                        columns: [
                            {
                                caption: 'previousYear',
                                dataField: 'prevHealth',
                                alignment: 'center',
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }, {
                                caption: 'currentYear',
                                dataField: 'curHealth',
                                alignment: 'center',
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }
                        ]
                    }
                ]
            }, 
            
        ],
        keyExpr: 'source'
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
    afterLoadDataHandler: function(data) {
        this.messageService.publish( {name: 'setData', rep3_data: data} );
        this.render(this.onContentReady());
    },
	onContentReady: function(){
		this.config.columns[1].columns.forEach( el => {
			el.columns[0].caption = this.previousYear;
			el.columns[1].caption = this.currentYear;
		});
	},    
	changeDateTimeValues: function(value){
        let date = new Date(value);
        let yyyy = date.getFullYear();
        return yyyy;
    },     
	afterRenderTable: function(){

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
        	    }
	        }
	    }
    },
    destroy: function(){
        this.sub.unsubscribe();
    },    
};
}());
