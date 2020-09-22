(function() {
    return {
        init: function() {
            this.form.onControlValueChanged('organization_id', this.organizationChanged.bind(this));
            let organization_id = this.form.getControlValue('organization_id');
            let orgParam = [{ parameterCode: '@organization_id', parameterValue: organization_id }];
            this.form.setControlParameterValues('position_id', orgParam);
        },
        organizationChanged: function(val) {
            if (typeof val === 'number') {
                let dependParams = [{ parameterCode: '@organization_id', parameterValue: val }];
                this.form.setControlParameterValues('position_id', dependParams);
                this.form.enableControl('position_id');
            } else if (val === null) {
                this.form.setControlValue('position_id', null);
                let dependParams = [{ parameterCode: '@organization_id', parameterValue: val }];
                this.form.setControlParameterValues('position_id', dependParams);
                this.form.disableControl('position_id');
            }
        }
    };
}());