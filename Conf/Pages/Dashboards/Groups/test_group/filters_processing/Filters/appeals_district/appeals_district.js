(function() {
    return {
        placeholder: 'Район',
        keyValue: 'Id',
        displayValue: 'name',
        baseQueryOptions: {
            queryCode: 'appeals_district',
            filterColumns: null,
            limit: -1,
            parameterValues: [ {key:'@pageOffsetRows' , value:0},{key: '@pageLimitRows', value: 50} ],
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
