(function() {
    return {
        init: function() {
            this.form.disableControl('position');
            if(this.form.getControlValue('organization_id') !== null) {
                this.form.disableControl('organization_id');
            }
        }
    };
}());
