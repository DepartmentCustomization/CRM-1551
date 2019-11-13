(function () {
  return {
    placeholder: 'Вулиці',
    keyValue: 'Id',
    displayValue: 'name',
    baseQueryOptions: {
        queryCode: 'zayavnyk_building_street',
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
    yourFunctionName: function(item) {
        let message = {
            name: '',
            package: {
                type: item.value
            }
        }
        this.messageService.publish(message);
        this.messageService.publish( { name: 'messageForBuilding', value: item.value });
    }
};
}());
