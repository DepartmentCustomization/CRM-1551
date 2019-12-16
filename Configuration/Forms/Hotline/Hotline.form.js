(function() {
    return {
        init: function() {
                        this.form.disableControl('Id');
                        this.form.disableControl('registration_date');
                        this.form.disableControl('phone_number');
                        //this.form.setControlValue('Id', this.id);
                        //this.form.setControlValue('Appeal_Id', this.id);
                              
        },
        afterSave: function(data){
            // const id = this.form.getControlValue('Id');
             this.navigateTo('/sections/Hotline/edit/'+data.rows[0].values[0]);
         } 
    }
    }());