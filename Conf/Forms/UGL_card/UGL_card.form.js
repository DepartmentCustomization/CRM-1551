(function() {
    return {
        is_obj: undefined,
        is_org: undefined,
        onLoadModalPhone: function() {
            this.modal_phone_NEW = null;
            const queryForGetValue22 = {
                queryCode: 'GetApplicantPhonesForApplicantId',
                parameterValues: [{ key: '@applicant_id', value: this.form.getControlValue('Applicant_Id') }]
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
                        if (data.rows[j].values[5] === 1) {
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
                parameterValues: [{ key: '@Applicant_id', value: this.form.getControlValue('Applicant_Id') }]
            };
            this.queryExecutor.getValues(queryForGetValue_RecalcPhone).subscribe(function(data) {
                this.form.setControlValue('CardPhone', data.rows[0].values[0]);
            }.bind(this));
            const queryForGetValue_GetIsMainPhone = {
                queryCode: 'GetApplicantPhonesIsMain',
                parameterValues: [{ key: '@Applicant_id', value: this.form.getControlValue('Applicant_Id') }]
            };
            this.queryExecutor.getValues(queryForGetValue_GetIsMainPhone).subscribe(function(data) {
                this.form.setControlValue('Applicant_Phone_Hide', data.rows[0].values[0]);
            }.bind(this));
        },
        onDeleteCardPhone: function(phone) {
            const queryForGetValue_DeletePhone = {
                queryCode: 'ApplicantPhonesDelete',
                parameterValues: [{ key: '@PhoneId', value: this.formModalConfig.getControlValue('modal_phone' + phone + '_phoneId') }]
            };
            this.queryExecutor.getValues(queryForGetValue_DeletePhone).subscribe(function() {
                let event = new Event('click');
                document.querySelector('smart-bi-modal-form > div.btn-center-control > button.smart-btn.btn-back.ng-star-inserted')
                    .dispatchEvent(event);
                this.onLoadModalPhone();
                this.onRecalcCardPhone();
                const parameters = [
                    { key: '@applicant_phone', value: this.form.getControlValue('CardPhone') }
                ];
                this.details.loadData('Detail_UGL_Aplicant', parameters);
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
            if (this.form.getControlValue('Applicant_Id')) {
                document.getElementById('modal_phone_NEW_phoneDelete').addEventListener('click', function() {
                    const queryForGetValue_AddNewPhone = {
                        queryCode: 'ApplicantPhonesAdd',
                        parameterValues: [{ key: '@Applicant_id', value: this.formConfig.form.getControlValue('Applicant_Id') },
                            { key: '@TypePhone', value: this.getControlValue('modal_phone_NEW_phoneType') },
                            { key: '@Phone', value: this.getControlValue('modal_phone_NEW') },
                            { key: '@IsMain', value: this.getControlValue('modal_phone_NEW_phoneIsMain') }]
                    };
                    this.formConfig.queryExecutor.getValues(queryForGetValue_AddNewPhone).subscribe(function(data) {
                        if (data.rows[0].values[0] === 'OK') {
                            this.setControlValue('modal_phone_NEW', null);
                            let event = new Event('click');
                            document.querySelector('smart-bi-modal-form > div.btn-center-control > ' +
                            'button.smart-btn.btn-back.ng-star-inserted').dispatchEvent(event);
                            this.formConfig.onLoadModalPhone();
                            this.formConfig.onRecalcCardPhone();
                            const parameters = [
                                { key: '@applicant_phone', value: this.form.getControlValue('CardPhone') }
                            ];
                            this.details.loadData('Detail_UGL_Aplicant', parameters);
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
                if (phone.replace('(', '').replace(')', '').replace(/-/g, '').replace(/\D/g, '').length === 10) {
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
                            parameterValues: [{ key: '@Applicant_id', value: this.form.getControlValue('Applicant_Id') },
                                { key: '@TypePhone', value: value.find(f => f.key === '@modal_phone' + (u + 1) + '_phoneType').value },
                                { key: '@Phone', value: value.find(f => f.key === '@modal_phone' + (u + 1) + '_phoneNumber').value },
                                { key: '@IsMain', value: value.find(f => f.key === '@modal_phone' + (u + 1) + '_phoneIsMain').value },
                                { key: '@IdPhone', value: value.find(f => f.key === '@modal_phone' + (u + 1) + '_phoneId').value }]
                        };
                        this.queryExecutor.getValues(queryForGetValue_UpdatePhone).subscribe(function() {
                        }.bind(this));
                    }
                    const parameters = [
                        { key: '@applicant_phone', value: this.form.getControlValue('CardPhone') }
                    ];
                    this.details.loadData('Detail_UGL_Aplicant', parameters);
                    this.onRecalcCardPhone();
                }
            }
        },
        init: function() {
            if (this.state === 'create') {
                let getDataFromLink = window
                    .location
                    .search
                    .replace('?', '')
                    .split('&')
                    .reduce(
                        function(p, e) {
                            let a = e.split('=');
                            p[decodeURIComponent(a[0])] = decodeURIComponent(a[1]);
                            return p;
                        }, {}
                    );
                let uglId;
                if (getDataFromLink['uglId'] === undefined) {
                    uglId = 'невідомо';
                } else {
                    uglId = getDataFromLink['uglId']
                }
                const queryForGetUGLAppeal = {
                    queryCode: 'CreateAppeal_FromUGL',
                    parameterValues: [
                        {
                            key: '@uglId',
                            value: uglId
                        }
                    ]
                };
                this.queryExecutor.getValue(queryForGetUGLAppeal).subscribe(data => {
                    this.navigateTo('sections/CreateAppeal_UGL/edit/' + data)
                });
            } else {
                this.form.setControlValue('AppealId', this.id);
                this.form.setControlValue('ReceiptSources', { key: 3, value: 'УГЛ' });
                document.getElementById('CardPhone').addEventListener('click', function() {
                    this.onLoadModalPhone();
                }.bind(this));
                document.getElementsByClassName('float_r')[0].children[1].style.display = 'none';
                document.getElementById('Question_Btn_Add').disabled = true;
                document.getElementById('Question_Aplicant_Btn_Add').disabled = true;
                document.getElementById('Applicant_Btn_Add').disabled = true;
                this.form.onControlValueChanged('Applicant_PIB', this.applicantIsPIBChanged);
                this.form.onControlValueChanged('Applicant_Building', this.applicantIsBuildingChanged);
                this.form.onControlValueChanged('Applicant_Entrance', this.applicantIsEntranceChanged);
                this.form.onControlValueChanged('Applicant_Flat', this.applicantIsFlatChanged);
                this.form.onControlValueChanged('Applicant_Privilege', this.applicantIsPrivilegeChanged);
                this.form.onControlValueChanged('Applicant_SocialStates', this.applicantIsSocialStateChanged);
                this.form.onControlValueChanged('Applicant_Type', this.applicantIsApplicantTypeChanged);
                this.form.onControlValueChanged('Applicant_Sex', this.applicantIsSexChanged);
                this.form.onControlValueChanged('Applicant_BirthDate', this.applicantIsBirthDateChanged);
                this.form.onControlValueChanged('Applicant_Email', this.applicantIsMailChanged);
                this.form.onControlValueChanged('Applicant_Comment', this.applicantIsNoteChanged);
                this.form.disableControl('CardPhone');
                this.form.disableControl('ReceiptSources');
                this.form.disableControl('Phone');
                this.form.disableControl('DateStart');
                this.form.disableControl('AppealNumber');
                this.form.disableControl('Appeal_enter_number');
                this.form.disableControl('Applicant_District');
                this.form.disableControl('Applicant_Age');
                this.form.disableControl('ExecutorInRoleForObject');
                this.form.disableControl('Question_OrganizationId');
                this.form.disableControl('Question_ControlDate');
                this.form.setControlVisibility('Question_Building', false);
                this.form.setControlVisibility('entrance', false);
                this.form.setControlVisibility('flat', false);
                this.form.setControlVisibility('Question_Organization', false);
                this.details.setVisibility('Detail_UGL_QuestionNumberAppeal', false);
                this.form.onControlValueChanged('Applicant_Id', this.checkApplicantHere);
                this.form.setGroupVisibility('UGL_Group_CreateQuestion', false);
                this.form.onControlValueChanged('Applicant_Building', this.getDistrictAndExecutor);
                this.form.onControlValueChanged('Applicant_Building', this.checkApplicantSaveAvailable);
                this.form.onControlValueChanged('Applicant_PIB', this.checkApplicantSaveAvailable);
                this.form.onControlValueChanged('Question_TypeId', this.onChanged_Question_TypeId);
                this.form.onControlValueChanged('Question_Content', this.checkQuestionRegistrationAvailable);
                this.form.onControlValueChanged('Question_AnswerType', this.onChangedQuestion_AnswerType.bind(this));
                this.form.onControlValueChanged('Question_Building', this.checkQuestionRegistrationAvailable);
                this.form.onControlValueChanged('Question_Organization', this.checkQuestionRegistrationAvailable);
                this.form.onControlValueChanged('Question_Organization', this.getOrgExecut);
                const AppealUGL = {
                    queryCode: 'AppealUGL_Info',
                    parameterValues: [
                        {
                            key: '@Id',
                            value: this.id
                        }
                    ]
                };
                this.queryExecutor.getValues(AppealUGL).subscribe(data => {
                    this.form.setControlValue('Appeal_enter_number', data.rows[0].values[0]);
                    this.form.setControlValue('Phone', data.rows[0].values[1]);
                    this.form.setControlValue('CardPhone', data.rows[0].values[3]);
                    this.form.setControlValue('DateStart', data.rows[0].values[2]);
                    this.form.setControlValue('Applicant_PIB', data.rows[0].values[4]);
                    this.form.setControlValue('Question_Content', data.rows[0].values[5]);
                    this.form.setControlValue('ApplicantUGL', data.rows[0].values[6]);
                    this.form.setControlValue('AppealNumber', data.rows[0].values[8]);
                    this.form.setControlValue('applicantAddress', data.rows[0].values[9]);
                    const parameters = [
                        { key: '@applicant_phone', value: this.form.getControlValue('CardPhone') }
                    ];
                    this.details.loadData('Detail_UGL_Aplicant', parameters);
                });
                this.details.onCellClick('Detail_UGL_Aplicant', this.getApplicantInfo.bind(this));
                document.getElementById('Applicant_Btn_Add').addEventListener('click', function() {
                    let entrance = this.form.getControlValue('Applicant_Entrance');
                    if (entrance !== null && entrance < 1) {
                        this.openPopUpInfoDialog('Номер під`їзду не може бути менше 1');
                    } else {
                        const queryForGetValue2 = {
                            queryCode: 'Applicant_UGL_InsertRow',
                            parameterValues: [
                                {
                                    key: '@Applicant_Id',
                                    value: this.form.getControlValue('Applicant_Id')
                                },
                                {
                                    key: '@Applicant_PIB',
                                    value: this.form.getControlValue('Applicant_PIB')
                                },
                                {
                                    key: '@Applicant_Privilege',
                                    value: this.form.getControlValue('Applicant_Privilege')
                                },
                                {
                                    key: '@Applicant_SocialStates',
                                    value: this.form.getControlValue('Applicant_SocialStates')
                                },
                                {
                                    key: '@Applicant_CategoryType',
                                    value: this.form.getControlValue('Applicant_CategoryType')
                                },
                                {
                                    key: '@Applicant_Type',
                                    value: this.form.getControlValue('Applicant_Type')
                                },
                                {
                                    key: '@Applicant_Sex',
                                    value: this.form.getControlValue('Applicant_Sex')
                                },
                                {
                                    key: '@Application_BirthDate',
                                    value: this.form.getControlValue('Applicant_BirthDate')
                                },
                                {
                                    key: '@Applicant_Age',
                                    value: this.form.getControlValue('Applicant_Age')
                                },
                                {
                                    key: '@Applicant_Comment',
                                    value: this.form.getControlValue('Applicant_Comment')
                                },
                                {
                                    key: '@Applicant_Building',
                                    value: this.form.getControlValue('Applicant_Building')
                                },
                                {
                                    key: '@Applicant_HouseBlock',
                                    value: this.form.getControlValue('Applicant_HouseBlock')
                                },
                                {
                                    key: '@Applicant_Entrance',
                                    value: this.form.getControlValue('Applicant_Entrance')
                                },
                                {
                                    key: '@Applicant_Flat',
                                    value: this.form.getControlValue('Applicant_Flat')
                                },
                                {
                                    key: '@AppealId',
                                    value: this.form.getControlValue('AppealId')
                                },
                                {
                                    key: '@Applicant_Phone',
                                    value: this.form.getControlValue('CardPhone')
                                },
                                {
                                    key: '@Applicant_Email',
                                    value: this.form.getControlValue('Applicant_Email')
                                },
                                {
                                    key: '@Applicant_TypePhone',
                                    value: 1
                                }
                            ]
                        };
                        this.queryExecutor.getValues(queryForGetValue2).subscribe(data => {
                            this.form.setControlValue('Applicant_Id', data.rows[0].values[0]);
                            const queryForGetValue3 = {
                                queryCode: 'Appeals_SelectRow',
                                parameterValues: [
                                    {
                                        key: '@Id',
                                        value: this.id
                                    }
                                ]
                            };
                            document.getElementById('Applicant_Btn_Add').disabled = true;
                            this.queryExecutor.getValues(queryForGetValue3).subscribe(data => {
                                const parameters = [
                                    { key: '@applicant_phone', value: this.form.getControlValue('CardPhone') }
                                ];
                                this.details.loadData('Detail_UGL_Aplicant', parameters);
                                const parameters2 = [
                                    { key: '@appealId', value: data.rows[0].values[0] }
                                ];
                                this.details.loadData('Detail_UGL_QuestionRegistration', parameters2);
                            });
                        });
                    }
                }.bind(this));
                document.getElementById('Applicant_Btn_Clear').addEventListener('click', function() {
                    this.form.setControlValue('Applicant_Id', null);
                    this.form.setControlValue('Applicant_PIB', null);
                    this.form.setControlValue('Applicant_District', null);
                    this.form.setControlValue('Applicant_Building', {});
                    this.form.setControlValue('Applicant_HouseBlock', null);
                    this.form.setControlValue('Applicant_Entrance', null);
                    this.form.setControlValue('Applicant_Flat', null);
                    this.form.setControlValue('Applicant_Privilege', {});
                    this.form.setControlValue('Applicant_SocialStates', {});
                    this.form.setControlValue('Applicant_CategoryType', {});
                    this.form.setControlValue('Applicant_Type', {});
                    this.form.setControlValue('Applicant_Sex', null);
                    this.form.setControlValue('Applicant_BirthDate', null);
                    this.form.setControlValue('Applicant_Age', null);
                    this.form.setControlValue('Applicant_Email', null);
                    this.form.setControlValue('Applicant_Comment', null);
                }.bind(this));
                document.getElementById('Question_Aplicant_Btn_Add').addEventListener('click', function() {
                    let build = this.form.getControlValue('Applicant_Building');
                    this.getBuildingInfo(build);
                    this.form.setGroupVisibility('UGL_Group_CreateQuestion', true);
                    this.form.setGroupExpanding('UGL_Group_Aplicant', false);
                    this.form.setGroupExpanding('UGL_Group_Appeal', false);
                    const objNameQuestion_AnswerType = {
                        queryCode: 'dir_AnswerTypes_SelectRow',
                        parameterValues: [
                            {
                                key: '@Id',
                                value: this.form.getControlValue('ReceiptSources')
                            }
                        ]
                    };
                    this.queryExecutor.getValues(objNameQuestion_AnswerType).subscribe(data => {
                        this.form.setControlValue('Question_AnswerType', { key: data.rows[0].values[0], value: data.rows[0].values[1] });
                    });
                }.bind(this));
            }
            document.getElementById('Question_Btn_Add').addEventListener('click', function() {
                const queryForGetValue3 = {
                    queryCode: 'Question_UGL_InsertRow',
                    parameterValues: [
                        {
                            key: '@AppealId',
                            value: this.form.getControlValue('AppealId')
                        },
                        {
                            key: '@AppealNumber',
                            value: this.form.getControlValue('AppealNumber')
                        },
                        {
                            key: '@Question_TypeId',
                            value: this.form.getControlValue('Question_TypeId')
                        },
                        {
                            key: '@Question_Building',
                            value: this.form.getControlValue('Question_Building')
                        },
                        {
                            key: '@Question_Organization',
                            value: this.form.getControlValue('Question_Organization')
                        },
                        {
                            key: '@Question_EventId',
                            value: this.form.getControlValue('Question_EventId')
                        },
                        {
                            key: '@Question_Content',
                            value: this.form.getControlValue('Question_Content')
                        },
                        {
                            key: '@Question_AnswerType',
                            value: this.form.getControlValue('Question_AnswerType')
                        },
                        {
                            key: '@Applicant_Phone',
                            value: this.form.getControlValue('CardPhone')
                        },
                        {
                            key: '@Applicant_Email',
                            value: this.form.getControlValue('Applicant_Email')
                        },
                        {
                            key: '@Applicant_Building',
                            value: this.form.getControlValue('applicantAddress')
                        },
                        {
                            key: '@Question_OrganizationId',
                            value: this.form.getControlValue('Question_OrganizationId')
                        },
                        {
                            key: '@applicant_id',
                            value: this.form.getControlValue('Applicant_Id')
                        },
                        {
                            key: '@entrance',
                            value: this.form.getControlValue('entrance')
                        },
                        {
                            key: '@flat',
                            value: this.form.getControlValue('flat')
                        },
                        {
                            key: '@Question_ControlDate',
                            value: new Date(this.convertDateNull(this.form.getControlValue('Question_ControlDate')))
                        },
                        {
                            key: '@answer_phone',
                            value: this.form.getControlValue('CardPhone')
                        },
                        {
                            key: '@answer_post',
                            value: this.form.getControlValue('applicantAddress')
                        },
                        {
                            key: '@answer_mail',
                            value: this.form.getControlValue('Applicant_Email')
                        }
                    ]
                };
                this.queryExecutor.getValues(queryForGetValue3).subscribe(() => {
                    const queryForGetValue4 = {
                        queryCode: 'Appeals_SelectRow',
                        parameterValues: [
                            {
                                key: '@Id',
                                value: this.id
                            }
                        ]
                    };
                    this.queryExecutor.getValues(queryForGetValue4).subscribe(data => {
                        this.form.setControlValue('AppealId', data.rows[0].values[0]);
                        this.form.setControlValue('ReceiptSources', { key: data.rows[0].values[4], value: data.rows[0].values[19] });
                        this.form.setControlValue('AppealNumber', data.rows[0].values[3]);
                        this.form.setControlValue('Phone', data.rows[0].values[5]);
                        this.form.setControlValue('DateStart', new Date());
                        const parameters = [
                            { key: '@phone_number', value: data.rows[0].values[5] }
                        ];
                        this.details.loadData('Detail_UGL_Aplicant', parameters);
                        const parameters2 = [
                            { key: '@appealId', value: this.id }
                        ];
                        this.details.loadData('Detail_UGL_QuestionRegistration', parameters2);
                    });
                });
                this.form.setControlValue('Question_Organization', {});
                this.form.setControlValue('Question_Content', '');
                this.form.setControlValue('Question_TypeId', {});
                this.form.setControlValue('Question_OrganizationId', {});
                this.form.setControlValue('Question_ControlDate', '');
                this.form.setControlValue('Question_EventId', null);
            }.bind(this));
            this.form.onControlValueChanged('Search_Appeals_Input', this.onChanged_Search_Appeals_Input.bind(this));
            document.getElementById('Search_Appeals_Search').disabled = true;
            document.getElementById('Search_Appeals_Search').addEventListener('click', function() {
                const parameters = [
                    { key: '@AppealRegistrationNumber', value: this.form.getControlValue('Search_Appeals_Input') }
                ];
                this.details.loadData('Detail_UGL_QuestionNumberAppeal', parameters);
                this.details.setVisibility('Detail_UGL_QuestionNumberAppeal', true);
            }.bind(this));
        },
        input_pib: null,
        input_pib_check: 0,
        applicantIsPIBChanged: function(value) {
            if (this.input_pib === value) {
                this.input_pib_check = 0;
            } else {
                this.input_pib_check = 1;
            }
            this.input_pib = value;
            this.applicantSaveButtonManager(this.input_pib_check);
        },
        input_building: null,
        input_building_check: 0,
        applicantIsBuildingChanged: function(value) {
            if (this.input_building === value) {
                this.input_building_check = 0;
            } else {
                this.input_building_check = 1;
            }
            this.input_building = value;
            this.applicantSaveButtonManager(this.input_building_check);
        },
        input_entrance: null,
        input_entrance_check: 0,
        applicantIsEntranceChanged: function(value) {
            if (this.input_entrance === value) {
                this.input_entrance_check = 0;
            } else {
                this.input_entrance_check = 1;
            }
            this.input_entrance = value;
            this.applicantSaveButtonManager(this.input_entrance_check);
        },
        input_flat: null,
        input_flat_check: 0,
        applicantIsFlatChanged: function(value) {
            if (this.input_flat === value) {
                this.input_flat_check = 0;
            } else {
                this.input_flat_check = 1;
            }
            this.input_flat = value;
            this.applicantSaveButtonManager(this.input_flat_check);
        },
        input_privilege: null,
        input_privilege_check: 0,
        applicantIsPrivilegeChanged: function(value) {
            if (this.input_privilege === value) {
                this.input_privilege_check = 0;
            } else {
                this.input_privilege_check = 1;
            }
            this.input_privilege = value;
            this.applicantSaveButtonManager(this.input_privilege_check);
        },
        input_socialState: null,
        input_socialState_check: 0,
        applicantIsSocialStateChanged: function(value) {
            if (this.input_socialState === value) {
                this.input_socialState_check = 0;
            } else {
                this.input_socialState_check = 1;
            }
            this.input_socialState = value;
            this.applicantSaveButtonManager(this.input_socialState_check);
        },
        input_applicantType: null,
        input_applicantType_check: 0,
        applicantIsApplicantTypeChanged: function(value) {
            if (this.input_applicantType === value) {
                this.input_applicantType_check = 0;
            } else {
                this.input_applicantType_check = 1;
            }
            this.input_applicantType = value;
            this.applicantSaveButtonManager(this.input_applicantType_check);
        },
        input_applicantSex: null,
        input_applicantSex_check: 0,
        applicantIsSexChanged: function(value) {
            if (this.input_applicantSex === value) {
                this.input_applicantSex_check = 0;
            } else {
                this.input_applicantSex_check = 1;
            }
            this.input_applicantSex = value;
            this.applicantSaveButtonManager(this.input_applicantSex_check);
        },
        input_birthDate: null,
        input_birthDate_check: 0,
        applicantIsBirthDateChanged: function(value) {
            if (this.input_birthDate === value) {
                this.input_birthDate_check = 0;
            } else {
                this.input_birthDate_check = 1;
            }
            this.input_birthDate = value;
            this.applicantSaveButtonManager(this.input_birthDate_check);
        },
        input_mail: null,
        input_mail_check: 0,
        applicantIsMailChanged: function(value) {
            if (this.input_mail === value) {
                this.input_mail_check = 0;
            } else {
                this.input_mail_check = 1;
            }
            this.input_mail = value;
            this.applicantSaveButtonManager(this.input_mail_check);
        },
        input_note: null,
        input_note_check: 0,
        applicantIsNoteChanged: function(value) {
            if (this.input_note === value) {
                this.input_note_check = 0;
            } else {
                this.input_note_check = 1;
            }
            this.input_note = value;
            this.applicantSaveButtonManager(this.input_note_check);
        },
        applicantSaveButtonManager: function(input_check) {
            if (this.form.getControlValue('Applicant_Id') !== null) {
                if (input_check === 1) {
                    document.getElementById('Applicant_Btn_Add').disabled = false;
                } else if (input_check === 0) {
                    document.getElementById('Applicant_Btn_Add').disabled = true;
                }
            }
        },
        questionObjectOrg: function() {
            let q_type_id = this.form.getControlValue('Question_TypeId');
            if (q_type_id === undefined) {
                this.form.setControlVisibility('Question_Building', false);
                this.form.setControlVisibility('entrance', false);
                this.form.setControlVisibility('flat', false);
                this.form.setControlVisibility('Question_Organization', false);
            } else {
                const objAndOrg = {
                    queryCode: 'QuestionTypes_HideColumns',
                    parameterValues: [
                        {
                            key: '@question_type_id',
                            value: q_type_id
                        }
                    ]
                };
                this.queryExecutor.getValues(objAndOrg).subscribe(data => {
                    this.is_org = data.rows[0].values[0];
                    this.is_obj = data.rows[0].values[1];
                    if (this.is_obj === true) {
                        this.form.setControlVisibility('Question_Building', true);
                        this.form.setControlVisibility('entrance', true);
                        this.form.setControlVisibility('flat', true);
                    } else if (this.is_obj !== true) {
                        this.form.setControlVisibility('Question_Building', false);
                        this.form.setControlVisibility('entrance', false);
                        this.form.setControlVisibility('flat', false);
                    }
                    if (this.is_org === true) {
                        this.form.setControlVisibility('Question_Organization', true);
                    } else if (this.is_org !== true) {
                        this.form.setControlVisibility('Question_Organization', false);
                    }
                    this.checkQuestionRegistrationAvailable();
                });
            }
        },
        checkApplicantHere: function() {
            if (this.form.getControlValue('Applicant_Id') !== undefined) {
                document.getElementById('Question_Aplicant_Btn_Add').disabled = false;
                this.form.enableControl('CardPhone');
            } else {
                document.getElementById('Question_Aplicant_Btn_Add').disabled = true;
                this.form.disableControl('CardPhone');
            }
        },
        checkApplicantSaveAvailable: function() {
            if (
                (this.form.getControlValue('Applicant_PIB') === null || this.form.getControlValue('Applicant_Building') === null)
            ) {
                document.getElementById('Applicant_Btn_Add').disabled = true;
            } else {
                document.getElementById('Applicant_Btn_Add').disabled = false;
            }
        },
        getApplicantInfo: function(column, row) {
            let applicantId = row.values[4];
            const Applicant = {
                queryCode: 'Applicant_Info',
                parameterValues: [
                    {
                        key: '@applicantId',
                        value: applicantId
                    }
                ]
            }
            this.queryExecutor.getValues(Applicant).subscribe(data => {
                if (data) {
                    let BirthDate = null;
                    if (data.rows[0].values[14] === null) {
                        BirthDate = null;
                    } else {
                        BirthDate = new Date(data.rows[0].values[14]);
                    }
                    let sex = null;
                    if (data.rows[0].values[13] === null) {
                        sex = null;
                    } else {
                        sex = (data.rows[0].values[13]).toString();
                    }
                    this.form.setControlValue('Applicant_Building',
                        { key: data.rows[0].values[1], value: data.rows[0].values[2] });
                    this.form.setControlValue('Applicant_Entrance', data.rows[0].values[4])
                    this.form.setControlValue('Applicant_Flat', data.rows[0].values[5])
                    this.form.setControlValue('Applicant_District', data.rows[0].values[6])
                    this.form.setControlValue('Applicant_Privilege',
                        { key: data.rows[0].values[7], value: data.rows[0].values[8] });
                    this.form.setControlValue('Applicant_SocialStates',
                        { key: data.rows[0].values[9], value: data.rows[0].values[10] });
                    this.form.setControlValue('Applicant_Type',
                        { key: data.rows[0].values[11], value: data.rows[0].values[12] });
                    this.form.setControlValue('Applicant_Sex', sex);
                    this.form.setControlValue('Applicant_BirthDate', BirthDate);
                    this.form.setControlValue('Applicant_Email', data.rows[0].values[15]);
                    this.form.setControlValue('Applicant_Comment', data.rows[0].values[16]);
                    this.form.setControlValue('Applicant_PIB', data.rows[0].values[0]);
                    this.form.setControlValue('Applicant_Id', data.rows[0].values[17]);
                    this.form.setControlValue('Applicant_Age', data.rows[0].values[18]);
                    this.form.setControlValue('ExecutorInRoleForObject', data.rows[0].values[19]);
                    this.form.setControlValue('CardPhone', data.rows[0].values[20]);
                }
            });
            document.getElementById('Applicant_Btn_Add').disabled = true;
        },
        onChanged_Question_TypeId: function() {
            let questionType = this.form.getControlValue('Question_TypeId');
            if (questionType === '' || questionType === undefined || questionType === null) {
                this.form.setControlValue('Question_Organization', { key: null, value: null });
                this.form.setControlValue('flat', null);
                this.form.setControlValue('entrance', null);
                this.form.setControlVisibility('flat', false);
                this.form.setControlVisibility('entrance', false);
                this.form.setControlVisibility('Question_Building', false);
                this.form.setControlVisibility('Question_Organization', false);
                document.getElementById('Question_Btn_Add').disabled = true;
            } else {
                this.getOrgExecut();
                this.onQuestionControlDate(questionType);
                this.questionObjectOrg();
            }
        },
        getOrgExecut: function() {
            const objAndOrg = {
                queryCode: 'getOrganizationExecutor',
                parameterValues: [
                    {
                        key: '@question_type_id',
                        value: this.form.getControlValue('Question_TypeId')
                    },
                    {
                        key: '@object_id',
                        value: this.form.getControlValue('Question_Building')
                    },
                    {
                        key: '@organization_id',
                        value: this.form.getControlValue('Question_Organization')
                    }
                ]
            };
            this.queryExecutor.getValues(objAndOrg).subscribe(data => {
                this.form.setControlValue('Question_OrganizationId',
                    { key: data.rows[0].values[0], value: data.rows[0].values[1] });
            });
        },
        onQuestionControlDate: function(ques_type_id) {
            if (ques_type_id === null) {
                this.form.setControlValue('Question_ControlDate', null)
            } else {
                const execute = {
                    queryCode: 'list_onExecuteTerm',
                    parameterValues: [{
                        key: '@q_type_id',
                        value: ques_type_id
                    }]
                };
                this.queryExecutor.getValues(execute).subscribe(data => {
                    const d = data.rows[0].values[0];
                    const dat = d.replace('T', ' ').slice(0, 16);
                    this.form.setControlValue('Question_ControlDate', dat)
                });
            }
        },
        onChangedQuestion_AnswerType: function(value) {
            this.form.setControlValue('Question_AnswerPhoneOrPost', null);
            if (value === 2) {
                this.form.setControlValue('Question_AnswerPhoneOrPost', this.form.getControlValue('CardPhone'));
            }
            if (value === 4 || value === 5) {
                this.form.setControlValue('Question_AnswerPhoneOrPost', this.form.getControlValue('applicantAddress'));
            }
            if (value === 3) {
                this.form.setControlValue('Question_AnswerPhoneOrPost', this.form.getControlValue('Applicant_Email'));
            }
            this.checkQuestionRegistrationAvailable();
        },
        checkQuestionRegistrationAvailable: function() {
            let questionBuilding = this.form.getControlValue('Question_Building');
            let questionOrg = this.form.getControlValue('Question_Organization');
            let questionContent = this.form.getControlValue('Question_Content');
            let howToAnswer = this.form.getControlValue('Question_AnswerType');
            if (this.form.getControlValue('Question_TypeId') !== null) {
                if (this.is_obj === true && this.is_org === true) {
                    if (
                        ((questionBuilding === undefined) || (questionBuilding === null))
                        ||
                        ((questionOrg === undefined) || (questionOrg === null))
                        ||
                        ((questionContent === '') || (questionContent === null))
                        ||
                        ((howToAnswer === undefined) || (howToAnswer === null))
                    ) {
                        document.getElementById('Question_Btn_Add').disabled = true;
                        this.form.setControlValue('flat', null);
                        this.form.setControlValue('entrance', null);
                    } else {
                        document.getElementById('Question_Btn_Add').disabled = false;
                    }
                }
                if (this.is_obj === true && this.is_org === false) {
                    if ((questionBuilding === undefined) || (questionBuilding === null)
                        ||
                        ((questionContent === undefined) || (questionContent === null))
                        ||
                        ((howToAnswer === undefined) || (howToAnswer === null))) {
                        document.getElementById('Question_Btn_Add').disabled = true;
                        this.form.setControlValue('flat', null);
                        this.form.setControlValue('entrance', null);
                    } else {
                        document.getElementById('Question_Btn_Add').disabled = false;
                    }
                }
                if (this.is_obj === false && this.is_org === true) {
                    if ((questionOrg === undefined) || (questionOrg === null)
                        ||
                        ((questionContent === undefined) || (questionContent === null))
                        ||
                        ((howToAnswer === undefined) || (howToAnswer === null))) {
                        document.getElementById('Question_Btn_Add').disabled = true;
                        this.form.setControlValue('flat', null);
                        this.form.setControlValue('entrance', null);
                    } else {
                        document.getElementById('Question_Btn_Add').disabled = false;
                    }
                }
            }
        },
        getBuildingInfo: function(building) {
            const findBuilding = {
                queryCode: 'SelectBuildName',
                parameterValues: [{
                    key: '@Id',
                    value: building
                }]
            };
            this.queryExecutor.getValues(findBuilding).subscribe(data => {
                this.form.setControlValue('Question_Building',
                    { key: data.rows[0].values[0], value: data.rows[0].values[1] });
            });
            this.form.setControlValue('flat', this.form.getControlValue('Applicant_Flat'));
            this.form.setControlValue('entrance', this.form.getControlValue('Applicant_Entrance'));
        },
        convertDateNull: function(value) {
            if (!value) {
                return this.extractStartDate();
            }
            return value;
        },
        onChanged_Search_Appeals_Input: function(value) {
            if (value === '') {
                document.getElementById('Search_Appeals_Search').disabled = true;
            } else {
                document.getElementById('Search_Appeals_Search').disabled = false;
            }
        },
        getDistrictAndExecutor: function() {
            let building = this.form.getControlValue('Applicant_Building');
            if (building !== null && typeof (building) === 'number') {
                const query = {
                    queryCode: 'DistrictAndExecutor_byBuilding',
                    parameterValues: [{
                        key: '@building_id',
                        value: building
                    }]
                };
                this.queryExecutor.getValues(query).subscribe(function(data) {
                    if (data.rows[0] !== undefined) {
                        this.form.setControlValue('Applicant_District', data.rows[0].values[1]);
                        this.form.setControlValue('ExecutorInRoleForObject', data.rows[0].values[2]);
                    }
                }.bind(this));
            } else {
                this.form.setControlValue('Applicant_District', null);
                this.form.setControlValue('ExecutorInRoleForObject', null);
            }
        }
    };
}());
