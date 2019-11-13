(function () {
  return {
    placeholder: 'Будинок',
    keyValue: 'Id',
    displayValue: 'name',
    baseQueryOptions: {
        queryCode: 'zayavnyk_building_number',
        filterColumns: null,
        limit: -1,
        parameterValues: [
            { key: '@Street_Id', value: '0' },
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
        this.sub = this.messageService.subscribe( 'messageForBuilding', this.streetValue, this);
    },
    streetValue: function(message){
        this.streetId = message.value;
        this.baseQueryOptions.parameterValues[0].value = this.streetId;
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
    }
};
}());
