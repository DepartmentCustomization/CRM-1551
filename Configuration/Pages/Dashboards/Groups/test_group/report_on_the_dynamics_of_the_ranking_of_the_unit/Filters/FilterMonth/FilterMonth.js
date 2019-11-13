(function () {
  return 
{
    placeholder: 'Miсяць',
    keyValue: 'Id',
    displayValue: 'Name',
    baseQueryOptions: {
        queryCode: 'filter_date',
        limit: -1,
        filterColumns: [],
        parameterValues: [],
        pageNumber: 8,
        sortColumns: []
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
        // console.log('send - ',item.value);
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
