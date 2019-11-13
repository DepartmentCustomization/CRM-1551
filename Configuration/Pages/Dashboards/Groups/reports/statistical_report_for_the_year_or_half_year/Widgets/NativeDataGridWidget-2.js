(function () {
  return {
    config: {
        query: {
            code: 'db_Report_7_4',
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
                width: 200
            }, 
            {
                caption: 'у тому числі питання:',
                columns: [
                    {
                        caption: 'комунального господарства',
                        alignment: 'center',
                        height: 150,
                        columns: [
                            {
                                caption: 'previousYear',
                                dataField: 'prevCommunal',
                                alignment: 'center',
                                
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }, {
                                caption: 'currentYear',
                                dataField: 'curCommunal',
                                alignment: 'center',
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }
                        ]
                    }, {
                        caption: 'житлової політики',
                        alignment: 'center',
                        columns: [
                            {
                                caption: 'previousYear',
                                dataField: 'prevResidential',
                                alignment: 'center',
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }, {
                                caption: 'currentYear',
                                dataField: 'curResidential',
                                alignment: 'center',
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }
                        ]
                    }, {
                        caption: 'екології та природних ресурсів',
                        alignment: 'center',
                        columns: [
                            {
                                caption: 'previousYear',
                                dataField: 'prevEcology',
                                alignment: 'center',
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }, {
                                caption: 'currentYear',
                                dataField: 'curEcology',
                                alignment: 'center',
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }
                        ]
                    }, {
                        caption: 'забезпечення дотримання законності та охорони правопорядку, запобігання дискримінації',
                        alignment: 'center',
                        columns: [
                            {
                                caption: 'previousYear',
                                dataField: 'prevLaw',
                                alignment: 'center',
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }, {
                                caption: 'currentYear',
                                dataField: 'curLaw',
                                alignment: 'center',
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }
                        ]
                    }, {
                        caption: 'сімейної та гендерної політики, захисту прав дітей',
                        alignment: 'center',
                        columns: [
                            {
                                caption: 'previousYear',
                                dataField: 'prevFamily',
                                alignment: 'center',
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }, {
                                caption: 'currentYear',
                                dataField: 'curFamily',
                                alignment: 'center',
                                customizeText: function(cellInfo) {
                                    let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                                    return value;
                                }
                            }
                        ]
                    }, {
                        caption: 'освіти, наукової, науково-технічної, інноваційної діяльності та інтелектуальної власності',
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
                                dataField: 'curSince',
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
        function setTdPreWrap(){
            let noWrapTdCollection = document.querySelectorAll('.dx-datagrid-text-content');
            let noWrapTdArr = Array.from(noWrapTdCollection);
            noWrapTdArr.forEach( td => {
                td.style.whiteSpace = "pre-wrap";
                td.parentElement.style.verticalAlign = "middle";
            });
        }
        setTimeout(setTdPreWrap, 100);
    },
	onContentReady: function(){
	   this.config.columns[1].columns.forEach( el => {
			el.columns[0].caption = this.previousYear;
			el.columns[1].caption = this.currentYear;
		}); 
	},
    afterLoadDataHandler: function(data) {
        this.messageService.publish( {name: 'setData', rep4_data: data} );
        this.render(this.onContentReady());
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
