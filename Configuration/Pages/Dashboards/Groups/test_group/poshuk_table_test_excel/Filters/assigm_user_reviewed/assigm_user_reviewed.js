(function () {
  return {
    placeholder: 'Розглянув',
    keyValue: 'Id',
    displayValue: 'name_user_reviewed',
    baseQueryOptions: {
        queryCode: 'assigm_user_reviewed',
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
    }
};
}());
