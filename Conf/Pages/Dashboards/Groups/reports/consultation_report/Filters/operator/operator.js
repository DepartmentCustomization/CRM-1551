(function() {
    return {
        placeholder: 'Оператор',
        keyValue: 'Id',
        displayValue: 'Operator',
        baseQueryOptions: {
            queryCode: 'UsersList',
            filterColumns: null,
            limit: -1,
            parameterValues: [],
            pageNumber: 1,
            sortColumns: [
                {
                    key: 'Operator',
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
