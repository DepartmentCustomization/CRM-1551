(function () {
  return {
    placeholder: 'Період',
    onItemSelect: function(date) {
        this.setDateValues(date);
    },
    setDateValues(date) {
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
        const weekAgo = 1000*60*60*24*7;
        const currentDate = new Date();
        let  startDate = new Date(Date.now() - weekAgo);
        let defaultValue = {
            dateFrom: startDate,
            dateTo: currentDate
        }
        this.setDefaultValue(defaultValue);
    },
    
    init: function() {
        // const weekAgo = 1000*60*60*24*7;
        // const currentDate = new Date();
        // let  startDate = new Date(Date.now() - weekAgo);
        // let defaultValue = {
        //     dateFrom: startDate,
        //     dateTo: currentDate
        // }
        // this.setDefaultValue(defaultValue);
    }
}
;
}());
