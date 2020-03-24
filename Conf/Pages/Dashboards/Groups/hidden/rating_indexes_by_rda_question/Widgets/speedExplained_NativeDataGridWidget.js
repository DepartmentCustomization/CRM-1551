(function() {
    return {
        config: {
            query: {
                code: 'db_ReestrRating1',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [
                {
                    dataField: 'RDAId',
                    dataType: 'string',
                    caption: 'Номер питання'
                }, {
                    dataField: 'PercentClosedOnTime',
                    caption: 'Ид асигмента'
                }, {
                    dataField: 'PercentClosedOnTime',
                    caption: 'дата надходження'
                }, {
                    dataField: 'PercentClosedOnTime',
                    caption: 'Тип питання'
                }, {
                    dataField: 'PercentClosedOnTime',
                    caption: 'кількість днів виконання'
                }, {
                    dataField: 'PercentClosedOnTime',
                    caption: 'дата виконання'
                }
            ],
            keyExpr: 'Id'
        },
        init: function() {
            const getUrlParams = window
                .location
                .search
                .replace('?', '')
                .split('&')
                .reduce(function(p, e) {
                    let a = e.split('=');
                    p[decodeURIComponent(a[0])] = decodeURIComponent(a[1]);
                    return p;
                }, {}
                );
            const executor = getUrlParams.executor;
            const date = getUrlParams.period;
            const ratingId = getUrlParams.rating;
            const rdaId = getUrlParams.dataField;
            const question = getUrlParams.code;
            this.config.query.parameterValues = [
                {key: '@Date' , value: date },
                {key: '@RDAId', value: rdaId },
                {key: '@RatingId', value: ratingId },
                {key: '@Question', value: question },
                {key: '@Executor', value: executor }
            ];
            this.loadData(this.afterLoadDataHandler);
            this.active = false;
            document.getElementById('containerSpeedExplained').style.display = 'none';
            this.sub = this.messageService.subscribe('showTable', this.showTable, this);
        },
        showTable: function(message) {
            let tabName = message.tabName;
            if(tabName !== 'tabSpeedExplained') {
                this.active = false;
                document.getElementById('containerSpeedExplained').style.display = 'none';
            }else {
                this.active = true;
                document.getElementById('containerSpeedExplained').style.display = 'block';
            }
        },
        renderTable: function() {
            if (this.active) {
                let msg = {
                    name: 'SetFilterPanelState',
                    package: {
                        value: false
                    }
                };
                this.messageService.publish(msg);
                this.config.query.parameterValues = [
                    {key: '@DateCalc' , value: this.period },
                    {key: '@RDAId', value: this.executor },
                    {key: '@RatingId', value: this.rating }
                ];
                this.loadData(this.afterLoadDataHandler);
            }
        },
        afterLoadDataHandler: function() {
            this.render();
        },
        destroy: function() {
            this.sub.unsubscribe();
        }
    };
}());
