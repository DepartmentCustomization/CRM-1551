(function () {
  return {
    stateForm: '',    
    init: function(){
        this.form.disableControl('add_date');
        // debugger;
        this.stateForm = this.state;
    },
    afterSave: function(data) {
        //  debugger;
        // this.form.setControlValue('QuestionDocumentsId', data.rows[0].values[0])
        if (this.stateForm == 'create') {
            location.reload();
        };
    }
};
}());
