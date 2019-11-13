(function () {
  return {
    config: {
        query: {
            code: 'db_Report_4',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                dataField: 'orgName',
                caption: 'Назва установи',
                width: 400,
            },  {
                dataField: 'AllCount',
                caption: 'Кількість звернень',
                alignment: 'center',
            },  {
                caption: 'Закриття виконавцем',
                columns: [
                    {
                        caption: "Вчасно",
                        dataField: "inTimeQty",
                        alignment: 'center'
                    }, {
                        caption: "Не вчасно",
                        dataField: "outTimeQty",
                        alignment: 'center'
                    }, {
                        caption: "Зареєстровано",
                        dataField: "waitTimeQty",
                        alignment: 'center'
                    }
                ]
            },  {
                caption: 'Виконання звернень',
                columns: [
                    {
                        caption: "Виконано",
                        dataField: "doneClosedQty",
                        alignment: 'center'
                    }, {
                        caption: "Не виконано",
                        dataField: "notDoneClosedQty",
                        alignment: 'center'
                    }, {
                        caption: "На перевірці",
                        dataField: "doneOnCheckQty",
                        alignment: 'center'
                    }
                ]
            },  {
                dataField: 'inWorkQty',
                caption: 'В роботі',
                alignment: 'center',
            },  {
                dataField: 'inTimePercent',
                caption: '% вчасно закритих',
                alignment: 'center',
                format: function(value){
                    return value + '%';
                },        
            },  {
                dataField: 'donePercent',
                caption: '% виконання',
                alignment: 'center',
            } 
        ],
        keyExpr: 'Id',
        scrolling: {
            mode: 'virtual'
        },
        filterRow: {
            visible: true,
            applyFilter: "auto"
        },
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
        this.dataGridInstance.height = window.innerHeight - 200;
        this.sub = this.messageService.subscribe( 'GlobalFilterChanged', this.getFiltersParams, this );
    },
    getFiltersParams: function(message){
        let period = message.package.value.values.find(f => f.name === 'period').value;
        let questionType = message.package.value.values.find(f => f.name === 'questionType').value;
        let organization = message.package.value.values.find(f => f.name === 'organization').value;
	    if( period !== null ){
    		if( period.dateFrom !== '' && period.dateTo !== ''){
                    
                this.dateFrom =  period.dateFrom;
                this.dateTo = period.dateTo;
                this.questionType = questionType === null ? 0 : questionType === '' ? 0 : questionType.value;
                this.organization = organization === null ? 0 : organization === '' ? 0 : organization.value ;
                this.config.query.parameterValues = [ 
                    {key: '@dateFrom' , value: this.dateFrom },  
                    {key: '@dateTo', value: this.dateTo },  
                    {key: '@question_type_id', value: this.questionType },  
                    {key: '@org', value: this.organization }  
                ];
                this.loadData(this.afterLoadDataHandler);
	        }
	    }
    }, 
    extractOrgValues: function(val) {
        if(val !== ''){
            var valuesList = [];
            valuesList.push(val.value);
            return  valuesList.length > 0 ? valuesList : [];
        } else {
            return [];
        };
	},    
    afterLoadDataHandler: function(data) {
        this.render();
    },
    destroy: function(){
        this.sub.unsubscribe();
    }, 
};
}());
