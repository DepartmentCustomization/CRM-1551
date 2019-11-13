(function () {
  return {
    config: {
        query: {
            code: 'NeVKompetentcii',
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
            },  {
                dataField: 'QuestionType',
                caption: 'Тип питання',
                sortOrder: 'asc',
                allowSorting: true,
            },  {
                dataField: 'zayavnyk',
                caption: 'Заявник',
            },  {
                dataField: 'adress_place',
                caption: 'Місце проблеми',
            },  {
                dataField: 'pidlegliy',
                caption: 'Виконавець',
            },  {
                dataField: 'Id3',
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
            mode: 'batch',
            allowUpdating: true,
            useIcons: true
        },
        scrolling: {
            mode: 'standart',
            rowRenderingMode: null,
            columnRenderingMode: null,
            showScrollbar: null
        },
        // selection: {
        //     mode: 'multiple'
        // },
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
        onRowUpdating: function(data) {},
        onRowExpanding: function(data) {},
        onRowInserting: function(data) {},
        onRowRemoving: function(data) {},
        onCellClick: function(data) {},
        onRowClick: function(data) {},
        selectionChanged: function(data) {},
    },
    childs: [],
    OrganizationId: [],
    elements: [],
    init: function() {
        document.getElementById('table5__NeVKompetentcii').style.display = 'none';
        this.sub = this.messageService.subscribe('clickOnTable2', this.changeOnTable, this);
        this.sub2 = this.messageService.subscribe('messageWithOrganizationId', this.takeOrganizationId, this);
        
        this.config.masterDetail.template = this.createMasterDetail.bind(this);
        this.dataGridInstance.onCellClick.subscribe(e => {
            if(e.column.dataField == "registration_number" && e.row != undefined){
                this.goToSection('Assignments/edit/'+e.row.data.Id+'');
            }
        });
        
        // this.dataGridInstance.onRowUpdating.subscribe( e => {
            
        // },
        this.dataGridInstance.onRowUpdating.subscribe( e => {
            var oldId = e.oldData;
            var newId = e.newData.Id2;
            var eKey = e.key;            
            
            let executeQuery = {
                queryCode: 'Button_Nadiishlo_NeVKompetentcii',
                parameterValues: [  {key: '@executor_organization_id', value: newId},
                                    {key: '@Id', value: eKey} ],
                limit: -1
            };
            this.queryExecutor(executeQuery, this.lookupFoo, this);
             this.messageService.publish({name: 'reloadAssignmentsTable' });
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
        
        if(currentEmployeeData.comment == null || currentEmployeeData.comment == undefined){
            currentEmployeeData.comment = '';
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
        
        let elementComment__content = this.createElement('div', { className: 'elementComment__content content', innerText: ""+currentEmployeeData.comment+""});
        let elementComment__caption = this.createElement('div', { className: 'elementComment__caption caption', innerText: "Коментар виконавця"});
        let elementComment = this.createElement('div', { className: 'elementСontent element'}, elementComment__caption, elementComment__content);
        
        
        let elementsWrapper  = this.createElement('div', { className: 'elementsWrapper'}, elementAdress, elementСontent, elementComment);
        container.appendChild(elementsWrapper);
        
        let elementsAll = document.querySelectorAll('.element');
        elementsAll.forEach( el => {
            el.style.display = 'flex';
            el.style.margin = '15px 10px';
        });
        let elementsCaptionAll = document.querySelectorAll('.caption');
        elementsCaptionAll.forEach( el => {
            el.style.minWidth = '200px';
        });
    },
    takeOrganizationId: function(message){
        this.OrganizationId = message.value;
    },
    changeOnTable: function(message){
        if(message.column != 'Не в компетенції'){
            document.getElementById('table5__NeVKompetentcii').style.display = 'none';
        }else{
            document.getElementById('table5__NeVKompetentcii').style.display = 'block';
            this.config.query.queryCode = 'NeVKompetentsii';
            this.config.query.parameterValues = [{ key: '@organization_id',  value: message.orgId},
                                                 { key: '@organizationName', value: message.orgName},
                                                 { key: '@navigation', value: message.row}];
            this.loadData(this.afterLoadDataHandler);
            
            let executeQuery = {
                queryCode: 'Lookup_NeVKompetencii_PidOrganization',
                parameterValues: [  {key: '@organization_id', value: this.OrganizationId} ],
                limit: -1
            };
            this.queryExecutor(executeQuery, this.lookupFoo, this);
        }
    },
    findAllSelectRowsNeVKompetentsii: function(message){
        let rows = this.dataGridInstance.selectedRowKeys;
        let arrivedSendValueRows = rows.join(', ');
        
        let executeQuery = {
            queryCode: 'Button_Nadiishlo_NeVKompetentcii',
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
        console.log( this.elements);
        this.loadData(this.afterLoadDataHandler);
    },
    afterLoadDataHandler: function(){
        this.render();
        // let elements = document.querySelectorAll('.dx-toolbar-items-container');
        // if(elements[0]){
        //     elements[0].style.display = 'none';
        // }
        
    },
    destroy: function() {
        this.sub.unsubscribe();
        this.sub2.unsubscribe();
    }
};
}());
