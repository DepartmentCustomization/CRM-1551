(function() {
    return {
        init:function() {
            this.form.disableControl('registration_date');
            this.form.disableControl('user_name');
            this.form.disableControl('complain_type_id');
            this.form.disableControl('culpritname');
            this.form.disableControl('guilty_name');
            this.form.disableControl('text');
        }
    };
}());
