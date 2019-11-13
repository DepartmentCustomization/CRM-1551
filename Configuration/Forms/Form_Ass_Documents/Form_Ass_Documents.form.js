(function () {
  return {
    stateForm: '', 
    init:function(){
        this.form.disableControl('add_date');
        
        let is_view = this.form.getControlValue('is_view');
        
        if (is_view == 1){
            // document.querySelector('.icon-delete').style.display = 'none';
            document.getElementsByClassName('float_r')[0].style.display = 'none';
            document.querySelectorAll('div.card-title > div > button')[1].style.display = 'none'
        };
        
        let ass_status = this.form.getControlValue('ass_status');
        if(ass_status == 5){
            this.form.disableControl('name');
            this.form.disableControl('doc_type_id');
            this.form.disableControl('content');
            document.querySelectorAll('div.card-title > div > button')[1].style.display = 'none'
            
        }
        this.stateForm = this.state;
        
        
      //   if (this.stateForm != 'create') {
       //      this.form.setControlValue('FormId',this.id);
       // };
        
    },
    afterSave: function(data) {
        if (this.stateForm == 'create') {
            location.reload();
        };
      //  debugger;
      // this.form.setControlValue('FormId',data.rows[0].values[0]);
    }
};
}());
