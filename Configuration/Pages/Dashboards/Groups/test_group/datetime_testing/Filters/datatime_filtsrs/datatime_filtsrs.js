(function () {
  return {
    placeholder: 'Період',
    showTime: true,   
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
                dateFrom: new Date(year, monthFrom, 1, 08, 00),
                dateTo: new Date( year, monthFrom, dayTo, 08, 00 )
            }
        this.setDefaultValue(defaultValue); 
    },
    
    destroy(){
       // console.log('Destroy date filter');
    }
};
}());
