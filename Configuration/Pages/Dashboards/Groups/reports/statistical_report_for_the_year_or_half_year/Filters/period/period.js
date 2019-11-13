(function () {
  return {
    placeholder: 'Дата з початку року',
    onItemSelect: function(date) {
        this.datePeriod(date);
    },
    datePeriod: function(date) {
        let message = {
            name: '',
            package: {
                dateFrom: date.dateFrom,
                dateTo: date.dateTo
            }
        }
        this.messageService.publish(message);
    },
    initValue: function() {
        let currentDate = new Date();
        let year = currentDate.getFullYear();
        let monthFrom = currentDate.getMonth();
        let dayTo = currentDate.getDate();
        
        let defaultValue = {
            // убрать  - 1 
                dateFrom: new Date(year, 0, '01'),
                dateTo: new Date( year, monthFrom , dayTo)
            }
        this.setDefaultValue(defaultValue); 
    },
    destroy(){
       // console.log('Destroy date filter');
    }
}
;
}());
