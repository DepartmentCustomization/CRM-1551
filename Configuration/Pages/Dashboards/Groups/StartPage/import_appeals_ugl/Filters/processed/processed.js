(function () {
  return {
    placeholder: 'Опрацьовані',
    keyValue: 'Id',
    displayValue: 'Name',
    baseQueryOptions: {
        queryCode: 'Filters_import_UGL',
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
    initValue: function() {
        this.setDefaultValue('first'); 
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
