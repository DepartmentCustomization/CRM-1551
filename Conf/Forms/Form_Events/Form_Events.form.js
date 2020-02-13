(function() {
    return {
        Detail_History: function(column, row) {
            const parameters = [
                { key: '@history_id', value: row.values[0] }
            ];
            this.details.loadData('EventHistory_Details', parameters);
            this.details.setVisibility('EventHistory_Details', true);
        },
        init: function() {
            if (this.form.getControlValue('real_end_date') != null) {
                this.navigateTo('/sections/Events/view/' + this.id);
            }
            this.details.setVisibility('EventHistory_Details', false);
            this.details.onCellClick('EventHistory', this.Detail_History.bind(this));
            if (this.state == 'create') {
                this.details.setVisibility('Detail_EventQuestionsTypes', false);
                this.details.setVisibility('Detail_EventQuestionsTypes_create', true);
            } else if (this.state == 'update') {
                this.details.setVisibility('Detail_EventQuestionsTypes', true);
                this.details.setVisibility('Detail_EventQuestionsTypes_create', false);
            }
            this.form.disableControl('event_id');
            this.form.disableControl('object_id');
            this.form.disableControl('active');
            if (this.form.getControlValue('real_end_date') == null) {
                document.getElementById('active_button').disabled = true;
            }
            this.form.onControlValueChanged('real_end_date', this.changeOndateFact.bind(this));
            const formNewContact = {
                title: 'Аудіофайл',
                acceptBtnText: 'save',
                cancelBtnText: 'cancel',
                fieldGroups: [{
                    code: 'file',
                    expand: true,
                    position: 1,
                    fields: [
                        {
                            code: 'audioFile',
                            placeholder: 'Виберіть файл',
                            hidden: false,
                            required: false,
                            fullScreen: true,
                            type: 'file'
                        }
                    ]
                }]
            }
            document.getElementById('active_button').addEventListener('click', function(event) {
                event.stopImmediatePropagation();
                const Question_Close_callback = (response) => {
                    if (!response) {
                        this.form.setControlValue('real_end_date', null);
                    } else {
                        const objName = {
                            queryCode: 'ak_CloseEvent',
                            parameterValues: [{
                                key: '@Id',
                                value: this.id
                            },
                            {
                                key: '@real_end_date',
                                value: this.form.getControlValue('real_end_date')
                            },
                            {
                                key: '@coment_executor',
                                value: this.form.getControlValue('coment_executor')
                            }
                            ]
                        };
                        this.queryExecutor.getValues(objName).subscribe(() => {
                        });
                        this.navigateTo('/sections/Events/view/' + this.id);
                    }
                };
                const fieldsForm = {
                    title: ' ',
                    text: 'Підтвердити закриття заходу?',
                    acceptBtnText: 'yes',
                    cancelBtnText: 'no'
                };
                this.openModalForm(fieldsForm, Question_Close_callback.bind(this));
            }.bind(this));
            this.form.onControlValueChanged('ObjectTypesId', this.onStreetsChanged);
            const addContactCallBack = (param) => {
                if (param === true) {
                    const body = {
                        parameterValues: param
                    }
                    this.queryExecutor.getValues(body).subscribe(() => {
                    });
                }
            }
            let icon = document.getElementById('fileIcon');
            icon.addEventListener('click', (e) => {
                e.stopPropagation();
                this.openModalForm(formNewContact, addContactCallBack);
            });
            icon.style.fontSize = '20px';
            if (this.state != 'create') {
                this.form.disableControl('event_id');
                this.form.disableControl('event_class_id');
                this.form.disableControl('event_type_id');
                this.form.disableControl('ObjectTypesId');
                this.form.disableControl('object_id');
                this.form.disableControl('executor_id');
                this.form.disableControl('comment');
                this.form.disableControl('start_date');
                this.form.disableControl('active');
                if (this.form.getControlValue('real_end_date') != null) {
                    this.form.disableControl('plan_end_date');
                    this.form.disableControl('real_end_date');
                    document.getElementById('active_button').disabled = true;
                }
            }
            this.form.onControlValueChanged('event_class_id', this.onEventQueType);
            this.questions();
        },
        questions: function() {
            const param2 = [{ key: '@Id', value: this.id }];
            this.details.loadData('Detail_Event_Questions', param2);
            this.details.loadData('P_Question', param2);
        },
        onEventQueType: function(type_id) {
            if (typeof type_id === 'string') {
                return
            }
            const param = [{ key: '@Id', value: type_id }];
            this.details.loadData('Detail_EventQuestionsTypes_create', param);
        },
        changeOndateFact: function(value) {
            const start_date = this.form.getControlValue('start_date');
            if (value == null) {
                document.getElementById('active_button').disabled = true;
            } else {
                if (value < start_date) {
                    this.openPopUpInfoDialog('Дата закриття неможе буди меньшою за дату відкриття!');
                    this.form.setControlValue('real_end_date', null);
                } else {
                    document.getElementById('active_button').disabled = false;
                }
            }
        },
        onStreetsChanged: function(dis_id) {
            if (typeof dis_id === 'string') {
                return
            } else if (dis_id == null) {
                this.form.setControlValue('object_id', null);
                let dependParams = [{ parameterCode: '@ObjectTypesId', parameterValue: dis_id }];
                this.form.setControlParameterValues('object_id', dependParams);
                this.form.disableControl('object_id');
            } else {
                let dependParams = [{ parameterCode: '@ObjectTypesId', parameterValue: dis_id }];
                this.form.setControlParameterValues('object_id', dependParams);
                this.form.enableControl('object_id');
            }
        },
        afterSave: function(data) {
            if (this.state == 'create') {
                this.navigateTo('sections/Events/edit/' + data.rows[0].values[0])
            }
        }
    };
}());