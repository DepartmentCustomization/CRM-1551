(function () {
  return {
    config: {
        query: {
            code: 'Nadiyshlo',
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
        masterDetail: {
            enabled: true,
        },
        export: {
            enabled: false,
            fileName: 'No_Competence'
        },
        pager: {
            showPageSizeSelector:  true,
            allowedPageSizes: [5, 10, 15, 30],
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
        selection: {
            mode: "multiple"
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
    sub2: [],

    containerForChackedBox: [],
    init: function() {
        document.getElementById('table4__arrived').style.display = 'none';
        this.sub = this.messageService.subscribe('clickOnTable2', this.changeOnTable, this);
        this.sub = this.messageService.subscribe('messageWithOrganizationId', this.orgIdDistribute, this);
        
        this.config.onToolbarPreparing = this.createTableButton.bind(this);
        this.config.masterDetail.template = this.createMasterDetail.bind(this);
        this.dataGridInstance.onCellClick.subscribe(e => {
            if(e.column.dataField == "registration_number" && e.row != undefined){
                this.goToSection('Assignments/edit/'+e.row.data.Id+'');
            }
        });
    },
    orgIdDistribute: function(message){
        this.organizationId = message.value;
        this.distribute = message.distribute;
    },
    createTableButton: function(e) {
        var toolbarItems = e.toolbarOptions.items;

        toolbarItems.push({
            widget: "dxButton", 
            options: { 
                icon: "check",
                type: "default",
                text: "Взяти в роботу",
                onClick: function(e) { 
                     this.findAllSelectRowsToArrived();
                }.bind(this)
            },
            location: "after"
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
        
        // let elementComment__content = this.createElement('div', { className: 'elementComment__content content', innerText: ""+currentEmployeeData.short_answer+""});
        // let elementComment__caption = this.createElement('div', { className: 'elementComment__caption caption', innerText: "Коментар виконавця"});
        // let elementComment = this.createElement('div', { className: 'elementСontent element'}, elementComment__caption, elementComment__content);
        
        
        let elementsWrapper  = this.createElement('div', { className: 'elementsWrapper'}, elementAdress, elementСontent );
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
        if(message.column != 'Надійшло'){
            document.getElementById('table4__arrived').style.display = 'none';
        }else if ( this.distribute == null ){
            document.getElementById('table4__arrived').style.display = 'block';

            this.config.query.parameterValues = [{ key: '@organization_id',  value: message.orgId},
                                                 { key: '@organizationName', value: message.orgName},
                                                 { key: '@navigation', value: message.row}];
            this.loadData(this.afterLoadDataHandler);          
        }
    },
    searchRelust: function(message){
        
    },
    findAllSelectRowsToArrived: function(message){
        let rows = this.dataGridInstance.selectedRowKeys;
        let arrivedSendValueRows = rows.join(', ');
        let executeQuery = {
            queryCode: 'Button_Nadiishlo_VzyatyVRobotu',
            parameterValues: [ {key: '@Ids', value: arrivedSendValueRows} ],
            limit: -1
        };
        this.queryExecutor(executeQuery);
        this.loadData(this.afterLoadDataHandler); 
        
        this.messageService.publish({name: 'reloadAssignmentsTable' });
    },
    findAllSelectRowsRozpodil: function(message){
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
    reloadAfterSend: function(message){
        this.loadData(this.afterLoadDataHandler); 
    },
	afterLoadDataHandler: function(data) {
		this.render();
	},	    
    destroy: function() {
        this.sub.unsubscribe();
    }
};
}());
