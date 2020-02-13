(function() {
    return {
        init: function() {
            this.form.onControlValueChanged('organization_id', this.onStreetsChanged);
        },
        onStreetsChanged: function(dis_id) {
            if (typeof dis_id === 'string') {
                return
            } else if (dis_id == null) {
                this.form.setControlValue('position_id', null);
                let dependParams = [{ parameterCode: '@organization_id', parameterValue: dis_id }];
                this.form.setControlParameterValues('position_id', dependParams);
                this.form.disableControl('position_id');
            } else {
                let dependParams = [{ parameterCode: '@organization_id', parameterValue: dis_id }];
                this.form.setControlParameterValues('position_id', dependParams);
                this.form.enableControl('position_id');
            }
        }
    };
}());