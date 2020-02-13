(function() {
    return {
        stateForm: '',
        init:function() {
            let categoryIdParam = [{ parameterCode: '@assignment_id', parameterValue: this.form.getControlValue('assignment_id') }];
            this.form.setControlParameterValues('template_id', categoryIdParam);
            this.form.onControlValueChanged('template_id', this.onComment);
            this.form.disableControl('add_date');
            let is_view = this.form.getControlValue('is_view');
            if (is_view == 1) {
                document.getElementsByClassName('float_r')[0].style.display = 'none';
                document.querySelectorAll('div.card-title > div > button')[1].style.display = 'none'
            }
            let ass_status = this.form.getControlValue('ass_status');
            if(ass_status == 5) {
                this.form.disableControl('name');
                this.form.disableControl('doc_type_id');
                this.form.disableControl('content');
                document.querySelectorAll('div.card-title > div > button')[1].style.display = 'none'
            }
            this.stateForm = this.state;
        },
        afterSave: function() {
            if (this.stateForm == 'create') {
                location.reload();
            }
        },
        onComment: function(onComment) {
            const queryForGetValue = {
                queryCode: 'ak_SelectComment_for_Templates',
                parameterValues: [
                    {
                        key: '@Id',
                        value: onComment
                    }
                ]
            };
            this.queryExecutor.getValues(queryForGetValue).subscribe(data => {
                this.form.setControlValue('content', data.rows[0].values);
            })
        }
    };
}());
