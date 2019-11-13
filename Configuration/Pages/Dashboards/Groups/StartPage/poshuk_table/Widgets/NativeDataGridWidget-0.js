(function () {
  return {
    config: {
        query: {
            code: 'ak_QueryCodeSearch',
            parameterValues: [{ key: '@param1', value: '1=1'}],
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
                caption: 'Поступило',
                dateType: 'datetime',
                format: 'dd.MM.yyy HH.mm'
            }
        ],
        focusedRowEnabled: true,
        allowColumnResizing: true,
        columnResizingMode: "widget",
        columnMinWidth: 50,
        columnAutoWidth: true,
        hoverStateEnabled: true,
        pager: {
            showPageSizeSelector: true,
            allowedPageSizes: [50, 100, 500],
        },
        paging: {
            pageSize: 50
        },
        sorting: {
            mode: "multiple"
        },        
        showBorders: false,
        showColumnLines: false,
        showRowLines: true,
        keyExpr: 'Id',
    },
    createButtons: function(e) {
        let toolbarItems = e.toolbarOptions.items;

        toolbarItems.push({
            widget: "dxButton", 
            options: { 
                icon: "exportxlsx",
                type: "default",
                text: "Excel",
                onClick: function(e) {
                    e.event.stopImmediatePropagation();
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
                    e.event.stopImmediatePropagation();
                    this.messageService.publish( { name: 'clickOnFiltersBtn'});
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
    filtersValuesMacros: [],
    textFilterMacros: '',
    init: function() {
        this.dataGridInstance.height = window.innerHeight - 230;
        document.getElementById('poshuk_table_main').style.display = 'none';
        
        this.sub = this.messageService.subscribe( 'GlobalFilterChanged', this.setFiltersValue, this );
        this.sub1 = this.messageService.subscribe( 'ApplyGlobalFilters', this.findAllCheckedFilter, this );
        this.sub2 = this.messageService.subscribe( 'findFilterColumns', this.reloadTable, this );
        this.config.onToolbarPreparing = this.createButtons.bind(this);
        
        this.dataGridInstance.onCellClick.subscribe( function(e) {
            if(e.column){
                if(e.column.dataField == "question_registration_number" && e.row != undefined){
                    window.open(location.origin + localStorage.getItem('VirtualPath') + "/sections/Assignments/edit/"+e.data.Id+"");
                }
            }
        }.bind(this));
        this.config.onContentReady = this.afterRenderTable.bind(this);
    },
    setFiltersValue:function(message) {
        
        this.registrationDateFrom = null;
        this.registrationDateTo = null;
        this.transferDateFrom = null;
        this.transferDateTo  = null;
        this.stateChangedDateFrom = null;
        this.stateChangedDateTo = null;
        this.stateChangedDateDoneFrom = null;
        this.stateChangedDateDoneTo = null;
        this.executionTermFrom = null;
        this.executionTermTo = null;
        this.controlDateFrom = null;
        this.controlDateTo = null;
        this.applicantPhoneNumber = null;
        
        this.filtersValuesMacros = [];
        let filters = message.package.value.values;
        this.filtersLength = filters.length;
        this.filtersWithOutValues = 0;
        
        filters.forEach( elem => {
            if(elem.active === true){
                let data = elem.value;
                if(typeof(data) === "boolean"){
                    this.createObjMacros( elem.name, '=', 'true', elem.placeholder);
                }else if( typeof(data) === "object"){
                    if(data[0]){
                        if(typeof(data[0].value) === 'number' ){
                            if(  elem.name === 'zayavnyk_age' ){
                                this.ageArr = [];
                                let ageSendViewValue = '';
                                data.forEach( el => {
                                    let values = el.viewValue.split('-');
                                    let ageValue = '(zayavnyk_age>='+values[0]+' and zayavnyk_age<='+values[1]+')';
                                    this.ageArr.push(ageValue);
                                    
                                    ageSendViewValue = ageSendViewValue + ', '+ el.viewValue;
                                });
                                ageSendViewValue = ageSendViewValue.slice(2, [ageSendViewValue.length]);
                                let ageSendValue =  this.ageArr.join(' or '); 
                                ageSendValue = '('+ageSendValue+')';
                                this.createObjMacros( elem.name, '===', ageSendValue, elem.placeholder, ageSendViewValue);
                            }else{
                                let sumValue = '';
                                let sumViewValue = '';
                                if(data.length > 0){
                                    data.forEach( row => { 
                                        sumValue =  sumValue + ', '+ row.value;
                                        sumViewValue =  sumViewValue + ', '+ row.viewValue;
                                    });
                                }
                                let numberSendValue = sumValue.slice(2, [sumValue.length]);
                                let numberSendViewValue = sumViewValue.slice(2, [sumViewValue.length]);
                                this.createObjMacros( elem.name, 'in', numberSendValue, elem.placeholder, numberSendViewValue); 
                            }
                        }else if(typeof(data[0].value) === 'string' ){
                            let stringSumValue = '';
                            let stringSumViewValue = '';
                            if(data.length > 0){
                                data.forEach( row => { 
                                    stringSumValue =  stringSumValue + ', \''+ row.value + '\'';
                                    stringSumViewValue =  stringSumViewValue + ', '+ row.viewValue;
                                });
                            }
                            let stringSendValue = stringSumValue.slice(2, [stringSumValue.length]);
                            let stringSendViewValue = stringSumViewValue.slice(2, [stringSumViewValue.length]);
                            this.createObjMacros( elem.name, 'in', stringSendValue, elem.placeholder, stringSendViewValue); 
                        }
                    }else{
                        if(data.dateFrom != '' ){
                            this.createObjMacros('cast('+elem.name+' as datetime)', '>=', checkDateFrom(elem.value), elem.placeholder, elem.value.viewValue);
                            switch(elem.name){
                                case 'registration_date':
                                    this.registrationDate__from = checkDateFrom(elem.value);
                                    this.registrationDateFrom = checkDateFrom(elem.value);
                                    break;
                                case 'transfer_date':
                                    this.transferDateFrom = checkDateFrom(elem.value);
                                    break;
                                case 'state_changed_date':
                                    this.stateChangedDateFrom = checkDateFrom(elem.value);
                                    break;
                                case 'state_changed_date_done':
                                    this.stateChangedDateDoneFrom = checkDateFrom(elem.value);
                                    break;
                                case 'execution_term':
                                    this.executionTermFrom = checkDateFrom(elem.value);
                                    break;
                                        
                                case 'control_date':
                                    this.controlDateFrom = checkDateFrom(elem.value);
                                    break;
                                        
                            }
                        }
                        if(data.dateTo != '' ){
                            this.createObjMacros('cast('+elem.name+' as datetime)', '<=', checkDateTo(elem.value), elem.placeholder, elem.value.viewValue);
                            switch(elem.name){
                                case 'registration_date':
                                    this.registrationDateTo = checkDateTo(elem.value);
                                    break;
                                case 'transfer_date':
                                    this.transferDateTo = checkDateTo(elem.value);
                                    break;
                                case 'state_changed_date':
                                    this.stateChangedDateTo = checkDateTo(elem.value);
                                    break;
                                case 'state_changed_date_done':
                                    this.stateChangedDateDoneTo = checkDateTo(elem.value);
                                    break;
                                case 'execution_term':
                                    this.executionTermTo = checkDateTo(elem.value);
                                    break;
                                case 'control_date':
                                    this.controlDateTo = checkDateTo(elem.value);
                                    break;
                            }
                        }
                    }
                }else if( typeof(data) === "string"){
                    if(elem.name === 'zayavnyk_phone_number'){
                        this.applicantPhoneNumber = elem.value;
                        this.createObjMacros( elem.name, 'like', elem.value, elem.placeholder, elem.value.viewValue );
                    }else{
                        this.createObjMacros( elem.name, 'like', elem.value, elem.placeholder, elem.value.viewValue );
                    }

                }
            }else if(elem.active === false){
                this.filtersWithOutValues += 1;
            }
        });
        function checkDateFrom(val){
            return val ? val.dateFrom : null;
        };
        function checkDateTo(val){
            return val ? val.dateTo : null;
        };
        this.filtersWithOutValues === this.filtersLength ?  this.isSelected = false   : this.isSelected = true; 
    },
    createObjMacros: function(name, operation, value, placeholder, viewValue){
        let obj = {
            code: name,
            operation: operation,
            value: value,
            placeholder: placeholder,
            viewValue: viewValue
        }
        this.filtersValuesMacros.push(obj);
    },
    findAllCheckedFilter: function(){
        this.isSelected === true ? document.getElementById('poshuk_table_main').style.display = 'block' : document.getElementById('poshuk_table_main').style.display = 'none' ;
        let filters = this.filtersValuesMacros;
        if( filters.length > 0 || this.applicantPhoneNumber !== null ){
            
            this.textFilterMacros = [];
            filters.forEach( el => {
                this.createFilterMacros( el.code, el.operation, el.value);
            });
            let arr = this.textFilterMacros;
            let str = arr.join(' ');
            let macrosValue = str.slice(0, -4);
            this.macrosValue = macrosValue === '' ?  '1=1' : macrosValue;
            
            this.sendMsgForSetFilterPanelState(false);
            this.config.query.parameterValues = [
                {  key: '@param1', value: this.macrosValue }, 
                {  key: '@registration_date_from', value: this.registrationDateFrom }, 
                {  key: '@registration_date_to', value: this.registrationDateTo },
                {  key: '@transfer_date_from', value: this.transferDateFrom }, 
                {  key: '@transfer_date_to', value: this.transferDateTo },
                {  key: '@state_changed_date_from', value: this.stateChangedDateFrom }, 
                {  key: '@state_changed_date_to', value: this.stateChangedDateTo },
                {  key: '@state_changed_date_done_from', value: this.stateChangedDateDoneFrom }, 
                {  key: '@state_changed_date_done_to', value: this.stateChangedDateDoneTo },
                {  key: '@execution_term_from', value: this.executionTermFrom }, 
                {  key: '@execution_term_to', value: this.executionTermTo },
                {  key: '@control_date_from', value: this.controlDateFrom }, 
                {  key: '@control_date_to', value: this.controlDateTo },
                {  key: '@zayavnyk_phone_number', value: this.applicantPhoneNumber },
                
            ];
            this.loadData(this.afterLoadDataHandler);
            this.messageService.publish( { 
                name: 'filters',
                value: this.filtersValuesMacros
            });    
        }
        else{
            this.messageService.publish( { 
                name: 'filters',
                value: this.filtersValuesMacros
            });        
        }
    },

    createFilterMacros: function(code, operation, value){
        if(code !==  'zayavnyk_phone_number' ){
            if( operation !== '>=' && operation !== '<=' ){
                let textMacros = '';
                if( operation == 'like' ){
                    textMacros = ""+code+" "+operation+" '%"+value+"%' and";
                }else if(  operation == '==='){
                    textMacros = ""+value+" and";
                }else if(  operation == '=='){
                    textMacros = ""+code+" "+'='+" "+value+" and";
                }else if(  operation == '+""+'){
                    textMacros = ""+code+" in  (N'"+value+"' and";
                }else if(  operation == 'in'){
                    textMacros = ""+code+" in ("+value+") and";
                }else if(  operation == '='){
                    textMacros = ""+code+" "+operation+" N'"+value+"' and";
                }
                this.textFilterMacros.push(textMacros);
            }
        }   
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
                width: 100 ,
                dateType: undefined,
            }, {
                dataField: 'registration_date',
                caption: 'Поступило',
                width: 130,
                dateType: 'datetime',
                format: 'dd.MM.yyy HH.mm'                
            }
        ]
        message.value.forEach(function(el){
            let column;
            switch(el.displayValue){
                case 'transfer_date':
                case 'state_changed_date':
                case 'state_changed_date_done':
                    column = {
                        dataField: el.displayValue,
                        caption: el.caption,
                        width: 130,
                        dateType: 'datetime',
                        format: 'dd.MM.yyy HH.mm'                         
                        
                    }
                    break;
                case 'appeals_files_check':
                    column = {
                        dataField: el.displayValue,
                        caption: el.caption,
                        width: el.width,
                        customizeText: function(cellInfo) {
                            let value = cellInfo.value === undefined ? ' ' : cellInfo.value === 'true' ? 'Наявний' : 'Відсутній' ;
                            return value;
                        }
                    }
                    break;
                default:
                    column = {
                        dataField: el.displayValue,
                        caption: el.caption,
                        width: el.width,
                        
                    }
                    break;
            }
            this.config.columns.push(column);
        }.bind(this));
        this.loadData(this.afterLoadDataHandler);
    },
    afterLoadDataHandler: function(data) {
        this.render();
        this.messageService.publish({ name: 'dataLength', value: data.length});
    },
    afterRenderTable: function(){
        let elements = document.querySelectorAll('.dx-datagrid-export-button');
        elements = Array.from(elements);
        elements.forEach( function(element){
            let spanElement = this.createElement('span', { className: 'dx-button-text', innerText: 'Excel'});
            element.firstElementChild.appendChild(spanElement);
        }.bind(this));
    },
    sendMsgForSetFilterPanelState: function(state) {
        const msg = {
            name: "SetFilterPanelState",
            package: {
                value: state
            }
        };
        this.messageService.publish(msg);
    },
    exportToExcel: function(){
        let value =  this.macrosValue ? this.macrosValue :  '1=1';
        
        let exportQuery = {
            queryCode: 'ak_QueryCodeSearch',
            limit: -1,
            parameterValues: [
                {  key: '@param1', value: this.macrosValue }, 
                {  key: '@registration_date_from', value: this.registrationDateFrom }, 
                {  key: '@registration_date_to', value: this.registrationDateTo },
                {  key: '@transfer_date_from', value: this.transferDateFrom }, 
                {  key: '@transfer_date_to', value: this.transferDateTo },
                {  key: '@state_changed_date_from', value: this.stateChangedDateFrom }, 
                {  key: '@state_changed_date_to', value: this.stateChangedDateTo },
                {  key: '@state_changed_date_done_from', value: this.stateChangedDateDoneFrom }, 
                {  key: '@state_changed_date_done_to', value: this.stateChangedDateDoneTo },
                {  key: '@execution_term_from', value: this.executionTermFrom }, 
                {  key: '@execution_term_to', value: this.executionTermTo },
                {  key: '@zayavnyk_phone_number', value: this.applicantPhoneNumber },
                {  key: '@control_date_from', value: this.controlDateFrom }, 
                {  key: '@control_date_to', value: this.controlDateTo },
                { key: '@pageOffsetRows', value: 0},
                { key: '@pageLimitRows', value: 10}
                ]
        };
        this.queryExecutor(exportQuery, this.myCreateExcel, this);
    },
    myCreateExcel: function(data){
        console.log(data)
        if( data.rows.length > 0 ){    
            this.showPagePreloader('Зачекайте, формується документ');
            this.indexArr = [];
            let columns = this.config.columns;columns.forEach( el => {
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
                pageSetup:{orientation: 'landscape', fitToPage: false, fitToWidth: true}
            });
            
            /*TITLE*/
            let cellInfoCaption = worksheet.getCell('A1');
            cellInfoCaption.value = 'Інформація';
            let cellInfo = worksheet.getCell('A2');
            cellInfo.value = 'про звернення громадян, що надійшли до Контактного центру  міста Києва. Термін виконання …';
            let cellPeriod = worksheet.getCell('A3');
            cellPeriod.value = 'Період вводу з (включно) : дата з ' +this.changeDateTimeValues(this.registrationDateFrom)+ ' дата по ' +this.changeDateTimeValues(this.registrationDateTo)+ ' (Розширений пошук).';
            let cellNumber = worksheet.getCell('A4');
            cellNumber.value = 'Реєстраційний № РДА …';
            worksheet.mergeCells('A1:F1'); 
            worksheet.mergeCells('A2:F2'); 
            worksheet.mergeCells('A3:F3');
            
            worksheet.getRow(1).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
            worksheet.getRow(1).alignment = { vertical: 'middle', horizontal: 'center' };
            worksheet.getRow(2).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
            worksheet.getRow(2).alignment = { vertical: 'middle', horizontal: 'center' };
            
            worksheet.getRow(3).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
            worksheet.getRow(3).alignment = { vertical: 'middle', horizontal: 'left' };
            worksheet.getRow(4).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
            worksheet.getRow(5).alignment = { vertical: 'middle', horizontal: 'left' };
            
         
            let indexArr = this.indexArr;
            let rows = [];
            let captions = [];
            let columnsHeader = [];
            let columnNumber = {
                key: 'number',
                width: 5
            }
            columnsHeader.push(columnNumber);
            let rowNumber = '№ з/п';
            captions.push(rowNumber);
            indexArr.forEach( el => {
                    if( el.name === 'question_registration_number'  ){
                        let obj =  {
                            key: 'registration_number',
                            width: 10,
                            height: 20
                        };
                        columnsHeader.push(obj);
                        captions.push('Номер, дата, час');
                    }else if(el.name === 'zayavnyk_full_name' ){
                        let obj =  {
                            key: 'name',
                            width: 15
                        };
                        columnsHeader.push(obj);
                        captions.push('Заявник');
                    }else if(el.name === 'question_question_type' ){
                        let obj =  { 
                            key: 'question_type',
                            width: 62
                        };
                        columnsHeader.push(obj);
                        captions.push('Суть питання');
                    }else if( el.name === 'assigm_executor_organization'  ){
                        let obj =  { 
                            key: 'organization',
                            width: 16
                        };
                        columnsHeader.push(obj);
                        captions.push('Виконавець');
                    }else if( el.name === 'question_object'  ){
                        let obj =  { 
                            key: 'object',
                            width: 21
                        };
                        columnsHeader.push(obj);
                        captions.push('Місце проблеми (Об\'єкт)');
                    }else if( el.name === 'registration_date' || el.name === 'zayavnyk_building_number' || el.name === 'zayavnyk_flat' || el.name === 'assigm_question_content'  ){
                    }else{
                        let obj =  { 
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
            
            
            let indexRegistrationDate = data.columns.findIndex(el => el.code.toLowerCase() === 'registration_date' );
            let indexZayavnykFlat = data.columns.findIndex(el => el.code.toLowerCase() === 'zayavnyk_flat' );
            let indexZayavnykBuildingNumber = data.columns.findIndex(el => el.code.toLowerCase() === 'zayavnyk_building_number' );
            let indexAssigmQuestionContent = data.columns.findIndex(el => el.code.toLowerCase() === 'assigm_question_content' );
            let indexExecutionTerm = data.columns.findIndex(el => el.code.toLowerCase() === 'execution_term' );
            
            for( let  j = 0; j < data.rows.length; j ++ ){  
                let row = data.rows[j];
                let rowArr = [];
                let rowItem = { number: j + 1 };
                
                for( i = 0; i < indexArr.length; i ++){
                    let el = indexArr[i];

                    let cdValue = this.changeDateTimeValues(row.values[indexExecutionTerm])
                    let rdValue = this.changeDateTimeValues(row.values[indexRegistrationDate])
                    if( el.name === 'question_registration_number'  ){
                        rowItem.registration_number = row.values[el.index] + ' ' + rdValue;
                    }else if(el.name === 'zayavnyk_full_name' ){
                        rowItem.name = row.values[el.index] + ' ' + row.values[indexZayavnykBuildingNumber] + ', кв. ' +  row.values[indexZayavnykFlat];
                    }else if(el.name === 'question_question_type' ){
                        rowItem.question_type = 'Зміст: ' + row.values[indexAssigmQuestionContent];
                    }else if( el.name === 'assigm_executor_organization'  ){
                        rowItem.organization = row.values[el.index] + '. Дату контролю: ' + cdValue;
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
                                rowItem.transfer_date = this.changeDateTimeValues(row.values[el.index]);
                                break
                            case 'state_changed_date':
                                rowItem.state_changed_date = this.changeDateTimeValues(row.values[el.index]);
                                break
                            case 'state_changed_date_done':
                                rowItem.state_changed_date_done = this.changeDateTimeValues(row.values[el.index]);
                                break
                            case 'execution_term':
                                rowItem.execution_term = this.changeDateTimeValues(row.values[el.index]);
                                break
                            case 'appeals_enter_number':
                                rowItem.appeals_enter_number = row.values[el.index];
                                break
                            case 'control_comment':
                                rowItem.control_comment = row.values[el.index];
                                break
                            case 'control_date':
                                rowItem.control_date = this.changeDateTimeValues(row.values[el.index]);
                                break
                        };
                        this.addetedIndexes.push(prop);
                    }
                };
                rows.push( rowItem );
            };
            rows.forEach( el => {
                let number = el.number + '.'
                let row = {
                    number: number,
                    name: el.name,
                    registration_number: el.registration_number,
                    organization: el.organization,
                    question_type: el.question_type,
                    object: el.object
                }
                let indexes = this.addetedIndexes;
                let size = Object.keys(el).length;
                for( i = 0; i < size - 6 ; i ++ ){
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
                        case 'appeals_enter_number':
                            row.appeals_enter_number = el.appeals_enter_number;
                            break   
                        case 'control_comment':
                            row.control_comment = el.control_comment;
                            break  
                        case 'control_date':
                            row.control_date = el.control_date;
                            break     
                            
                    };
                }
                worksheet.addRow(row);
            });
            
            worksheet.pageSetup.margins = {
                left: 0.4, right: 0.3,
                top: 0.4, bottom: 0.4,
                header: 0.0, footer: 0.0
            };
            for(let  i = 0; i < rows.length + 1; i++ ){
                let number = i + 5 ;
                let row = worksheet.getRow(number);
                row.height = 100;
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
            worksheet.getRow(5).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true  };
            this.helperFunctions.excel.save(workbook, 'Заявки', this.hidePagePreloader);
        }    
    },
    changeDateTimeValues: function(value){
        let trueDate = ' ';
        if( value !== null){
            let date = new Date(value);
            let dd = date.getDate();
            let MM = date.getMonth();
            let yyyy = date.getFullYear();
            let HH = date.getUTCHours()
            let mm = date.getMinutes();
            MM += 1 ;
            if( (dd.toString()).length === 1){  dd = '0' + dd; }
            if( (MM.toString()).length === 1){ MM = '0' + MM ; }
            if( (HH.toString()).length === 1){  HH = '0' + HH; }
            if( (mm.toString()).length === 1){ mm = '0' + mm; }
            trueDate = dd+'.'+MM+'.' + yyyy;
        }
        return trueDate;
    },
    destroy: function(){
        this.sub.unsubscribe();  
        this.sub1.unsubscribe();  
        this.sub2.unsubscribe();  
    },
};
}());
