(function () {
  return {
    placeholder: 'Організації',
    keyValue: 'Id',
    displayValue: 'Name',
    baseQueryOptions: {
        queryCode: 'Filter_ParentOrgForReport',
        filterColumns: null,
        limit: -1,
        parameterValues: [
            { key: '@pos', value: '0' },
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
        this.sub = this.messageService.subscribe( 'messageForOrganization', this.organizationId, this);
    },
    organizationId: function(message){
        this.pos = message.value;
        this.baseQueryOptions.parameterValues[0].value = this.pos;
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
        
        let value = '';
        item.forEach( el => {
            value = value + ', ' + el.value;
        });
        let stringSendValue = value.slice(2, [value.length]);
        this.messageService.publish( { name: 'messageForTable', value: stringSendValue });
        
    },
    destroy: function(){
        this.sub.unsubscribe();
    }
};
}());
