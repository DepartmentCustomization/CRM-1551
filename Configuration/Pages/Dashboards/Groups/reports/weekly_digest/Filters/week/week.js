(function () {
  return {
    placeholder: 'Дата за тиждень',
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
        let day =  currentDate.getDay();
        let dayFromFact;
        let monthFromFact;
        
        if( dayTo - day >= 0 ){
            dayFromFact = dayTo - --day;
            monthFromFact = monthFrom;
        }else{
            
            let cDate = new Date( year, monthFrom, 0 );
            thisMonth = cDate.getMonth();
            thisDay = cDate.getDate();
            dayFromFact = ++thisDay + (  dayTo - day );
            monthFromFact = thisMonth;
        }
        
        let defaultValue = {
                dateFrom: new Date( year, monthFromFact, dayFromFact ),
                dateTo: new Date( year, monthFrom , dayTo )
            }
        this.setDefaultValue(defaultValue); 
    },
    destroy(){
       // console.log('Destroy date filter');
    }
}
;
}());
