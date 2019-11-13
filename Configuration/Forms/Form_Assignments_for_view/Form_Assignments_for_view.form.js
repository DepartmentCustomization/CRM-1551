(function () {
  return {
    init:function(){
        
        // this.navigateTo('/sections/Assignments_for_view/view/' + this.id)
        
        // document.getElementsByClassName('float_r')[0].style.display = 'none';
        var btns = document.querySelectorAll('.add-btn');
        btns.forEach( el=> {
            el.style.display = 'none'
        });
       
        this.form.disableControl('registration_date');
        this.form.disableControl('main_executor');
        this.form.disableControl('ass_type_id');
        this.form.disableControl('ass_state_id');
        this.form.disableControl('rework_counter');
        this.form.disableControl('result_id');
        this.form.disableControl('resolution_id');
        this.form.disableControl('transfer_to_organization_id');
        this.form.disableControl('performer_id');
        this.form.disableControl('control_comment');
        this.form.disableControl('execution_date');
        this.form.disableControl('responsible_name');
        this.form.disableControl('short_answer');
        
        let rework_counter = this.form.setControlValue('rework_counter')
        
        if(rework_counter == 0 || rework_counter == null ){
            this.form.setControlVisibility('rework_counter', false);
        }
       
       this.details.onCellClick('Detail_Assignments_for_view_FILE', this.goToFileView.bind(this));
    },
    
    goToFileView:function(column, row, value, event, indexOfColumnId){
        
        this.navigateTo('/sections/Ass_Documents_ReadOnly/view/'+ row.values[0]);
    }
};
}());
