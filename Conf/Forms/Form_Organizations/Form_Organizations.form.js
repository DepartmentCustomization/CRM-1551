(function() {
    return {
        init: function() {
            this.form.disableControl('edit_date');
            this.form.disableControl('user_edit_id');
            this.form.disableControl('');
            this.form.disableControl('');
            let dependParams = [{ parameterCode: '@organization_id', parameterValue: this.id }];
            this.form.setControlParameterValues('organization_id', dependParams);
            let icon = document.getElementById('phone_numberIcon');
            document.getElementById('phone_numberIcon').style.fontSize = '35px';
            icon.addEventListener('click', function() {
                let phone_number = document.getElementById('phone_number');
                let xhr = new XMLHttpRequest();
                xhr.open('GET', 'http://172.16.0.197:5566/CallService/Call/number=' + phone_number.value + '&operator=699');
                xhr.send();
            });
        }
    };
}());
