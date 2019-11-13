(function () {
  return {
    config: {
        query: {
            code: 'EventsTable',
            parameterValues: [
                {key: '@pageOffsetRows', value: 0},
                {key: '@pageLimitRows',  value: 15}
                ],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                dataField: 'EventType',
                caption: 'Номер заходу',
                fixed: true,
            },  {
                dataField: 'EventType',
                caption: 'Тип заходу',
                fixed: true,
            },  {
                dataField: 'EventName',
                caption: 'Назва',
                fixed: true,
            },  {
                dataField: 'start_date',
                caption: 'Дата початку',
                fixed: true,
                sortOrder: 'desc',
            },  {
                dataField: 'plan_end_date',
                caption: 'Планова дата закінчення',
                fixed: true,
            },  {
                dataField: 'CountQuestions',
                caption: 'К-ть питань пов`язаних з заходом',
                fixed: true,
            }
        ],
        masterDetail: {
            enabled: true,
        },
        export: {
            enabled: false,
            fileName: 'No_Competence'
        },
        searchPanel: {
            visible: false,
            highlightCaseSensitive: true
        },
        pager: {
            showPageSizeSelector: false,
            allowedPageSizes: [10, 15, 30],
            showInfo: false,
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
        keyExpr: 'EventId',
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
    sub1: [],
    init: function() {
        document.getElementById('table8_events').style.display = 'none';
        this.sub = this.messageService.subscribe('clickOnTable2', this.changeOnTable, this);
        this.sub1 = this.messageService.subscribe('search', this.searchRelust, this);
        
        this.config.masterDetail.template = this.createMasterDetail.bind(this);
        this.dataGridInstance.onCellClick.subscribe(e => {
            if(e.column.dataField == "registration_number" && e.row != undefined){
                this.goToSection('Assignments/edit/'+e.row.data.Id+'');
            }
        });
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
        
        if(currentEmployeeData.short_answer == null || currentEmployeeData.short_answer == undefined){
            currentEmployeeData.short_answer = '';
        }
        if(currentEmployeeData.zayavnyk_zmist == null || currentEmployeeData.zayavnyk_zmist == undefined){
            currentEmployeeData.zayavnyk_zmist = '';
        }
        if(currentEmployeeData.zayavnyk_adress == null || currentEmployeeData.zayavnyk_adress == undefined){
            currentEmployeeData.zayavnyk_adress = '';
        }
        let elementAdress__content = this.createElement('div', { className: 'elementAdress__content content', innerText: ""+currentEmployeeData.zayavnyk_adress+""});
        let elementAdress__caption = this.createElement('div', { className: 'elementAdress__caption caption', innerText: "Адреса заявника"});
        let elementAdress = this.createElement('div', { className: 'elementAdress element'}, elementAdress__caption, elementAdress__content);
        
        let elementСontent__content = this.createElement('div', { className: 'elementСontent__content content', innerText: ""+currentEmployeeData.zayavnyk_zmist+""});
        let elementСontent__caption = this.createElement('div', { className: 'elementСontent__caption caption', innerText: "Зміст"});
        let elementСontent = this.createElement('div', { className: 'elementСontent element'}, elementСontent__caption, elementСontent__content);
        
        let elementComment__content = this.createElement('div', { className: 'elementComment__content content', innerText: ""+currentEmployeeData.short_answer+""});
        let elementComment__caption = this.createElement('div', { className: 'elementComment__caption caption', innerText: "Коментар виконавця"});
        let elementComment = this.createElement('div', { className: 'elementСontent element'}, elementComment__caption, elementComment__content);
        
        
        let elementsWrapper  = this.createElement('div', { className: 'elementsWrapper'}, elementAdress, elementСontent, elementComment);
        container.appendChild(elementsWrapper);
        
        let elementsAll = document.querySelectorAll('.element');
        elementsAll.forEach( el => {
            el.style.display = 'flex';
            el.style.margin = '15px 10px';
        })
        let elementsCaptionAll = document.querySelectorAll('.caption');
        elementsCaptionAll.forEach( el => {
            el.style.minWidth = '200px';
        })
    },    
    changeOnTable: function(message){
        if(message.column != 'Система' && message.column != 'Городок'){
            document.getElementById('table8_events').style.display = 'none';
        }else{
            document.getElementById('table8_events').style.display = 'block';
            this.config.query.queryCode = 'NeVKompetentsii';
            this.config.query.parameterValues = [{ key: '@organization_id',  value: message.orgId},
                                                 { key: '@organizationName', value: message.orgName},
                                                 { key: '@navigation', value: message.row}];
            this.loadData(this.afterLoadDataHandler); 
        }
    },
	afterLoadDataHandler: function(data) {
		this.render();
	},    
    destroy: function() {
        this.sub.unsubscribe();
        this.sub1.unsubscribe();
    }
};
}());
