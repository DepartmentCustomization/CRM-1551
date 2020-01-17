(function () {
  return {
    title: ' ',
    hint: '',
    formatTitle: function() {},
    customConfig:
                `
                <style>
                    #modalWindowWrapper{
                        position:fixed;
                        display:flex;
                        width:100%;
                        height:100%;
                        justify-content:center;
                        align-items:center;
                        background:rgba(0,0,0,.7);
                        z-index:100;   
                        top: 44px;  
                        left: 0;
                    }
                    #modalWindow{
                        position: fixed;
                        top: 140px;
                        margin-left: 50%;
                        left: -450px;
                        z-index: 100;
                        background: #fafafa;
                        width: 100%;
                        max-width: 900px;
                        padding: 15px;
                    }
                    .groupsContainer{
                        display: flex;
                        flex-direction: row;
                        justify-content: center;
                        flex-wrap: wrap;                    
                    }
                    .group__element{
                        display: flex;
                        flex-direction: row;
                        margin-left: 15px;  
                        font-size: 14px;
                        padding: 3px;
                    }
                    .group__element_title{
                        margin-bottom: 15px;
                        padding-left: 5px;
                    }
                    .group__element_checkBox{
                        width: 20px;
                        height: 20px;
                    }
                    #modalBtnWrapper{
                        display: flex;
                        justify-content: center;                        
                    }
                    #btnWrapper{
                        display: flex;
                        flex-direction: column;
                        align-items: flex-end;                        
                    }
                    #renderBtn, #modalBtnSave{
                        background-color: #ff6e40;
                    }
                    #modalBtnExit{
                        background-color: #ffffff;
                        color: #333;
                    }
                    #modalBtnSave, #modalBtnExit{
                        margin: 8px 10px;
                        box-shadow: 0 3px 1px -2px rgba(0,0,0,.2), 0 2px 2px 0 rgba(0,0,0,.14), 0 1px 5px 0 rgba(0,0,0,.12);                        
                    }
                    .btn{
                        border-radius: 4px;
                        padding: 5px 20px;
                        color: #fff;
                        height: 28px;
                        font-size: 16px;
                        min-width: 60px!important;
                        outline: none;
                        border: 0;
                        font-weight: 600;
                    }
                    #filtersContainer{
                        justify-content: space-around;
                        display: flex;  
                        margin-top: 15px;
                        flex-wrap: wrap;
                    }
                    .filterBox{
                        padding: 5px 10px;
                        border-width: 0px;
                        max-width: 250px;
                        height: 40px;
                        background: inherit;
                        background-color: rgba(239, 247, 249, 1);
                        border: none;
                        border-radius: 16px;
                        -moz-box-shadow: none;
                        -webkit-box-shadow: none;
                        box-shadow: none;
                        font-size: 12px;
                        display: flex;
                        justify-content: space-around;
                        align-items: center; 
                        cursor: pointer;
                        margin: 5px 0;  
                    }
                    .filterBox__value{
                        margin-left: 20px;
                        position: relative;
                        display: inline-block;
                        text-overflow: ellipsis;
                        overflow: hidden;
                        white-space: nowrap;
                        max-width: 100px;  
                        min-width: 60px;
                        margin: 10px;
                    }
                    [tooltip]:before {            
                        position : absolute;
                         content : attr(tooltip);
                         opacity : 0;
                    }
                    [tooltip]:hover:before {        
                        opacity : 1;
                    }
                    [tooltip]:not([tooltip-persistent]):before {
                        pointer-events: none;
                    }
                    .filterBox__title{
                        white-space: nowrap;
                    }
                </style>
                <div id='container' ></div>
                `
    ,
    filterColumns: [],
    checkedItems: [],
    defaultCheckedItem: [],
    filtersBox: [],
    init: function(){
        this.sub = this.messageService.subscribe('filters', this.showFiltersValue, this );
        this.sub = this.messageService.subscribe('clickOnFiltersBtn', this.clickOnGear, this );
        
            this.defaultCheckedItem = [ ]
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
        const container =  document.getElementById('container');
        const filtersContainer = this.createElement('div', { id:'filtersContainer', className: 'filtersContainer'});
        const modalWindow = this.createElement('div', { id:'modalWindow', className: 'modalWindow'}); 
        const modalWindowWrapper = this.createElement('div', { id:'modalWindowWrapper', className: 'modalWindowWrapper'}, modalWindow); 
        modalWindowWrapper.style.display = 'none';
        container.appendChild(filtersContainer);
        container.appendChild(modalWindowWrapper);
        this.createFilterElements(modalWindow);
    },
    clickOnGear: function(message){
        if( document.getElementById('modalWindowWrapper').style.display == 'none' ){
            document.getElementById('modalWindowWrapper').style.display = 'block'
        }
    },    
    showFiltersValue: function(message){
        let container = document.getElementById("filtersContainer");
        while( container.hasChildNodes() ) { 
          container.removeChild( container.lastElementChild );
        }
        this.filtersBox = [];
        console.log(container, this.filtersBox, message.value);
        message.value.forEach( function(el){
            if(el.code == 'zayavnyk_building_street'){
                this.streetId = el.value;
            }
            if(Number.isInteger(el.value) ||  el.code == 'appeals_user' ){
                if( el.code == 'zayavnyk_building_number' ){
                    let executeQuery = {
                        queryCode: el.code,
                        filterColumns: null,
                        limit: -1,
                        parameterValues: [ 
                            {key: '@Street_Id' , value: this.streetId},
                            {key: '@pageOffsetRows' , value:0},
                            {key: '@pageLimitRows', value: 50} ],
                        pageNumber: 1,
                        sortColumns: [
                            {
                            key: 'Id',
                            value: 0
                            }
                        ]
                    };
                    this.queryExecutor(executeQuery, this.loadFilster.bind(this,  el.value, el.code  ), this);
                }else{
                    let executeQuery = {
                        queryCode: el.code,
                        filterColumns: null,
                        limit: -1,
                        parameterValues: [ {key:'@pageOffsetRows' , value:0},{key: '@pageLimitRows', value: 50} ],
                        pageNumber: 1,
                        sortColumns: [
                            {
                            key: 'Id',
                            value: 0
                            }
                        ]
                    };
                    this.queryExecutor(executeQuery, this.loadFilster.bind(this,  el.value, el.code  ), this);
                }    
            }else {
                var resultTitle;
                switch(el.code) {
                    case 'zayavnyk_full_name':  
                        title = 'ПiБ'
                        break
                    case 'appeals_files_check': 
                        title = 'Ознака',
                        el.value = 'Наявнiсть файлiв'
                        break
                    case 'zayavnyk_phone_number':  
                        title = 'Номер телефону'
                        break
                    case 'zayavnyk_entrance': 
                        title = 'Парадне'
                        break
                    case 'zayavnyk_email':  
                        title = 'E-mail'
                        break
                    case 'zayavnyk_flat':  
                        title = 'Квартира'
                        break
                    case 'question_registration_number':  
                        title = 'Номер питання'
                        break
                    case 'question_object':  
                        title = "Об'єкт"
                        break
                    case 'question_organization': 
                        title = 'Органiзацiя'
                        break
                    case 'assigm_executor_organization':
                        title = 'Виконавець'
                        break
                    case 'assigm_question_content': 
                        title = 'Змiст'
                        break
                    case 'registration_date': 
                        title = 'Поступило '
                        resultTitle = this.operation(el.operation, title)
                        title = resultTitle
                        el.value = this.changeDateValue(el.value)
                        break
                    case 'transfer_date':  
                         title = 'Передано '
                        resultTitle = this.operation(el.operation, title)
                        title = resultTitle
                        el.value = this.changeDateValue(el.value)
                        break
                    case 'state_changed_date':  
                        title = 'Розглянуто '
                        resultTitle = this.operation(el.operation, title)
                        title = resultTitle
                        el.value = this.changeDateValue(el.value)
                        break
                    case 'state_changed_date_done':  
                        title = 'На прозвон '
                        resultTitle = this.operation(el.operation, title);
                        title = resultTitle;
                        el.value = this.changeDateValue(el.value);
                        break
                    case 'execution_term':  
                        title = 'Контроль '
                        resultTitle = this.operation(el.operation, title);
                        title = resultTitle;
                        el.value = this.changeDateValue(el.value);
                        break
                     /*   
                    case 'state_change_date_close':
                        title = 'Перевірено '
                        resultTitle = this.operation(el.operation, title);
                        title = resultTitle;
                        el.value = this.changeDateValue(el.value);
                        break
                        */
                }
                let obj = {
                    title: title,
                    value: el.value
                }
                this.filtersBox.push(obj); 
            }
        }.bind(this));
        setTimeout(this.createFilterBox.bind(this), 100);
        this.streetId = 0;
    },
    operation: function(operation, title){
        switch( operation ) {
            case '>=': 
                title = title + 'з'
                break
            case '<=': 
                title = title + 'по'
                break
        }
        return title
    },
    changeDateValue: function(value){
        let day =  value.getDate();
        let month = value.getMonth() + 1;
        let year = value.getFullYear();
        day = day.toString();
        month = month.toString();
        year = year.toString();
        if( day.length == 1){
            day = '0'+ day;
        }
        if( month.length == 1){
            month = '0'+ month;
        }
        let fullDate = day +"-"+ month + "-"+ year;
        return fullDate;
    },
    loadFilster: function( value, title, data ){
        data.rows.forEach(  function(el) {
            if( value == el.values[0] ) {
                this.createWrapperForFilter(  title, el.values[1]);
            }
        }.bind(this));
    },
    createWrapperForFilter: function(title, value){
        if(  title == 'appeals_receipt_source'){
            title = 'Джерела надходження'
        }else if(  title == 'appeals_user' ){
            title = 'Прийняв (ла)'
        } 
        else if(  title == 'appeals_district'){
            title = 'Район'
        }
        else if(  title == 'zayavnyk_applicant_privilage'){
            title = 'Пiльга'
        }
        else if(  title == 'zayavnyk_social_state'){
            title = 'Соц.стан'
        }
        else if(  title == 'zayavnyk_sex'){
            title = 'Стать'
        }
        else if(  title == 'zayavnyk_applicant_type'){
            title = 'Тип заявника'
        }
        else if(  title == 'question_ObjectTypes'){
            title = "Тип об'єкта"
        }
        else if(  title == 'question_question_type'){
            title = 'Тип питання'
        }
        else if(  title == 'question_question_state'){
            title = 'Стан питання'
        }
        else if(  title == 'question_list_state'){
            title = 'Перелiк'
        }
        else if(  title == 'assigm_main_executor'){
            title = 'Головний'
        }
        else if(  title == 'assigm_accountable'){
            title = 'Вiдповiдальний'
        }
        else if(  title == 'assigm_assignment_state'){
            title = 'Стан'
        }
        else if(  title == 'assigm_assignment_result'){
            title = 'Результат'
        }
        else if(  title == 'assigm_assignment_resolution'){
            title = 'Резолюцiя'
        }
        else if(  title == 'assigm_user_reviewed'){
            title = 'Розглянув'
        }
        else if(  title == 'assigm_user_checked'){
            title = 'Перевiрив'
        }
        else if(  title == 'zayavnyk_building_number'){
            title = 'Будинок'
        }
        else if(  title == 'zayavnyk_building_street'){
            title = 'Вулиця'
        }
        let obj = {
            title: title,
            value: value
        }
        this.filtersBox.push(obj);
        // console.log(this.filtersBox);
    },
    createFilterBox: function(){
        this.filtersBox.forEach( function( el){
            let filterBox__title = this.createElement('span', { className: 'filterBox__title',  innerText: ''+el.title+' :'+' '});
            let filterBox__value = this.createElement('div', { className: 'filterBox__value tooltip',title: ''+el.value+'',  innerText: ''+el.value+''});
            let filterBox = this.createElement('div', { className: 'filterBox'}, filterBox__title, filterBox__value );
            filtersContainer.appendChild(filterBox);
        }.bind(this));
    },
    createFilterElements: function(modalWindow){
        /* группа 1*/
        const group1__title =  this.createElement('div', { className: 'group1__title groupTitle material-icons', innerText: 'view_stream Звернення'});
        const group2__title =  this.createElement('div', { className: 'group1__title groupTitle material-icons', innerText: 'view_stream Заявник'});
        const group3__title =  this.createElement('div', { className: 'group1__title groupTitle material-icons', innerText: 'view_stream Питання'});
        const group4__title =  this.createElement('div', { className: 'group1__title groupTitle material-icons', innerText: 'view_stream Доручення'});
        const group5__title =  this.createElement('div', { className: 'group1__title groupTitle material-icons', innerText: 'view_stream Дати'});
        
        const group1__element1_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox',  name: 150,  value: 'appeals_receipt_source', id: 'appeals_receipt_source'});
        const group1__element1_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Джерела надходження'});
        const group1__element1 =  this.createElement('div', { className: 'group__element'}, group1__element1_checkBox, group1__element1_title);  
        
        const group1__element2_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox',  name: 250,  value: 'appeals_user', id: 'appeals_user' });
        const group1__element2_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Прийняв'});
        const group1__element2 =  this.createElement('div', { className: 'group__element'}, group1__element2_checkBox, group1__element2_title);
        
        const group1__element3_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox',  name: 120,  value: 'appeals_district', id: 'appeals_district' });
        const group1__element3_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Район'});
        const group1__element3 =  this.createElement('div', { className: 'group__element'}, group1__element3_checkBox, group1__element3_title);
        
        const group1__element4_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox',  name: 70,  value: 'appeals_files_check', id: 'appeals_files_check' });
        const group1__element4_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Ознака'});
        const group1__element4 =  this.createElement('div', { className: 'group__element'}, group1__element4_checkBox, group1__element4_title);
        
        const group1__container =  this.createElement('div', {  className: 'groupContainer'}, group1__title, group1__element1, group1__element2, group1__element3, group1__element4 );
        
        /* группа 2*/

        const group2__element2_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox',  name: 120,  value: 'zayavnyk_phone_number', id: 'zayavnyk_phone_number' });
        const group2__element2_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Номер телефону'});
        const group2__element2 =  this.createElement('div', { className: 'group__element'}, group2__element2_checkBox, group2__element2_title);

        const group2__element4_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox',  name: 60,  value: 'zayavnyk_entrance', id: 'zayavnyk_entrance' });
        const group2__element4_title =  this.createElement('div', { className: 'group__element_title', innerText: "Парадне"});
        const group2__element4 =  this.createElement('div', { className: 'group__element'}, group2__element4_checkBox, group2__element4_title);

        const group2__element6_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox',  name: 120,  value: 'zayavnyk_applicant_privilage', id: 'zayavnyk_applicant_privilage' });
        const group2__element6_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Пiльга'});
        const group2__element6 =  this.createElement('div', { className: 'group__element'}, group2__element6_checkBox, group2__element6_title);
        
        const group2__element7_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox',  name: 150,  value: 'zayavnyk_social_state', id: 'zayavnyk_social_state' });
        const group2__element7_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Соц.стан'});
        const group2__element7 =  this.createElement('div', { className: 'group__element'}, group2__element7_checkBox, group2__element7_title);
        
        const group2__element8_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox',  name: 80,  value: 'zayavnyk_sex', id: 'zayavnyk_sex' });
        const group2__element8_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Стать'});
        const group2__element8 =  this.createElement('div', { className: 'group__element'}, group2__element8_checkBox, group2__element8_title);
        
        const group2__element12_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', name: 110,   value: 'zayavnyk_applicant_type', id: 'zayavnyk_applicant_type' });
        const group2__element12_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Тип заявника'});
        const group2__element12 =  this.createElement('div', { className: 'group__element'}, group2__element12_checkBox, group2__element12_title);
        
        const group2__element9_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox',  name: 60,  value: 'zayavnyk_age', id: 'zayavnyk_age' });
        const group2__element9_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Вiк'});
        const group2__element9 =  this.createElement('div', { className: 'group__element'}, group2__element9_checkBox, group2__element9_title);
        
        const group2__element10_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', name: 250,   value: 'zayavnyk_email', id: 'zayavnyk_email' });
        const group2__element10_title =  this.createElement('div', { className: 'group__element_title', innerText: 'E-mail'});
        const group2__element10 =  this.createElement('div', { className: 'group__element'}, group2__element10_checkBox, group2__element10_title);
        
        const group2__container =  this.createElement('div', {  className: 'groupContainer'}, group1__title, group2__element2, group2__element4, group2__element6, group2__element7, group2__element8, group2__element12, group2__element9, group2__element10);
        
        
        /* Группа 3*/

        const group3__element2_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', name: 150,   value: 'question_ObjectTypes', id: 'question_ObjectTypes' });
        const group3__element2_title =  this.createElement('div', { className: 'group__element_title', innerText: "Тип об'єкту"});
        const group3__element2 =  this.createElement('div', { className: 'group__element'}, group3__element2_checkBox, group3__element2_title);

        const group3__element4_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', name: 300, value: 'question_organization', id: 'question_organization' });
        const group3__element4_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Органiзацiя'});
        const group3__element4 =  this.createElement('div', { className: 'group__element'}, group3__element4_checkBox, group3__element4_title);

        const group3__element6_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', name: 120, value: 'question_question_state', id: 'question_question_state' });
        const group3__element6_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Стан питання'});
        const group3__element6 =  this.createElement('div', { className: 'group__element'}, group3__element6_checkBox, group3__element6_title);
        
        const group3__element7_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', name: 150, value: 'question_list_state', id: 'question_list_state' });
        const group3__element7_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Перелiк'});
        const group3__element7 =  this.createElement('div', { className: 'group__element'}, group3__element7_checkBox, group3__element7_title);
        
        const group3__container =  this.createElement('div', {  className: 'groupContainer'}, group1__title, group3__element2, group3__element4, group3__element6, group3__element7 );
 
        
        const group4__element2_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', name: 100,  value: 'assigm_main_executor', id: 'assigm_main_executor' });
        const group4__element2_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Головний'});
        const group4__element2 =  this.createElement('div', { className: 'group__element'}, group4__element2_checkBox, group4__element2_title);        
        
        const group4__element3_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', name: 700,  value: 'assigm_question_content', id: 'assigm_question_content' });
        const group4__element3_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Змiст'});
        const group4__element3 =  this.createElement('div', { className: 'group__element'}, group4__element3_checkBox, group4__element3_title);        
        
        const group4__element4_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', name: 250,  value: 'assigm_accountable', id: 'assigm_accountable' });
        const group4__element4_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Вiдповiдальний'});
        const group4__element4 =  this.createElement('div', { className: 'group__element'}, group4__element4_checkBox, group4__element4_title);        
        
        const group4__element5_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', name: 120,  value: 'assigm_assignment_state', id: 'assigm_assignment_state' });
        const group4__element5_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Стан'});
        const group4__element5 =  this.createElement('div', { className: 'group__element'}, group4__element5_checkBox, group4__element5_title);        
        
        const group4__element6_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', name: 150,  value: 'assigm_assignment_result', id: 'assigm_assignment_result' });
        const group4__element6_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Результат'});
        const group4__element6 =  this.createElement('div', { className: 'group__element'}, group4__element6_checkBox, group4__element6_title);        
    
        const group4__element7_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', name: 150,  value: 'assigm_assignment_resolution', id: 'assigm_assignment_resolution' });
        const group4__element7_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Резолюцiя'});
        const group4__element7 =  this.createElement('div', { className: 'group__element'}, group4__element7_checkBox, group4__element7_title);        
        
        const group4__element8_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', name: 250,  value: 'assigm_user_reviewed', id: 'assigm_user_reviewed' });
        const group4__element8_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Розглянув'});
        const group4__element8 =  this.createElement('div', { className: 'group__element'}, group4__element8_checkBox, group4__element8_title);        
        
        const group4__element9_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', name: 250,  value: 'assigm_user_checked', id: 'assigm_user_checked' });
        const group4__element9_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Перевiрив'});
        const group4__element9 =  this.createElement('div', { className: 'group__element'}, group4__element9_checkBox, group4__element9_title);        
        
        const group4__container =  this.createElement('div', {  className: 'groupContainer'}, group4__title, group4__element2,  group4__element3, group4__element4, group4__element5, group4__element6, group4__element7 , group4__element8 , group4__element9 );
        
        /* Группа 5*/

        const group5__element2_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', name: 100,  value: 'transfer_date',  id: 'transfer_date'});
        const group5__element2_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Передано'});
        const group5__element2 =  this.createElement('div', { className: 'group__element'}, group5__element2_checkBox, group5__element2_title);

        const group5__element3_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', name: 100,  value: 'state_changed_date',  id: 'state_changed_date'});
        const group5__element3_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Розглянуто'});
        const group5__element3 =  this.createElement('div', { className: 'group__element'}, group5__element3_checkBox, group5__element3_title);

        const group5__element4_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', name: 100,  value: 'state_changed_date_done',  id: 'state_changed_date_done'});
        const group5__element4_title =  this.createElement('div', { className: 'group__element_title', innerText: 'На прозвон'});
        const group5__element4 =  this.createElement('div', { className: 'group__element'}, group5__element4_checkBox, group5__element4_title);

        const group5__element5_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', name: 100,  value: 'execution_term',  id: 'execution_term'});
        const group5__element5_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Контроль'});
        const group5__element5 =  this.createElement('div', { className: 'group__element'}, group5__element5_checkBox, group5__element5_title);

        // const group5__element6_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', name: 100,  value: 'state_change_date_close',  id: 'state_change_date_close'});
        // const group5__element6_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Перейнято'});
        // const group5__element6 =  this.createElement('div', { className: 'group__element'}, group5__element6_checkBox, group5__element6_title);
        
        const group5__container =  this.createElement('div', {  className: 'groupContainer'}, group5__title, group5__element2, group5__element3, group5__element4, group5__element5 );
        
        const group1 =  this.createElement('div', { id:'group1', className: 'group1'}, group1__title, group1__container );
        const group2 =  this.createElement('div', { id:'group2', className: 'group2'}, group2__title, group2__container);
        const group3 =  this.createElement('div', { id:'group3', className: 'group3'},  group3__title, group3__container);
        const group4 =  this.createElement('div', { id:'group4', className: 'group4'},  group4__title, group4__container);
        const group5 =  this.createElement('div', { id:'group4', className: 'group4'},  group5__title, group5__container);
        
        const groupsContainer =  this.createElement('div', { id:'groupsContainer', className: 'groupsContainer'}, group1, group2, group3, group4, group5);
        
        const modalBtnSave =  this.createElement('button', { id:'modalBtnSave', className: 'btn', innerText: 'Зберегти'});
        const modalBtnExit =  this.createElement('button', { id:'modalBtnExit', className: 'btn', innerText: 'Вийти'});
        const modalBtnWrapper =  this.createElement('div', { id:'modalBtnWrapper', className: 'modalBtnWrapper'}, modalBtnSave, modalBtnExit);
        
        modalBtnExit.addEventListener('click', event =>{
            document.getElementById('modalWindowWrapper').style.display = 'none';
        });
        modalBtnSave.addEventListener('click', event =>{
            this.defaultCheckedItem = [];
            this.filterColumns = [];
            let checkedElements = document.querySelectorAll('.group__element');

            checkedElements.forEach( function(el){
                if( el.firstElementChild.checked == true ){
                    let elWidth = Number(el.firstElementChild.name);
                    let obj = {
                        displayValue: el.firstElementChild.value,
                        caption: el.lastElementChild.innerText,
                        width: elWidth
                    }
                    this.filterColumns.push(obj);
                }
            }.bind(this));
            // console.log(this.filterColumns);
            let columns = this.filterColumns;
            this.messageService.publish( { 
                name: 'findFilterColumns', value: columns
            });
        });
        modalWindow.appendChild(modalBtnWrapper);
        modalWindow.appendChild(groupsContainer);
        
        if(this.defaultCheckedItem.length > 0 ){
            let arr = this.defaultCheckedItem;
            arr.forEach( e => {
               document.getElementById(e.displayValue).checked = true; 
            });
        }
        this.checkItems();
    },
    checkItems: function(){
        let elements = this.filterColumns;
        elements.forEach( e => {
           document.getElementById(e.displayValue).checked = true;
        });
    },
        
};
}());
