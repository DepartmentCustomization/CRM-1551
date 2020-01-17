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
        const header1 = document.getElementById('header1');
        header1.firstElementChild.style.overflow = 'visible';
        header1.firstElementChild.firstElementChild.firstElementChild.style.overflow = 'visible';
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
            let executeQuery = {
                queryCode: 'organization_name',
                parameterValues: [{ key: '@organizationId',  value: this.organizationId}],
                limit: -1
            };
            this.queryExecutor(executeQuery, this.userOrganization, this);
            this.showPreloader = false; 
        }
        
        let executeQueryOrganizations = {
            queryCode: 'events',
            limit: -1,
            parameterValues: [ 
                    { key: '@organization_id', value: this.organizationId }
                ]
        };
        this.queryExecutor(executeQueryOrganizations, this.createSubordinateOrganizationsTable, this);
        this.showPreloader = false; 
        
    },
    userOrganization: function(data){
        let indexOfTypeName = data.columns.findIndex(el => el.code.toLowerCase() === 'organizationname' );
        let indexOfTypeId = data.columns.findIndex(el => el.code.toLowerCase() === 'organizationid' );
        let indexOfTypeDistribute = data.columns.findIndex(el => el.code.toLowerCase() === 'distribute' );
        this.organizationId = [];
        this.organizationId = (data.rows[0].values[indexOfTypeId]);
        this.distribute = (data.rows[0].values[indexOfTypeDistribute]);
        
        this.messageService.publish({name: 'messageWithOrganizationId', value: this.organizationId, distribute:  this.distribute});
        if( window.location.search != '?id='+data.rows[0].values[indexOfTypeId]+''){
            window.location.search = 'id='+data.rows[0].values[indexOfTypeId]+'';
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
        
        const btnWrapper = this.createElement('div', { id: 'btnWrapper'});
        const table = this.createElement('div', { id: 'table'});
        const tableContainer = this.createElement('div', { id: 'tableContainer', className: 'tableContainer'}, table, btnWrapper);
        const tableWrapper = this.createElement('div', { id: 'tableWrapper', className: 'tableWrapper'}, tableContainer);
        
        container.appendChild(tabsWrapper);
        container.appendChild(tableContainer);
        this.createTabs();
    },
    createTabs: function(){
        
        let tabInformation__title  = this.createElement('div', { className: 'tabInformation tab_title', innerText: 'ЗАГАЛЬНА ІНФОРМАЦІЯ'});
        let tabAction__title  = this.createElement('div', { className: 'tabAction tab_title', innerText: 'ЗАХІД'});
        let tabProcessingOrders__title  = this.createElement('div', { className: 'tabProcessingOrders tab_title', innerText: 'ОБРОБКА ДОРУЧЕНЬ'});
        let tabOrganizations__title  = this.createElement('div', { className: 'tabOrganizations tab_title', innerText: 'ОРГАНІЗАЦІЇ'});
        
        
        const tabInformation = this.createElement('div', { id: 'tabInformation', url: '', className: 'tabInformation tab'}, tabInformation__title);
        const tabAction = this.createElement('div', { id: 'tabAction', url: 'performer_new_actions', className: 'tabHover tabAction tab'}, tabAction__title);
        const tabProcessingOrders = this.createElement('div', { id: 'tabProcessingOrders', url: 'performer_new_processing_assigments', className: 'tabProcessingOrders tab tabTo'}, tabProcessingOrders__title);
        const tabOrganizations = this.createElement('div', { id: 'tabOrganizations', url: 'performer_new_organizations', className: 'tabOrganizations tab  tabTo'}, tabOrganizations__title);
        
        
        const tabsContainer = this.createElement('div', { id: 'tabsContainer', className: 'tabsContainer'}, tabInformation, tabAction, tabProcessingOrders, tabOrganizations);
        
        tabsWrapper.appendChild(tabsContainer);
 
        let tabs = document.querySelectorAll('.tabTo');
        tabs = Array.from(tabs);
        tabs.forEach( function (el){
            el.addEventListener( 'click', event => {
                let target =  event.currentTarget;
                document.getElementById('container').style.display = 'none';
                this.goToDashboard(target.url, { queryParams: { id: this.organizationId } });
            })    
        }.bind(this));
    },
    sendMesOnBtnClick: function(message, typeEvent, source, orgId){
        this.messageService.publish({name: message, typeEvent: typeEvent,  source: source, orgId: orgId });
    },
    showTable: function(target, headers, typeEvent, source){
        if( target.classList.contains('check') || target.classList.contains('hover')){
            headers.forEach( el => {
                el.firstElementChild.classList.remove('triangle');
            });
            document.getElementById('headerItem__overdue').style.backgroundColor = "rgb(74, 193, 197)";
            document.getElementById('headerItem__notActive').style.backgroundColor = "rgb( 132, 199, 96 )";
            document.getElementById('headerItem__inWork').style.backgroundColor = 'rgb(173, 118, 205)';

           
            document.getElementById('headerItem__overdue').firstElementChild.classList.add('overdue_triangle');
            document.getElementById('headerItem__notActive').firstElementChild.classList.add('notActive_triangle');
            
            document.getElementById('eventWrapper').classList.remove('displayNone');
            document.getElementById('eventWrapper').classList.add('displayFlex');
            headers.forEach( function(el) {
                el.classList.remove('check'); 
                el.classList.remove('hover');
            }.bind(this));
            this.sendMesOnBtnClick('showEventTable', 'none', 'none');
        }else{
            target.classList.add('hover');
            document.getElementById('eventWrapper').classList.add('displayNone');
            document.getElementById('eventWrapper').classList.remove('displayFlex');
            headers.forEach( function(target, header) {
                if( target.id != header.id ){
                    header.style.backgroundColor = "#d3d3d3";
                    header.classList.add('check');
                    header.firstElementChild.classList.remove(header.firstElementChild.classList[0]);
                    header.firstElementChild.classList.add('triangle');
                }  
                headers[2].firstElementChild.classList.remove('triangle');
            }.bind(this, target));
            this.sendMesOnBtnClick('showEventTable', typeEvent, source, this.organizationId);
        }
    },
    createSubordinateOrganizationsTable: function(data){
        this.createHeaderOrganizations();
        for ( let i = 0; i < data.rows.length; i ++){
            var row = data.rows[i];
            
            var eventElementsСounter = this.createElement('div', {  className: 'eventElementsСounter displayFlex'});    
             
            var eventTitle__name = this.createElement('div', {  className: 'eventTitle__name', innerText: ''+row.values[1]+''});
            var eventTitle = this.createElement('div', {  className: 'eventTitle displayFlex'}, eventTitle__name);
            var event = this.createElement('div', {  className: 'event displayFlex', id: ''+row.values[0]+''}, eventTitle, eventElementsСounter);
            eventWrapper.appendChild(event);
            var name = row.values[1];
            for ( let i = 2;  i <row.values.length; i ++){
                let el = row.values[i];
                if( i == 2 ){
                    var link = 'Прострочені';
                }else if ( i == 3){
                    var link = 'Не активні';
                }else if( i == 4 ){
                    var link = 'В роботі';
                }
                if( el != '0 (0)'){
                    var eventElementsСounterItem__value = this.createElement('div', {  className: ' counter_value', innerText: ''+el+''});
                    var eventElementsСounterItem = this.createElement('div', { value: link,  name: name,  className: 'counter'},eventElementsСounterItem__value);
                }else{
                    var eventElementsСounterItem = this.createElement('div', {  className: 'counter'});
                }
                eventElementsСounter.appendChild(eventElementsСounterItem);
            }
        }    
        let counterHeaderElements = document.querySelectorAll('.counter');
        counterHeaderElements = Array.from(counterHeaderElements);
        counterHeaderElements.forEach( el => {
            if(el.childNodes.length == 0 ){
                el.style.backgroundColor = 'transparent';
            }else{
                el.classList.add('counterBorder');
            }
        });
        
        let headers = document.querySelectorAll('.headerItem ');
        headers = Array.from(headers);
        headers.forEach( function(el){
            el.addEventListener( 'click', function(event){
                let target = event.currentTarget;
                let source = 'Усі';
                let typeEvent = target.innerText;
                this.showTable(target, headers, typeEvent, source);
            }.bind(this));
        }.bind(this));
        
        let counters = document.querySelectorAll('.counter');
        counters = Array.from(counters);
        counters.forEach( function(el){
            el.addEventListener( 'click', function(event){
                let target = event.currentTarget;
                let source = target.name;
                let typeEvent = target.value;
                if( typeEvent === 'Прострочені'){
                    target  = document.getElementById('headerItem__overdue');
                }else if( typeEvent === 'Не активні' ){
                    target  = document.getElementById('headerItem__notActive');
                }else if(typeEvent === 'В роботі'  ){
                    target  = document.getElementById('headerItem__inWork');
                }
                this.showTable(target, headers, typeEvent, source);
            }.bind(this));
        }.bind(this));
        this.messageService.publish( { name: 'hidePagePreloader'  } );
    },
    createHeaderOrganizations: function(){
        const headerItem__overdue_triangle    = this.createElement('div', { className: 'overdue_triangle' });
        const headerItem__notActive_triangle    = this.createElement('div', { className: 'notActive_triangle' });
        const headerItem__inWork_triangle    = this.createElement('div', { className: 'inWork_triangle' });
        const headerItem__overdue    = this.createElement('div', { id: 'headerItem__overdue', value: 'Прострочені', className: 'headerItem overdue displayFlex', innerText: 'Прострочені'}, headerItem__overdue_triangle);
        const headerItem__notActive  = this.createElement('div', { id: 'headerItem__notActive', value: 'Не активні', className: 'headerItem notActive displayFlex', innerText: 'Не активні'}, headerItem__notActive_triangle);
        const headerItem__inWork     = this.createElement('div', { id: 'headerItem__inWork', value: 'В роботі', className: 'headerItem inWork displayFlex', innerText: 'В роботі'}, headerItem__inWork_triangle);
        
        headerItem__overdue.style.backgroundColor = "rgb(74, 193, 197)";
        headerItem__notActive.style.backgroundColor = "rgb( 132, 199, 96 )";
        headerItem__inWork.style.backgroundColor = 'rgb(173, 118, 205)';
        
        const headerItems = this.createElement('div', { id: 'headerItems', className: 'headerItems displayFlex'}, headerItem__overdue, headerItem__notActive, headerItem__inWork);
        const headerTitle = this.createElement('div', { id: 'headerTitle'});        
        const eventsHeader = this.createElement('div', { id: 'eventsHeader', className: 'orgContainer displayFlex'}, headerTitle, headerItems);
        const eventWrapper = this.createElement('div', {  id: 'eventWrapper', value: 0 , className: 'eventWrapper displayFlex'});
        table.appendChild(eventsHeader);
        table.appendChild(eventWrapper);

        const createNewEventBtn = this.createElement('div', { id: 'createNewEventBtn', innerText: 'Додати Захід'});
        const btnContainer = this.createElement('div', { id: 'btnContainer', className: 'btnContainer'}, createNewEventBtn);
        btnWrapper.appendChild(btnContainer);
        
        createNewEventBtn.addEventListener( 'click', event => {
            window.open(location.origin + localStorage.getItem('VirtualPath') + "/sections/Events/add");
        });
    },
};
}());
