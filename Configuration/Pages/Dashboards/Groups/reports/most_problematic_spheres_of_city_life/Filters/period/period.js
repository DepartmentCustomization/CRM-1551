(function () {
  return {
    placeholder: 'Період',
    onItemSelect: function(date) {
        this.datePeriod(date);
    },
    datePeriod(date) {
        let message = {
            name: 'dateSel',
            package: {
                dateFrom: date.dateFrom,
                dateTo: date.dateTo
            }
        }
        this.messageService.publish(message);
    },
    init: function(){
      
    },
    
    initValue: function() {
        let currentDate = new Date();
        let year = currentDate.getFullYear();
        let monthFrom = currentDate.getMonth();
        let dayTo = currentDate.getDate();
        let defaultValue = {
                dateFrom: new Date(year, '00' , '01'),
                dateTo: new Date( year, monthFrom , dayTo)
            }
        this.setDefaultValue(defaultValue); 
    },
    destroy(){
       // console.log('Destroy date filter');
    }
};
}());
