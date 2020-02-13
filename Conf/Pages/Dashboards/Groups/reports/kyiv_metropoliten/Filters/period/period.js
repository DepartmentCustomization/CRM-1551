(function() {
    return {
        placeholder: 'Період',
        type: 'Date',
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
        init: function() {
        },
        initValue: function() {
            let currentDate = new Date();
            let year = currentDate.getFullYear();
            let monthFrom = currentDate.getMonth();
            let dayTo = currentDate.getDate();
            let defaultValue = {
                dateFrom: new Date(year, monthFrom , '01'),
                dateTo: new Date(year, monthFrom , dayTo)
            }
            this.setDefaultValue(defaultValue);
        },
        destroy() {
        }
    };
}());
