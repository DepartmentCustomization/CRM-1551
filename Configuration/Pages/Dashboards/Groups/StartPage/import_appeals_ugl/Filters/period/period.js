(function () {
  return {
    placeholder: '',
    showTime: true,
    onItemSelect: function(date) {
        this.yourFunctionName(date);
    },
    initValue: function() {
        let currentDate = new Date();
        let year = currentDate.getFullYear();
        let monthFrom = currentDate.getMonth();
        let dayTo = currentDate.getDate();

        let HH = currentDate.getHours();
        let MM = currentDate.getMinutes();

        let defaultValue = {
            dateFrom: new Date('2019', '05' , '01'),
            dateTo: new Date( year, monthFrom , dayTo, HH, MM)
        }
        this.setDefaultValue(defaultValue); 
    },
    yourFunctionName: function(date) {
        let message = {
            name: '',
            package: {
                dateFrom: date.dateFrom,
                dateTo: date.dateTo
            }
        }
        this.messageService.publish(message);
    }
};
}());
