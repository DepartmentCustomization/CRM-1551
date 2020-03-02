(function() {
    return {
        config: {
            query: {
                code: 'db_first',
                parameterValues: [{key: '@date_start', value: this.start_date},{key: '@date_end', value: this.finish_date}],
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
                    dataField: 'AllCount',
                    caption: 'Загальна к-ть звернень',
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
                    dataField: 'ZakrVchasno',
                    caption: 'Закрито',
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
                        dataField: 'ZakrVchasno'
                    }, {
                        caption: 'Не вчасно',
                        dataField: 'ZakrNeVchasno'
                    }]
                }, {
                    dataField: 'VidsVchasnoZakr',
                    caption: '% закритих вчасно',
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
            sortingMode: 'multiple',
            groupingAutoExpandAll: null,
            masterDetail: null
        },
        sub: {},
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
            this.config.query.queryCode = 'db_first';
            this.config.query.parameterValues = [
                {key: '@date_start', value: this.filter_dataStart},
                {key: '@date_end', value: this.filter_dataEnd}
            ];
            this.loadData();
        },
        chengeFilters:function(message) {
            function checkDateFrom(val) {
                return val ? val.dateFrom : null;
            }
            function checkDateTo(val) {
                return val ? val.dateTo : null;
            }
            this.start_date = checkDateFrom(message.package.value.values[0].value);
            this.finish_date = checkDateTo(message.package.value.values[0].value);
            this.config.query.queryCode = 'db_first';
            this.config.query.parameterValues = [{
                key:'@date_start',
                value: this.start_date
            },
            {
                key: '@date_end' ,
                value: this.finish_date
            }];
            this.loadData();
        },
        destroy: function() {
            this.sub.unsubscribe();
        }
    };
}());
