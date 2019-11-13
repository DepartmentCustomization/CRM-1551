(function () {
  return {
    customConfig:
        `
            <style>
                .elementAdress__caption{
                    color: red
                }
                #elementAdress{
                    color: blue
                }
            </style>
        `
    ,    
    config: {
        query: {
            code: 'CoordinatorController_NeVKompetentsii',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
           {
                dataField: 'registration_number',
                caption: 'Номер питання',
                fixed: true,
            },  {
                dataField: 'QuestionType',
                caption: 'Тип питання',
                fixed: true,
            },  {
                dataField: 'zayavnikName',
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
                sortOrder: 'asc',
            }, {
                dataField: 'vykonavets',
                caption: 'Можливий виконавець',
                lookup: {
                    dataSource: {
                        paginate: true,
                        store: this.elements,
                    },
                    valueExpr: "ID",
                    displayExpr: "Name"
                }
            }
        ],
        masterDetail: {
            enabled: true,
        },
        export: {
            enabled: false,
            fileName: 'No_Competence'
        },
        pager: {
            showPageSizeSelector:  true,
            allowedPageSizes: [10, 15, 30],
            showInfo: true,
        },
        paging: {
            pageSize: 10
        },        
        scrolling: {
            mode: 'standart',
            rowRenderingMode: null,
            columnRenderingMode: null,
            showScrollbar: null
        },
        searchPanel: {
            visible: false,
            highlightCaseSensitive: true
        },
        editing: {
            mode: 'cell',
            allowUpdating: true,
            useIcons: true
        },
        keyExpr: 'Id',
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
        document.getElementById('table5__NeVKompetentsii').style.display = 'none';
        this.sub = this.messageService.subscribe('clickOnСoordinator_table', this.changeOnTable, this);
        this.sub1 = this.messageService.subscribe('findAllRowsNeVKompetentсii', this.findAllRowsNeVKompetentсii, this);



        this.config.masterDetail.template = this.myFunc.bind(this);
        
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
    myFunc: function(container, options) {
        var currentEmployeeData = options.data;
        
        if(currentEmployeeData.short_answer == null){
            currentEmployeeData.short_answer = '';
        }
        let elementAdress__content = this.createElement('div', { className: 'elementAdress__content content', innerText: ""+currentEmployeeData.adress+""});
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
        if(message.column != 'Не в компетенції'){
            document.getElementById('table5__NeVKompetentsii').style.display = 'none';
        }else{
            document.getElementById('table5__NeVKompetentsii').style.display = 'block';
            this.config.query.queryCode = 'CoordinatorController_NeVKompetentsii';
            this.config.query.parameterValues = [ { key: '@navigation', value: message.value} ];
            this.loadData(this.afterLoadDataHandler);
            
            let executeQuery = {
                queryCode: 'Lookup_NeVKompetencii_PidOrganization',
                parameterValues: [  {key: '@organization_id', value: 6704} ],
                limit: -1
            };
            this.queryExecutor(executeQuery, this.lookupFoo, this);
        }
    },
    findAllRowsNeVKompetentсii: function(){
        
        let rows = this.dataGridInstance.selectedRowKeys;
        let arrivedSendValueRows = rows.join(', ');
        let executeQuery = {
            queryCode: 'Button_NeVKompetentsii_Peredatu',
            parameterValues: [ {key: '@Ids', value: arrivedSendValueRows} ],
            limit: -1
        };
        this.queryExecutor(executeQuery);
        this.loadData(this.afterLoadDataHandler); 
        
        this.messageService.publish({name: 'reloadAssignmentsTable' });
    },
    lookupFoo: function(data) {
        this.elements = [];
        for( i = 0; i < data.rows.length; i++){
            let el = data.rows[i];
            let obj = {
                "ID": el.values[0],
                "Name": el.values[1],
            } 
            this.elements.push(obj);
        }
        this.config.columns[5].lookup.dataSource.store = this.elements;
        this.loadData(this.afterLoadDataHandler);
    },
    afterLoadDataHandler: function(){
        this.render();
    },
    destroy: function() {
        this.sub.unsubscribe();
        this.sub1.unsubscribe();
    }
};
}());
