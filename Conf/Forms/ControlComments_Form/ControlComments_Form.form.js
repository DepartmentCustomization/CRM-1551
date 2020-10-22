(function() {
    return {
        init: function() {
            this.form.disableControl('user_create');
            this.form.disableControl('create_date');
            this.form.disableControl('user_edit');
            this.form.disableControl('edit_date');
        }
    }
}());