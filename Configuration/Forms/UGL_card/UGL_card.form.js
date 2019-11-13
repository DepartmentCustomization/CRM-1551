(function () {
    return {

        init: function () {

            if (this.state == "create") {
                var getDataFromLink = window
                    .location
                    .search
                    .replace('?', '')
                    .split('&')
                    .reduce(
                        function (p, e) {
                            var a = e.split('=');
                            p[decodeURIComponent(a[0])] = decodeURIComponent(a[1]);
                            return p;
                        }, {}
                    );

                let uglId;
                if (getDataFromLink["uglId"] == undefined) {
                    uglId = 'невідомо';
                } else {
                    uglId = getDataFromLink["uglId"]
                };

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
            }
            else { // state != create
                this.form.setControlValue('AppealId', this.id);

                document.getElementsByClassName('float_r')[0].children[1].style.display = 'none';
                document.getElementById('Question_Btn_Add').disabled = true;

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

                this.form.setControlValue('ReceiptSources', { key: 3, value: 'УГЛ' });
                this.form.onControlValueChanged('Question_AnswerType', this.onChangedQuestion_AnswerType.bind(this));

                this.details.setVisibility('Detail_UGL_QuestionNumberAppeal', false);
                // Если Applicant_Id в форме не задан то создавать Questions еще рано (заявителя нету)
                if (this.form.getControlValue('Applicant_Id') == null) {
                    document.getElementById('Question_Aplicant_Btn_Add').disabled = true;
                };
                this.form.onControlValueChanged('Applicant_Id', this.checkApplicantHere);
                this.form.setGroupVisibility('UGL_Group_CreateQuestion', false);

                if (this.form.getControlValue('Applicant_PIB') == null) { document.getElementById('Applicant_Btn_Add').disabled = true; };

                this.form.onControlValueChanged('Applicant_PIB', this.checkApplicantSaveAvailable);
                this.form.onControlValueChanged('Question_TypeId', this.onChanged_Question_TypeId);
                this.form.onControlValueChanged('Question_Content', this.checkQuestionRegistrationAvailable);
                // Заполнение полей "Загальна інформація"          
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
                    this.form.setControlValue('Applicant_Phone_Hide', data.rows[0].values[3]);
                    this.form.setControlValue('Applicant_PIB', data.rows[0].values[4]);
                    this.form.setControlValue('Question_Content', data.rows[0].values[5]);
                    this.form.setControlValue('ApplicantUGL', data.rows[0].values[6]);
                    this.form.setControlValue('AppealNumber', data.rows[0].values[8]);

                    // Загрузка заявителей по телефону в деталь
                    const parameters = [
                        { key: '@applicant_phone', value: this.form.getControlValue('CardPhone') }
                    ];
                    this.details.loadData('Detail_UGL_Aplicant', parameters);
                });
                // Получение данных выбранного из детали заявителя по телефону             
                this.details.onCellClick('Detail_UGL_Aplicant', this.getApplicantInfo.bind(this));

                //Кнопка "Зберегти" в группе "Заявник"
                document.getElementById('Applicant_Btn_Add').addEventListener("click", function (event) {
                    const queryForGetValue2 = {
                        queryCode: 'Applicant_Btn_Add_InsertRow',
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
                                value: this.form.getControlValue('Phone')
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

                        this.queryExecutor.getValues(queryForGetValue3).subscribe(data => {

                            //LoadDetail Detail_UGL_Aplicant
                            const parameters = [
                                { key: '@phone_number', value: this.form.getControlValue('Phone') }
                            ];
                            this.details.loadData('Detail_UGL_Aplicant', parameters);

                            //Detail_UGL_QuestionRegistration
                            const parameters2 = [
                                { key: '@appealId', value: data.rows[0].values[0] }
                            ];
                            this.details.loadData('Detail_UGL_QuestionRegistration', parameters2);

                            this.onRecalcCardPhone();
                        });

                        this.checkApplicantSaveAvailable();
                    });
                    document.getElementById('Applicant_Btn_Add').disabled = true;
                }.bind(this));

                //Кнопка "Очистити" в группе "Заявник"
                document.getElementById('Applicant_Btn_Clear').addEventListener("click", function (event) {

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
                    this.form.setControlValue('Applicant_Phone_Hide', null);
                   
                }.bind(this));
                // Отработка кнопки "Додати питання"
                document.getElementById('Question_Aplicant_Btn_Add').addEventListener("click", function (event) {
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
            //Кнопка "Зберегти" в группе "Реєстрація питання"
            document.getElementById('Question_Btn_Add').addEventListener("click", function (event) {
                const queryForGetValue3 = {
                    queryCode: 'Question_Btn_Add_InsertRow',
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
                            value: this.form.getControlValue('Phone')
                        },
                        {
                            key: '@Applicant_Email',
                            value: this.form.getControlValue('Applicant_Email')
                        },
                        {
                            key: '@Applicant_Building',
                            value: this.form.getControlValue('Adress_for_answer')
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
                        }
                    ]
                };
                this.queryExecutor.getValues(queryForGetValue3).subscribe(data => {
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
                        // this.form.setControlValue('DateStart', new Date(data.rows[0].values[10]));
                        this.form.setControlValue('DateStart', new Date());
                        //LoadDetail Detail_UGL_Aplicant
                        const parameters = [
                            { key: '@phone_number', value: data.rows[0].values[5] }
                        ];
                        this.details.loadData('Detail_UGL_Aplicant', parameters);
                        //LoadDetail Detail_UGL_QuestionRegistration
                        const parameters2 = [
                            { key: '@appealId', value: this.id }
                        ];
                        this.details.loadData('Detail_UGL_QuestionRegistration', parameters2);
                    });
                });
                this.form.setControlValue('Question_Organization', {});
                this.form.setControlValue('Question_Content', "");
                this.form.setControlValue('Question_TypeId', {});
                this.form.setControlValue('Question_OrganizationId', {});
                this.form.setControlValue('Question_ControlDate', "");
                this.form.setControlValue('Question_EventId', null);
            }.bind(this));
            //Кнопка "Пошук" (за № Звернення) в группе "Загальна інформація"
            this.form.onControlValueChanged('Search_Appeals_Input', this.onChanged_Search_Appeals_Input.bind(this));
            document.getElementById('Search_Appeals_Search').disabled = true;
            document.getElementById('Search_Appeals_Search').addEventListener("click", function (event) {
              //Detail_QuestionNumberAppeal
                const parameters = [
                    { key: '@AppealRegistrationNumber', value: this.form.getControlValue('Search_Appeals_Input') }
                ];
                this.details.loadData('Detail_UGL_QuestionNumberAppeal', parameters/*, filters, sorting*/);
                this.details.setVisibility('Detail_UGL_QuestionNumberAppeal', true);
            }.bind(this));
        },
        // END INIT
        checkApplicantHere: function () {
            if (this.form.getControlValue('Applicant_Id') != null) {
                document.getElementById('Question_Aplicant_Btn_Add').disabled = false;
            }
            else {
                document.getElementById('Question_Aplicant_Btn_Add').disabled = true;
            };
        },
        // Условие доступности сохранения заявителя
        checkApplicantSaveAvailable: function () {
            if (this.form.getControlValue('Applicant_PIB') == null) {
                document.getElementById('Applicant_Btn_Add').disabled = true;
            }
            else {
                document.getElementById('Applicant_Btn_Add').disabled = false;
            };
        },
        //Получение данных заявителя
        getApplicantInfo: function (column, row, value, event, indexOfColumnId) {
            let applicantId = row.values[4];
            console.log(applicantId);

            const Applicant = {
                queryCode: 'Applicant_Info',
                parameterValues: [
                    {
                        key: '@applicantId',
                        value: applicantId
                    }
                ]
            }

            // Наполнение полей заявителя данными выбраного с детали
            this.queryExecutor.getValues(Applicant).subscribe(data => {

                let BirthDate = null;
                if (data.rows[0].values[14] == null) {
                    BirthDate = null;
                } else {
                    BirthDate = new Date(data.rows[0].values[14]);
                };

                let sex = null;
                if (data.rows[0].values[13] == null) {
                    sex = null;
                } else {
                    sex = (data.rows[0].values[13]).toString();
                };

                console.log(data);
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
            });
        },
        onRecalcCardPhone: function () {
            const queryForGetValue_RecalcPhone = {
                queryCode: 'ApplicantPhonesRecalcCardPhone',
                parameterValues: [{ key: '@Applicant_id', value: this.form.getControlValue('Applicant_Id') }]
            };

            this.queryExecutor.getValues(queryForGetValue_RecalcPhone).subscribe(function (data) {
                this.form.setControlValue('CardPhone', data.rows[0].values[0]);
            }.bind(this));

            const queryForGetValue_GetIsMainPhone = {
                queryCode: 'GetApplicantPhonesIsMain',
                parameterValues: [{ key: '@Applicant_id', value: this.form.getControlValue('Applicant_Id') }]
            };

            this.queryExecutor.getValues(queryForGetValue_GetIsMainPhone).subscribe(function (data) {
                this.form.setControlValue('Applicant_Phone_Hide', data.rows[0].values[0]);
            }.bind(this));
        },
        // Подстановка ответственной организации и контрольной даты по типу вопроса 
        onChanged_Question_TypeId: function () {
            let questionType = this.form.getControlValue('Question_TypeId');
            this.getOrgExecut();
            this.onQuestionControlDate(questionType);
            this.checkQuestionRegistrationAvailable();
        },
        getOrgExecut: function () {
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
        // Проставить дату контроля
        onQuestionControlDate: function (ques_type_id) {
            if (ques_type_id == null) {
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
        // При изменении типа ответа
        onChangedQuestion_AnswerType: function (value) {
            this.form.setControlValue('Question_AnswerPhoneOrPost', null);
            if (value == 2) {
                this.form.setControlValue('Question_AnswerPhoneOrPost', this.form.getControlValue('Applicant_Phone_Hide'));
            };

            if (value == 4 || value == 5) {
                this.form.setControlValue('Question_AnswerPhoneOrPost', this.form.getControlValue('Adress_for_answer'));
            };

            if (value == 3) {
                this.form.setControlValue('Question_AnswerPhoneOrPost', this.form.getControlValue('Applicant_Email'));
            };
            this.checkQuestionRegistrationAvailable();
        },
        // Условия допустимости регистрации Questions`a
        checkQuestionRegistrationAvailable: function () {
            if (this.form.getControlValue('Question_Content') != null
                && this.form.getControlValue('Question_TypeId') != null
                && this.form.getControlValue('Question_AnswerType') != null) {
                document.getElementById('Question_Btn_Add').disabled = false;
            }
            else {
                document.getElementById('Question_Btn_Add').disabled = true;
            }
        },
        // Если надо по Id дома найти его полный адрес
        getBuildingInfo: function (building) {
            const findBuilding = {
                queryCode: 'SelectBuildName',
                parameterValues: [{
                    key: '@Id',
                    value: building
                }]
            };
            // И подставить объект вопроса = дом заявителя
            this.queryExecutor.getValues(findBuilding).subscribe(data => {
                this.form.setControlValue('Question_Building',
                    { key: data.rows[0].values[0], value: data.rows[0].values[1] });
            });
        },
        convertDateNull: function (value) {
            if (!value) { return this.extractStartDate(); } else { return value; };
        },
        onChanged_Search_Appeals_Input: function(value) {
            if(value == "") {
                //   this.form.disableControl('Search_Appeals_Search');
                document.getElementById('Search_Appeals_Search').disabled = true;
            } else { 
                //   this.form.enableControl('Search_Appeals_Search');
                document.getElementById('Search_Appeals_Search').disabled = false;
            };
        },
    };
}());
