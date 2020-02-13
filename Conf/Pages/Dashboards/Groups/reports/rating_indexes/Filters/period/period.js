(function() {
    return {
        placeholder: '',
        minDate: null,
        maxDate: null,
        showTime: false,
        showSeconds: false,
        hourFormat: 24,
        showButtonBar: false,
        numberOfMonths: 1,
        dateFormat: 'dd.mm.yy',
        monthNavigator: false,
        yearNavigator: false,
        yearRange: null,
        timeOnly: false,
        readonlyInput: null,
        view: 'date',
        disabledDays: null,
        disabledDates: null,
        type: 'Date',
        onItemSelect: function(date) {
            this.yourFunctionName(date);
        },
        initValue: function() {
        },
        yourFunctionName: function(value) {
            let message = {
                name: '',
                package: {
                    value: value
                }
            }
            this.messageService.publish(message);
        }
    };
}());
