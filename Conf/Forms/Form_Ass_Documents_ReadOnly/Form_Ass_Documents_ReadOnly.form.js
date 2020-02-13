(function() {
    return {
        stateForm: '',
        init:function() {
            this.form.disableControl('name');
            this.form.disableControl('doc_type_id');
            this.form.disableControl('content');
            this.form.disableControl('add_date');
            document.querySelectorAll('div.card-title > div > button')[1].style.display = 'none'
        }
    };
}());
