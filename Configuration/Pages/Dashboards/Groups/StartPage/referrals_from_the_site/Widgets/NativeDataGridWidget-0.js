(function () {
  return {
    config: {
        query: {
            code: 'db_AppealsFromSite',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                dataField: 'receiptDate',
                caption: 'Дата надходження',
                width: 200,
            }, {
                dataField: 'workDirection',
                caption: 'Напрямок робіт',
                width: 200,
            }, {
                dataField: 'appealObject',
                caption: 'Місце проблеми',
                width: 180,
            }, {
                dataField: 'content',
                caption: 'Зміст',
            }, {
                dataField: 'result',
                caption: 'Результат',
                width: 200,
            }, {
                dataField: 'moderComment',
                caption: 'Коментар',
                width: 350
            }, {
                dataField: 'linkTo',
                caption: 'Перехiд',
                width: 150,
                alignment: 'center'
            }, 
        ],
        pager: {
            showPageSizeSelector:  true,
            allowedPageSizes: [20, 50, 100],
            showInfo: true,
        },
        paging: {
            pageSize: 20
        },          
        keyExpr: 'Id',
        // scrolling: {
        //     mode: 'virtual'
        // },   
        filterRow: {
            visible: true,
            applyFilter: "auto"
        },
        showBorders: false,
        showColumnLines: false,
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
        
        this.dataGridInstance.height = window.innerHeight - 200 ;
        const self = this;
        this.sub = this.messageService.subscribe( 'GlobalFilterChanged', this.getFiltersParams, this );
        this.dataGridInstance.onCellClick.subscribe(e => {
            e.event.stopImmediatePropagation();
            if(e.column){
                if(e.column.dataField == "linkTo" && e.row != undefined){
                    window.open(location.origin + localStorage.getItem('VirtualPath') + "/sections/Appeals_from_Site/edit/"+e.key+"");
                }
            }
        });
        this.dataGridInstance.onCellPrepared.subscribe( e => {
            if(e.column.caption === "Перехiд" && e.data !== undefined){
                let icon = self.createElement('span', { className: 'iconToLink dx-icon-arrowright dx-icon-custom-style'} );
                e.cellElement.appendChild(icon);
            }
        });
    },
    getFiltersParams: function(message){
        let result = message.package.value.values.find(f => f.name === 'appeals_result').value;
        this.result = result === null ?  [] : result === '' ? 0 : this.extractFilterValues(result);
        this.config.query.parameterValues = [ 
            {key: '@result' , value: this.result },  
        ];
        this.config.query.filterColumns = [];
        if (this.result.length > 0) {
            const filter = {
                key: "result",
                value: {
                    operation: 0,
                    not: false,
                    values: this.result
                }
            };
            this.config.query.filterColumns.push(filter);
        }else{
            this.result = [ 1 ];
            const filter = {
                key: "result",
                value: {
                    operation: 0,
                    not: false,
                    values: this.result
                }
            };
            this.config.query.filterColumns.push(filter);
        }
        this.loadData(this.afterLoadDataHandler);
    },
    createElement: function(tag, props, ...children) {
        const element = document.createElement(tag);
        Object.keys(props).forEach( key => element[key] = props[key] );
        if(children.length > 0){
            children.forEach( child =>{
                element.appendChild(child);
            });
        } return element;
    },    
    extractFilterValues: function(val){
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
