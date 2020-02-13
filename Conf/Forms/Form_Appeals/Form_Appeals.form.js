(function() {
    return {
        init: function() {
            this.details.setVisibility('Detail_test', false)
            this.form.disableControl('registration_number');
            this.form.disableControl('receipt_source_id');
            this.form.disableControl('phone_number');
            this.form.disableControl('receipt_date');
            this.form.disableControl('adress');
            this.form.disableControl('app_phone');
            this.form.disableControl('user_id');
            this.form.disableControl('edit_date');
            this.form.disableControl('user_edit_id');
            let num = this.form.getControlValue('phone_number');
            this.form.onControlValueChanged('phone_number', this.onAppealsChanged);
            this.onAppealsChanged(num);
            let icon = document.getElementById('applicant_idIcon');
            icon.style.fontSize = '1.6rem';
            icon.style.position = 'relative';
            icon.style.bottom = '0.3em';
            this.form.onControlValueChanged('applicant_id', this.testDetail);
        },
        testDetail: function() {
        },
        onAppealsChanged: function(app_Id) {
            let appl = [{ parameterCode: '@phone_number', parameterValue: app_Id }];
            this.form.setControlParameterValues('applicant_id', appl);
        },
        afterSave: function(data) {
            this.navigateTo('/sections/Appeals/edit/' + data.rows[0].values[0]);
        }
    };
}());
