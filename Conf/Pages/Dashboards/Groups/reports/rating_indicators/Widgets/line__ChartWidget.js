(function() {
    return {
        chartConfig: {
            chart: {
                type: 'line'
            },
            title: {
                text: 'Динаміка РДА по місцях'
            },
            plotOptions: {
                line: {
                    dataLabels: {
                        enabled: true
                    },
                    enableMouseTracking: false
                }
            },
            series: [],
            credits: {
                enabled: false
            },
            yAxis: {
                title: {
                    text: 'Місце'
                }
            },
            xAxis: {
                categories: []
            }
        },
        colors: [
            'rgb(124, 181, 236)',
            'rgb(241, 92, 128)',
            'rgb(228, 211, 84)',
            'rgb(128, 133, 233)',
            'rgb(144, 237, 125)',
            'rgb(56, 81, 123)',
            'rgb(247, 163, 92)',
            'rgb(18, 121, 13)',
            'rgb(244, 91, 91)',
            'rgb(145, 232, 225)'
        ],
        init: function() {
            this.sub = this.messageService.subscribe('FiltersParams', this.setFiltersParams, this);
            this.sub1 = this.messageService.subscribe('showInfo', this.showInfo, this);
        },
        executeQuery: function() {
            const query = {
                'queryCode': 'db_ReestrRating_LineChart',
                'limit': -1,
                'parameterValues': [
                    {
                        'key': '@CalcDate',
                        'value': this.date
                    },
                    {
                        'key': '@RatingId',
                        'value': this.rating
                    }
                ]
            };
            this.queryExecutor(query, this.load, this);
            this.showPreloader = false;
        },
        load: function(data) {
            this.setChartSeries(data);
            this.render();
        },
        setFiltersParams: function(message) {
            this.date = message.date;
            this.rating = message.rating;
        },
        showInfo: function() {
            this.executeQuery();
        },
        setChartSeries: function(data) {
            this.chartConfig.series = [];
            this.chartConfig.series = this.getSeriesData(data);
        },
        getSeriesData: function(array) {
            let result = [];
            let categories = this.chartConfig.xAxis.categories = [];
            for (let i = 2; i < array.columns.length; i++) {
                let day = array.columns[i];
                let value = day.code;
                categories.push(value);
            }
            for (let j = 0; j < array.rows.length; j++) {
                let data = [];
                let row = array.rows[j];
                let name = row.values[1];
                let color = this.colors[j];
                for (let index = 2; index < row.values.length; index++) {
                    let value = row.values[index];
                    data.push(value);
                }
                let obj = { name, data, color }
                result.push(obj);
            }
            return result;
        },
        destroy: function() {
            this.sub.unsubscribe();
            this.sub1.unsubscribe();
        }
    };
}());
