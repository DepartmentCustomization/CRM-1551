(function() {
    return {
        init: function() {
            this.form.disableControl('Id');
            this.form.disableControl('registration_date');
            this.form.disableControl('phone_number');
        },
        afterSave: function(data) {
            this.navigateTo('/sections/Hotline/edit/' + data.rows[0].values[0]);
        }
    }
}());