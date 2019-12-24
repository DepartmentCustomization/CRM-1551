(function () {
    return {

        chartConfig: {
            chart: {
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false,
                type: 'pie'
            },
            title: {
                text: 'Частка за кількістю звернень в роботі'
            },
            tooltip: {
                pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        format: '<b>{point.name}</b>: {point.percentage:.1f} %'
                    },
                    showInLegend: true
                }
            },
            series: []
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

        init: function () {
            this.sub = this.messageService.subscribe( 'FiltersParams', this.setFiltersParams, this );
            this.sub1 = this.messageService.subscribe( 'showInfo', this.showInfo, this );  
        },

        setFiltersParams: function (message) {
            this.date = message.date;
            this.rating =   message.rating;
        },

        showInfo: function (message) {
            this.executeQuery();
        },

        executeQuery: function () {
            const query = {
                "queryCode": "db_ReestrRating_PieChart",
                "limit": -1,
                "parameterValues": [
                    {
                        "key": "@CalcDate",
                        "value": this.date
                    },
                    {
                        "key": "@RatingId",
                        "value": this.rating
                    }
                ]
            };
            this.queryExecutor(query, this.load, this);
            this.showPreloader = false;
        },

        load: function (data) {
            this.fillIndexes(data);
            this.setChartSeries(data);
            this.render();
        },

        fillIndexes: function (data) {
            this.indexRDAId = this.getIndex(data, 'rdaid');
            this.indexRDAName = this.getIndex(data, 'rdaname');
            this.indexIndicator = this.getIndex(data, 'indicator');
        },

        getIndex: function (data, name) {
            return data.columns.findIndex((el) => {
                return el.code.toLowerCase() === name;
            })
        },

        setChartSeries: function (data) {
            const chartData = {
                name: 'Кіл-ть заявок',
                colorByPoint: true,
                data: this.getSeriesData(data)
            };
            this.chartConfig.series = [];
            this.chartConfig.series.push(chartData);
        },

        getSeriesData: function (data) {
            let result = [];
            for (let i = 0; i < data.rows.length; i++) {
                let element = {
                    id: data.rows[i].values[this.indexRDAId],
                    name: data.rows[i].values[this.indexRDAName],
                    y: data.rows[i].values[this.indexIndicator],
                    color: this.colors[i]
                }
                result.push(element);
            }
            return result;
        },

        destroy: function () {
            this.sub.unsubscribe();      
            this.sub1.unsubscribe();      
        }
    };
}());
