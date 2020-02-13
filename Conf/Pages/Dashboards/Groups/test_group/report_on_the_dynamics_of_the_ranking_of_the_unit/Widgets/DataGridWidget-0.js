(function() {
    return {
        config: {
            query: {
                code: 'db_third',
                parameterValues: [{key: '@dat', value: this.filter_month}],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [
                {
                    dataField: 'OrganizationName',
                    caption: '',
                    dataType: null,
                    format: null,
                    width: null,
                    alignment: null,
                    groupIndex: null,
                    fixed: true,
                    sortOrder: 'asc',
                    allowSorting: true,
                    subColumns: []
                }, {
                    dataField: 'VidsVykon',
                    caption: '% виконаних',
                    dataType: null,
                    format: null,
                    width: null,
                    alignment: null,
                    groupIndex: null,
                    fixed: true,
                    sortOrder: 'asc',
                    allowSorting: true,
                    subColumns: []
                }, {
                    dataField: 'VidsZad',
                    caption: '% задоволеності',
                    dataType: null,
                    format: null,
                    width: null,
                    alignment: null,
                    groupIndex: null,
                    fixed: true,
                    sortOrder: 'asc',
                    allowSorting: true,
                    subColumns: []
                }, {
                    dataField: 'VidsRozyasn',
                    caption: '% роз`янесно',
                    dataType: null,
                    format: null,
                    width: null,
                    alignment: null,
                    groupIndex: null,
                    fixed: true,
                    sortOrder: 'asc',
                    allowSorting: true,
                    subColumns: []
                }, {
                    dataField: 'ReitCoef',
                    caption: 'Рейтинговий коефіціент',
                    dataType: null,
                    format: null,
                    width: null,
                    alignment: null,
                    groupIndex: null,
                    fixed: true,
                    sortOrder: 'asc',
                    allowSorting: true,
                    subColumns: []
                }, {
                    dataField: 'PlaceReitNew',
                    caption: 'Місце у рейтингу (нове)',
                    dataType: null,
                    format: null,
                    width: null,
                    alignment: null,
                    groupIndex: null,
                    fixed: true,
                    sortOrder: 'asc',
                    allowSorting: true,
                    subColumns: []
                }, {
                    dataField: 'PlaceReitOld',
                    caption: 'Місце у рейтингу (старе)',
                    dataType: null,
                    format: null,
                    width: null,
                    alignment: null,
                    groupIndex: null,
                    fixed: true,
                    sortOrder: 'asc',
                    allowSorting: true,
                    subColumns: []
                }
            ],
            export: {
                enabled: false,
                fileName: 'File_name'
            },
            searchPanel: {
                visible: true,
                highlightCaseSensitive: true
            },
            pager: {
                showPageSizeSelector: false,
                allowedPageSizes: [10, 15, 30],
                showInfo: false,
                pageSize: 15
            },
            editing: {
                enabled: false,
                allowAdding: false
            },
            scrolling: {
                mode: 'standart',
                rowRenderingMode: null,
                columnRenderingMode: null,
                showScrollbar: null
            },
            keyExpr: 'OrganizationId',
            showBorders: true,
            showColumnLines: true,
            showRowLines: true,
            remoteOperations: null,
            allowColumnReordering: null,
            rowAlternationEnabled: null,
            columnAutoWidth: null,
            hoverStateEnabled: true,
            columnWidth: null,
            wordWrapEnabled: true,
            allowColumnResizing: true,
            showFilterRow: false,
            showHeaderFilter: false,
            showColumnChooser: false,
            showColumnFixing: true,
            groupingAutoExpandAll: null,
            masterDetail: null
        },
        sub1: {},
        filter_month: '2018-12',
        init: function() {
            this.sub1 = this.messageService.subscribe('GlobalFilterChanged', this.chengeFilters, this);
            this.loadData();
        },
        chengeFilters:function(message) {
            this.filter_month = message.package.value.values[0].value.viewValue;
            this.config.query.queryCode = 'db_third';
            this.config.query.parameterValues = [
                { key: '@dat', value: this.filter_month}
            ];
            this.loadData();
        },
        destroy: function() {
            this.sub1.unsubscribe();
        }
    };
}());
