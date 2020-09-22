(function() {
    return {
        placeholder: 'Район',
        keyValue: 'Id',
        displayValue: 'Name',
        baseQueryOptions: {
            queryCode: 'kp_blag_DistrictSelectRows',
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
        initValue: function() {
            this.setDefaultValue('first');
        },
        onItemSelect: function() {
        },
        onClearFilter: function() {
        }
    };
}());
