(function() {
    return {
        placeholder: '',
        type: 'Date',
        stepMinute: 1,
        timeOnly: false,
        onItemSelect: function(date) {
            this.yourFunctionName(date);
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
        },
        initValue: function() {
            const currentDate = new Date();
            const yearTo = currentDate.getFullYear();
            const monthTo = currentDate.getMonth();
            const dayTo = currentDate.getDate();
            const timeTo = currentDate.getTime();
            const timeFrom = timeTo - (3600 * 24 * 7 * 1000);
            const dateFrom = new Date(timeFrom);
            const yearFrom = dateFrom.getFullYear();
            const monthFrom = dateFrom.getMonth();
            const dayFrom = dateFrom.getDate();
            const defaultValue = {
                dateFrom: new Date(yearFrom, monthFrom, dayFrom),
                dateTo: new Date(yearTo, monthTo , dayTo)
            }
            this.setDefaultValue(defaultValue);
        }
    };
}());
