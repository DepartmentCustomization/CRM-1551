(function () {
  return {
    placeholder: 'Вулиці',
    keyValue: 'Id',
    displayValue: 'name',
    baseQueryOptions: {
        queryCode: 'zayavnyk_building_street',
        filterColumns: null,
        limit: -1,
        parameterValues: [ 
            { key: '@Street_Id', value: 0 },
            { key: '@pageOffsetRows', value: 0},
            { key: '@pageLimitRows', value: 50}
        ],
        pageNumber: 1,
        sortColumns: [
            {
            key: 'Id',
            value: 0
            }
        ]
    },
    init: function(){
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
        let arrMessage = [];
        item.forEach( el =>  arrMessage.push(el.value));
        arrMessage = arrMessage.join(', ');

        this.messageService.publish( { name: 'messageForBuilding', value: arrMessage });
    }
};
}());
