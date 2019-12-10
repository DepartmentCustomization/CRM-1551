(function() {
    return {
        init: function() {
            this.form.onControlValueChanged('organization_id', this.onStreetsChanged);
        },
        
        

        onStreetsChanged: function(dis_id) {
            //debugger
            if (typeof dis_id === 'string') {
                return
            } else if (dis_id == null) {
                this.form.setControlValue('position_id', null);
                let dependParams = [{ parameterCode: '@organization_id', parameterValue: dis_id }];
                this.form.setControlParameterValues('position_id', dependParams);
                this.form.disableControl('position_id');
            } else {
                let dependParams = [{ parameterCode: '@organization_id', parameterValue: dis_id }];
                this.form.setControlParameterValues('position_id', dependParams); //арт building_id StrictId
                this.form.enableControl('position_id'); // building_id StrictId арт
            }
        }
        
    };
}());