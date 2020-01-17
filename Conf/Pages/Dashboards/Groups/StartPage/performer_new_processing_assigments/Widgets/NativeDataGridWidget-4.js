(function () {
  return {
    config: {
        query: {
            code: 'DoVidoma',
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
                width: 150
            }, {
                dataField: 'QuestionType',
                caption: 'Тип питання',
            }, {
                dataField: 'zayavnyk',
                caption: 'Заявник',
            }, {
                dataField: 'adress',
                caption: 'Місце проблеми',
            }
        ],
	    masterDetail: {
            enabled: true,
        },
        filterRow: {
            visible: true,
            applyFilter: "auto"
        },
        export: {
            enabled: true,
            fileName: 'Excel'
        },
        pager: {
            showPageSizeSelector:  true,
            allowedPageSizes: [ 10, 15, 30],
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
        sorting: {
            mode: "multiple"
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
        this.dataGridInstance.height = window.innerHeight - 300;
        document.getElementById('table7__doVidoma').style.display = 'none';
        this.sub = this.messageService.subscribe('clickOnTable2', this.changeOnTable, this);
        
        this.config.onToolbarPreparing = this.createTableButton.bind(this);
        this.config.masterDetail.template = this.createMasterDetail.bind(this);
        this.dataGridInstance.onCellClick.subscribe(e => {
            if(e.column) {
                if(e.column.dataField == "registration_number" && e.row != undefined){
                    window.open(location.origin + localStorage.getItem('VirtualPath') + "/sections/Assignments/edit/"+e.key+"");
                }
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
        if(currentEmployeeData.balans_name == null || currentEmployeeData.balans_name == undefined){
            currentEmployeeData.balans_name = '';
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

        let elementBalance__content = this.createElement('div', { className: 'elementBalance__content content', innerText: ""+currentEmployeeData.balans_name+""});
        let elementBalance__caption = this.createElement('div', { className: 'elementBalance__caption caption', innerText: "Балансоутримувач"});
        let elementBalance = this.createElement('div', { className: 'elementСontent element'}, elementBalance__caption, elementBalance__content);        
        
        let elementsWrapper  = this.createElement('div', { className: 'elementsWrapper'}, elementAdress, elementСontent, elementBalance);
        container.appendChild(elementsWrapper);
        
        let elementsAll = document.querySelectorAll('.element');
        elementsAll = Array.from(elementsAll);
        elementsAll.forEach( el => {
            el.style.display = 'flex';
            el.style.margin = '15px 10px';
        })
        let elementsCaptionAll = document.querySelectorAll('.caption');
        elementsCaptionAll = Array.from(elementsCaptionAll);
        elementsCaptionAll.forEach( el => {
            el.style.minWidth = '200px';
        })
    },
    createTableButton: function(e) {
            var toolbarItems = e.toolbarOptions.items;

            toolbarItems.push({
                widget: "dxButton", 
                options: { 
                    icon: "check",
                    type: "default",
                    text: "Ознайомився",
                    onClick: function(e) { 
                        e.event.stopImmediatePropagation();
                        this.findAllSelectRowsDoVidoma();
                    }.bind(this)
                },
                location: "after"
            });
    },    
    changeOnTable: function(message){
        this.column = message.column;
        this.navigator = message.navigation;
        this.targetId = message.targetId;
        if(message.column != 'До відома'){
            document.getElementById('table7__doVidoma').style.display = 'none';
        }else{
            document.getElementById('table7__doVidoma').style.display = 'block';

            this.config.query.parameterValues = [{ key: '@organization_id',  value: message.orgId},
                                                 { key: '@organizationName', value: message.orgName},
                                                 { key: '@navigation', value: message.navigation}];
            this.loadData(this.afterLoadDataHandler);
        }
    },
    findAllSelectRowsDoVidoma: function(message){
        let rows = this.dataGridInstance.selectedRowKeys;
        if( rows.length > 0 ){
            let arrivedSendValueRows = rows.join(', ');
            let executeQuery = {
                queryCode: 'Button_DoVidoma_Oznayomyvzya',
                parameterValues: [ {key: '@Ids', value: arrivedSendValueRows} ],
                limit: -1
            };
            this.queryExecutor(executeQuery);
            this.loadData(this.afterLoadDataHandler); 
            this.messageService.publish( { name: 'reloadMainTable', column: this.column,   navigator: this.navigator, targetId: this.targetId });
        }
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
    }
};
}());
