(function() {
    return {
        showTime: true,
        placeholder: 'Дата реєстрації',
        type: 'DateTime',
        stepMinute: 1,
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
        }
    };
}());
