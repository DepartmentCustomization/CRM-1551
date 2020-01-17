(function () {
  return {
    placeholder: 'Вулиця',
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
        let value = '';
        item.forEach( el => {
            value = value + ', ' + el.value;
        });
        let stringSendValue = value.slice(2, [value.length]);
        this.messageService.publish( { name: 'messageForBuilding', value: stringSendValue });
    }
};
}());
