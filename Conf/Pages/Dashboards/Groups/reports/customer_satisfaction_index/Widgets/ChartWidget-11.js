(function() {
    return {
        chartConfig:{
            chart: {
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false,
                type: 'pie'
            },
            title: {
                text: 'Важливість показників'
            },
            tooltip: {
                pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: false
                    },
                    showInLegend: true
                }
            },
            series: []
        },
        init: function() {
            this.sub = this.messageService.subscribe('FilterParams', this.setFilterValues, this);
        },
        setFilterValues: function(message) {
            this.dateFrom = message.dateFrom;
            this.dateTo = message.dateTo;
            if(this.dateFrom && this.dateTo) {
                this.executeQuery();
            }
        },
        executeQuery: function() {
            const query = {
                'queryCode': 'ak_CSI_graph1_6',
                'limit': -1,
                'parameterValues': [
                    {
                        'key': '@date_from',
                        'value': this.dateFrom
                    },
                    {
                        'key': '@date_to',
                        'value': this.dateTo
                    }
                ]
            };
            this.queryExecutor(query, this.load, this);
        },
        load: function(data) {
            this.fillIndexes(data);
            this.setChartSeries(data);
            this.render();
        },
        fillIndexes: function(data) {
            this.valueId = this.getIndex(data, 'id');
            this.grade = this.getIndex(data, 'grade');
            this.countQuestions = this.getIndex(data, 'count_questions');
        },
        getIndex: function(data, name) {
            return data.columns.findIndex((el) => {
                return el.code.toLowerCase() === name;
            })
        },
        setChartSeries: function(data) {
            const chartData = {
                name: 'this.chartConfig.title.text',
                colorByPoint: true,
                data: this.getSeriesData(data)
            };
            this.chartConfig.series = [];
            this.chartConfig.series.push(chartData);
        },
        getSeriesData: function(data) {
            let result = [];
            for (let i = 0; i < data.rows.length; i++) {
                let element = {
                    id: data.rows[i].values[this.valueId],
                    name: data.rows[i].values[this.countQuestions],
                    y: data.rows[i].values[this.grade]
                }
                result.push(element);
            }
            return result;
        },
        destroy: function() {
            this.sub.unsubscribe();
        }
    };
}());
