(function() {
    return {
        Detail_History: function(column, row, value, event, indexOfColumnId) {
            const parameters = [
                { key: '@history_id', value: row.values[0] }
            ];
            this.details.loadData('detal_history', parameters /*, filters, sorting*/ );
            this.details.setVisibility('detal_history', true);

        },

        date_in_form: '',
        previous_result: '',

        init: function() {

            // в поле виконавець выводить только подрядные огранизации, родитель - Assignments.organization_id на кого пришло доручення
            let param_ass_id = [
                { parameterCode: '@ass_id', parameterValue: this.id }
            ];
            this.form.setControlParameterValues('performer_id', param_ass_id);

            console.log(this.user);
            this.date_in_form = this.form.getControlValue('date_in_form')
            this.previous_result = this.form.getControlValue('result_id')

            this.details.setVisibility('detal_history', false);
            this.details.onCellClick('Detail_Assig_HistoryAssig', this.Detail_History.bind(this));


            let btn_goToQuestion = document.getElementById('registration_numberIcon');
            btn_goToQuestion.style.fontSize = '25px';
            btn_goToQuestion.addEventListener('click', e => {
                let ques_id = this.form.getControlValue('question_id');
                this.navigateTo('/sections/Questions/edit/' + ques_id)
            });

            const onChangeStatus = {
                queryCode: 'RightsFilter_HideAndDisableColumns',
                parameterValues: []
            };
            this.queryExecutor.getValues(onChangeStatus).subscribe(data => {
                if (data.rows.length > 0) {
                    for (var i = 0; i < data.rows.length; i++) {
                        console.log(data.rows[i].values);
                        if (data.rows[i].values[1] == 'disable') {
                            this.form.disableControl(data.rows[i].values[0]);
                        };

                        if (data.rows[i].values[1] == 'hide') {
                            this.form.setControlVisibility(data.rows[i].values[0], false);
                        };

                    }

                };
            });


            this.form.onControlValueChanged('resolution_id', this.onChangeStatus.bind(this));


            this.form.disableControl('registration_number');
            this.form.disableControl('receipt_source_id');
            this.form.disableControl('que_reg_date');
            this.form.disableControl('full_name');
            this.form.disableControl('LiveAddress');
            this.form.disableControl('object_name');
            this.form.disableControl('organization_id');
            this.form.disableControl('address_problem');
            this.form.disableControl('obj_type_id');
            this.form.disableControl('control_date');
            this.form.disableControl('question_content');
            this.form.disableControl('bal_name');
            this.form.disableControl('main_executor');
            this.form.disableControl('registration_date');
            this.form.disableControl('resolution_id');
            this.form.disableControl('ass_state_id');
            this.form.disableControl('rework_counter');
            this.form.disableControl('ass_type_id');
            this.form.disableControl('responsible');
            this.form.disableControl('phones');
            this.form.disableControl('answer');
            // this.form.disableControl('executor_person_id');
            //enter_number
            this.form.disableControl('enter_number');

            this.details.onCellClick('Detail_Assig_otherQues', this.goToAssigView.bind(this));

            let rework_count = this.form.getControlValue('rework_counter');
            console.log('Счетчик равен: ' + rework_count);

            if (rework_count > 0) {
                this.form.setControlVisibility('rework_counter', true);
            } else {
                this.form.setControlVisibility('rework_counter', false);
            };


            this.form.setControlVisibility('control_comment', false);
            this.form.setControlVisibility('transfer_to_organization_id', false);


            let ass_state_id = this.form.getControlValue('ass_state_id');
            let result_id = this.form.getControlValue('result_id');
            let resolution_id = this.form.getControlValue('resolution_id');

            //ПОКА ВРЕМЕННО УБРАЛ ПРАВИЛО БЛОКИРОВКИ ДЛЯ ЛЮДЕЙ У КОТОРЫХ НЕТ ЗАПРЕТОВ
            // 		const compareExecutor123 = {
            //                 queryCode: 'RightsFilter_AssignmentStates',
            //                 parameterValues: [{key: '@AssignmentId', value: this.id}, {key: '@res_id', value: 0 }, {key: '@pageOffsetRows', value: 0 }, {key: '@pageLimitRows', value: 9 }]
            //             };
            //             this.queryExecutor.getValues(compareExecutor123).subscribe(data => {
            //               if (data.rows.length == 0) {
            //                    this.form.disableControl('result_id');
            //                    this.form.disableControl('resolution_id');
            //               };
            //             });

            const noChoose1 = [{ parameterCode: '@AssignmentId', parameterValue: this.id }, { parameterCode: '@res_id', parameterValue: 0 }];
            this.form.setControlParameterValues('result_id', noChoose1);

            const execute = {
                queryCode: 'dir_tree_day_assigments',
                parameterValues: [{
                    key: '@registration_date',
                    value: this.form.getControlValue('registration_date')
                }]
            };

            this.queryExecutor.getValues(execute).subscribe(data => {
                let dateC = data.rows[0].values;
                let control = new Date(dateC) - new Date();
                let ChoiseResult = [];

                if (control < 0) {
                    const noChoose = [{ parameterCode: '@AssignmentId', parameterValue: this.id }, { parameterCode: '@res_id', parameterValue: 3 }];
                    this.form.setControlParameterValues('result_id', noChoose);
                    // break;
                };

                if (result_id == 4 || result_id == 7 || result_id == 8) {
                    if (rework_count < 2) {
                        this.form.setControlVisibility('rework_counter', true);
                        ChoiseResult = [{ parameterCode: '@AssignmentId', parameterValue: this.id }, { parameterCode: '@res_id', parameterValue: 12 }];
                        this.form.setControlParameterValues('result_id', ChoiseResult);
                    } else {
                        this.form.setControlVisibility('rework_counter', false);
                        ChoiseResult = [{ parameterCode: '@AssignmentId', parameterValue: this.id }, { parameterCode: '@res_id', parameterValue: 5 }];
                        this.form.setControlParameterValues('result_id', ChoiseResult);
                    };
                };
            });


            if (result_id == 3 || resolution_id == 1 && resolution_id == 14) {
                const onCountRows3 = {
                    queryCode: 'RightsFilter_AssignmentResolution',
                    parameterValues: [{ key: '@pageOffsetRows', value: 0 }, { key: '@pageLimitRows', value: 5 }, { key: '@AssignmentId', value: this.id }, { key: '@new_assignment_result_id', value: this.form.getControlValue('result_id') }]
                };
                this.queryExecutor.getValues(onCountRows3).subscribe(data => {
                    if (data.rows.length == 1) {
                        // Al - отключил в рамках задачи CRM1551-167
                        //  this.form.setControlValue('resolution_id', {key: data.rows[0].values[0], value: data.rows[0].values[1] });
                    };
                });
                let params = [{ parameterCode: '@new_assignment_result_id', parameterValue: this.form.getControlValue('result_id') }, { parameterCode: '@AssignmentId', parameterValue: this.id }];
                this.form.setControlParameterValues('resolution_id', params);
            };

            if (result_id == 5 || ass_state_id == 3 || ass_state_id == 4 || ass_state_id == 5) {
                this.form.setControlVisibility('rework_counter', true);
                this.form.setControlVisibility('control_comment', true);

                this.form.enableControl('control_comment');
                this.form.disableControl('performer_id');
            };
            if (result_id == 3) {
                this.form.setControlVisibility('transfer_to_organization_id', true);
                this.form.disableControl('performer_id');
            };

            if (ass_state_id == 5) {

                this.form.disableControl('resolution_id');
                this.form.disableControl('result_id');
                this.form.disableControl('performer_id');
                this.form.disableControl('transfer_to_organization_id');
                this.form.disableControl('short_answer');
                this.form.disableControl('execution_date');
                this.form.disableControl('ass_type_id');
                this.form.disableControl('control_comment');
                let doc = document.querySelector('#Detail_Assig_File .add-btn');
                doc.style.display = 'none'
            };

            let main = this.form.getControlValue('is_aktiv_true');
            let check = this.form.getControlValue('main_executor');

            console.log('Головне доручення є (1- так): ' + main);
            console.log('Головне: ' + check);

            if (main == 0) {
                this.form.enableControl('main_executor');
            } else if (main > 0 && check == true) {
                this.form.enableControl('main_executor');
            };

            if (this.form.getControlValue('registration_date') == null) {
                this.form.setControlValue('ass_state_id', { key: 1, value: 'Зареєстровано' });
                this.form.setControlValue('result_id', { key: 1, value: 'Очікує прийому в роботу' });
            };


            if (result_id != 5 && result_id != 3) {
                const compareExecutor = {
                    queryCode: 'list_is_check_executor',
                    parameterValues: [{ key: '@Id', value: this.id }]
                };
                this.queryExecutor.getValue(compareExecutor).subscribe(data => {
                    // 1 равны , 0 - не равны
                    this.form.setControlValue('is_exe', data);
                    if (data == 1) {
                        this.form.enableControl('performer_id');
                    } else {
                        this.form.disableControl('performer_id');
                    };
                });
            }

            this.form.onControlValueChanged('result_id', this.filterResolution.bind(this));
            this.form.onControlValueChanged('performer_id', this.chooseExecutorPerson.bind(this));
        },
        /*END INIT */

        chooseExecutorPerson: function(executor_id) {
            if (executor_id == null) {
                this.form.setControlValue('executor_person_id', {});
            };

            let param = [{ parameterCode: '@org_id', parameterValue: executor_id }];
            this.form.setControlParameterValues('executor_person_id', param);
        },

        goToAssigView: function(column, row, value, event, indexOfColumnId) {
            this.navigateTo('/sections/Assignments_for_view/edit/' + row.values[0] + '/Questions/' + row.values[7]);
        },

        filterResolution: function(result_id) {
            this.form.setControlVisibility('transfer_to_organization_id', false);
            this.form.setControlRequirement('transfer_to_organization_id', false);
            this.form.setControlVisibility('rework_counter', false);
            this.form.setControlVisibility('control_comment', false);
            this.form.setControlValue('resolution_id', {});

            if (result_id == 9) {
                const onCountRows1 = {
                    queryCode: 'RightsFilter_AssignmentResolution',
                    parameterValues: [{ key: '@pageOffsetRows', value: 0 }, { key: '@pageLimitRows', value: 5 }, { key: '@AssignmentId', value: this.id }, { key: '@new_assignment_result_id', value: this.form.getControlValue('result_id') }]
                };
                this.queryExecutor.getValues(onCountRows1).subscribe(data => {
                    if (data.rows.length == 1) {
                        this.form.setControlValue('resolution_id', { key: data.rows[0].values[0], value: data.rows[0].values[1] });
                    };
                });

                let newParams2 = [{ parameterCode: '@new_assignment_result_id', parameterValue: this.form.getControlValue('result_id') }, { parameterCode: '@AssignmentId', parameterValue: this.id }];
                this.form.setControlParameterValues('resolution_id', newParams2);
                this.onChangeStatus();
            } else if (this.form.getControlValue('result_id') == null) {
                this.form.setControlValue('ass_state_id', {});
                this.form.setControlValue('resolution_id', {});
                this.form.disableControl('resolution_id');

            } else {
                this.form.enableControl('resolution_id');
                if (result_id == 3 && this.previous_result != 3) {
                    this.form.setControlVisibility('transfer_to_organization_id', true);
                    this.form.disableControl('resolution_id');


                    const onCountRows2_3 = {
                        queryCode: 'RightsFilter_AssignmentResolution',
                        parameterValues: [{ key: '@pageOffsetRows', value: 0 }, { key: '@pageLimitRows', value: 5 }, { key: '@AssignmentId', value: this.id }, { key: '@new_assignment_result_id', value: this.form.getControlValue('result_id') }]
                    };
                    this.queryExecutor.getValues(onCountRows2_3).subscribe(data => {

                        if (this.form.getControlValue('is_exe') != 0) {
                            // this.form.setControlValue('resolution_id', {key: data.rows[0].values[0], value: data.rows[0].values[1] });
                            this.form.setControlValue('resolution_id', { key: 1, value: 'Повернуто в 1551' });
                            this.form.disableControl('resolution_id');
                        } else {
                            // this.form.setControlValue('resolution_id', {key: data.rows[1].values[0], value: data.rows[1].values[1] });
                            this.form.setControlValue('resolution_id', { key: 14, value: 'Повернуто в батьківську організацію' });
                            this.form.disableControl('resolution_id');
                        };
                    });


                    let newParams = [{ parameterCode: '@new_assignment_result_id', parameterValue: this.form.getControlValue('result_id') }, { parameterCode: '@AssignmentId', parameterValue: this.id }];
                    this.form.setControlParameterValues('resolution_id', newParams);
                    return
                }
                if (result_id == 5) {
                    this.form.setControlVisibility('rework_counter', true);
                    this.form.setControlVisibility('control_comment', true);
                    this.form.disableControl('rework_counter');
                };

                if (result_id == 1) {
                    // if(resolution_id == 3)
                    this.form.setControlVisibility('transfer_to_organization_id', true);
                    this.form.setControlRequirement('transfer_to_organization_id', true);
                };


                const onCountRows2 = {
                    queryCode: 'RightsFilter_AssignmentResolution',
                    parameterValues: [{ key: '@pageOffsetRows', value: 0 }, { key: '@pageLimitRows', value: 5 }, { key: '@AssignmentId', value: this.id }, { key: '@new_assignment_result_id', value: this.form.getControlValue('result_id') }]
                };
                this.queryExecutor.getValues(onCountRows2).subscribe(data => {
                    if (data.rows.length === 1) {
                        this.form.setControlValue('resolution_id', { key: data.rows[0].values[0], value: data.rows[0].values[1] });
                        this.form.disableControl('resolution_id');
                    } else {
                        this.form.setControlValue('resolution_id', { key: data.rows[0].values[0], value: data.rows[0].values[1] });
                        this.form.enableControl('resolution_id');
                    };
                });
                let newParams = [{ parameterCode: '@new_assignment_result_id', parameterValue: this.form.getControlValue('result_id') }, { parameterCode: '@AssignmentId', parameterValue: this.id }, { parameterCode: '@programuser_id', parameterValue: this.user.userId }];
                this.form.setControlParameterValues('resolution_id', newParams);
            }
        },

        onChangeStatus: function(resol_id) {
            let result = this.form.getControlValue('result_id');
            if (resol_id != null || result != 9) {

                const onChangeStatus = {
                    queryCode: 'dir_change_newStatus_from_Result',
                    parameterValues: [{ key: '@new_result', value: result }, { key: '@new_resolution', value: resol_id }]
                };

                this.queryExecutor.getValues(onChangeStatus).subscribe(data => {

                    if (data.rows.length > 0) {
                        this.form.setControlValue('ass_state_id', { key: data.rows[0].values[0], value: data.rows[0].values[1] });
                    };
                });
            } else if (result == 9) {
                const onChangeStatus = {
                    queryCode: 'dir_change_newStatus_from_Result_only',
                    parameterValues: [{ key: '@new_result', value: result }]
                };
                this.queryExecutor.getValues(onChangeStatus).subscribe(data => {
                    if (data.rows.length > 0) {
                        this.form.setControlValue('ass_state_id', { key: data.rows[0].values[0], value: data.rows[0].values[1] });
                    };
                });
            };
        },
        validate: function() {

            if (this.form.getControlValue('result_id') == 5 && this.form.getControlValue('rework_counter') == 2) {
                return 'Доопрацювання не доступне  (не більше двох)';
            } else if (!this.form.getControlValue('result_id')) {
                return 'Результат розгляду не може бути порожнім';
            } else {
                return true;
            };


        }
    };
}());