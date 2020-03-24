(function() {
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
                    caption: 'Тип питання'
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
                    caption: 'Об\'єкт'
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
            columnResizingMode: 'widget',
            columnMinWidth: 50,
            columnAutoWidth: true,
            hoverStateEnabled: true,
            pager: {
                showPageSizeSelector: true,
                allowedPageSizes: [50, 100, 500]
            },
            paging: {
                pageSize: 50
            },
            sorting: {
                mode: 'multiple'
            },
            showBorders: false,
            showColumnLines: false,
            showRowLines: true,
            keyExpr: 'Id'
        },
        filtersValuesMacros: [],
        textFilterMacros: '',
        filterValueTypes: {
            Input: 'Input',
            Select: 'Select',
            MultiSelect: 'MultiSelect',
            Date: 'Date',
            Time: 'Time',
            DateTime: 'DateTime',
            CheckBox: 'CheckBox'
        },
        init: function() {
            this.dataGridInstance.height = window.innerHeight - 230;
            document.getElementById('poshuk_table_main').style.display = 'none';
            this.sub = this.messageService.subscribe('GlobalFilterChanged', this.setFiltersValue, this);
            this.sub1 = this.messageService.subscribe('ApplyGlobalFilters', this.findAllCheckedFilter, this);
            this.sub2 = this.messageService.subscribe('findFilterColumns', this.reloadTable, this);
            this.config.onToolbarPreparing = this.createButtons.bind(this);
            this.dataGridInstance.onCellClick.subscribe(function(e) {
                if(e.column) {
                    if(e.column.dataField === 'question_registration_number' && e.row !== undefined) {
                        window.open(String(
                            location.origin +
                            localStorage.getItem('VirtualPath') +
                            '/sections/Assignments/edit/' +
                            e.data.Id
                        ));
                    }
                }
            }.bind(this));
            this.config.onContentReady = this.afterRenderTable.bind(this);
        },
        createButtons: function(e) {
            let toolbarItems = e.toolbarOptions.items;
            toolbarItems.push({
                widget: 'dxButton',
                options: {
                    icon: 'exportxlsx',
                    type: 'default',
                    text: 'Excel',
                    onClick: function(e) {
                        e.event.stopImmediatePropagation();
                        this.exportToExcel();
                    }.bind(this)
                },
                location: 'after'
            });
            toolbarItems.push({
                widget: 'dxButton',
                options: {
                    icon: 'preferences',
                    type: 'default',
                    text: 'Налаштування фiльтрiв',
                    onClick: function(e) {
                        e.event.stopImmediatePropagation();
                        this.messageService.publish({ name: 'clickOnFiltersBtn'});
                    }.bind(this)
                },
                location: 'after'
            });
        },
        createElement: function(tag, props, ...children) {
            const element = document.createElement(tag);
            Object.keys(props).forEach(key => element[key] = props[key]);
            if(children.length > 0) {
                children.forEach(child =>{
                    element.appendChild(child);
                });
            } return element;
        },
        setFiltersValue:function(message) {
            this.dateValues = {
                registration_date_from: null,
                registration_date_to: null,
                registration_date_question_from: null,
                registration_date_question_to: null,
                transfer_date_from: null,
                transfer_date_to: null,
                state_changed_date_from: null,
                state_changed_date_to: null,
                state_changed_date_done_from: null,
                state_changed_date_done_to: null,
                execution_term_from: null,
                execution_term_to: null,
                control_date_from: null,
                control_date_to: null
            }
            this.applicantPhoneNumber = null;
            this.filtersValuesMacros = [];
            let filters = message.package.value.values;
            this.filtersLength = filters.length;
            this.filtersWithOutValues = 0;
            filters.forEach(filter => {
                if(filter.active === true) {
                    const type = filter.type;
                    const value = filter.value;
                    const name = filter.name;
                    const placeholder = filter.placeholder;
                    switch (type) {
                    case this.filterValueTypes.Input:
                        if(name === 'zayavnyk_phone_number') {
                            this.applicantPhoneNumber = value;
                        }
                        this.createObjMacros(name, 'like', value, placeholder, value.viewValue);
                        break;
                    case this.filterValueTypes.CheckBox:
                        this.createObjMacros(filter.name, '=', value, filter.placeholder);
                        break;
                    case this.filterValueTypes.DateTime:
                    case this.filterValueTypes.Date:
                        if(value.dateFrom !== '') {
                            const property = name + '_from';
                            this.setFilterDateValues(property, value.dateFrom);
                            this.setMacrosProps(name, '>=', value.dateFrom, placeholder, value.viewValue);
                        }
                        if(value.dateTo !== '') {
                            const property = name + '_to';
                            this.setFilterDateValues(property, value.dateTo);
                            this.setMacrosProps(name, '<=', value.dateTo, placeholder, value.viewValue);
                        }
                        break;
                    case this.filterValueTypes.MultiSelect:
                        if(name === 'zayavnyk_age') {
                            const age = [];
                            let ageSendViewValue = '';
                            value.forEach(filter => {
                                let values = filter.viewValue.split('-');
                                let ageValue = '(zayavnyk_age>=' + values[0] + ' and zayavnyk_age<=' + values[1] + ')';
                                age.push(ageValue);
                                ageSendViewValue = ageSendViewValue + ', ' + filter.viewValue;
                            });
                            ageSendViewValue = ageSendViewValue.slice(2, [ageSendViewValue.length]);
                            const ageSendValue = '(' + age.join(' or ') + ')';
                            this.createObjMacros(name, '===', ageSendValue, placeholder, ageSendViewValue);
                        }else{
                            let sumValue = '';
                            let sumViewValue = '';
                            if(value.length > 0) {
                                value.forEach(filter => {
                                    sumValue = sumValue + ', ' + filter.value;
                                    sumViewValue = sumViewValue + ', ' + filter.viewValue;
                                });
                            }
                            let numberSendValue = sumValue.slice(2, [sumValue.length]);
                            let numberSendViewValue = sumViewValue.slice(2, [sumViewValue.length]);
                            this.createObjMacros(name, 'in', numberSendValue, placeholder, numberSendViewValue);
                        }
                        break;
                    default:
                        break;
                    }
                }else if(filter.active === false) {
                    this.filtersWithOutValues += 1;
                }
            });
            this.filtersWithOutValues === this.filtersLength ? this.isSelected = false : this.isSelected = true;
        },
        setFilterDateValues: function(property, value) {
            this.dateValues[property] = value;
        },
        setMacrosProps: function(name, type, value, placeholder, viewValue) {
            this.createObjMacros(
                'cast(' + name + ' as datetime)',
                type,
                value,
                placeholder,
                viewValue
            );
        },
        createObjMacros: function(name, operation, value, placeholder, viewValue) {
            let obj = {
                code: name,
                operation: operation,
                value: value,
                placeholder: placeholder,
                viewValue: viewValue
            }
            this.filtersValuesMacros.push(obj);
        },
        findAllCheckedFilter: function() {
            this.isSelected === true ?
                document.getElementById('poshuk_table_main').style.display = 'block' :
                document.getElementById('poshuk_table_main').style.display = 'none';
            let filters = this.filtersValuesMacros;
            if(filters.length > 0 || this.applicantPhoneNumber !== null) {
                this.textFilterMacros = [];
                filters.forEach(el => {
                    this.createFilterMacros(el.code, el.operation, el.value);
                });
                let arr = this.textFilterMacros;
                let str = arr.join(' ');
                let macrosValue = str.slice(0, -4);
                this.macrosValue = macrosValue === '' ? '1=1' : macrosValue;
                this.sendMsgForSetFilterPanelState(false);
                this.config.query.parameterValues = [
                    { key: '@param1', value: this.macrosValue },
                    { key: '@registration_date_from', value: this.dateValues.registration_date_from },
                    { key: '@registration_date_to', value: this.dateValues.registration_date_to },
                    { key: '@registration_date_question_from', value: this.dateValues.registration_date_question_from },
                    { key: '@registration_date_question_to', value: this.dateValues.registration_date_question_to },
                    { key: '@transfer_date_from', value: this.dateValues.transfer_date_from },
                    { key: '@transfer_date_to', value: this.dateValues.transfer_date_to },
                    { key: '@state_changed_date_from', value: this.dateValues.state_changed_date_from },
                    { key: '@state_changed_date_to', value: this.dateValues.state_changed_date_to },
                    { key: '@state_changed_date_done_from', value: this.dateValues.state_changed_date_done_from },
                    { key: '@state_changed_date_done_to', value: this.dateValues.state_changed_date_done_to },
                    { key: '@execution_term_from', value: this.dateValues.execution_term_from },
                    { key: '@execution_term_to', value: this.dateValues.execution_term_to },
                    { key: '@control_date_from', value: this.dateValues.control_date_from },
                    { key: '@control_date_to', value: this.dateValues.control_date_to },
                    { key: '@zayavnyk_phone_number', value: this.applicantPhoneNumber }
                ];
                this.loadData(this.afterLoadDataHandler);
                this.messageService.publish({
                    name: 'filters',
                    value: this.filtersValuesMacros
                });
            } else{
                this.messageService.publish({
                    name: 'filters',
                    value: this.filtersValuesMacros
                });
            }
        },
        createFilterMacros: function(code, operation, value) {
            if(code !== 'zayavnyk_phone_number') {
                if(operation !== '>=' && operation !== '<=') {
                    let textMacros = '';
                    if(operation === 'like') {
                        textMacros = String(code) + ' ' + operation + ' \'%' + value + '%\' and';
                    }else if(operation === '===') {
                        textMacros = String(value) + ' and';
                    }else if(operation === '==') {
                        textMacros = String(code) + ' ' + '=' + ' ' + value + ' and';
                    }else if(operation === '+""+') {
                        textMacros = String(code) + ' in  (N\'' + value + '\' and';
                    }else if(operation === 'in') {
                        textMacros = String(code) + ' in (' + value + ') and';
                    }else if(operation === '=') {
                        textMacros = String(code) + ' ' + operation + ' N\'' + value + '\' and';
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
        reloadTable: function(message) {
            this.setConfigColumns();
            message.value.forEach(function(el) {
                let column;
                switch(el.displayValue) {
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
                            return this.setAppealsFilesCheckValue(cellInfo.value);
                        }.bind(this)
                    }
                    break;
                default:
                    column = {
                        dataField: el.displayValue,
                        caption: el.caption,
                        width: el.width
                    }
                    break;
                }
                this.config.columns.push(column);
            }.bind(this));
            this.loadData(this.afterLoadDataHandler);
        },
        setConfigColumns: function() {
            this.config.columns = [];
            this.config.columns = [
                {
                    dataField: 'question_registration_number',
                    caption: 'Номер питання',
                    width: 120
                }, {
                    dataField: 'question_question_type',
                    caption: 'Тип питання'
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
                    caption: 'Об\'єкт',
                    width: 250
                }, {
                    dataField: 'assigm_executor_organization',
                    caption: 'Виконавець',
                    width: 100 ,
                    dateType: undefined
                }, {
                    dataField: 'registration_date',
                    caption: 'Поступило',
                    width: 130,
                    dateType: 'datetime',
                    format: 'dd.MM.yyy HH.mm'
                }
            ]
        },
        afterLoadDataHandler: function(data) {
            this.render();
            this.messageService.publish({ name: 'dataLength', value: data.length});
        },
        afterRenderTable: function() {
            let elements = document.querySelectorAll('.dx-datagrid-export-button');
            elements = Array.from(elements);
            elements.forEach(element => {
                let spanElement = this.createElement('span', { className: 'dx-button-text', innerText: 'Excel'});
                element.firstElementChild.appendChild(spanElement);
            });
        },
        sendMsgForSetFilterPanelState: function(state) {
            const msg = {
                name: 'SetFilterPanelState',
                package: {
                    value: state
                }
            };
            this.messageService.publish(msg);
        },
        exportToExcel: function() {
            let exportQuery = {
                queryCode: this.config.query.code,
                limit: -1,
                parameterValues: [
                    { key: '@param1', value: this.macrosValue },
                    { key: '@registration_date_from', value: this.dateValues.registration_date_from },
                    { key: '@registration_date_to', value: this.dateValues.registration_date_to },
                    { key: '@registration_date_question_from', value: this.dateValues.registration_date_question_from },
                    { key: '@registration_date_question_to', value: this.dateValues.registration_date_question_to },
                    { key: '@transfer_date_from', value: this.dateValues.transfer_date_from },
                    { key: '@transfer_date_to', value: this.dateValues.transfer_date_to },
                    { key: '@state_changed_date_from', value: this.dateValues.state_changed_date_from },
                    { key: '@state_changed_date_to', value: this.dateValues.state_changed_date_to },
                    { key: '@state_changed_date_done_from', value: this.dateValues.state_changed_date_done_from },
                    { key: '@state_changed_date_done_to', value: this.dateValues.state_changed_date_done_to },
                    { key: '@execution_term_from', value: this.dateValues.execution_term_from },
                    { key: '@execution_term_to', value: this.dateValues.execution_term_to },
                    { key: '@control_date_from', value: this.dateValues.control_date_from },
                    { key: '@control_date_to', value: this.dateValues.control_date_to },
                    { key: '@zayavnyk_phone_number', value: this.applicantPhoneNumber },
                    { key: '@pageOffsetRows', value: 0},
                    { key: '@pageLimitRows', value: 10}
                ]
            };
            this.queryExecutor(exportQuery, this.myCreateExcel, this);
        },
        myCreateExcel: function(data) {
            if(data.rows.length > 0) {
                this.showPagePreloader('Зачекайте, формується документ');
                const workbook = this.createExcel();
                const worksheet = workbook.addWorksheet('Заявки', {
                    pageSetup:{
                        orientation: 'landscape',
                        fitToPage: false,
                        fitToWidth: true
                    }
                });
                this.excelFields = [];
                this.setExcelFields(data);
                this.setHeader(worksheet);
                this.setWorksheetStyle(worksheet);
                this.setExcelColumns(worksheet);
                this.setRowValues(data, worksheet);
                this.helperFunctions.excel.save(workbook, 'Заявки', this.hidePagePreloader);
            }
        },
        setHeader: function(worksheet) {
            let cellInfoCaption = worksheet.getCell('A1');
            cellInfoCaption.value = 'Інформація';
            let cellInfo = worksheet.getCell('A2');
            cellInfo.value = 'про звернення громадян, що надійшли до Контактного центру  міста Києва. Термін виконання …';
            let cellPeriod = worksheet.getCell('A3');
            cellPeriod.value = 'Період вводу з (включно) : дата з ' +
                this.changeDateTimeValues(this.dateValues.registration_date_from, true) +
                ' дата по ' +
                this.changeDateTimeValues(this.dateValues.registration_date_to, true) +
                ' (Розширений пошук).';
            let cellNumber = worksheet.getCell('A4');
            cellNumber.value = 'Реєстраційний № РДА …';
            worksheet.mergeCells('A1:F1');
            worksheet.mergeCells('A2:F2');
            worksheet.mergeCells('A3:F3');
        },
        setExcelFields: function(data) {
            this.config.columns.forEach(column => {
                let columnDataField = column.dataField;
                let columnCaption = column.caption;
                for (let i = 0; i < data.columns.length; i++) {
                    const dataColumnDataFiled = data.columns[i].code;
                    if(
                        columnDataField === dataColumnDataFiled
                    ) {
                        let obj = {
                            name: columnDataField,
                            index: i,
                            caption: columnCaption
                        }
                        this.excelFields.push(obj);
                    }
                }
            });
        },
        setExcelColumns: function(worksheet) {
            let captions = [];
            let columnsHeader = [];
            let otherColumns = [];
            let columnNumber = {
                key: 'number',
                width: 5
            }
            columnsHeader.push(columnNumber);
            let rowNumber = '№ з/п';
            captions.push(rowNumber);
            this.excelFields.forEach(field => {
                if(field.name === 'question_registration_number') {
                    let obj = {
                        key: 'registration_number',
                        width: 10,
                        height: 20
                    };
                    columnsHeader.push(obj);
                    captions.push('Номер, дата, час');
                }else if(field.name === 'zayavnyk_full_name') {
                    let obj = {
                        key: 'name',
                        width: 15
                    };
                    columnsHeader.push(obj);
                    captions.push('Заявник');
                }else if(field.name === 'question_question_type') {
                    let obj1 = {
                        key: 'question_type',
                        width: 10
                    };
                    columnsHeader.push(obj1);
                    captions.push('Тип питання');
                    let obj2 = {
                        key: 'assigm_question_content',
                        width: 62
                    };
                    columnsHeader.push(obj2);
                    captions.push('Суть питання');
                }else if(field.name === 'assigm_executor_organization') {
                    let obj = {
                        key: 'organization',
                        width: 11
                    };
                    columnsHeader.push(obj);
                    captions.push('Виконавець');
                }else if(field.name === 'question_object') {
                    let obj = {
                        key: 'object',
                        width: 16
                    };
                    columnsHeader.push(obj);
                    captions.push('Місце проблеми (Об\'єкт)');
                }else if(
                    field.name === 'registration_date' ||
                    field.name === 'zayavnyk_building_number' ||
                    field.name === 'zayavnyk_flat' ||
                    field.name === 'assigm_question_content'
                ) {
                    let obj = {
                        key: field.name,
                        width: 13
                    };
                    otherColumns.push(obj);
                }else{
                    let obj = {
                        key: field.name,
                        width: 13
                    };
                    columnsHeader.push(obj);
                    captions.push(field.caption);
                }
            });
            worksheet.getRow(5).values = captions;
            worksheet.columns = columnsHeader;
        },
        setWorksheetStyle: function(worksheet) {
            worksheet.getRow(1).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
            worksheet.getRow(1).alignment = { vertical: 'middle', horizontal: 'center' };
            worksheet.getRow(2).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
            worksheet.getRow(2).alignment = { vertical: 'middle', horizontal: 'center' };
            worksheet.getRow(3).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
            worksheet.getRow(3).alignment = { vertical: 'middle', horizontal: 'left' };
            worksheet.getRow(4).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
            worksheet.getRow(5).alignment = { vertical: 'middle', horizontal: 'left' };
            worksheet.pageSetup.margins = {
                left: 0.4, right: 0.3,
                top: 0.4, bottom: 0.4,
                header: 0.0, footer: 0.0
            };
            worksheet.getRow(2).border = {
                bottom: {style:'thin'}
            };
            worksheet.getRow(5).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
            worksheet.getRow(5).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };
        },
        setRowValues: function(data, worksheet) {
            let indexRegistrationDate = data.columns.findIndex(el => el.code.toLowerCase() === 'registration_date');
            let indexZayavnykFlat = data.columns.findIndex(el => el.code.toLowerCase() === 'zayavnyk_flat');
            let indexZayavnykFullName = data.columns.findIndex(el => el.code.toLowerCase() === 'zayavnyk_full_name');
            let indexZayavnykBuildingNumber = data.columns.findIndex(el => el.code.toLowerCase() === 'zayavnyk_building_number');
            let indexAssigmQuestionContent = data.columns.findIndex(el => el.code.toLowerCase() === 'assigm_question_content');
            let indexExecutionTerm = data.columns.findIndex(el => el.code.toLowerCase() === 'execution_term');
            let indexRegistrationNumber = data.columns.findIndex(el => el.code.toLowerCase() === 'question_registration_number');
            let indexQuestionType = data.columns.findIndex(el => el.code.toLowerCase() === 'question_question_type');
            let indexExecutorOrganization = data.columns.findIndex(el => el.code.toLowerCase() === 'assigm_executor_organization');
            let indexQuestionObject = data.columns.findIndex(el => el.code.toLowerCase() === 'question_object');
            let rows = [];
            for(let j = 0; j < data.rows.length; j++) {
                const row = data.rows[j];
                const rowItem = { number: j + 1 };
                const executionTerm = this.changeDateTimeValues(row.values[indexExecutionTerm], false);
                const regDate = this.changeDateTimeValues(row.values[indexRegistrationDate], false);
                rowItem.registration_number = row.values[indexRegistrationNumber] + ' ' + regDate;
                rowItem.name = row.values[indexZayavnykFullName] + ' ' +
                        row.values[indexZayavnykBuildingNumber] + ', кв. ' +
                        row.values[indexZayavnykFlat];
                rowItem.question_type = 'Тип питання: ' + row.values[indexQuestionType];
                rowItem.assigm_question_content = 'Зміст: ' + row.values[indexAssigmQuestionContent];
                rowItem.organization = row.values[indexExecutorOrganization] + '. Дату контролю: ' + executionTerm;
                rowItem.object = row.values[indexQuestionObject];
                for(let i = 0; i < this.excelFields.length; i++) {
                    const field = this.excelFields[i];
                    const prop = this.excelFields[i].name;
                    switch(prop) {
                        case 'appeals_user':
                        case 'appeals_receipt_source':
                        case 'appeals_district':
                        case 'zayavnyk_phone_number':
                        case 'zayavnyk_entrance':
                        case 'zayavnyk_applicant_privilage':
                        case 'zayavnyk_social_state':
                        case 'zayavnyk_sex':
                        case 'zayavnyk_applicant_type':
                        case 'zayavnyk_age':
                        case 'zayavnyk_email':
                        case 'question_ObjectTypes':
                        case 'question_organization':
                        case 'question_question_state':
                        case 'question_list_state':
                        case 'assigm_main_executor':
                        case 'assigm_accountable':
                        case 'assigm_assignment_state':
                        case 'assigm_assignment_result':
                        case 'assigm_assignment_resolution':
                        case 'assigm_user_reviewed':
                        case 'assigm_user_checked':
                        case 'appeals_enter_number':
                        case 'control_comment':
                        case 'ConsDocumentContent':
                            rowItem[prop] = row.values[field.index];
                            break
                        case 'transfer_date':
                        case 'state_changed_date':
                        case 'state_changed_date_done':
                        case 'execution_term':
                        case 'control_date':
                            rowItem[prop] = this.changeDateTimeValues(row.values[field.index], false);
                            break
                        case 'appeals_files_check':
                            rowItem[prop] = this.setAppealsFilesCheckValue(row.values[field.index]);
                            break
                        default:
                            break
                    }
                }
                rows.push(rowItem);
            }
            rows.forEach(row => {
                worksheet.addRow(row);
            });
            this.setRowCellStyle(worksheet, rows);
        },
        setRowCellStyle: function(worksheet, rows) {
            for(let i = 0; i < rows.length + 1; i++) {
                let number = i + 5;
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
            }
        },
        setAppealsFilesCheckValue: function(value) {
            return value === 'false' ? 'Відсутній' : 'Наявний';
        },
        changeDateTimeValues: function(value, caption) {
            if(value === null) {
                return ' '
            }
            let date = undefined;
            if(caption) {
                date = new Date(value);
            } else {
                const dateValue = value + '+0000';
                date = new Date(Date.parse(dateValue));
            }
            let dd = date.getDate().toString();
            let mm = (date.getMonth() + 1).toString();
            let yyyy = date.getFullYear().toString();
            let HH = date.getHours().toString();
            let MM = date.getMinutes().toString();
            dd = dd.length === 1 ? '0' + dd : dd;
            mm = mm.length === 1 ? '0' + mm : mm;
            HH = HH.length === 1 ? '0' + HH : HH;
            MM = MM.length === 1 ? '0' + MM : MM;
            return dd + '.' + mm + '.' + yyyy + ' ' + HH + ':' + MM;
        },
        destroy: function() {
            this.sub.unsubscribe();
            this.sub1.unsubscribe();
            this.sub2.unsubscribe();
        }
    };
}());
