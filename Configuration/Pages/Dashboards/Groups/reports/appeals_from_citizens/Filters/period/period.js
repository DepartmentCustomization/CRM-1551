(function () {
  return 
{
    placeholder: 'Дата та час',
    showTime: true,
    onItemSelect: function(date) {
        this.datePeriod(date);
    },
    datePeriod(date) {
        let message = {
            name: '',
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
        
        let hh = currentDate.getHours();
        let mm = currentDate.getMinutes();
        
        let defaultValue = {
            // убрать  - 1 
                dateFrom: new Date(year, monthFrom , dayTo, '00', '00'),
                dateTo: new Date( year, monthFrom , dayTo, hh, mm)
            }
        this.setDefaultValue(defaultValue); 
    },
    destroy(){
       // console.log('Destroy date filter');
    }
};
}());
