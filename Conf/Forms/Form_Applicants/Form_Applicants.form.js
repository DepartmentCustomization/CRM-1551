(function() {
    return {
        Detail_History: function(column, row) {
            const parameters = [
                { key: '@history_id', value: row.values[0] }
            ];
            this.details.loadData('ApplicantHistory_details', parameters);
            this.details.setVisibility('ApplicantHistory_details', true);
        },
        date_in_form: '',
        previous_result: '',
        onLoadModalPhone: function() {
            this.modal_phone_NEW = null;
            const queryForGetValue22 = {
                queryCode: 'GetApplicantPhonesForApplicantId',
                parameterValues: [{ key: '@applicant_id', value: this.form.getControlValue('Id') }]
            };
            this.queryExecutor.getValues(queryForGetValue22).subscribe(function(data) {
                this.kolvoPhonesForApplicant = data.rows.length - 1;
                if (data.rows.length > 0) {
                    const fieldsForm = {
                        title: 'Телефони заявника',
                        acceptBtnText: 'save',
                        cancelBtnText: 'exit',
                        singleButton: false,
                        fieldGroups: []
                    };
                    for (let j = 0; j < data.rows.length; j++) {
                        if (data.rows[j].values[5] == 1) {
                            let p = {
                                code: 'GroupPhone' + j,
                                name: 'Створення телефону',
                                expand: true,
                                position: data.rows[j].values[0],
                                fields: []
                            };
                            fieldsForm.fieldGroups.push(p);
                            let c = fieldsForm.fieldGroups.length - 1;
                            let t = {
                                code: data.rows[j].values[1],
                                fullScreen: true,
                                hidden: false,
                                placeholder: data.rows[j].values[2],
                                position: 1,
                                required: false,
                                value: data.rows[j].values[3],
                                disabled: true,
                                type: 'text',
                                icon: 'phone_forwarded',
                                iconHint: 'Скопіювати з вхідного номера телефону',
                                maxlength: 14,
                                width: '50%'
                            };
                            fieldsForm.fieldGroups[c].fields.push(t);
                            let t0_0 = {
                                code: data.rows[j].values[1] + '_phoneType',
                                fullScreen: true,
                                hidden: false,
                                placeholder: 'Тип',
                                position: 2,
                                required: false,
                                value: 'Мобільний',
                                keyValue: 1,
                                listKeyColumn: 'Id',
                                listDisplayColumn: 'name',
                                type: 'select',
                                queryListCode: 'dir_PhoneTypes_SelectRows',
                                width: '50%'
                            };
                            fieldsForm.fieldGroups[c].fields.push(t0_0);
                            let t0_2 = {
                                code: data.rows[j].values[1] + '_phoneIsMain',
                                fullScreen: true,
                                hidden: false,
                                placeholder: 'Основний?',
                                position: 3,
                                required: false,
                                value: false,
                                type: 'checkbox',
                                width: '50%'
                            };
                            fieldsForm.fieldGroups[c].fields.push(t0_2);
                            let t0_1 = {
                                code: data.rows[j].values[1] + '_phoneDelete',
                                fullScreen: true,
                                hidden: false,
                                placeholder: 'Додати',
                                position: 4,
                                icon: 'add',
                                required: false,
                                type: 'button',
                                width: '50%'
                            };
                            fieldsForm.fieldGroups[c].fields.push(t0_1);
                        } else {
                            let p1 = {
                                code: 'GroupPhone' + j,
                                name: data.rows[j].values[2],
                                expand: true,
                                position: data.rows[j].values[0],
                                fields: []
                            };
                            fieldsForm.fieldGroups.push(p1);
                            let c1 = fieldsForm.fieldGroups.length - 1;
                            let t1_0 = {
                                code: data.rows[j].values[1] + '_phoneNumber',
                                fullScreen: true,
                                hidden: false,
                                placeholder: 'Номер телефону',
                                position: 1,
                                required: false,
                                value: data.rows[j].values[3],
                                type: 'text',
                                maxlength: 14,
                                width: '50%'
                            };
                            fieldsForm.fieldGroups[c1].fields.push(t1_0);
                            let t1_1 = {
                                code: data.rows[j].values[1] + '_phoneType',
                                fullScreen: true,
                                hidden: false,
                                placeholder: 'Тип',
                                position: 2,
                                required: false,
                                value: data.rows[j].values[7],
                                keyValue: data.rows[j].values[6],
                                listKeyColumn: 'Id',
                                listDisplayColumn: 'name',
                                type: 'select',
                                queryListCode: 'dir_PhoneTypes_SelectRows',
                                width: '50%'
                            };
                            fieldsForm.fieldGroups[c1].fields.push(t1_1);
                            let t1_2 = {
                                code: data.rows[j].values[1] + '_phoneIsMain',
                                fullScreen: true,
                                hidden: false,
                                placeholder: 'Основний?',
                                position: 3,
                                required: false,
                                value: data.rows[j].values[4],
                                type: 'checkbox',
                                width: '50%'
                            };
                            fieldsForm.fieldGroups[c1].fields.push(t1_2);
                            if (data.rows[j].values[4]) {
                                let t1_3_0 = {
                                    code: 'phoneDelete_Disabled',
                                    fullScreen: true,
                                    hidden: false,
                                    placeholder: 'Видалити',
                                    position: 4,
                                    required: false,
                                    icon: 'delete',
                                    type: 'button',
                                    width: '50%'
                                };
                                fieldsForm.fieldGroups[c1].fields.push(t1_3_0);
                            } else {
                                let t1_3_1 = {
                                    code: data.rows[j].values[1] + '_phoneDelete',
                                    fullScreen: true,
                                    hidden: false,
                                    placeholder: 'Видалити',
                                    position: 4,
                                    required: false,
                                    icon: 'delete',
                                    type: 'button',
                                    width: '50%'
                                };
                                fieldsForm.fieldGroups[c1].fields.push(t1_3_1);
                            }
                            let t1_4 = {
                                code: data.rows[j].values[1] + '_phoneId',
                                fullScreen: true,
                                hidden: true,
                                placeholder: 'Id',
                                position: 5,
                                value: data.rows[j].values[8],
                                required: false,
                                type: 'text',
                                width: '100%'
                            };
                            fieldsForm.fieldGroups[c1].fields.push(t1_4);
                        }
                    }
                    this.openModalForm(fieldsForm, this.onModal_Phone.bind(this), this.afterModal_Phone_FormOpen.bind(this));
                }
            }.bind(this));
        },
        onChangeCardPhone: function() {
            for (let u = 0; u < this.kolvoPhonesForApplicant; u++) {
                this.formModalConfig.setControlValue('modal_phone' + (u + 1) + '_phoneIsMain', false);
            }
        },
        onRecalcCardPhone: function() {
            const queryForGetValue_RecalcPhone = {
                queryCode: 'ApplicantPhonesRecalcCardPhone',
                parameterValues: [{ key: '@Applicant_id', value: this.form.getControlValue('Id') }]
            };
            this.queryExecutor.getValues(queryForGetValue_RecalcPhone).subscribe(function(data) {
                this.form.setControlValue('phone_number', data.rows[0].values[0]);
            }.bind(this));
            const queryForGetValue_GetIsMainPhone = {
                queryCode: 'GetApplicantPhonesIsMain',
                parameterValues: [{ key: '@Applicant_id', value: this.form.getControlValue('Id') }]
            };
            this.queryExecutor.getValues(queryForGetValue_GetIsMainPhone).subscribe(function(data) {
                this.form.setControlValue('phone_number_norm', data.rows[0].values[0]);
            }.bind(this));
        },
        onDeleteCardPhone: function(phone) {
            const queryForGetValue_DeletePhone = {
                queryCode: 'ApplicantPhonesDelete',
                parameterValues: [{ key: '@PhoneId', value: this.formModalConfig.getControlValue('modal_phone' + phone + '_phoneId') }]
            };
            this.queryExecutor.getValues(queryForGetValue_DeletePhone).subscribe(function() {
                let event = new Event('click');
                document.querySelector('smart-bi-modal-form > div.btn-center-control > button.smart-btn.btn-back.ng-star-inserted').dispatchEvent(event);
                this.onLoadModalPhone();
                this.onRecalcCardPhone();
                const parameters = [
                    { key: '@applicant_phone', value: this.form.getControlValue('phone_number') }
                ];
                this.details.loadData('Phone', parameters);
            }.bind(this));
        },
        afterModal_Phone_FormOpen: function(form) {
            form.formConfig = this;
            this.formModalConfig = form;
            if (this.kolvoPhonesForApplicant > 0) {
                for (let u = 0; u < this.kolvoPhonesForApplicant; u++) {
                    document.getElementById('modal_phone' + (u + 1) + '_phoneIsMain').addEventListener('click', function() {
                        this.formConfig.onChangeCardPhone(true);
                    }.bind(form));
                    if (document.getElementById('modal_phone' + (u + 1) + '_phoneDelete')) {
                        document.getElementById('modal_phone' + (u + 1) + '_phoneDelete').addEventListener('click', function() {
                            this.formConfig.onDeleteCardPhone(u + 1);
                        }.bind(form));
                    }
                    let input = document.getElementById('modal_phone' + (u + 1) + '_phoneNumber');
                    input.addEventListener('input', this.mask, false);
                    input.addEventListener('focus', this.mask, false);
                    input.addEventListener('blur', this.mask, false);
                    input.addEventListener('change', this.mask, false);
                }
                document.getElementById('phoneDelete_Disabled').disabled = true;
                for (let u2 = 0; u2 < this.kolvoPhonesForApplicant; u2++) {
                    document.getElementById('modal_phone' + (u2 + 1) + '_phoneNumber').focus();
                }
            }
            form.onControlValueChanged('modal_phone_NEW', this.onModalPhonesChanged);
            document.getElementById('modal_phone_NEW_phoneDelete').disabled = true;
            if (this.form.getControlValue('Id')) {
                document.getElementById('modal_phone_NEW_phoneDelete').addEventListener('click', function() {
                    const queryForGetValue_AddNewPhone = {
                        queryCode: 'ApplicantPhonesAdd',
                        parameterValues: [{ key: '@Applicant_id', value: this.formConfig.form.getControlValue('Id') }, { key: '@TypePhone', value: this.getControlValue('modal_phone_NEW_phoneType') }, { key: '@Phone', value: this.getControlValue('modal_phone_NEW') }, { key: '@IsMain', value: this.getControlValue('modal_phone_NEW_phoneIsMain') }]
                    };
                    this.formConfig.queryExecutor.getValues(queryForGetValue_AddNewPhone).subscribe(function(data) {
                        if (data.rows[0].values[0] == 'OK') {
                            this.setControlValue('modal_phone_NEW', null);
                            let event = new Event('click');
                            document.querySelector('smart-bi-modal-form > div.btn-center-control > button.smart-btn.btn-back.ng-star-inserted').dispatchEvent(event);
                            this.formConfig.onLoadModalPhone();
                            this.formConfig.onRecalcCardPhone();
                            const parameters = [
                                { key: '@applicant_phone', value: this.form.getControlValue('phone_number') }
                            ];
                            this.details.loadData('Phone', parameters);
                        } else {
                            this.setControlValue('modal_phone_NEW', null);
                            this.formConfig.openPopUpInfoDialog('Помилка. Такий номер вже існує!');
                        }
                    }.bind(this));
                }.bind(form));
                let input3 = document.getElementById('modal_phone_NEW');
                input3.addEventListener('input', this.mask, false);
                input3.addEventListener('focus', this.mask, false);
                input3.addEventListener('blur', this.mask, false);
                input3.addEventListener('change', this.mask, false);
                document.getElementById('modal_phone_NEW').focus();
                document.getElementById('modal_phone_NEW_phoneDelete').focus();
                document.getElementById('modal_phone_NEWIcon').addEventListener('click', function() {
                    this.setControlValue('modal_phone_NEW', this.formConfig.form.getControlValue('Phone'));
                    document.getElementById('modal_phone_NEW').focus();
                    document.getElementById('modal_phone_NEW_phoneDelete').focus();
                }.bind(form));
            }
        },
        onModalPhonesChanged: function(phone) {
            if (!phone) {
                document.getElementById('modal_phone_NEW_phoneDelete').disabled = true;
            } else {
                if (phone.replace('(', '').replace(')', '').replace(/-/g, '').replace(/\D/g, '').length == 10) {
                    document.getElementById('modal_phone_NEW_phoneDelete').disabled = false;
                } else {
                    document.getElementById('modal_phone_NEW_phoneDelete').disabled = true;
                }
            }
        },
        onModal_Phone: function(value) {
            if (value) {
                if (this.kolvoPhonesForApplicant > 0) {
                    for (let u = 0; u < this.kolvoPhonesForApplicant; u++) {
                        const queryForGetValue_UpdatePhone = {
                            queryCode: 'ApplicantPhonesUpdate',
                            parameterValues: [{ key: '@Applicant_id', value: this.form.getControlValue('Id') },
                                { key: '@TypePhone', value: value.find(f => f.key === '@modal_phone' + (u + 1) + '_phoneType').value },
                                { key: '@Phone', value: value.find(f => f.key === '@modal_phone' + (u + 1) + '_phoneNumber').value },
                                { key: '@IsMain', value: value.find(f => f.key === '@modal_phone' + (u + 1) + '_phoneIsMain').value },
                                { key: '@IdPhone', value: value.find(f => f.key === '@modal_phone' + (u + 1) + '_phoneId').value }]
                        };
                        this.queryExecutor.getValues(queryForGetValue_UpdatePhone).subscribe(function() {
                        }.bind(this));
                    }
                    const parameters = [
                        { key: '@applicant_phone', value: this.form.getControlValue('phone_number') }
                    ];
                    this.details.loadData('Phone', parameters);
                    this.onRecalcCardPhone();
                }
            }
        },
        init: function() {
            this.details.setVisibility('ApplicantHistory_details', false);
            this.details.onCellClick('ApplicantHistory', this.Detail_History.bind(this));
            this.form.disableControl('district_id');
            this.form.disableControl('age');
            document.getElementById('phone_number').addEventListener('click', function() {
                this.onLoadModalPhone();
            }.bind(this));
            function setCursorPosition(pos, elem) {
                elem.focus();
                if (elem.setSelectionRange) {
                    elem.setSelectionRange(pos, pos);
                } else if (elem.createTextRange) {
                    let range = elem.createTextRange();
                    range.collapse(true);
                    range.moveEnd('character', pos);
                    range.moveStart('character', pos);
                    range.select()
                }
            }
            function mask1(event2) {
                let matrix = '__-__',
                    i = 0,
                    def = matrix.replace(/\D/g, ''),
                    val = this.value.replace(/\D/g, '');
                if (def.length >= val.length) {
                    val = def;
                }
                this.value = matrix.replace(/./g, function(a) {
                    return /[_\d]/.test(a) && i < val.length ? val.charAt(i++) : i >= val.length ? '' : a
                });
                if (event2.type == 'blur') {
                    if (this.value.length == 2) {
                        this.value = ''
                    }
                } else {
                    setCursorPosition(this.value.length, this)
                }
            }
            this.form.onControlValueChanged('birth_year', this.inputGetYear);
            this.form.onControlValueChanged('day_month', this.inputGetYear);
            let input = document.getElementById('day_month');
            input.placeholder = 'дд-мм';
            input.addEventListener('input', mask1, false);
            input.addEventListener('focus', mask1, false);
            input.addEventListener('blur', mask1, false);
            this.form.onControlValueChanged('birth_date', this.validateDate);
            this.form.onControlValueChanged('building_id', this.onChanged_Applicant_Building);
        },
        onChanged_Applicant_Building: function() {
            let build = this.form.getControlValue('building_id');
            if (typeof (build) === 'number') {
                let district = {
                    queryCode: 'GetDistrictForBuilding2',
                    parameterValues: [
                        {
                            key: '@building_id',
                            value: build
                        }
                    ]
                };
                this.queryExecutor.getValues(district).subscribe(function(data) {
                    if (data.rows.length > 0) {
                        this.form.setControlValue('district_id', { key: data.rows[0].values[0], value: data.rows[0].values[1] });
                    } else {
                        this.form.setControlValue('district_id', '');
                    }
                }.bind(this));
            }
        },
        inputGetYear: function(data) {
            let inputYear = document.getElementById('birth_year');
            let input = document.getElementById('day_month');
            let dataStr = data.toString();
            if (dataStr.length == 4 && input.value.length == 5) {
                let val = input.value;
                let y = Number(data);
                let d = Number(val.slice(0, 2));
                let m = Number(val.slice(3, 5));
                let birth = new Date(y, m - 1, d);
                let year = birth.getFullYear();
                let today = new Date();
                let thisday = today.setFullYear(year);
                let birthDay = birth.setFullYear(year);
                let today2 = new Date();
                let ageValue = today2.getFullYear() - birth.getFullYear();
                let age = document.getElementById('age');
                if (birthDay < thisday) {
                    age.value = ageValue;
                } else {
                    age.value = ageValue - 1;
                }
                let val_data = age.value;
                if (val_data < 16 && val_data >= 0) {
                    const formValidDate = {
                        title: 'Дата народження введена некоректно',
                        text: 'Заявнику не може бути менше 16 років',
                        singleButton: true
                    }
                    const callbackValidDate = () => {
                        this.form.setControlValue('birth_date', null);
                        this.form.setControlValue('age', null);
                    }
                    this.openModalForm(formValidDate, callbackValidDate);
                } else if (val_data < 0) {
                    const formValidDate = {
                        title: 'Дата народження введена некоректно',
                        text: ' Ви обрали майбутню дату',
                        singleButton: true
                    }
                    const callbackValidDate = () => {
                        this.form.setControlValue('birth_date', null);
                        this.form.setControlValue('age', null);
                    }
                    this.openModalForm(formValidDate, callbackValidDate);
                }
            } else if (data.length == 5 && inputYear.value) {
                let val = data;
                let y = Number(inputYear.value);
                let d = Number(val.slice(0, 2));
                let m = Number(val.slice(3, 5));
                let birth = new Date(y, m - 1, d);
                let year = birth.getFullYear();
                let today = new Date();
                let thisday = today.setFullYear(year);
                let birthDay = birth.setFullYear(year);
                let today2 = new Date();
                let ageValue = today2.getFullYear() - birth.getFullYear();
                let age = document.getElementById('age');
                if (birthDay < thisday) {
                    age.value = ageValue;
                } else {
                    age.value = ageValue - 1;
                }
                let val_data = age.value;
                if (val_data < 16 && val_data >= 0) {
                    const formValidDate = {
                        title: 'Дата народження введена некоректно',
                        text: 'Заявнику не може бути менше 16 років',
                        singleButton: true
                    }
                    const callbackValidDate = () => {
                        this.form.setControlValue('birth_date', null);
                        this.form.setControlValue('age', null);
                    }
                    this.openModalForm(formValidDate, callbackValidDate);
                } else if (val_data < 0) {
                    const formValidDate = {
                        title: 'Дата народження введена некоректно',
                        text: ' Ви обрали майбутню дату',
                        singleButton: true
                    }
                    const callbackValidDate = () => {
                        this.form.setControlValue('birth_date', null);
                        this.form.setControlValue('age', null);
                    }
                    this.openModalForm(formValidDate, callbackValidDate);
                }
            } else if (dataStr.length == 4 && input.value.length == 0) {
                let birth = new Date(data, 0, 1);
                let year = birth.getFullYear();
                let today = new Date();
                let thisday = today.setFullYear(year);
                let birthDay = birth.setFullYear(year);
                let today2 = new Date();
                let ageValue = today2.getFullYear() - birth.getFullYear();
                let age = document.getElementById('age');
                if (birthDay < thisday) {
                    age.value = ageValue;
                } else {
                    age.value = ageValue - 1;
                }
                let val_data = age.value;
                if (val_data < 16 && val_data >= 0) {
                    const formValidDate = {
                        title: 'Дата народження введена некоректно',
                        text: 'Заявнику не може бути менше 16 років',
                        singleButton: true
                    }
                    const callbackValidDate = () => {
                        this.form.setControlValue('birth_date', null);
                        this.form.setControlValue('age', null);
                    }
                    this.openModalForm(formValidDate, callbackValidDate);
                } else if (val_data < 0) {
                    const formValidDate = {
                        title: 'Дата народження введена некоректно',
                        text: ' Ви обрали майбутню дату',
                        singleButton: true
                    }
                    const callbackValidDate = () => {
                        this.form.setControlValue('birth_date', null);
                        this.form.setControlValue('age', null);
                    }
                    this.openModalForm(formValidDate, callbackValidDate);
                }
            }
        },
        validateDate: function(valid_date) {
            const getAge = birthDate => Math.floor((new Date() - new Date(birthDate).getTime()) / 31556925994)
            let val_data = getAge(valid_date);
            if (val_data < 16 && val_data >= 0) {
                const formValidDate = {
                    title: 'Дата народження введена некоректно',
                    text: 'Заявнику не може бути менше 16 років',
                    singleButton: true
                }
                const callbackValidDate = () => {
                    this.form.setControlValue('birth_date', null);
                    this.form.setControlValue('age', null);
                }
                this.openModalForm(formValidDate, callbackValidDate);
            } else if (val_data < 0) {
                const formValidDate = {
                    title: 'Дата народження введена некоректно',
                    text: ' Ви обрали майбутню дату',
                    singleButton: true
                }
                const callbackValidDate = () => {
                    this.form.setControlValue('birth_date', null);
                    this.form.setControlValue('age', null);
                }
                this.openModalForm(formValidDate, callbackValidDate);
            }
            this.form.setControlValue('age', getAge(valid_date));
        },
        onStreetsChanged: function(dis_id) {
            this.form.setControlValue('building_id', {});
            let dependParams = [{ parameterCode: '@district_id', parameterValue: dis_id }];
            this.form.setControlParameterValues('building_id', dependParams);
            this.form.enableControl('building_id');
        }
    }
}());
