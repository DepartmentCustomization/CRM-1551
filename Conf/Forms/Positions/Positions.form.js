(function() {
    return {
        init: function() {
            this.form.disableControl('position_id');
            this.form.disableControl('edit_date');
            this.form.disableControl('UserName');
            let dependParams = [{ parameterCode: '@position_id', parameterValue: this.id }];
            this.form.setControlParameterValues('parent_id', dependParams);
        }
    };
}());
