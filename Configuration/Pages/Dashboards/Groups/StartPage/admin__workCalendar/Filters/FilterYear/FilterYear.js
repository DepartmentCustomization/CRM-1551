(function () {
  return {
    placeholder: 'Рік',
    keyValue: 'Id',
    displayValue: 'name',
    baseQueryOptions: {
        queryCode: 'workYearCalendar',
        filterColumns: null,
        limit: -1,
        parameterValues: [],
        pageNumber: 1,
        sortColumns: [
            {
            key: 'Id',
            value: 0
            }
        ]
    },
    onItemSelect: function(item) {
        this.yourFunctionName(item);
    },
    onClearFilter: function() {
    },
    // init: function(){
    //     this.setDefaultValue('first');
    // },
    yourFunctionName: function(item) {
        let message = {
            name: '',
            package: {
                type: item.value
            }
        }
        this.messageService.publish(message);
    }
};
}());
