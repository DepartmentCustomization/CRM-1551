(function() {
    return {
        chartConfig:{
            title: {
                text: 'Швидкiсть реагування виконавця'
            },
            xAxis: {
                categories: []
            },
            yAxis: {
                title: {
                    text: ''
                }
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'middle'
            },
            plotOptions: {
                series: {
                    label: {
                        connectorAllowed: false
                    },
                    pointStart: 1
                }
            },
            series: [],
            responsive: {
                rules: [{
                    condition: {
                        maxWidth: 500
                    },
                    chartOptions: {
                        legend: {
                            layout: 'horizontal',
                            align: 'center',
                            verticalAlign: 'bottom'
                        }
                    }
                }]
            }
        },
        init: function() {
            this.sub = this.messageService.subscribe('FilterParams', this.setFilterValues, this);
        },
        setFilterValues: function(message) {
            this.dateFrom = message.dateFrom;
            this.dateTo = message.dateTo;
            this.chartConfig.yAxis.title.text = message.yAxis;
            if(this.dateFrom && this.dateTo) {
                this.executeQuery();
            }
        },
        executeQuery: function() {
            const query = {
                'queryCode': 'ak_CSI_graph1_9',
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
            this.calcDate = this.getIndex(data, 'calc_date');
            this.average = this.getIndex(data, 'average');
        },
        getIndex: function(data, name) {
            return data.columns.findIndex((el) => {
                return el.code.toLowerCase() === name;
            })
        },
        setChartSeries: function(data) {
            const chartData = {
                name: this.chartConfig.title.text,
                colorByPoint: true,
                data: this.getSeriesData(data)
            };
            this.chartConfig.series = [];
            this.chartConfig.series.push(chartData);
        },
        getSeriesData: function(data) {
            let result = [];
            this.chartConfig.xAxis.categories = [];
            for (let i = 0; i < data.rows.length; i++) {
                const value = data.rows[i].values[this.average];
                const caption = data.rows[i].values[this.calcDate];
                this.chartConfig.xAxis.categories.push(caption);
                result.push(value);
            }
            return result;
        },
        destroy: function() {
            this.sub.unsubscribe();
        }
    };
}());
