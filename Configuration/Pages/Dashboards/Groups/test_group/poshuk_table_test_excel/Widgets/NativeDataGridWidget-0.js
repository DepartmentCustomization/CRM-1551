(function () {
  return {
    config: {
        query: {
            code: 'ak_QueryCodeSearch_2',
            parameterValues: [ { key: '@param1', value: '1=1'} ],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                dataField: 'question_registration_number',
                caption: 'Номер питання'
            }, {
                dataField: 'question_question_type',
                caption: 'Тип питання',
            }, {
                dataField: 'zayavnyk_full_name',
                caption: 'ПІБ Заявника'
            }, {
                dataField: 'zayavnyk_building_number',
                caption: 'Будинок'
            }, {
                dataField: 'zayavnyk_flat',
                caption: 'Квартира'
            }, {
                dataField: 'question_object',
                caption: "Об'єкт"
            }, {
                dataField: 'assigm_executor_organization',
                caption: 'Виконавець'
            }, {
                dataField: 'registration_date',
                caption: 'Поступило'
            }
        ],
        allowColumnResizing: true,
        columnResizingMode: "widget",
        columnMinWidth: 50,
        columnAutoWidth: true,
        pager: {
            showPageSizeSelector: true,
            allowedPageSizes: [5, 10, 15],
            showInfo: true,
        },
        paging: {
            pageSize: 10
        },
        export: {
            enabled: false,
            fileName: 'File_name'
        },
        sorting: {
            mode: "multiple"
        },        
        showBorders: false,
        showColumnLines: false,
        showRowLines: true,
    },
    indexArr: [],
    filtersValuesMacros: [],
    textFilterMacros: '',
    init: function() {
        this.sub = this.messageService.subscribe( 'GlobalFilterChanged', this.setFiltersValue, this );
        this.sub1 = this.messageService.subscribe( 'findFilterColumns', this.reloadTable, this );
        this.loadData(this.afterLoadDataHandler);
        this.config.onToolbarPreparing = this.createButtons.bind(this);
        
        this.dataGridInstance.onCellClick.subscribe( function(e) {
            if(e.column.dataField == "question_registration_number" && e.row != undefined){
                this.goToSection('Assignments/edit/'+e.key+'');
            }
        }.bind(this));
    },
    exportToExcel: function(){
        let exportQuery = {
            queryCode: 'ak_QueryCodeSearch_2',
            limit: -1,
            parameterValues: [
                { key: '@param1', value: '1=1'},
                { key: '@pageOffsetRows', value: 0},
                { key: '@pageLimitRows', value: 10}
                ]
        };
        this.queryExecutor(exportQuery, this.myCreateExcel, this);
    },
    myCreateExcel: function(data){
        this.showPagePreloader('Зачекайте, формується документ');
        this.indexArr = [];
        var columns = this.config.columns;columns.forEach( el => {
            let elDataField = el.dataField;
            let elCaption = el.caption;
            for ( i = 0; i < data.columns.length; i ++){
                if( elDataField === data.columns[i].code ){
                    let obj = {
                        name: elDataField,
                        index: i,
                        caption: elCaption
                    }
                    this.indexArr.push(obj);
                }
            }
        });
        const workbook = this.createExcel();
        const worksheet = workbook.addWorksheet('Заявки', {
            pageSetup:{
                orientation: 'landscape',
                fitToPage: false,
            }
        });
        worksheet.pageSetup.margins = {
            left: 0.4, right: 0.3,
            top: 0.4, bottom: 0.4,
            header: 0.0, footer: 0.0
        };
        /*TITLE*/
        let cellInfoCaption = worksheet.getCell('A1');
        cellInfoCaption.value = 'Інформація';
        let cellInfo = worksheet.getCell('A2');
        cellInfo.value = 'про звернення громадян, що надійшли до Контактного центру  міста Києва. Термін виконання …';
        let cellPeriod = worksheet.getCell('A3');
        cellPeriod.value = 'Період вводу з (включно) : дата з … дата по … (Розширений пошук).';
        let cellNumber = worksheet.getCell('A4');
        cellNumber.value = 'Реєстраційний № РДА …';
        worksheet.mergeCells('A1:F1'); //вставить другой конец колонок
        worksheet.mergeCells('A2:F2'); //вставить другой конец колонок
        worksheet.mergeCells('A3:F3'); //вставить другой конец колонок
        worksheet.getRow(1).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
        worksheet.getRow(1).alignment = { vertical: 'middle', horizontal: 'center' };
        worksheet.getRow(2).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
        worksheet.getRow(2).alignment = { vertical: 'middle', horizontal: 'center' };
        
        worksheet.getRow(3).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
        worksheet.getRow(3).alignment = { vertical: 'middle', horizontal: 'left' };
        worksheet.getRow(4).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
        worksheet.getRow(5).alignment = { vertical: 'middle', horizontal: 'left' };
        
     
        var indexArr = this.indexArr;
        var rows = [];
        var captions = [];
        var columnsHeader = [];
        let columnNumber = {
            key: 'number',
            width: 5
        }
        columnsHeader.push(columnNumber);
        let rowNumber = '№ з/п';
        captions.push(rowNumber);
        console.log(indexArr);
        indexArr.forEach( el => {
                if( el.name === 'question_registration_number'  ){
                    var obj =  {
                        key: 'registration_number',
                        width: 10,
                        height: 20,
                    };
                    columnsHeader.push(obj);
                    captions.push('Номер, дата,  час');
                }else if(el.name === 'zayavnyk_full_name' ){
                    var obj =  {
                        key: 'name',
                        width: 15
                    };
                    columnsHeader.push(obj);
                    captions.push('Заявник');
                }else if(el.name === 'question_question_type' ){
                    var obj =  { 
                        key: 'question_type',
                        width: 62
                    };
                    columnsHeader.push(obj);
                    captions.push('Суть питання');
                }else if( el.name === 'assigm_executor_organization'  ){
                    var obj =  { 
                        key: 'organization',
                        width: 16
                    };
                    columnsHeader.push(obj);
                    captions.push('Виконавець');
                }else if( el.name === 'question_object'  ){
                    var obj =  { 
                        key: 'object',
                        width: 21
                    };
                    columnsHeader.push(obj);
                    captions.push('Місце проблеми (Об\'єкт)');
                }else if( el.name === 'registration_date' || el.name === 'zayavnyk_building_number' || el.name === 'zayavnyk_flat' || el.name === 'assigm_question_content'  ){
                }else{
                    var obj =  { 
                        key: el.name,
                        width: 13
                    };
                    columnsHeader.push(obj);
                    captions.push(el.caption);
                }
        });
        worksheet.getRow(5).values = captions;
        worksheet.columns = columnsHeader;
        
        this.addetedIndexes = [];
        for( let  j = 0; j < data.rows.length; j ++ ){  
            var row = data.rows[j];
            var rowArr = [];
            var rowItem = { number: j + 1 };
            
            for( i = 0; i < indexArr.length; i ++){
                var el = indexArr[i];
                if( el.name === 'question_registration_number'  ){
                    rowItem.registration_number = row.values[el.index] + ' ' + row.values[33];
                }else if(el.name === 'zayavnyk_full_name' ){
                    rowItem.name = row.values[el.index] + ' ' + row.values[8] + ', кв. ' +  row.values[10];
                }else if(el.name === 'question_question_type' ){
                    rowItem.question_type = 'Тип питання: '+ row.values[el.index] + ', зміст: ' + row.values[26];
                }else if( el.name === 'assigm_executor_organization'  ){
                    rowItem.organization = row.values[el.index]
                }else if( el.name === 'question_object'  ){
                    rowItem.object = row.values[el.index];
                }else if( el.name === 'registration_date' || el.name === 'zayavnyk_building_number' || el.name === 'zayavnyk_flat' || el.name === 'assigm_question_content'  ){
                }else{
                    let prop = indexArr[i].name;
                    switch(prop) {
                        case 'appeals_receipt_source':
                            rowItem.appeals_receipt_source = row.values[el.index]
                            break
                        case 'appeals_user':
                            rowItem.appeals_user = row.values[el.index]
                            break
                        case 'appeals_district':
                            rowItem.appeals_district = row.values[el.index]
                            break
                        case 'appeals_files_check':
                            rowItem.appeals_files_check = row.values[el.index]
                            break
                        case 'zayavnyk_phone_number':
                            rowItem.zayavnyk_phone_number = row.values[el.index]
                            break
                        case 'zayavnyk_entrance':
                            rowItem.zayavnyk_entrance = row.values[el.index]
                            break
                        case 'zayavnyk_applicant_privilage':
                            rowItem.zayavnyk_applicant_privilage = row.values[el.index]
                            break
                        case 'zayavnyk_social_state':
                            rowItem.zayavnyk_social_state = row.values[el.index]
                            break
                        case 'zayavnyk_sex':
                            rowItem.zayavnyk_sex = row.values[el.index]
                            break
                        case 'zayavnyk_applicant_type':
                            rowItem.zayavnyk_applicant_type = row.values[el.index]
                            break
                        case 'zayavnyk_age':
                            rowItem.zayavnyk_age = row.values[el.index]
                            break
                        case 'zayavnyk_email':
                            rowItem.zayavnyk_email = row.values[el.index]
                            break
                        case 'question_ObjectTypes':
                            rowItem.question_ObjectTypes = row.values[el.index]
                            break
                        case 'question_organization':
                            rowItem.question_organization = row.values[el.index]
                            break
                        case 'question_question_state':
                            rowItem.question_question_state = row.values[el.index]
                            break
                        case 'question_list_state':
                            rowItem.question_list_state = row.values[el.index]
                            break
                        case 'assigm_main_executor':
                            rowItem.assigm_main_executor = row.values[el.index]
                            break
                        case 'assigm_accountable':
                            rowItem.assigm_accountable = row.values[el.index]
                            break
                        case 'assigm_assignment_state':
                            rowItem.assigm_assignment_state = row.values[el.index]
                            break
                        case 'assigm_assignment_result':
                            rowItem.assigm_assignment_result = row.values[el.index]
                            break
                        case 'assigm_assignment_resolution':
                            rowItem.assigm_assignment_resolution = row.values[el.index]
                            break
                        case 'assigm_user_reviewed':
                            rowItem.assigm_user_reviewed = row.values[el.index]
                            break
                        case 'assigm_user_checked':
                            rowItem.assigm_user_checked = row.values[el.index]
                            break
                        case 'transfer_date':
                            rowItem.transfer_date = row.values[el.index]
                            break
                        case 'state_changed_date':
                            rowItem.state_changed_date = row.values[el.index]
                            break
                        case 'state_changed_date_done':
                            rowItem.state_changed_date_done = row.values[el.index]
                            break
                        case 'execution_term':
                            rowItem.execution_term = row.values[el.index]
                            break
                    };
                    this.addetedIndexes.push(prop);
                }
            };
            rows.push( rowItem );
        };
        rows.forEach( el => {
            let number = el.number + '.'
            var row = {
                number: number,
                name: el.name,
                registration_number: el.registration_number,
                organization: el.organization,
                question_type: el.question_type,
                object: el.object
            }
            let indexes = this.addetedIndexes;
            var size = Object.keys(el).length
            for( i = 0; i <size - 6 ; i ++ ){
                let prop = indexes[i];
                switch(prop) {
                    case 'appeals_receipt_source':
                        row.appeals_receipt_source = el.appeals_receipt_source
                        break
                    case 'appeals_user':
                        row.appeals_user =  el.appeals_user
                        break
                    case 'appeals_district':
                        row.appeals_district =  el.appeals_district
                        break
                    case 'appeals_files_check':
                        row.appeals_files_check =  el.appeals_files_check
                        break
                    case 'zayavnyk_phone_number':
                        row.zayavnyk_phone_number =  el.zayavnyk_phone_number
                        break
                    case 'zayavnyk_entrance':
                        row.zayavnyk_entrance =  el.zayavnyk_entrance
                        break
                    case 'zayavnyk_applicant_privilage':
                        row.zayavnyk_applicant_privilage =  el.zayavnyk_applicant_privilage
                        break
                    case 'zayavnyk_social_state':
                        row.zayavnyk_social_state = el.zayavnyk_social_state
                        break
                    case 'zayavnyk_sex':
                        row.zayavnyk_sex = el.zayavnyk_sex
                        break
                    case 'zayavnyk_applicant_type':
                        row.zayavnyk_applicant_type =  el.zayavnyk_applicant_type
                        break
                    case 'zayavnyk_age':
                        row.zayavnyk_age = el.zayavnyk_age
                        break
                    case 'zayavnyk_email':
                        row.zayavnyk_email = el.zayavnyk_email
                        break
                    case 'question_ObjectTypes':
                        row.question_ObjectTypes = el.question_ObjectTypes
                        break
                    case 'question_organization':
                        row.question_organization = el.question_organization
                        break
                    case 'question_question_state':
                        row.question_question_state = el.question_question_state
                        break
                    case 'question_list_state':
                        row.question_list_state = el.question_list_state
                        break
                    case 'assigm_main_executor':
                        row.assigm_main_executor = el.assigm_main_executor
                        break
                    case 'assigm_accountable':
                        row.assigm_accountable = el.assigm_accountable
                        break
                    case 'assigm_assignment_state':
                        row.assigm_assignment_state = el.assigm_assignment_state
                        break
                    case 'assigm_assignment_result':
                        row.assigm_assignment_result = el.assigm_assignment_result
                        break
                    case 'assigm_assignment_resolution':
                        row.assigm_assignment_resolution = el.assigm_assignment_resolution
                        break
                    case 'assigm_user_reviewed':
                        row.assigm_user_reviewed = el.assigm_user_reviewed
                        break
                    case 'assigm_user_checked':
                        row.assigm_user_checked = el.assigm_user_checked
                        break
                    case 'transfer_date':
                        row.transfer_date = el.transfer_date
                        break
                    case 'state_changed_date':
                        row.state_changed_date = el.state_changed_date
                        break
                    case 'state_changed_date_done':
                        row.state_changed_date_done = el.state_changed_date_done
                        break
                    case 'execution_term':
                        row.execution_term =  el.execution_term
                        break
                };
            }
            worksheet.addRow(row);
        });
        
        for(let  i = 0; i < rows.length + 1; i++ ){
            let number = i + 5 ;
            var row = worksheet.getRow(number);
            row.height = 80;
            worksheet.getRow(number).border = {
                top: {style:'thin'},
                left: {style:'thin'},
                bottom: {style:'thin'},
                right: {style:'thin'}
            };
            worksheet.getRow(number).alignment = { 
                vertical: 'middle',
                horizontal: 'center',
                wrapText: true 
            };
            worksheet.getRow(number).font = {
                name: 'Times New Roman',
                family: 4, size: 10,
                underline: false,
                bold: false ,
                italic: false
            };
        };
        
        worksheet.getRow(2).border = {
            bottom: {style:'thin'}
        };
        worksheet.getRow(5).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
        worksheet.getRow(5).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };
        this.helperFunctions.excel.save(workbook, 'Заявки', this.hidePagePreloader);
    },
    setFiltersValue:function(message) {

        this.filtersValues = [];
        this.filtersValuesMacros = [];
        var elem = message.package.value.values;
        elem.forEach( elem => { 
            if( elem.value == true){
                // this.createObj( elem.name, 0, elem.value); 
                this.createObjMacros( elem.name, '=', 'true'); 
            }
            if(elem.value != ''){
                if( elem.value == null ){
                    // done --->>>
                    filterValue = null;
                }else{
                    if( elem.value.length > 0 ){
                        // this.createObj( elem.name, 6, elem.value); 
                        this.createObjMacros( elem.name, 'like', elem.value); 
                    }
                    if( elem.value.value){
                        if( Number.isInteger(elem.value.value)){
                            this.createObjMacros( elem.name, '==', elem.value.value); 
                        }else{
                            this.createObjMacros( elem.name, '=', elem.value.value); 
                        }
                        // this.createObj( elem.name, 0, elem.value.value); 
                    }else{
                        if( elem.value.dateFrom != undefined  && elem.value.dateFrom != ''){
                            // this.createObj(elem.name+'_from', 1, checkDateFrom(elem.value));
                            this.createObjMacros(elem.name, '>=', checkDateFrom(elem.value));
                        }
                        if( elem.value.dateTo != undefined  && elem.value.dateTo != ''){
                            // this.createObj(elem.name+'_to', 2, checkDateTo(elem.value));
                            this.createObjMacros(elem.name, '<=', checkDateTo(elem.value));
                        }
                    } 
                }
            }
        });
        function checkDateFrom(val){
            return val ? val.dateFrom : null;
        };
        function checkDateTo(val){
            return val ? val.dateTo : null;
        };
    },
    findAllCheckedFilter: function(){
        let filters = this.filtersValuesMacros;
        if( filters.length > 0 ){
            
            this.textFilterMacros = [];
            filters.forEach( function(el){
              this.createFilterMacros( el.code, el.operation, el.value);
            }.bind(this));
            
            let arr = this.textFilterMacros;
            let str = arr.join(' ');
            let macrosValue = str.slice(0, -4);
            console.log(macrosValue);
            this.macrosValue = macrosValue;
            this.messageService.publish( { 
                name: 'filters',
                value: this.filtersValuesMacros
            });
            
            this.config.query.parameterValues = [ {  key: '@param1', value: macrosValue } ];
            this.loadData(this.afterLoadDataHandler);
        }else{
            this.config.query.parameterValues = [{ key: '@param1', value: '1=1'}];
            this.loadData(this.afterLoadDataHandler);
            
            this.messageService.publish( { 
                name: 'filters',
                value: this.filtersValuesMacros
            });
        }
    },
    createFilterMacros: function(code, operation, value){
        if( operation == 'like' ){
            var textMacros = ""+code+" "+operation+" '%"+value+"%' and";
        }else if(  operation == '=='){
            var textMacros = ""+code+" "+'='+" "+value+" and";
        }else if(  operation == '='){
            var textMacros = ""+code+" "+operation+" N'"+value+"' and";
        }else if( operation == '>=' || operation == '<=' ){
            
            let currentDate = value;
            let year = currentDate.getFullYear();
            let month = currentDate.getMonth();
            let date = currentDate.getDate();
            
            let monthStr = month.toString();
            if(monthStr.length == 1 ){
                month = '0'+monthStr;
            }
            let dateStr = date.toString()
            if(dateStr.length == 1 ){
                date = '0'+dateStr;
            }
            value = ''+year+'-'+month+'-'+date+''; 
            var textMacros = ""+code+" "+operation+" N'"+value+"' and";
        }
        this.textFilterMacros.push(textMacros);
    },
    setFilterColumns: function(code, operation, value) {
        const filter = {
                key: code,
                value: {
                    operation: operation,
                    not: false,
                    values: value
                }
            };
        this.config.query.filterColumns.push(filter);
    },
    reloadTable: function(message){
        this.config.columns = [];
        
        this.config.columns = [
            {
                dataField: 'question_registration_number',
                caption: 'Номер питання',
                width: 120
            }, {
                dataField: 'question_question_type',
                caption: 'Тип питання', 
                width: 250
            }, {
                dataField: 'zayavnyk_full_name',
                caption: 'ПІБ Заявника',
                width: 250               
            }, {
                dataField: 'zayavnyk_building_number',
                caption: 'Будинок',
                width: 250               
            }, {
                dataField: 'zayavnyk_flat',
                caption: 'Квартира',
                width: 60               
            }, {
                dataField: 'question_object',
                caption: "Об'єкт",
                width: 250               
            }, {
                dataField: 'assigm_executor_organization',
                caption: 'Виконавець',
                width: 100               
            }, {
                dataField: 'registration_date',
                caption: 'Поступило',
                width: 100               
            }
        ]
        message.value.forEach(function(el){
            let column = {
                dataField: el.displayValue,
                caption: el.caption,
                width: el.width
            }
            this.config.columns.push(column)
        }.bind(this));
        this.loadData(this.afterLoadDataHandler);
    },
    afterLoadDataHandler: function(data) {
        this.render();
        this.createCustomStyle();
    },
    createCustomStyle: function(){
        let elements = document.querySelectorAll('.dx-datagrid-export-button');
        elements.forEach( function(element){
            let spanElement = this.createElement('span', { className: 'dx-button-text', innerText: 'Excel'});
            element.firstElementChild.appendChild(spanElement);
        }.bind(this));
    },   
    createObj: function(name, operation, value ){
        let obj = {
            code: name,
            operation: operation,
            value: value
        }
        this.filtersValues.push(obj);
    },
    createButtons: function(e) {
            
        var toolbarItems = e.toolbarOptions.items;
        toolbarItems.push({
            widget: "dxButton", 
            options: { 
                icon: "exportxlsx",
                type: "default",
                text: "Excel",
                onClick: function(e) { 
                     this.exportToExcel();
                }.bind(this)
            },
            location: "after"
        });

        toolbarItems.push({
            widget: "dxButton", 
            options: { 
                icon: "preferences",
                type: "default",
                text: "Налаштування фiльтрiв",
                onClick: function(e) { 
                    this.messageService.publish( { name: 'clickOnFiltersBtn'});
                }.bind(this)
            },
            location: "after"
        });
    },
    createObjMacros: function(name, operation, value){
        let obj = {
            code: name,
            operation: operation,
            value: value
        }
        this.filtersValuesMacros.push(obj);
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
    destroy: function(){
        this.sub.unsubscribe();  
        this.sub1.unsubscribe();  
    },
};
}());
