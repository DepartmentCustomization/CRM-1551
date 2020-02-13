(function() {
    return {
        placeholder: 'Результати звернення',
        keyValue: 'Id',
        displayValue: 'name',
        baseQueryOptions: {
            queryCode: 'list_AppealsFromSite_Results',
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
            this.sendMessage(item);
        },
        onClearFilter: function() {
        },
        sendMessage: function(item) {
            let message = {
                name: '',
                package: {
                    type: item.value
                }
            }
            this.messageService.publish(message);
        },
        initValue: function() {
            this.setDefaultValue('first');
        }
    };
}());
