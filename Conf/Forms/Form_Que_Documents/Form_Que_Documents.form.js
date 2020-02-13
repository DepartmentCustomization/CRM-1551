(function() {
    return {
        stateForm: '',
        init: function() {
            this.form.disableControl('add_date');
            this.stateForm = this.state;
        },
        afterSave: function() {
            if (this.stateForm == 'create') {
                location.reload();
            }
        }
    };
}());
