(function() {
    return {
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
        onClearFilter: function() {
        },
        initValue:function() {
            this.setDefaultValue('first');
        },
        init:function() {
        },
        destroy() {
        }
    };
}());
