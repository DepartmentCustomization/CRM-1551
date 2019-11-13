(function () {
  return {
    config: {
        query: {
            code: 'Prozvon_House',
            parameterValues: [ ],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                dataField: 'registration_number',
                caption: 'Номер'
            }, {
                dataField: 'registration_date',
                caption: 'Дата надходження',
                width: 200
            },{
                dataField: 'QuestionType',
                caption: 'Тип питання',
                width: 200
            }, {
                dataField: 'states',
                caption: 'Стан',
                alignment: 'middle'
            }, {
                dataField: 'full_name',
                caption: 'Заявник'
            }, {
                dataField: 'phone_number',
                caption: 'Телефон'
            }, {
                dataField: 'cc_nedozvon',
                caption: 'Ндз',
                width: 50
            }, {
                dataField: 'District',
                caption: 'Район'
            }, {
                dataField: 'house',
                caption: 'БУДИНОК ТА КВАРТИРА'
            }, {
                dataField: 'entrance',
                caption: 'П'
            }, {
                dataField: 'place_problem',
                caption: 'МІСЦЕ ПРОБЛЕМИ'
            }, {
                dataField: 'vykon',
                caption: 'Виконавець'
            }
        ],
        allowColumnResizing: true,
        columnResizingMode: "widget",
        columnMinWidth: 50,
        columnAutoWidth: true,
        pager: {
            showPageSizeSelector: true,
            allowedPageSizes: [10, 50, 100],
            showInfo: true,
        },
        paging: {
            pageSize: 100
        },
        export: {
            enabled: false,
            fileName: 'File_name'
        },
        sorting: {
            mode: "multiple"
        },
        selection: {
            mode: "multiple"
        },
        masterDetail: {
            enabled: true,
        },        
        showBorders: false,
        showColumnLines: false,
        showRowLines: true,
        wordWrapEnabled: true,        
    },
    init: function() {
        this.dataGridInstance.height = window.innerHeight - 130;
        this.sort = '1=1';
        this.filter = '1=1';        
        let executeQuery = {
            queryCode: 'es_show_user_phone',
            limit: -1,
            parameterValues: []
        };
        this.queryExecutor(executeQuery, this.showUser, this);
        this.showPreloader = false;
        this.sub1 = this.messageService.subscribe( 'ApplyGlobalFilters', this.findAllCheckedFilter, this );
        this.sub2 = this.messageService.subscribe( 'reloadMainTable', this.reloadMainTable, this );
        
        this.sortingArr = [];
        this.config.onToolbarPreparing = this.createDGButtons.bind(this);
        this.config.masterDetail.template = this.createMasterDetails.bind(this);
        this.config.onOptionChanged = this.onOptionChanged.bind(this);
        
        this.config.onCellPrepared = this.onCellPrepared.bind(this);
        
        this.dataGridInstance.onCellClick.subscribe( function(e) {
            if(e.column){
                if(e.column.dataField == "registration_number" && e.row != undefined){
                    window.open(location.origin + localStorage.getItem('VirtualPath') + "/sections/Assignments/edit/"+e.data.Id+"");
                }else if(e.column.dataField == "phone_number" && e.row != undefined){
                    let CurrentUserPhone = e.row.data.phone_number;
                    let PhoneForCall = this.userPhoneNumber;
                    let xhr = new XMLHttpRequest();
                    xhr.open('GET', `http://10.192.200.14:5566/CallService/Call/number=` + CurrentUserPhone + `&operator=` + PhoneForCall );
                    xhr.send();
                }
            }
        }.bind(this));        
        
        if(window.location.search != ''){
            let getUrlParams =  window
                                    .location
                                        .search
                                            .replace('?', '')
                                                .split('&')
                                                    .reduce(function(p, e) {
                                                          let a = e.split('=');
                                                          p[decodeURIComponent(a[0])] = decodeURIComponent(a[1]);
                                                          return p;
                                                        }, {}
                                                    );
            let buildId = Number(getUrlParams.id);
            this.buildId = [];
            this.buildId = (buildId);
            this.config.query.parameterValues = [ {  key: '@buildId', value: this.buildId },
                                                  {  key: '@filter', value: this.filter },
                                                  {  key: '@sort', value: this.sort } ];
            this.loadData(this.afterLoadDataHandler);
        }
        this.config.onContentReady = this.afterRenderTable.bind(this);
    },
    onCellPrepared: function(options){
        if( options.rowType === 'data'){
            if( options.column.dataField  == 'states'){
                options.cellElement.classList.add('stateResult');
            }
        }
    },
    afterRenderTable: function(){
        let stateResult = document.querySelectorAll('.stateResult');
        for (let i = 0; i < stateResult.length; i++) {
            
            let el = stateResult[i];
            let number = el.parentElement.children[2].innerText;
            let dataIndex = this.numbers.findIndex( num => num === number  );
            let spanCircle = this.createElement( 'span', { classList: 'material-icons', innerText: 'lens'});
            el.style.textAlign = 'center';
            spanCircle.style.width = '100%';
            if( el.childNodes.length < 2 ){  el.appendChild(spanCircle); }
            let cond1 = this.data[dataIndex][17];
            let cond2 = this.data[dataIndex][18];

            if(cond1 === 'На перевірці'  ){
                if( cond2 === 'Не в компетенції'  || cond2 === 'Роз`яснено' ){
                    spanCircle.classList.add('onCheck');
                }else{
                    spanCircle.classList.add('yellow');
                }
            }else if(cond1 === 'Зареєстровано'){
                spanCircle.classList.add('registrated');
            }else if(cond1 === 'В роботі'){
                spanCircle.classList.add('inWork');
            }else if(cond1 === 'Закрито'){
                spanCircle.classList.add('closed');
            }else if(cond1 === 'Не виконано'){
                spanCircle.classList.add('notDone');
            }
        }
    },
    showUser: function(data){
        indexPhoneNumber = data.columns.findIndex(el => el.code.toLowerCase() === 'phonenumber' );
        this.userPhoneNumber = data.rows[0].values[indexPhoneNumber]
    },
    onOptionChanged: function(args) {
        let sortingArr = this.sortingArr;
        if( args.fullName != undefined ){
            let columnCode ;
            switch(args.fullName){
                case('columns[0].sortOrder'):
                    columnCode = 'registration_number'
                break;
                case('columns[1].sortOrder'):
                    columnCode = 'QuestionType'
                    break;
                case('columns[2].sortOrder'):
                    columnCode = 'states'
                    break;
                case('columns[3].sortOrder'):
                    columnCode = 'full_name'
                    break;
                case('columns[4].sortOrder'):
                    columnCode = 'phone_number'
                    break;
                case('columns[5].sortOrder'):
                    columnCode = 'cc_nedozvon'
                    break;
                case('columns[6].sortOrder'):
                    columnCode = 'District'
                    break;
                case('columns[7].sortOrder'):
                    columnCode = 'house'
                    break;
                case('columns[8].sortOrder'):
                    columnCode = 'entrance'
                    break;
                case('columns[9].sortOrder'):
                    columnCode = 'place_problem'
                    break;
                case('columns[10].sortOrder'):
                    columnCode = 'vykon'
                    break;
                case('dataSource'):
                    columnCode = 'dataSource'
                    break;
            }
            
            if(columnCode != undefined ){
                if(columnCode != 'dataSource'){
                    let infoColumn = { fullName: columnCode, value: args.value };
                    if( sortingArr.length === 0  ){
                        sortingArr.push(infoColumn);
                    }else{
                        index = sortingArr.findIndex(x => x.fullName === columnCode);
                        if( index === -1 ){
                            sortingArr.push(infoColumn);
                        }else{
                            sortingArr.splice(index, 1); 
                            sortingArr.push(infoColumn);
                        }
                    }
                    this.messageService.publish({ name: 'sortingArr', arr: this.sortingArr });
                }
            }
        }
        
        
    },      
    createMasterDetails: function(container, options){
        let currentEmployeeData = options.data;
        let lastNdzTime ;
        if(currentEmployeeData.comment == null){ currentEmployeeData.comment = ''; }
        if(currentEmployeeData.zmist == null){ currentEmployeeData.zmist = ''; }
        
        if(currentEmployeeData.cc_nedozvon == null){ currentEmployeeData.cc_nedozvon = ''; }
        if(currentEmployeeData.edit_date === null){
            lastNdzTime = ''
        }else{
            lastNdzTime = this.changeDateTimeValues(currentEmployeeData.edit_date);
        }
        if(currentEmployeeData.control_comment == null){ currentEmployeeData.control_comment = ''; }
        
        let ndz = currentEmployeeData.cc_nedozvon;
        let ndzComment = currentEmployeeData.control_comment;
        
        let elementHistory__content = this.createElement('div', { className: 'elementHistory__content content', innerText: ndz +  ' ( дата та час останнього недозвону: ' + lastNdzTime + '), коментар: ' + ndzComment  });
        let elementHistory__caption = this.createElement('div', { className: 'elementHistory__caption caption', innerText: "Історія"});
        let elementHistory = this.createElement('div', { className: 'elementHistory element'}, elementHistory__caption, elementHistory__content);
        
        let elementСontent__content = this.createElement('div', { className: 'elementСontent__content content', innerText: ""+currentEmployeeData.zmist+""});
        let elementСontent__caption = this.createElement('div', { className: 'elementСontent__caption caption', innerText: "Зміст"});
        let elementСontent = this.createElement('div', { className: 'elementСontent element'}, elementСontent__caption, elementСontent__content);
        
        let elementComment__content = this.createElement('div', { className: 'elementComment__content content', innerText: ""+currentEmployeeData.comment+""});
        let elementComment__caption = this.createElement('div', { className: 'elementComment__caption caption', innerText: "Коментар виконавця"});
        let elementComment = this.createElement('div', { className: 'elementСontent element'}, elementComment__caption, elementComment__content);
        
        let elementsWrapper  = this.createElement('div', { className: 'elementsWrapper'}, elementHistory, elementСontent, elementComment);
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
    changeDateTimeValues: function(value){
        
        let date = new Date(value);
        let dd = date.getDate();
        let MM = date.getMonth();
        let yyyy = date.getFullYear();
        let HH = date.getHours();
        let mm = date.getMinutes();
        MM += 1 ;
        if( (dd.toString()).length === 1){  dd = '0' + dd; }
        if( (MM.toString()).length === 1){ MM = '0' + MM ; }
        if( (HH.toString()).length === 1){  HH = '0' + HH; }
        if( (mm.toString()).length === 1){ mm = '0' + mm; }
        let trueDate = dd+'.'+MM+'.' + yyyy +' '+ HH +':'+ mm;
        return trueDate;
    },     
    reloadMainTable: function(message){
        this.config.query.parameterValues = [
            { key: '@filter', value: this.filter },
            { key: '@buildId', value: this.buildId },
            { key: '@sort', value: message.sortingString }
        ];
        this.loadData(this.afterLoadDataHandler);
    },
    afterLoadDataHandler: function(data) {
        this.numbers = [];
        this.data = data;
        console.log(data);
        data.forEach( data => this.numbers.push(data[1]));
        this.render();
    },
    createDGButtons: function(e) {
            let toolbarItems = e.toolbarOptions.items;

            toolbarItems.push({
                widget: "dxButton", 
                options: { 
                    icon: "close",
                    type: "default",
                    text: "Закрити",
                    onClick: function(e) {
                        e.event.stopImmediatePropagation();
                        this.openModalCloserForm();
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
    openModalCloserForm: function(){
        let rowsMessage = [];
        let selectedRows = this.dataGridInstance.instance.getSelectedRowsData();
        selectedRows.forEach( row => {
            let obj = {
                id: row.Id,
                organization_id: row.Organizations_Id
            }
            rowsMessage.push(obj);
        });
        if(selectedRows.length > 0){
            this.messageService.publish( { name: 'openModalForm', value: rowsMessage } );
        }
    },
    destroy: function(){  
        this.sub1.unsubscribe();  
        this.sub2.unsubscribe();  
    },
};
}());
