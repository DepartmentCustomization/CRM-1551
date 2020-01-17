(function () {
  return {
    config: {
        query: {
            code: 'Coordinator_Poshuk',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                dataField: 'id',
                caption: '',
                width: '0',
                fixed: true,

            }, {
                dataField: 'navigation',
                caption: 'Джерело надходження',
                fixed: true,
            }, {
                dataField: 'registration_number',
                caption: 'Номер питання',
                fixed: true,
                sortOrder: 'asc',
            }, {
                dataField: 'QuestionType',
                caption: 'Тип питання',
                fixed: true,
            }, {
                dataField: 'zayavnyk',
                caption: 'Заявник',
                fixed: true,
            }, {
                dataField: 'adress',
                caption: 'Місце проблеми',
                fixed: true,
            }, {
                dataField: 'vykonavets',
                caption: 'Виконавець',
                fixed: true,
            }
        ],
        filterRow: {
            visible: true,
            applyFilter: "auto"
        },
        export: {
            enabled: true,
            fileName: 'Excel'
        },
        searchPanel: {
            visible: false,
            highlightCaseSensitive: true
        },
		pager: {
            showPageSizeSelector:  true,
            allowedPageSizes: [10, 15, 30],
            showInfo: true,
            pageSize: 10
        },
        paging: {
            pageSize: 10
        },  
        editing: {
            enabled: false,
        },
        scrolling: {
            mode: 'standart',
            rowRenderingMode: null,
            columnRenderingMode: null,
            showScrollbar: null
        },
        masterDetail: {
            enabled: true,
        },
        keyExpr: 'Id',
        focusedRowEnabled: true,
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
        this.dataGridInstance.height = window.innerHeight - 305;
        this.showPreloader = false;
        document.getElementById('searchTable').style.display = 'none';
        this.sub = this.messageService.subscribe('resultSearch', this.changeOnTable, this);
        this.sub1 = this.messageService.subscribe('clearInput', this.hideAllTable, this);
        this.sub2 = this.messageService.subscribe('clickOnСoordinator_table', this.hideSearchTable, this);
        document.getElementById('allTables').style.display = 'none';
        this.config.masterDetail.template = this.createMasterDetail.bind(this);
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
    createMasterDetail: function(container, options) {
        var currentEmployeeData = options.data;
        
        if(currentEmployeeData.short_answer == null){
            currentEmployeeData.short_answer = '';
        }
        if(currentEmployeeData.adressZ == null){
            currentEmployeeData.adressZ = '';
        }
        if(currentEmployeeData.question_content == null){
            currentEmployeeData.question_content = '';
        }
        let elementAdress__content = this.createElement('div', { className: 'elementAdress__content content', innerText: ""+currentEmployeeData.adressZ+""});
        let elementAdress__caption = this.createElement('div', { className: 'elementAdress__caption caption', innerText: "Адреса заявника"});
        let elementAdress = this.createElement('div', { className: 'elementAdress element'}, elementAdress__caption, elementAdress__content);
        
        let elementСontent__content = this.createElement('div', { className: 'elementСontent__content content', innerText: ""+currentEmployeeData.question_content+""});
        let elementСontent__caption = this.createElement('div', { className: 'elementСontent__caption caption', innerText: "Зміст"});
        let elementСontent = this.createElement('div', { className: 'elementСontent element'}, elementСontent__caption, elementСontent__content);
        
        let elementComment__content = this.createElement('div', { className: 'elementComment__content content', innerText: ""+currentEmployeeData.short_answer+""});
        let elementComment__caption = this.createElement('div', { className: 'elementComment__caption caption', innerText: "Коментар виконавця"});
        let elementComment = this.createElement('div', { className: 'elementСontent element'}, elementComment__caption, elementComment__content);
        
        let elementsWrapper  = this.createElement('div', { className: 'elementsWrapper'}, elementAdress, elementСontent, elementComment);
        container.appendChild(elementsWrapper);
        
        let elementsAll = document.querySelectorAll('.element');
        elementsAll = Array.from(elementsAll);
        elementsAll.forEach( el => {
            el.style.display = 'flex';
            el.style.margin = '15px 10px';
        });
        let elementsCaptionAll = document.querySelectorAll('.caption');
        elementsCaptionAll = Array.from(elementsCaptionAll);
        elementsCaptionAll.forEach( el => {
            el.style.minWidth = '200px';
        });
    },    
    changeOnTable: function(message){
        document.getElementById('allTables').style.display = 'none';
        if(message.value != ''){
            document.getElementById('searchTable').style.display = 'block';
            this.config.query.queryCode = 'Coordinator_Poshuk';
            this.config.query.parameterValues = [{ key: '@appealNum',  value: message.value}];
            this.loadData(this.afterLoadDataHandler);
            
            this.dataGridInstance.onCellClick.subscribe(e => {
                if(e.column) {
                    if(e.column.dataField === "registration_number" && e.row !== undefined) {
                        window.open(location.origin + localStorage.getItem('VirtualPath') + "/sections/Assignments/edit/"+e.key+"");
                    }
                }
            });
        }
    },
    hideAllTable: function(){
        document.getElementById('allTables').style.display = 'none';
        document.getElementById('searchTable').style.display = 'none';
    },    
    hideSearchTable: function(message){
        document.getElementById('allTables').style.display = 'block';
        document.getElementById('searchTable').style.display = 'none';
    },
	afterLoadDataHandler: function(data) {
		this.render();
        this.createCustomStyle();
	},	    
    createCustomStyle: function(){
        let elements = document.querySelectorAll('.dx-datagrid-export-button');
        elements = Array.from(elements);
        elements.forEach( function(element){
            let spanElement = this.createElement('span', { className: 'dx-button-text', innerText: 'Excel'});
            element.firstElementChild.appendChild(spanElement);
        }.bind(this));
    },    	
    destroy: function() {
        this.sub.unsubscribe();
        this.sub1.unsubscribe();
        this.sub2.unsubscribe();
    }
};
}());
