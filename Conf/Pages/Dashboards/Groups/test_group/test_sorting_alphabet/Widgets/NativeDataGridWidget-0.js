(function () {
  return {
    config: {
        query: {
            code: 'test_sorting_alphabet',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                dataField: 'Id',
                caption: 'Id',
            },
            {
                dataField: 'n',
                caption: 'N',
            }
        ],
        pager: {
            showPageSizeSelector: true,
            allowedPageSizes: [500],
            showInfo: false,
        },
        paging: {
            pageSize: 100
        },
        height: 400,
        keyExpr: 'Id'
    },
    init: function() {
        this.loadData(this.afterLoadDataHandler);
    },
    afterLoadDataHandler: function(data) {
        this.render();
    },
};
}());
