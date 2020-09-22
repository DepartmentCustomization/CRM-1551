(function() {
    return {
        init: function() {
            this.form.disableControl('Name');
            this.form.disableControl('Phone');
            this.form.disableControl('ContactType');
            this.form.setControlVisibility('ContactType');
            if (this.form.getControlValue('ContactType') === '1557site') {
                this.form.disableControl('StreetId');
                this.form.disableControl('HouseId');
                this.form.disableControl('FlatId');
                this.form.disableControl('SendClaims');
                this.openPopUpInfoDialog(
                    'Користувач сайту 1557.kyiv.ua. Інформацію по поточному контакту змінити не ' +
                    'можливо (налаштування СМС користувач редагує самостійно). Для зміни інформації потрібно перейти на сайт 1557.'
                );
            }
            let dependParams = [{ parameterCode: '@street_id', parameterValue: this.form.getControlValue('StreetId')}];
            this.form.setControlParameterValues('HouseId', dependParams);
            let dependParams2 = [{ parameterCode: '@house_id', parameterValue: this.form.getControlValue('HouseId') }];
            this.form.setControlParameterValues('FlatId', dependParams2);
            this.form.onControlValueChanged('StreetId', this.onStreetChanged);
            this.form.onControlValueChanged('HouseId', this.onHouseChanged);
        },
        onStreetChanged: function(Id) {
            this.form.setControlValue('HouseId', {});
            this.form.setControlValue('FlatId', {});
            let dependParams = [{ parameterCode: '@street_id', parameterValue: Id }];
            this.form.setControlParameterValues('HouseId', dependParams);
        },
        onHouseChanged: function(Id) {
            this.form.setControlValue('FlatId', {});
            let dependParams = [{ parameterCode: '@house_id', parameterValue: Id }];
            this.form.setControlParameterValues('FlatId', dependParams);
        }
    };
}());