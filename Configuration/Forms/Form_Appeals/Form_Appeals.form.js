(function () {
  return {
    init: function(){
        
        //скрыть деталь Detail_test
        this.details.setVisibility('Detail_test', false) 
       
        this.form.disableControl('registration_number');
        this.form.disableControl('receipt_source_id');
        this.form.disableControl('phone_number');
        this.form.disableControl('receipt_date');
        this.form.disableControl('adress');
        this.form.disableControl('app_phone');
        this.form.disableControl('user_id');
        this.form.disableControl('edit_date');
        this.form.disableControl('user_edit_id');
        
        var num = this.form.getControlValue('phone_number');
        console.log(num);
        // if(num !== null){
        //     //debugger;
        //     this.form.setControlValue('receipt_source_id', {key:1 , value:'Дзвінок в 1551'});
        // }
        
        var rec = this.form.getControlValue('receipt_source_id');
        if(rec == 1){
            // this.form.removeControl('enter_number');
            // this.form.removeControl('submission_date');
            // this.form.removeControl('article');
            // this.form.removeControl('sender_name');
            // this.form.removeControl('sender_post_adrress');
            // this.form.removeControl('city_receipt');
        }
         
       this.form.onControlValueChanged('phone_number', this.onAppealsChanged);
       this.onAppealsChanged(num);
       
        var icon = document.getElementById('applicant_idIcon');
        icon.style.fontSize = "1.6rem";
        icon.style.position = "relative";
        icon.style.bottom = "0.3em";
        // icon.addEventListener("click", newAppeal);
        
        // function newAppeal(){
        //     let r = [{ code: "phone_number", value: this.form.getControlValue('phone_number')}];
        //         let r1 = JSON.stringify(r);
        //         let r2 = encodeURI(r1);
        //     window.open(location.origin + localStorage.getItem('VirtualPath') + "/sections/Appeals/add?DefaultValues="+r2, "_self");
        // }
        
        this.form.onControlValueChanged('applicant_id', this.testDetail);
    },
    
    testDetail: function(ap_id){
      console.log(ap_id)  
    },

    
    onAppealsChanged: function(app_Id) {
        let appl = [{ parameterCode: '@phone_number', parameterValue: app_Id }];
        this.form.setControlParameterValues('applicant_id', appl);
    },
    
    afterSave: function(data){
       // const id = this.form.getControlValue('Id');
        this.navigateTo('/sections/Appeals/edit/'+data.rows[0].values[0]);
    }
    
    
   
};
}());
