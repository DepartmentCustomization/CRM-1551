(function () {
  return {
    title: ' ',
    hint: '',
    formatTitle: function() {},
    customConfig:
                `
                <style>
                  
                </style>
                <div id='container' ></div>
                `
    ,
    
    init: function(){
        const msg = {
            name: "SetFilterPanelState",
            package: {
                value: true
            }
        };
        this.messageService.publish(msg);
                
        this.sub = this.messageService.subscribe('filters', this.showApplyFiltersValue, this );
        this.sub1 = this.messageService.subscribe('clickOnFiltersBtn', this.clickOnGear, this );
        this.filterColumns = [];
        this.defaultCheckedItem = [];
    },
    clickOnGear: function(message){
        if( document.getElementById('modalWindowWrapper').style.display == 'none' ){
            document.getElementById('modalWindowWrapper').style.display = 'block'
        }
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
    
    checkItems: function(){
        let elements = this.filterColumns;
        elements.forEach( e => {
           document.getElementById(e.displayValue).checked = true;
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
    showApplyFiltersValue: function(message){

        let container = document.getElementById("filtersContainer");
        while( container.hasChildNodes() ) { 
          container.removeChild( container.lastElementChild );
        }
        filtersBox = [];
        message.value.forEach( el => {
            let value = el.operation;
            switch(value){
                case true:
                case '=':
                    var obj = {
                        title: el.placeholder,
                        value: 'Наявнiсть файлiв'
                    }
                    break;
                case 'like':
                    var obj = {
                        title: el.placeholder,
                        value: el.value
                    } 
                    break;
                case '===':
                case '==':
                case 'in':
                case '+""+':
                    var obj = {
                        title: el.placeholder,
                        value: el.viewValue
                    } 
                    break
                default:
                    resultTitle = this.operation(el.operation, el.placeholder);
                    resultValue = this.changeDateValue(el.value);   
                    var obj = {
                        title: resultTitle,
                        value: resultValue
                    } 
                    break;
            }
            filtersBox.push(obj);
        });
        this.createFilterBox(filtersBox);
    },
    operation: function(operation, title){
        switch( operation ) {
            case '>=': 
                title = title + ' з'
                break
            case '<=': 
                title = title + ' по'
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
    createFilterBox: function(filtersBox){
        for( let i = 0; i < filtersBox.length; i++ ){
            let el = filtersBox[i];
            let filterBox__value = this.createElement('div', { className: 'filterBox__value tooltip', title: el.value,  innerText: el.value });
            let filterBox__title = this.createElement('div', { className: 'filterBox__title',  innerText: el.title+' : '});
            let filterBox = this.createElement('div', { className: 'filterBox'}, filterBox__title, filterBox__value );
            document.getElementById('filtersContainer').appendChild(filterBox);            
        }
    },
    createFilterElements: function(modalWindow){
        /* группа 1*/
        const group1__title =  this.createElement('div', { className: 'group1__title groupTitle material-icons', innerText: 'view_stream Звернення'});
        const group2__title =  this.createElement('div', { className: 'group1__title groupTitle material-icons', innerText: 'view_stream Заявник'});
        const group3__title =  this.createElement('div', { className: 'group1__title groupTitle material-icons', innerText: 'view_stream Питання'});
        const group4__title =  this.createElement('div', { className: 'group1__title groupTitle material-icons', innerText: 'view_stream Доручення'});
        const group5__title =  this.createElement('div', { className: 'group1__title groupTitle material-icons', innerText: 'view_stream Дати'});
        
        const group1__element1_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox',  columnWidth: 150,  value: 'appeals_receipt_source', id: 'appeals_receipt_source'});
        const group1__element1_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Джерела надходження'});
        const group1__element1 =  this.createElement('div', { className: 'group__element'}, group1__element1_checkBox, group1__element1_title);  
        
        const group1__element5_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox',  columnWidth: 150,  value: 'appeals_enter_number', id: 'appeals_enter_number'});
        const group1__element5_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Вхідний номер'});
        const group1__element5 =  this.createElement('div', { className: 'group__element'}, group1__element5_checkBox, group1__element5_title);  
        
        const group1__element2_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox',  columnWidth: 250,  value: 'appeals_user', id: 'appeals_user' });
        const group1__element2_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Прийняв'});
        const group1__element2 =  this.createElement('div', { className: 'group__element'}, group1__element2_checkBox, group1__element2_title);
        
        const group1__element3_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox',  columnWidth: 120,  value: 'appeals_district', id: 'appeals_district' });
        const group1__element3_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Район'});
        const group1__element3 =  this.createElement('div', { className: 'group__element'}, group1__element3_checkBox, group1__element3_title);
        
        const group1__element4_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox',  columnWidth: 90,  value: 'appeals_files_check', id: 'appeals_files_check' });
        const group1__element4_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Ознака'});
        const group1__element4 =  this.createElement('div', { className: 'group__element'}, group1__element4_checkBox, group1__element4_title);
        
        const group1__container =  this.createElement('div', {  className: 'groupContainer'}, group1__title, group1__element1, group1__element5, group1__element2, group1__element3, group1__element4 );
        
        /* группа 2*/

        const group2__element2_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox',  columnWidth: 120,  value: 'zayavnyk_phone_number', id: 'zayavnyk_phone_number' });
        const group2__element2_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Номер телефону'});
        const group2__element2 =  this.createElement('div', { className: 'group__element'}, group2__element2_checkBox, group2__element2_title);

        const group2__element4_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox',  columnWidth: 60,  value: 'zayavnyk_entrance', id: 'zayavnyk_entrance' });
        const group2__element4_title =  this.createElement('div', { className: 'group__element_title', innerText: "Парадне"});
        const group2__element4 =  this.createElement('div', { className: 'group__element'}, group2__element4_checkBox, group2__element4_title);

        const group2__element6_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox',  columnWidth: 120,  value: 'zayavnyk_applicant_privilage', id: 'zayavnyk_applicant_privilage' });
        const group2__element6_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Пiльга'});
        const group2__element6 =  this.createElement('div', { className: 'group__element'}, group2__element6_checkBox, group2__element6_title);
        
        const group2__element7_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox',  columnWidth: 150,  value: 'zayavnyk_social_state', id: 'zayavnyk_social_state' });
        const group2__element7_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Соц.стан'});
        const group2__element7 =  this.createElement('div', { className: 'group__element'}, group2__element7_checkBox, group2__element7_title);
        
        const group2__element8_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox',  columnWidth: 80,  value: 'zayavnyk_sex', id: 'zayavnyk_sex' });
        const group2__element8_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Стать'});
        const group2__element8 =  this.createElement('div', { className: 'group__element'}, group2__element8_checkBox, group2__element8_title);
        
        const group2__element12_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', columnWidth: 110,   value: 'zayavnyk_applicant_type', id: 'zayavnyk_applicant_type' });
        const group2__element12_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Тип заявника'});
        const group2__element12 =  this.createElement('div', { className: 'group__element'}, group2__element12_checkBox, group2__element12_title);
        
        const group2__element9_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox',  columnWidth: 60,  value: 'zayavnyk_age', id: 'zayavnyk_age' });
        const group2__element9_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Вiк'});
        const group2__element9 =  this.createElement('div', { className: 'group__element'}, group2__element9_checkBox, group2__element9_title);
        
        const group2__element10_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', columnWidth: 250,   value: 'zayavnyk_email', id: 'zayavnyk_email' });
        const group2__element10_title =  this.createElement('div', { className: 'group__element_title', innerText: 'E-mail'});
        const group2__element10 =  this.createElement('div', { className: 'group__element'}, group2__element10_checkBox, group2__element10_title);
        
        const group2__container =  this.createElement('div', {  className: 'groupContainer'}, group1__title, group2__element2, group2__element4, group2__element6, group2__element7, group2__element8, group2__element12, group2__element9, group2__element10);
        
        
        /* Группа 3*/

        const group3__element2_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', columnWidth: 150,   value: 'question_ObjectTypes', id: 'question_ObjectTypes' });
        const group3__element2_title =  this.createElement('div', { className: 'group__element_title', innerText: "Тип об'єкту"});
        const group3__element2 =  this.createElement('div', { className: 'group__element'}, group3__element2_checkBox, group3__element2_title);

        const group3__element4_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', columnWidth: 300, value: 'question_organization', id: 'question_organization' });
        const group3__element4_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Органiзацiя'});
        const group3__element4 =  this.createElement('div', { className: 'group__element'}, group3__element4_checkBox, group3__element4_title);

        const group3__element6_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', columnWidth: 120, value: 'question_question_state', id: 'question_question_state' });
        const group3__element6_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Стан питання'});
        const group3__element6 =  this.createElement('div', { className: 'group__element'}, group3__element6_checkBox, group3__element6_title);
        
        const group3__element7_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', columnWidth: 150, value: 'question_list_state', id: 'question_list_state' });
        const group3__element7_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Перелiк'});
        const group3__element7 =  this.createElement('div', { className: 'group__element'}, group3__element7_checkBox, group3__element7_title);
        
        const group3__container =  this.createElement('div', {  className: 'groupContainer'}, group1__title, group3__element2, group3__element4, group3__element6, group3__element7 );
 
        
        const group4__element2_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', columnWidth: 100,  value: 'assigm_main_executor', id: 'assigm_main_executor' });
        const group4__element2_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Головний'});
        const group4__element2 =  this.createElement('div', { className: 'group__element'}, group4__element2_checkBox, group4__element2_title);        
        
        const group4__element3_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', columnWidth: 700,  value: 'assigm_question_content', id: 'assigm_question_content' });
        const group4__element3_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Змiст'});
        const group4__element3 =  this.createElement('div', { className: 'group__element'}, group4__element3_checkBox, group4__element3_title);        
        
        const group4__element4_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', columnWidth: 250,  value: 'assigm_accountable', id: 'assigm_accountable' });
        const group4__element4_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Вiдповiдальний'});
        const group4__element4 =  this.createElement('div', { className: 'group__element'}, group4__element4_checkBox, group4__element4_title);        
        
        const group4__element5_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', columnWidth: 120,  value: 'assigm_assignment_state', id: 'assigm_assignment_state' });
        const group4__element5_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Стан'});
        const group4__element5 =  this.createElement('div', { className: 'group__element'}, group4__element5_checkBox, group4__element5_title);        
        
        const group4__element6_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', columnWidth: 150,  value: 'assigm_assignment_result', id: 'assigm_assignment_result' });
        const group4__element6_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Результат'});
        const group4__element6 =  this.createElement('div', { className: 'group__element'}, group4__element6_checkBox, group4__element6_title);        
    
        const group4__element7_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', columnWidth: 150,  value: 'assigm_assignment_resolution', id: 'assigm_assignment_resolution' });
        const group4__element7_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Резолюцiя'});
        const group4__element7 =  this.createElement('div', { className: 'group__element'}, group4__element7_checkBox, group4__element7_title);        
        
        const group4__element8_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', columnWidth: 250,  value: 'assigm_user_reviewed', id: 'assigm_user_reviewed' });
        const group4__element8_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Розглянув'});
        const group4__element8 =  this.createElement('div', { className: 'group__element'}, group4__element8_checkBox, group4__element8_title);        
        
        const group4__element9_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', columnWidth: 250,  value: 'assigm_user_checked', id: 'assigm_user_checked' });
        const group4__element9_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Перевiрив'});
        const group4__element9 =  this.createElement('div', { className: 'group__element'}, group4__element9_checkBox, group4__element9_title);        
        
        const group4__element10_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', columnWidth: 250,  value: 'ConsDocumentContent', id: 'ConsDocumentContent' });
        const group4__element10_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Повна відповідь'});
        const group4__element10 =  this.createElement('div', { className: 'group__element'}, group4__element10_checkBox, group4__element10_title);        
        
        const group4__element11_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', columnWidth: 250,  value: 'control_comment', id: 'control_comment' });
        const group4__element11_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Коментар виконавця'});
        const group4__element11 =  this.createElement('div', { className: 'group__element'}, group4__element11_checkBox, group4__element11_title);        
        
        const group4__container =  this.createElement('div', {  className: 'groupContainer'}, group4__title, group4__element2,  group4__element3, group4__element4, group4__element5, group4__element6, group4__element7 , group4__element8 , group4__element9, group4__element11, group4__element10  );
        
        /* Группа 5*/

        const group5__element2_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', columnWidth: 100,  value: 'transfer_date',  id: 'transfer_date'});
        const group5__element2_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Передано'});
        const group5__element2 =  this.createElement('div', { className: 'group__element'}, group5__element2_checkBox, group5__element2_title);

        const group5__element3_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', columnWidth: 100,  value: 'state_changed_date',  id: 'state_changed_date'});
        const group5__element3_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Розглянуто'});
        const group5__element3 =  this.createElement('div', { className: 'group__element'}, group5__element3_checkBox, group5__element3_title);

        const group5__element4_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', columnWidth: 100,  value: 'state_changed_date_done',  id: 'state_changed_date_done'});
        const group5__element4_title =  this.createElement('div', { className: 'group__element_title', innerText: 'На прозвон'});
        const group5__element4 =  this.createElement('div', { className: 'group__element'}, group5__element4_checkBox, group5__element4_title);

        const group5__element5_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', columnWidth: 100,  value: 'execution_term',  id: 'execution_term'});
        const group5__element5_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Контроль'});
        const group5__element5 =  this.createElement('div', { className: 'group__element'}, group5__element5_checkBox, group5__element5_title);
        
        const group5__element6_checkBox =  this.createElement('input', {type: 'checkbox', className: 'group__element_checkBox', columnWidth: 100,  value: 'control_date',  id: 'control_date'});
        const group5__element6_title =  this.createElement('div', { className: 'group__element_title', innerText: 'Перевірка'});
        const group5__element6 =  this.createElement('div', { className: 'group__element'}, group5__element6_checkBox, group5__element6_title);
        
        const group5__container =  this.createElement('div', {  className: 'groupContainer'}, group5__title, group5__element2, group5__element3, group5__element4, group5__element5, group5__element6 );
        
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
            checkedElements = Array.from(checkedElements);
            checkedElements.forEach( function(el){
                if( el.firstElementChild.checked == true ){
                    let width = Number(el.firstElementChild.columnWidth);
                    let displayValue =  el.firstElementChild.value;
                    let caption =  el.lastElementChild.innerText;
                    let obj = { displayValue, caption, width }
                    this.filterColumns.push(obj);
                }
            }.bind(this));
            let columns = this.filterColumns;
            this.messageService.publish( { 
                name: 'findFilterColumns', value: columns
            });
            document.getElementById('modalWindowWrapper').style.display = 'none';
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
    destroy: function(){
        this.sub.unsubscribe();
        this.sub1.unsubscribe();
    },
};
}());
