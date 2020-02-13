(function() {
    return {
        init: function() {
            document.getElementById('active_button').disabled = true;
            let finish_date = this.form.getControlValue('real_end_date');
            if (finish_date != null) {
                document.getElementById('active_button').disabled = false;
            }
            document.getElementById('active_button').addEventListener('click', function(event) {
                event.stopImmediatePropagation();
                const Question_Close_callback = (response) => {
                    if (response) {
                        const objName = {
                            queryCode: 'CloseQuestion_GlobGor',
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
                                value: this.form.getControlValue('executor_comment')
                            }
                            ]
                        };
                        this.queryExecutor.getValues(objName).subscribe(() => {
                        });
                    }
                };
                const fieldsForm = {
                    title: ' ',
                    text: 'Закритти повя\'язані питання?',
                    acceptBtnText: 'yes',
                    cancelBtnText: 'no'
                };
                this.openModalForm(fieldsForm, Question_Close_callback.bind(this));
            }.bind(this));
        }
    }
}())