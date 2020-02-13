(function() {
    return {
        Detail_History: function(column, row) {
            const parameters = [
                { key: '@history_id', value: row.values[0]}
            ];
            this.details.loadData('BuildingHistory_details', parameters);
            this.details.setVisibility('BuildingHistory_details', true);
        },
        init: function() {
            this.details.setVisibility('BuildingHistory_details', false);
            this.details.onCellClick('BuildingHistory', this.Detail_History.bind(this));
            this.form.disableControl('street_id');
            this.form.disableControl('number');
            document.getElementById('change_but').disabled = true;
            this.ChangeBtn_Check();
            document.getElementById('delete_but').addEventListener('click', function() {
                this.openPopUpConfirmDialog('Ви впевнені що потрібно видалити будинок?', this.DeleteObject);
            }.bind(this));
            document.getElementById('change_but').addEventListener('click', function() {
                const queryForUpdateBuilding = {
                    queryCode: 'ChangeBuilding',
                    parameterValues: [
                        {
                            key: '@Id',
                            value: this.form.getControlValue('Id')
                        },
                        {
                            key: '@building',
                            value: this.form.getControlValue('change_building')
                        }
                    ] };
                this.queryExecutor.getValues(queryForUpdateBuilding).subscribe(data => {
                    if (data) {
                        if (data.rows.length > 0) {
                            this.ChangeBtn_Check();
                            const option = { title: 'Заміна будинку',
                                text: 'Сутності з даного будинку переміщено на обраний',
                                acceptBtnText: 'Ok',
                                singleButton: true
                            };
                            this.openModalForm(option,this.ChangeObject);
                            const parameters = [{ key: '@Id', value: this.id }];
                            const filters = [];
                            const sorting = [];
                            this.details.loadData('BuildingApplicants', parameters, filters, sorting);
                            this.details.loadData('BuildingQuestion', parameters, filters, sorting);
                        }
                    }
                });
            }.bind(this));
            this.form.onControlValueChanged('change_building', this.onBuildingChanged);
        },
        onBuildingChanged: function(BuildingId) {
            if(BuildingId) {
                document.getElementById('change_but').disabled = false;
            } else {
                document.getElementById('change_but').disabled = true;
            }
        },
        ChangeBtn_Check: function() {
            const checkResult = {
                queryCode: 'CheckApplicantsAndQuestions',
                parameterValues:[
                    {
                        key: '@Id',
                        value: this.form.getControlValue('Id')
                    } ]
            };
            this.queryExecutor.getValues(checkResult).subscribe(data => {
                if (data) {
                    if (data.rows.length > 0) {
                        if(Number(data.rows[0].values[0]) == 0) {
                            document.getElementById('delete_but').disabled = false;
                        } else {
                            document.getElementById('delete_but').disabled = true;
                        }
                    }
                }
            });
        },
        DeleteObject: function(value) {
            if (value) {
                const queryForDeleteBuilding = {
                    queryCode: 'DeleteBuilding',
                    parameterValues: [
                        {
                            key: '@Id',
                            value: this.form.getControlValue('Id')
                        } ]
                };
                this.queryExecutor.getValues(queryForDeleteBuilding).subscribe(data => {
                    if (data) {
                        if (data.rows.length > 0) {
                            this.back();
                        }
                    }
                });
            }
        }
    };
}());
