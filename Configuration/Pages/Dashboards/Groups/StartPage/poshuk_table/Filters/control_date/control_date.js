(function () {
  return {
    showTime: true,   
    placeholder: 'Перевірка',
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
