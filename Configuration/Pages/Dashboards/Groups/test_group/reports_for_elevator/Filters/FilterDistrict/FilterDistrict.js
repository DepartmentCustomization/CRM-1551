(function () {
  return {
    placeholder: 'Район',
    keyValue: 'Id',
    displayValue: 'Name',
    baseQueryOptions: {
        queryCode: 'DistricsSelect',
        limit: -1,
        filterColumns: [
            {
                key: 'Name',
                value: {
                    values: []
                }
            }
        ],
        parameterValues: [],
        pageNumber: 1,
        sortColumns: [
            {
            key: 'Name',
            value: 0
            }
        ]
    },
    onItemSelect: function(item) {
        this.yourFunctionName(item);
    },
    onClearFilter: function() {
    },
    yourFunctionName(item) {
                // var message = {
                //                 name: 'chance_filter_organization',
                //                 value: item.value
                //               };
                // this.messageService.publish(message);
        console.log('send - ',item.value);
    },
    
    initValue:function() {
        // this.setDefaultValue();  
        this.setDefaultValue("first");
    },
    init:function() {
    
    },
    destroy() {
    }
};
}());
