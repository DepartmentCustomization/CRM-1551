(function() {
    return {
        init: function() {
            document.getElementById('active_button').disabled = true;

            let finish_date = this.form.getControlValue('real_end_date');
            if (finish_date != null) {
                document.getElementById('active_button').disabled = false;
            };

            document.getElementById('active_button').addEventListener("click", function(event) {
                // debugger;

                event.stopImmediatePropagation();
                const Question_Close_callback = (response) => {
                    if (!response) {
                        console.log('No');
                    } else {
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
                        console.table(objName.parameterValues);
                        debugger;

                        this.queryExecutor.getValues(objName).subscribe(data => {
                            console.log('Event is not activ');
                        });
                    }
                };

                const fieldsForm = {
                    title: ' ',
                    // singleButton: 1,
                    text: 'Закритти повя\'язані питання?',
                    acceptBtnText: 'yes',
                    cancelBtnText: 'no'
                };

                this.openModalForm(fieldsForm, Question_Close_callback.bind(this));

            }.bind(this));
        }

    }
}())