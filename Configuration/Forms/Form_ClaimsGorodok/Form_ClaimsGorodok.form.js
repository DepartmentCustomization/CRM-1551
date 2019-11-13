(function () {
  return {
    init:function(){
        this.form.disableControl('global');
        this.form.disableControl('claim_number');
        this.form.disableControl('claim_state');
        this.form.disableControl('claim_type');
        this.form.disableControl('claim_content');
        this.form.disableControl('executor');
        this.form.disableControl('main_object_id');
        this.form.disableControl('start_date');
        this.form.disableControl('planned_end_date');
        this.form.disableControl('fact_end_date');
        this.form.disableControl('audio_start_date');
        this.form.disableControl('audio_end_date');
        // this.form.disableControl('qw');
        // this.form.disableControl('qw');
    }
};
}());
