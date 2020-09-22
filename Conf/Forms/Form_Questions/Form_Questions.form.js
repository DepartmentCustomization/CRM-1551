(function() {
    return {
        Detail_History: function(column, row) {
            const parameters = [
                { key: '@history_id', value: row.values[0]}
            ];
            this.details.loadData('Question_History', parameters);
            this.details.setVisibility('Question_History', true);
        },
        validate: function() {
            let controlDate = this.form.getControlValue('control_date');
            let today = new Date();
            if(controlDate > today) {
                return true;
            }
            return 'Дата контролю менша за поточну';
        },
        checkAttentionVal() {
            let attentionVal = this.form.getControlValue('attention_val');
            if(attentionVal === 1) {
                document.getElementById('btn_Attention').style.background = '#3498DB';
                document.getElementById('btn_Attention').style.color = 'white';
                document.getElementById('btn_Attention').innerHTML = 'Зняти з контролю';
            } else if(attentionVal === 0) {
                document.getElementById('btn_Attention').style.background = 'white';
                document.getElementById('btn_Attention').style.color = 'black';
                document.getElementById('btn_Attention').innerHTML = 'Взяти на контроль';
            }
        },
        init:function() {
            let state = this.form.getControlValue('question_state_id');
            this.form.disableControl('geolocation_lat');
            this.form.disableControl('geolocation_lon');

            if (state === 5) {
                this.navigateTo('/sections/Questions/view/' + this.id);
            } else if (state === 2 || state === 3) {
                this.form.disableControl('question_type_id');
                this.form.disableControl('object_id');
                this.form.disableControl('perfom_id');
                this.form.disableControl('question_content');
            }

            if (this.form.getControlValue('geolocation_lat')) {
                this.form.enableControl('geolocation_map');
                document.getElementById('geolocation_map').disabled = false;
            } else {
                this.form.disableControl('geolocation_map');
                document.getElementById('geolocation_map').disabled = true;
            }
            document.getElementById('geolocation_map').addEventListener('click', function() {
                window.open(String(location.origin + localStorage.getItem('VirtualPath')
                    + '/dashboard/page/SearchGoogle?lat=' + this.form.getControlValue('geolocation_lat')
                    + '&lon=' + this.form.getControlValue('geolocation_lon')));
            }.bind(this));
            this.details.setVisibility('Question_History', false);
            this.details.onCellClick('Detail_Que_Hisroty', this.Detail_History.bind(this));
            const onChangeStatus = {
                queryCode: 'Question_RightsFilter_HideAndDisableColumns',
                parameterValues: []
            };
            this.queryExecutor.getValues(onChangeStatus).subscribe(data => {
                if (data.rows.length > 0) {
                    for (let i = 0; i < data.rows.length; i++) {
                        if(data.rows[i].values[1] === 'disable') {
                            this.form.disableControl(data.rows[i].values[0]);
                        }
                        if(data.rows[i].values[1] === 'hide') {
                            this.form.setControlVisibility(data.rows[i].values[0], false);
                        }
                    }
                }
            });
            this.form.disableControl('registration_number');
            this.form.disableControl('registration_date');
            this.form.disableControl('app_registration_number');
            this.form.disableControl('full_name');
            this.form.disableControl('user_name');
            this.form.disableControl('question_state_id');
            this.form.disableControl('ass_result_id');
            this.form.disableControl('ass_resolution_id');
            this.form.disableControl('address_problem');
            this.form.disableControl('districts_id');
            this.onQuestionFromSiteAppeal();
            this.checkAttentionVal();
            let btn_Attention = document.getElementById('btn_Attention');
            let flag_is_state = this.form.getControlValue('flag_is_state');
            if (flag_is_state === 1) {
                this.form.enableControl('object_id');
                this.form.enableControl('question_type_id');
                this.form.enableControl('perfom_id');
            }
            let statettt = document.getElementById('question_state_id');
            statettt.style.fontWeight = 'bold';
            let btn_goToApplicant = document.getElementById('full_nameIcon');
            btn_goToApplicant.style.fontSize = '25px';
            btn_goToApplicant.addEventListener('click', () => {
                let appl_id = this.form.getControlValue('appl_id');
                this.navigateTo('/sections/Applicants/edit/' + appl_id)
            });
            let btn_goToAppeal = document.getElementById('app_registration_numberIcon');
            btn_goToAppeal.style.fontSize = '25px';
            btn_goToAppeal.addEventListener('click', () =>{
                let ques_id = this.form.getControlValue('appeal_id');
                this.navigateTo('/sections/Appeals/view/' + ques_id)
            });
            let answer = this.form.getControlValue('answer_type_id');
            if (answer === 1) {
                this.form.setControlVisibility('answer_post',false);
                this.form.setControlVisibility('answer_phone',false);
                this.form.setControlVisibility('answer_mail', false);
            }
            if (answer === 2) {
                this.form.setControlVisibility('answer_phone',true);
                this.form.setControlVisibility('answer_post', false);
                this.form.setControlVisibility('answer_mail', false);
            }
            if (answer === 3) {
                this.form.setControlVisibility('answer_mail',true);
                this.form.setControlVisibility('answer_phone',false);
                this.form.setControlVisibility('answer_post', false);
            }
            if (answer === 4 || answer === 5) {
                this.form.setControlVisibility('answer_post',true);
                this.form.setControlVisibility('answer_phone',false);
                this.form.setControlVisibility('answer_mail', false);
            }
            btn_Attention.addEventListener('click', function() {
                let attention_val = this.form.getControlValue('attention_val');
                let queryCode;
                if(attention_val === 0) {
                    queryCode = 'InsertAttentionRow';
                } else if(attention_val === 1) {
                    queryCode = 'DeleteAttentionRow';
                }
                const queryForAttention = {
                    queryCode: queryCode,
                    parameterValues: [
                        {
                            key: '@question_id',
                            value: this.form.getControlValue('question_id')
                        }
                    ]
                };
                this.queryExecutor.getValue(queryForAttention).subscribe((val) => {
                    if(val === 1) {
                        this.form.setControlValue('attention_val', 1);
                    } else if(val === 0) {
                        this.form.setControlValue('attention_val', 0);
                    }
                    this.checkAttentionVal();
                })
            }.bind(this));
            document.getElementById('add_Assignment').addEventListener('click', function() {
                const queryForInsert = {
                    queryCode: 'cx_test_Procedur_Insert',
                    parameterValues: [
                        {
                            key: '@question_id',
                            value: this.form.getControlValue('question_id')
                        },
                        {
                            key: '@question_type_id',
                            value: this.form.getControlValue('question_type_id')
                        },
                        {
                            key: '@object_id',
                            value: this.form.getControlValue('object_id')
                        },
                        {
                            key: '@organization_execut',
                            value: this.form.getControlValue('organization_id')
                        },
                        {
                            key: '@dictrict',
                            value: this.form.getControlValue('districts_id')
                        },
                        {
                            key: '@user_id',
                            value: this.user.userId
                        }
                    ]
                };
                this.queryExecutor.getValues(queryForInsert).subscribe(() => {
                })
            }.bind(this));
            document.getElementById('add_Complain').addEventListener('click', function() {
                let currentUserName = (this.user.lastName + ' ' + this.user.firstName);
                const formAddComplain = {
                    title: 'Створити скаргу',
                    acceptBtnText: 'save',
                    cancelBtnText: 'cancel',
                    fieldGroups: [
                        {
                            code: 'compl',
                            expand: true,
                            position: 1,
                            fields:[
                                {
                                    code: 'complain_type_id',
                                    placeholder:'Тип скарги',
                                    hidden: false,
                                    required: true,
                                    position: 1,
                                    fullScreen: true,
                                    queryListCode: 'list_complain_type',
                                    listDisplayColumn: 'name',
                                    listKeyColumn: 'Id',
                                    type: 'select'
                                },
                                {
                                    code:'culpritname',
                                    placeholder:'Скаржник',
                                    hidden: false,
                                    required: true,
                                    position: 2,
                                    fullScreen: true,
                                    value: currentUserName,
                                    type: 'text'
                                },
                                {
                                    code: 'guilty',
                                    placeholder:'Винуватець',
                                    hidden: false,
                                    required: true,
                                    position: 1,
                                    fullScreen: true,
                                    queryListCode: 'list_Question_Executors',
                                    listDisplayColumn: 'name',
                                    listKeyColumn: 'Id',
                                    type: 'select'
                                },
                                {
                                    code:'text',
                                    placeholder:'Коментар',
                                    hidden: false,
                                    required: false,
                                    position: 4,
                                    fullScreen: true,
                                    value: this.form.getControlValue('registration_number'),
                                    type: 'textarea'
                                }
                            ]
                        }
                    ]
                };
                const addComplain = (param) => {
                    if(param !== false) {
                        const body = {
                            queryCode: 'cx_Complains_Insert',
                            parameterValues: param
                        }
                        this.queryExecutor.getValues(body).subscribe((data) => {
                            if(data.rows[0].values[0] === 'OK') {
                                let message = 'Скаргу зареєстровано';
                                this.openPopUpInfoDialog(message);
                            }
                        });
                    }
                };
                this.openModalForm(formAddComplain, addComplain);
            }.bind(this));
            this.form.onControlValueChanged('question_type_id', this.onChanged_Question_TypeId);
            this.form.onControlValueChanged('answer_type_id', this.onChangedQuestion_AnswerType);
        },
        onQuestionFromSiteAppeal: function() {
            let source = this.form.getControlValue('receipt_source_id');
            let siteVal = 2;
            if(source === siteVal) {
                const getMail = {
                    queryCode: 'setMailAnswerForSiteAppeal',
                    parameterValues: [{
                        key: '@Id',
                        value: this.id
                    }]
                };
                this.queryExecutor.getValue(getMail).subscribe(data => {
                    if(data) {
                        let mailAnswer = 3;
                        this.form.setControlValue('answer_type_id',{ key: mailAnswer, value: 'На E-mail'});
                        this.form.setControlValue('answer_mail', data);
                    }
                });
            }
        },
        onChangedQuestion_AnswerType:function(value) {
            const allp_info = {
                queryCode: 'Answer_Applicant_info',
                parameterValues: [{key: '@id_con', value: this.form.getControlValue('appl_id')}]
            }
            this.queryExecutor.getValues(allp_info).subscribe(data => {
                this.form.setControlValue('answer_phone',data.rows[0].values[2]);
                this.form.setControlValue('answer_post', data.rows[0].values[3]);
                this.form.setControlValue('answer_mail', data.rows[0].values[1]);
            });
            if(value === 1 || value === null) {
                this.form.setControlValue('answer_phone', null);
                this.form.setControlValue('answer_mail', null);
                this.form.setControlValue('answer_post', null);
                this.form.setControlVisibility('answer_post',false);
                this.form.setControlVisibility('answer_phone',false);
                this.form.setControlVisibility('answer_mail', false);
            }
            if(value === 2) {
                this.form.setControlVisibility('answer_phone',true);
                this.form.setControlVisibility('answer_post', false);
                this.form.setControlVisibility('answer_mail', false);
            }
            if(value === 3) {
                this.form.setControlVisibility('answer_mail',true);
                this.form.setControlVisibility('answer_phone',false);
                this.form.setControlVisibility('answer_post', false);
            }
            if(value === 4 || value === 5) {
                this.form.setControlVisibility('answer_post',true);
                this.form.setControlVisibility('answer_phone',false);
                this.form.setControlVisibility('answer_mail', false);
            }
        },
        onChanged_Question_TypeId: function(value) {
            if (typeof value === 'string') {
                return
            }
            const objAndOrg = {
                queryCode: 'QuestionTypes_HideColumns',
                parameterValues: [{
                    key: '@question_type_id',
                    value: this.form.getControlValue('question_type_id')
                }]
            };
            this.queryExecutor.getValues(objAndOrg).subscribe(data => {
                if (data.rows.length > 0) {
                    if (data.rows[0].values[0]) {
                        this.form.setControlVisibility('organization_id', true);
                    } else {
                        this.form.setControlVisibility('organization_id', false);
                    }
                    if (data.rows[0].values[1]) {
                        this.form.setControlVisibility('object_id', true);
                    } else {
                        this.form.setControlVisibility('object_id', false);
                    }
                } else {
                    this.form.setControlVisibility('object_id', true);
                    this.form.setControlVisibility('organization_id', true);
                }
            });
        }
    };
}());
