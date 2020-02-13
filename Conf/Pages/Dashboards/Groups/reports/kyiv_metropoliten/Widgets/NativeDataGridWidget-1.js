(function() {
    return {
        config: {
            query: {
                code: 'db_Report_metro2',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [
                {
                    dataField: 'qType',
                    caption: 'Питання'
                }, {
                    dataField: 'qty',
                    caption: 'Кількість '
                }
            ],
            summary: {
                totalItems: [
                    {
                        column: 'qty',
                        summaryType: 'sum',
                        customizeText: function(data) {
                            return 'Всього: ' + data.value;
                        }
                    }
                ]
            },
            keyExpr: 'Id'
        },
        init: function() {
            this.sub = this.messageService.subscribe('GlobalFilterChanged', this.getFiltersParams , this);
            this.loadData(this.afterLoadDataHandler);
        },
        getFiltersParams: function(message) {
            const period = message.package.value.values.find(f => f.name === 'period').value;
            if(period !== null) {
                if(period.dateFrom !== '' && period.dateTo !== '') {
                    this.dateFrom = period.dateFrom;
                    this.dateTo = period.dateTo;
                    this.config.query.parameterValues = [
                        {key: '@dateFrom' , value: this.dateFrom },
                        {key: '@dateTo', value: this.dateTo }
                    ];
                    this.loadData(this.afterLoadDataHandler);
                }
            }
        },
        afterLoadDataHandler: function(data) {
            this.messageService.publish({name: 'setData', rep2_data: data});
            this.render();
        },
        destroy: function() {
            this.sub.unsubscribe();
        }
    };
}());
