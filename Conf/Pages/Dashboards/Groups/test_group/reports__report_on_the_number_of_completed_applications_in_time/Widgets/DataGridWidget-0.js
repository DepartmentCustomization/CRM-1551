(function() {
    return {
        config: {
            query: {
                code: 'db_second',
                parameterValues: [
                    {key: '@date_start', value: this.start_date},
                    {key: '@date_end', value: this.finish_date},
                    {key: '@place_id', value: this.place}
                ],
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
                    dataField: 'Bylo',
                    caption: 'Було',
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
                    dataField: 'Nadiyshlo',
                    caption: 'Надійшло',
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
                    dataField: 'VRoboti',
                    caption: 'В роботі',
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
                    dataField: 'dovidoma',
                    caption: 'Виконано',
                    dataType: null,
                    format: null,
                    width: null,
                    alignment: null,
                    groupIndex: null,
                    fixed: true,
                    sortOrder: 'asc',
                    allowSorting: true,
                    subColumns: [{
                        caption: 'Вчасно',
                        dataField: 'VykonVchasno'
                    }, {
                        caption: 'Не вчасно',
                        dataField: 'VykonNeVchasno'
                    }]
                }, {
                    dataField: 'RozyasnenoVchasno',
                    caption: 'Роз`янесно',
                    dataType: null,
                    format: null,
                    width: null,
                    alignment: null,
                    groupIndex: null,
                    fixed: true,
                    sortOrder: 'asc',
                    allowSorting: true,
                    subColumns: [{
                        caption: 'Вчасно',
                        dataField: 'RozyasnenoVchasno'
                    }, {
                        caption: 'Не вчасно',
                        dataField: 'RozyasnenoNeVchasno'
                    }]
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
        sub: {},
        place: '',
        start_date: '',
        finish_date: '',
        filter_dataStart: '03.10.2018',
        filter_dataEnd: '10.10.2018',
        init: function() {
            const weekAgo = 1000 * 60 * 60 * 24 * 7;
            const currentDate = new Date();
            let startDate = new Date(Date.now() - weekAgo);
            this.filter_dataStart = startDate;
            this.filter_dataEnd = currentDate;
            this.sub = this.messageService.subscribe('GlobalFilterChanged', this.chengeFilters, this);
            this.config.query.queryCode = 'db_second';
            this.config.query.parameterValues = [
                {key: '@date_start', value: this.filter_dataStart},
                {key: '@date_end', value: this.filter_dataEnd},
                {key: '@place_id', value: this.place}
            ];
            this.loadData();
        },
        chengeFilters:function(message) {
            this.place = message.package.value.values[1].value.value;
            function checkDateFrom(val) {
                return val ? val.dateFrom : null;
            }
            function checkDateTo(val) {
                return val ? val.dateTo : null;
            }
            this.start_date = checkDateFrom(message.package.value.values[0].value);
            this.finish_date = checkDateTo(message.package.value.values[0].value);
            this.config.query.queryCode = 'db_first';
            this.config.query.parameterValues = [
                {
                    key:'@date_start',
                    value: this.start_date
                }, {
                    key: '@date_end' ,
                    value: this.finish_date
                },{
                    key:'@place_id',
                    value: this.place
                }
            ];
            this.loadData();
        },
        destroy: function() {
            this.sub.unsubscribe();
        }
    };
}());
