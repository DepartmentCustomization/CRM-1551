(function () {
  return {
    placeholder: 'Типи питань',
    keyValue: 'Id',
    displayValue: 'Name',
    baseQueryOptions: {
        queryCode: 'QuestionTypesList',
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
