(function () {
  return {
    config: {
        query: {
            code: 'db_Report_7_2',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                caption: 'Повторних (п. 2.2)',
                columns: [
                    {
                        caption: 'previousYear',
                        dataFields: 'qtyRepeated_prev',
                        alignment: 'center',
                        customizeText: function(cellInfo) {
                            let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                            return value;
                        }
                    },  {
                        caption: 'currentYear',
                        dataFields: 'qtyRepeated_curr',
                        alignment: 'center',
                        customizeText: function(cellInfo) {
                            let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                            return value;
                        }
                    }
                ]
            }, {
                caption: 'колективних (п. 5.2)',
                columns: [
                    {
                        caption: 'previousYear',
                        dataFields: 'qtyСollective_prev',
                        alignment: 'center',
                        customizeText: function(cellInfo) {
                            let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                            return value;
                        }
                    }, {
                        caption: 'currentYear',
                        dataFields: 'qtyСollective_curr',
                        alignment: 'center',
                        customizeText: function(cellInfo) {
                            let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                            return value;
                        }
                    }
                ]
            }, {
                caption: 'від учасників та інвалідів війни, учасників бойових дій (п. 7.1, 7.3, 7.4, 7.5)',
                columns: [
                    {
                        caption: 'previousYear',
                        dataFields: 'qtyWarsParticipants_prev',
                        alignment: 'center',
                        customizeText: function(cellInfo) {
                            let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                            return value;
                        }
                    }, {
                        caption: 'currentYear',
                        dataFields: 'qtyWarsParticipants_curr',
                        alignment: 'center',
                        customizeText: function(cellInfo) {
                            let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                            return value;
                        }
                    }
                ]
            }, {
                caption: 'від інвалідів I, II, III групи (п. 7.7, 7.8, 7.9)',
                columns: [
                    {
                        caption: 'previousYear',
                        dataFields: 'qtyInvalids_prev',
                        alignment: 'center',
                        customizeText: function(cellInfo) {
                            let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                            return value;
                        }
                    }, {
                        caption: 'currentYear',
                        dataFields: 'qtyInvalids_curr',
                        alignment: 'center',
                        customizeText: function(cellInfo) {
                            let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                            return value;
                        }
                    }
                ]
            }, {
                caption: 'від ветеранів праці (п. 7.6)',
                columns: [
                    {
                        caption: 'previousYear',
                        dataFields: 'qtyWorkVeterans_prev',
                        alignment: 'center',
                        customizeText: function(cellInfo) {
                            let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                            return value;
                        }
                    }, {
                        caption: 'currentYear',
                        dataFields: 'qtyWorkVeterans_curr',
                        alignment: 'center',
                        customizeText: function(cellInfo) {
                            let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                            return value;
                        }
                    }
                ]
            }, {
                caption: 'від дітей війни (п. 7.2)',
                columns: [
                    {
                        caption: 'previousYear',
                        dataFields: 'qtyWarKids_prev',
                        alignment: 'center',
                        customizeText: function(cellInfo) {
                            let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                            return value;
                        }
                    }, {
                        caption: 'currentYear',
                        dataFields: 'qtyWarKids_curr',
                        alignment: 'center',
                        customizeText: function(cellInfo) {
                            let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                            return value;
                        }
                    }
                ]
            }, {
                caption: 'від членів багатодітних сімей, одиноких матерів, матерів-героїнь (п. 7.11, 7.12, 7.13)',
                columns: [
                    {
                        caption: 'previousYear',
                        dataFields: 'qtyFamily_prev',
                        alignment: 'center',
                        customizeText: function(cellInfo) {
                            let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                            return value;
                        }
                    }, {
                        caption: 'currentYear',
                        dataFields: 'qtyFamily_curr',
                        alignment: 'center',
                        customizeText: function(cellInfo) {
                            let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                            return value;
                        }
                    }
                ]
            }, {
                caption: 'від учасників ліквідації аварії на ЧАЕС та осіб, що потерпіли від Чорнобильської катастрофи (п. 7.14, 7.15)',
                columns: [
                    {
                        caption: 'previousYear',
                        dataFields: 'qtyChernobyl_prev',
                        alignment: 'center',
                        customizeText: function(cellInfo) {
                            let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                            return value;
                        }
                    }, {
                        caption: 'currentYear',
                        dataFields: 'qtyChernobyl_curr',
                        alignment: 'center',
                        customizeText: function(cellInfo) {
                            let value = cellInfo.value === null ? ' - ' :  cellInfo.value ;
                            return value;
                        }
                    }
                ]
            }, 
        ],
        keyExpr: 'qtyRepeated_prev'
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
			el.columns[1].caption = this.currentYear;
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
        	    }
	        }
	    }
    },
	changeDateTimeValues: function(value){
        let date = new Date(value);
        let yyyy = date.getFullYear();
        return yyyy;
    },      
    destroy: function(){
        this.sub.unsubscribe();
    },
    afterLoadDataHandler: function(data) {
        this.messageService.publish( {name: 'setData', rep2_data: data} );
        this.render(this.onContentReady());
    },
	onContentReady: function(){
	   this.config.columns.forEach( el => {
            el.columns[0].caption = this.previousYear;
			el.columns[1].caption = this.currentYear;
		}); 
	},    
    destroy: function(){
        this.sub.unsubscribe();
    },    
};
}());
