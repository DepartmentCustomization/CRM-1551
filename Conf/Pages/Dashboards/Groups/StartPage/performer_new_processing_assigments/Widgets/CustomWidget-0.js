(function () {
  return {
    title: ' ',
    hint: '',
    formatTitle: function() {},
    customConfig:
                `
                    <div id = 'container'></div>
                `
    ,
    init: function() {
        this.messageService.publish( { name: 'showPagePreloader'  } );
        const header = document.getElementById('header1');
        header.firstElementChild.style.overflow = 'visible';
        header.firstElementChild.firstElementChild.firstElementChild.style.overflow = 'visible';
        
        this.sub = this.messageService.subscribe('reloadMainTable', this.reloadMainTable, this);

        if(window.location.search == ''){
            let executeQuery = {
                queryCode: 'organization_name',
                parameterValues: [],
                limit: -1
            };
            this.queryExecutor(executeQuery, this.userOrganization, this);
            this.showPreloader = false; 
            
        }else{
            var getUrlParams = window
                            .location
                                .search
                                    .replace('?', '')
                                        .split('&')
                                            .reduce(function(p, e) {
                                                      var a = e.split('=');
                                                      p[decodeURIComponent(a[0])] = decodeURIComponent(a[1]);
                                                      return p;
                                                    }, {}
                                                        );
            let tabInd = Number(getUrlParams.id);
            this.organizationId = [];
            this.organizationId = (tabInd);
            let executeQueryValues = {
                queryCode: 'table2',
                limit: -1,
                parameterValues: [ { key: '@organization_id',  value: this.organizationId} ]
            };
            this.queryExecutor(executeQueryValues, this.createTable.bind(this, false, null), this);
            this.showPreloader = false; 
            let executeQuery = {
                queryCode: 'organization_name',
                parameterValues: [{ key: '@organizationId',  value: this.organizationId}],
                limit: -1
            };
            this.queryExecutor(executeQuery, this.userOrganization, this);
            this.showPreloader = false; 
        }
        let executeOrganizationSelect = {
            queryCode: 'OrganizationSelect',
            limit: -1,
            parameterValues: []
        };
        this.queryExecutor(executeOrganizationSelect, this.setOrganizationSelect, this);
        this.showPreloader = false; 
    },
    userOrganization: function(data){
        let indexOfTypeName = data.columns.findIndex(el => el.code.toLowerCase() === 'organizationname' );
        let indexOfTypeId = data.columns.findIndex(el => el.code.toLowerCase() === 'organizationid' );
        let indexOfTypeDistribute = data.columns.findIndex(el => el.code.toLowerCase() === 'distribute' );
        this.organizationId = [];

        if(data.rows[0]){
            this.organizationId = (data.rows[0].values[indexOfTypeId]);
            this.distribute = (data.rows[0].values[indexOfTypeDistribute]);
            this.messageService.publish({name: 'messageWithOrganizationId', value: this.organizationId, distribute:  this.distribute});
            document.getElementById('organizationName').value = (data.rows[0].values[indexOfTypeId]);
            document.getElementById('organizationName').innerText = (data.rows[0].values[indexOfTypeName]);
            if( window.location.search != '?id='+data.rows[0].values[indexOfTypeId]+''){
                window.location.search = 'id='+data.rows[0].values[indexOfTypeId]+'';
            }
        }
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
    afterViewInit: function(){
        const container = document.getElementById('container')
        
        const tabsWrapper = this.createElement('div', { id: 'tabsWrapper', className: 'tabsWrapper'});
        const filtersWrapper = this.createElement('div', { id: 'filtersWrapper', className: 'filtersWrapper'});
        const tableContainer = this.createElement('div', { id: 'tableContainer', className: 'tableContainer'});
        const tableWrapper = this.createElement('div', { id: 'tableWrapper', className: 'tableWrapper'}, tableContainer);

        container.appendChild(tabsWrapper);
        container.appendChild(filtersWrapper);
        container.appendChild(tableWrapper);
        this.createTabs();
        this.createFilters();
    },
    setOrganizationSelect: function(data){
        this.organizationSelect = [];
        if( data.rows.length > 0 ){
            var organizationSelect  = [];
            indexId = data.columns.findIndex(el => el.code.toLowerCase() === 'id' );
            indexName = data.columns.findIndex(el => el.code.toLowerCase() === 'name' );
            data.rows.forEach( row => {
                let obj = {
                    id: row.values[indexId],
                    name: row.values[indexName],
                }
                organizationSelect.push(obj);
            });
            this.organizationSelect = organizationSelect;
        }
    },     
    createTabs: function(){
        
        let tabInformation__title  = this.createElement('div', { className: 'tabInformation tab_title', innerText: 'ЗАГАЛЬНА ІНФОРМАЦІЯ'});
        let tabAction__title  = this.createElement('div', { className: 'tabAction tab_title', innerText: 'ЗАХІД'});
        let tabProcessingOrders__title  = this.createElement('div', { className: 'tabProcessingOrders tab_title', innerText: 'ОБРОБКА ДОРУЧЕНЬ'});
        let tabOrganizations__title  = this.createElement('div', { className: 'tabOrganizations tab_title', innerText: 'ОРГАНІЗАЦІЇ'});
        
        let tabFinder__title  = this.createElement('div', { className: ' tab_title', innerText: 'Розширений пошук'});
        const tabFinder = this.createElement('div', { id: 'tabFinder', url: 'poshuk_table', className: 'tabFinder tab tabTo'}, tabFinder__title);
        const tabInformation = this.createElement('div', { id: 'tabInformation', url: '', className: 'tabInformation tab '}, tabInformation__title);
        const tabAction = this.createElement('div', { id: 'tabAction', url: 'performer_new_actions', className: 'tabAction tab tabTo'}, tabAction__title);
        const tabProcessingOrders = this.createElement('div', { id: 'tabProcessingOrders', url: 'performer_new_processing_assigments', className: 'tabHover tabProcessingOrders tab'}, tabProcessingOrders__title);
        const tabOrganizations = this.createElement('div', { id: 'tabOrganizations', url: 'performer_new_organizations', className: 'tabOrganizations tab tabTo'}, tabOrganizations__title);
        
        
        const tabsContainer = this.createElement('div', { id: 'tabsContainer', className: 'tabsContainer'}, tabInformation, tabAction, tabProcessingOrders, tabOrganizations, tabFinder);
                 
        const orgLinkСhangerBox__icon = this.createElement('div', { id: 'orgLinkСhangerBox__icon', className:'material-icons', innerText:'more_vert' });
        const orgLinkСhangerBox = this.createElement('div', { id: 'orgLinkСhangerBox'}, orgLinkСhangerBox__icon );
        
        const linkСhangerContainer = this.createElement('div', { id: 'organizationsContainer'}, orgLinkСhangerBox);
        
        tabsWrapper.appendChild(tabsContainer);
        tabsWrapper.appendChild(linkСhangerContainer);
        
        orgLinkСhangerBox__icon.addEventListener('click', event => {
            if(this.organizationSelect.length > 0 ){
                
                event.stopImmediatePropagation();
                let target = event.currentTarget;
                if(orgLinkСhangerBox.children.length === 1 ){
                    let orgLinksWrapper__triangle =  this.createElement('div', { className: 'orgLinksWrapper__triangle' });
                    let orgLinksWrapper = this.createElement('div', { id: 'orgLinksWrapper'}, orgLinksWrapper__triangle);
                    orgLinkСhangerBox.appendChild(orgLinksWrapper);
                    this.organizationSelect.forEach( el => {
                        let organizationLink = this.createElement('div', { className: 'organizationLink',  orgId: ''+el.id+'',  innerText: el.name });
                        orgLinksWrapper.appendChild(organizationLink);
                        
                        organizationLink.addEventListener( 'click', event => {
                            event.stopImmediatePropagation();
                            let target  =  event.currentTarget;
                            window.open(location.origin + localStorage.getItem('VirtualPath') + "/dashboard/page/performer_new_processing_assigments?id="+target.orgId+"");
                        });
                    });
                }else if(orgLinkСhangerBox.children.length === 2){
                    let container = document.getElementById('orgLinksWrapper');
                    orgLinkСhangerBox.removeChild(container);
                }
            }
        });
 
        let tabs = document.querySelectorAll('.tabTo');
        tabs = Array.from(tabs);
        tabs.forEach( function (el){
            el.addEventListener( 'click', event => {
                let target =  event.currentTarget;
                document.getElementById('container').style.display = 'none';
                if( target.id === 'tabFinder' ){
                    this.goToDashboard(target.url);
                }else{
                    this.goToDashboard(target.url, { queryParams: { id: this.organizationId } });
                }
            });    
        }.bind(this));
    },
    createFilters: function(){
        const searchContainer__input = this.createElement('input', {id: 'searchContainer__input', type: 'search', placeholder: 'Пошук доручення за номером', className: "searchContainer__input"});
        const searchContainer = this.createElement('div', {id: 'searchContainer', className: "searchContainer"}, searchContainer__input);
        
        searchContainer__input.addEventListener('input', event =>  {
            if(searchContainer__input.value.length == 0 ){
                this.resultSearch('clearInput', 0);
                this.showTable(searchContainer__input);
            }
        });
        searchContainer__input.addEventListener('keypress', function (e) {
            var key = e.which || e.keyCode;
            if (key === 13) {
                this.resultSearch('resultSearch', searchContainer__input.value, this.organizationId);
                this.resultSearch('clickOnTable2', 'none');
                this.hideAllItems(0);
            }
        }.bind(this));
        
        const filterLeft__icon = this.createElement('div', { className: "filterLeft__icon filterIcon material-icons", innerText: 'filter_list'});
        const filterLeft__title = this.createElement('div', { className: "filterLeft__title filterTitle",  innerText: 'Голосіївський - Житлове господарство'});
        
        const filterRight__icon = this.createElement('div', { className: "filterLeft filterIcon material-icons", innerText: 'filter_list'});
        const filterRight__title = this.createElement('div', { className: "filterLeft filterTitle", innerText: 'Святошинський - Ліфти'});
        
        const filterLeft = this.createElement('div', { id: 'filterLeft', className: "filterLeft filter"}, filterLeft__icon, filterLeft__title);
        const filterRight  =  this.createElement('div', { id: 'filterRight', className: "filterRight filter"}, filterRight__icon, filterRight__title);
        
        filtersContainer =  this.createElement('div', { id: 'filtersContainer', className: "filtersContainer"}, filterLeft, filterRight);
        
        const organizationName =  this.createElement('div', { id: 'organizationName', className: "organizationName" });
        filtersWrapper.appendChild(organizationName);
        filtersWrapper.appendChild(searchContainer);
    },
    reloadMainTable: function(message){
        this.column = message.column;
        this.navigator = message.navigator;
        let targetId = message.targetId;
        while ( tableContainer.hasChildNodes() ) {
            tableContainer.removeChild( tableContainer.childNodes[0] );
        }   
        let executeQueryValues = {
            queryCode: 'table2',
            limit: -1,
            parameterValues: [ { key: '@organization_id',  value: this.organizationId} ]
        };
        this.queryExecutor(executeQueryValues, this.createTable.bind(this, true, targetId), this);
        this.showPreloader = false; 
    },
    createTable: function(reloadTable, targetId, data) {
        for(let i = 2; i < data.columns.length; i ++ ){
            let item = data.columns[i];
            let columnTriangle =  this.createElement('div', { });
            let columnHeader =  this.createElement('div', { id: 'columnHeader_'+i+'', code: ''+item.code+'',  className: 'columnHeader', innerText: ''+item.name+''}, columnTriangle);
            let columnsWrapper =  this.createElement('div', { id: 'columnsWrapper_'+i+'',  className: 'columnsWrapper'});
            if( i == 2){
                columnHeader.style.backgroundColor = "rgb(74, 193, 197)";
                columnTriangle.classList.add('triangle'+i+'');
            }else if( i == 3){
                columnHeader.style.backgroundColor = "rgb(173, 118, 205)";
                columnTriangle.classList.add('triangle'+i+'');
            }else if( i == 4 ){
                columnHeader.style.backgroundColor = "rgb(240, 114, 93)";
                columnTriangle.classList.add('triangle'+i+'');
            }else if( i == 5){
                columnHeader.style.backgroundColor = "rgb(238, 163, 54)";
                columnTriangle.classList.add('triangle'+i+'');
            }else if( i == 6){
                columnHeader.style.backgroundColor = "rgb(132, 199, 96)";
                columnTriangle.classList.add('triangle'+i+'');
            }else if( i == 7){
                columnHeader.style.backgroundColor = "rgb(248, 195, 47)";
                columnTriangle.classList.add('triangle'+i+'');
            }else if( i == 8){
                columnHeader.style.backgroundColor = "rgb(94, 202, 162)";
                columnTriangle.classList.add('triangle'+i+'');
            }else if( i == 9){
                columnHeader.style.backgroundColor = "rgb(73, 155, 199)";
                columnTriangle.classList.add('triangle'+i+'');
            }
            
            
            let column =  this.createElement('div', { id: 'column_'+i+'', code: ''+item.code+'', className: "column"}, columnHeader, columnsWrapper);
            column.classList.add('column_'+i+'');
            tableContainer.appendChild(column);
        }
        for(let i = 0; i < data.rows.length; i ++  ){
            var elRow = data.rows[i];
            for(let  j = 2; j < elRow.values.length; j ++  ){
                let el = elRow.values[j];
                if( el != 0 ){
                    let columnCategorie__value =  this.createElement('div', { className: 'columnCategorie__value', innerText: '('+el+')'});
                    let columnCategorie__title =  this.createElement('div', { className: 'columnCategorie__title', code: ''+elRow.values[1]+'', innerText: ''+elRow.values[1]+''});
                    let columnCategorie =  this.createElement('div', { className: 'columnCategorie', code: ''+elRow.values[1]+''}, columnCategorie__title, columnCategorie__value);
                    document.getElementById('columnsWrapper_'+j+'').appendChild(columnCategorie);
                }
            }
        }
        var headers = document.querySelectorAll('.columnHeader');
        var categories = document.querySelectorAll('.columnCategorie');
        categories = Array.from(categories);
        headers = Array.from(headers);
        headers.forEach( function(el){
            el.addEventListener( 'click', function(event){
                let target = event.currentTarget;
                searchContainer__input.value = '';
                this.resultSearch('clearInput', 0);
                categories.forEach( el => {
                   el.style.display = 'none'; 
                });
                let navigator = 'Усі';
                let column = this.columnName(target);
                this.showTable(target, column, navigator);
            }.bind(this));
        }.bind(this));
        
        categories.forEach( function(el){
            el.addEventListener( 'click', function(event){
                let target = event.currentTarget;
                categories.forEach( el => {
                   el.style.display = 'none'; 
                });
                let navigator = target.firstElementChild.innerText;
                target = target.parentElement.parentElement.firstElementChild;
                let column = this.columnName(target);
                this.showTable(target, column, navigator);
            }.bind(this));
        }.bind(this));
        
        if( reloadTable == true ){
            categories.forEach( el => {
               el.style.display = 'none'; 
            });            
            let target = document.getElementById(targetId);
            this.showTable(target,  this.column, this.navigator );
        }
        
        
        this.messageService.publish( { name: 'hidePagePreloader'  } );
    },
    columnName: function(target){
        let column = '';
        if( target.code == 'nadiyshlo'){
            column = 'Надійшло'
        }else if( target.code == 'neVKompetentsii'){
            column = 'Не в компетенції'
        }else if( target.code == 'prostrocheni'){
            column = 'Прострочені'
        }else if( target.code == 'uvaga'){
            column = 'Увага'
        }else if( target.code == 'vroboti'){
            column = 'В роботі'
        }else if( target.code == 'dovidoma'){
            column = 'До відома'
        }else if( target.code == 'naDoopratsiyvanni' ){
            column = 'На доопрацюванні'
        }else if( target.code == 'neVykonNeMozhl'){
            column = 'План/Програма'
        }
        return column
    },
    showTable: function(target, columnName, navigator){
        var headers = document.querySelectorAll('.columnHeader');
        headers = Array.from(headers);
        if( target.classList.contains('check') || target.classList.contains('hover') || target.id == 'searchContainer__input'){
            
            headers.forEach( el => {
                el.firstElementChild.classList.remove('triangle');
            });            
            
            document.getElementById('columnHeader_2').style.backgroundColor = "rgb(74, 193, 197)";
            document.getElementById('columnHeader_3').style.backgroundColor = "rgb(173, 118, 205)";
            document.getElementById('columnHeader_4').style.backgroundColor = "rgb(240, 114, 93)";
            document.getElementById('columnHeader_5').style.backgroundColor = "rgb(238, 163, 54)";
            document.getElementById('columnHeader_6').style.backgroundColor = "rgb(132, 199, 96)";
            document.getElementById('columnHeader_7').style.backgroundColor = "rgb(248, 195, 47)";
            document.getElementById('columnHeader_8').style.backgroundColor = "rgb(94, 202, 162)";
            document.getElementById('columnHeader_9').style.backgroundColor = "rgb(73, 155, 199)";
            
            document.getElementById('columnHeader_2').firstElementChild.classList.add('triangle2');
            document.getElementById('columnHeader_3').firstElementChild.classList.add('triangle3');
            document.getElementById('columnHeader_4').firstElementChild.classList.add('triangle4');
            document.getElementById('columnHeader_5').firstElementChild.classList.add('triangle5');
            document.getElementById('columnHeader_6').firstElementChild.classList.add('triangle6');
            document.getElementById('columnHeader_7').firstElementChild.classList.add('triangle7');
            document.getElementById('columnHeader_8').firstElementChild.classList.add('triangle8');
            
            headers.forEach( function(el) {
                el.classList.remove('hover'); 
                el.classList.remove('check'); 
            }.bind(this));
            this.hideAllItems(1)
            this.sendMesOnBtnClick('clickOnTable2', 'none', 'none');
        }else{
            target.classList.add('hover');
            headers.forEach( function(target, header) {
                let headers = document.querySelectorAll('.columnHeader');
                headers = Array.from(headers);
                if( target.id != header.id ){
                    header.style.backgroundColor = "#d3d3d3";
                    header.classList.add('check');
                    header.firstElementChild.classList.remove(header.firstElementChild.classList[0]);
                    header.firstElementChild.classList.add('triangle');
                }  
                headers[7].firstElementChild.classList.remove('triangle');
            }.bind(this, target));
            this.sendMesOnBtnClick('clickOnTable2', columnName, navigator, target.id);
        }
    },
    hideAllItems: function(value){
        var categories = document.querySelectorAll('.columnCategorie');
        categories = Array.from(categories);
        if( value == 0){
            categories.forEach( el => {
               el.style.display = 'none'; 
            });                                                            
        }else if( value == 1){
             categories.forEach( el => {
               el.style.display = 'flex'; 
            }); 
        }    
    },
    sendMesOnBtnClick: function(message, column, navigator, targetId ){
        this.messageService.publish( {
            name: message,
            column: column,  
            navigation: navigator, 
            orgId: this.organizationId, 
            orgName: organizationName.innerText,
            targetId:  targetId
        });
    },
    resultSearch: function(message, value, id){
        this.messageService.publish({name: message, value: value, orgId: id });
    },  
    destroy: function() {
        this.sub.unsubscribe();
    }    
};
}());
