(function() {
    return {
        chartConfig: {
            chart: {
                type: 'column'
            },
            title: {
                text: 'Консультації'
            },
            subtitle: {
                text: ''
            },
            xAxis: {
                categories: []
            },
            yAxis: {
                title: {
                    text: 'Кількість'
                }
            },
            plotOptions: {
                line: {
                    dataLabels: {
                        enabled: true
                    },
                    enableMouseTracking: false
                }
            },
            series: []
        },
        init: function() {
            const query = this.query('ak_NPS_Index1_2');
            this.queryExecutor(query, this.getYesterdayIndex, this);
            this.showPreloader = false;
            this.sub = this.messageService.subscribe('GlobalFilterChanged', this.getFiltersParams, this);
        },
        getYesterdayIndex: function(data) {
            let value = 0;
            if (data.rows.length) {
                value = data.rows[0].values[0];
            }
            this.chartConfig.subtitle.text = value;
        },
        getFiltersParams: function(message) {
            let period = message.package.value.values.find((el) => {
                return el.name.toLowerCase() === 'period';
            });
            const value = period.value;
            if (value !== null) {
                if (value.dateFrom !== '' && value.dateTo !== '') {
                    this.dateFrom = value.dateFrom;
                    this.dateTo = value.dateTo;
                    this.executeQuery();
                }
            }
        },
        executeQuery: function() {
            const query = this.query('ak_NPS_Graf1_2');
            this.queryExecutor(query, this.load, this);
            this.showPreloader = false;
        },
        query: function(queryCode) {
            return {
                'queryCode': queryCode,
                'limit': -1,
                'parameterValues': [
                    { 'key': '@date_from', 'value': this.dateFrom },
                    { 'key': '@date_to', 'value': this.dateTo }
                ]
            };
        },
        load: function(data) {
            this.fillIndexes(data);
            this.setChartSeries(data);
            this.render();
        },
        fillIndexes: function(data) {
            this.id = this.getIndex(data, 'id');
            this.grade = this.getIndex(data, 'grade');
            this.countPeople = this.getIndex(data, 'count_people');
        },
        getIndex: function(data, name) {
            return data.columns.findIndex(el => {
                return el.code.toLowerCase() === name;
            })
        },
        setChartSeries: function(data) {
            const chartData = {
                name: 'Оцінка',
                data: this.getSeriesData(data)
            };
            const categories = this.getCategories(data);
            this.chartConfig.series = [];
            this.chartConfig.series.push(chartData);
            this.chartConfig.xAxis.categories = [];
            this.chartConfig.xAxis.categories = categories;
        },
        getSeriesData: function(data) {
            let result = [];
            for (let i = 0; i < data.rows.length; i++) {
                let value = data.rows[i].values[this.countPeople];
                value = value === null ? 0 : value;
                result.push(value);
            }
            return result;
        },
        getCategories: function(data) {
            let result = [];
            for (let i = 0; i < data.rows.length; i++) {
                let value = data.rows[i].values[this.grade];
                result.push(value);
            }
            return result;
        },
        setDete: function(value) {
            let date = new Date(value);
            let dd = date.getDate().toString();
            let mm = (date.getMonth() + 1).toString();
            let yy = date.getFullYear().toString().slice(-2);
            dd = dd.length === 1 ? '0' + dd : dd;
            mm = mm.length === 1 ? '0' + mm : mm;
            return dd + '-' + mm + '-' + yy;
        },
        destroy: function() {
            this.sub.unsubscribe();
        }
    };
}());
