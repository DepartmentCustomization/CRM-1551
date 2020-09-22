(function() {
    return {
        chartConfig: {
            chart: {
                type: 'pie',
                options3d: {
                    enabled: true,
                    alpha: 45,
                    beta: 0
                }
            },
            title: {
                text: ''
            },
            plotOptions: {
                pie: {
                    cursor: 'pointer',
                    depth: 35,
                    dataLabels: {
                        enabled: true,
                        format: '{point.name}: {point.y}'
                    },
                    showInLegend: false,
                    point: {
                        events: {
                        }
                    }
                }
            },
            series: [],
            credits: {
                enabled: false
            }
        },
        MESSAGES: {
            CHART_INFO: 'CHART_INFO'
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
        dateFrom: new Date(),
        dateTo: new Date(),
        groupQuestionId: undefined,
        groupQuestionName: undefined,
        qty: undefined,
        firstLoad: true,
        init: function() {
            this.sub = this.messageService.subscribe('GlobalFilterChanged', this.getFiltersParams, this);
            this.sub1 = this.messageService.subscribe('ApplyGlobalFilters', this.applyChanges, this);
            this.chartConfig.plotOptions.pie.point.events.click = this.clickOnPie.bind(this);
        },
        clickOnPie: function(e) {
            const id = e.point.id;
            const name = e.point.name;
            const dateFrom = this.dateFrom;
            const dateTo = this.dateTo;
            const organization = this.organization;
            const organizationGroup = this.organizationGroup;
            const sources = this.sources;
            window.open(
                location.origin +
                localStorage.getItem('VirtualPath') +
                '/dashboard/page/the_most_problematic_issues_of_the_sphere' +
                '?id=' + id +
                '&name=' + name +
                '&dateFrom=' + dateFrom +
                '&dateTo=' + dateTo +
                '&organization=' + organization +
                '&organizationGroup=' + organizationGroup +
                '&sourceId=' + sources
            );
        },
        applyChanges: function() {
            const msg = {
                name: 'SetFilterPanelState',
                package: {
                    value: false
                }
            };
            this.messageService.publish(msg);
            this.queryExecutor(this.query, this.load, this);
        },
        executeQuery: function() {
            this.query = {
                'queryCode': 'db_Report_8_1',
                'limit': -1,
                'parameterValues': [
                    { 'key': '@dateFrom','value': this.dateFrom },
                    { 'key': '@dateTo', 'value': this.dateTo },
                    { 'key': '@organization', 'value': this.organization },
                    { 'key': '@organizationGroup', 'value': this.organizationGroup },
                    { 'key': '@sourceId', 'value': this.sources.toString() }
                ]
            };
            if (this.firstLoad) {
                this.queryExecutor(this.query, this.load, this);
                this.firstLoad = false;
            }
        },
        load: function(data) {
            this.fillIndexes(data);
            this.publishMessage(data);
            this.setChartSeries(data);
            this.render();
        },
        publishMessage: function(data) {
            const message = {
                name: this.MESSAGES.CHART_INFO,
                package: {
                    colors: this.colors,
                    groupQuestionId: this.groupQuestionId,
                    groupQuestionName: this.groupQuestionName,
                    qty: this.qty,
                    sources: this.sources,
                    chartData: data
                }
            };
            this.messageService.publish(message);
        },
        getFiltersParams: function(message) {
            let period = message.package.value.values.find(f => f.name === 'period').value;
            let organization = message.package.value.values.find(f => f.name === 'organization').value;
            let organizationGroup = message.package.value.values.find(f => f.name === 'organizationGroup').value;
            let sources = message.package.value.values.find(f => f.name === 'sources').value;
            if (period !== null) {
                if (period.dateFrom !== '' && period.dateTo !== '') {
                    this.sources = this.extractValues(sources);
                    this.dateFrom = period.dateFrom;
                    this.dateTo = period.dateTo;
                    this.organization = organization === null ? 0 : organization === '' ? 0 : organization.value;
                    this.organizationGroup = organizationGroup === null ? 0 : organizationGroup === '' ? 0 : organizationGroup.value;
                    this.sources = sources.toString() === '' ? '0' : this.sources.toString();
                    this.executeQuery();
                }
            }
        },
        extractValues: function(items) {
            if (items.length && items !== '') {
                const valuesList = [];
                items.forEach(item => valuesList.push(item.value));
                return valuesList;
            }
            return [];
        },
        fillIndexes: function(data) {
            this.groupQuestionId = this.getIndex(data, 'groupquestionid');
            this.groupQuestionName = this.getIndex(data, 'groupquestionname');
            this.qty = this.getIndex(data, 'qty');
        },
        setChartSeries: function(data) {
            const chartData = {
                name: 'Кіл-ть заявок',
                colorByPoint: true,
                data: this.getSeriesData(data)
            };
            this.chartConfig.series = [];
            this.chartConfig.series.push(chartData);
        },
        getIndex: function(data, name) {
            return data.columns.findIndex((el) => {
                return el.code.toLowerCase() === name;
            })
        },
        getSeriesData: function(data) {
            let result = [];
            for (let i = 0; i < data.rows.length; i++) {
                let element = {
                    id: data.rows[i].values[this.groupQuestionId],
                    name: data.rows[i].values[this.groupQuestionName],
                    y: data.rows[i].values[this.qty],
                    color: this.colors[i]
                }
                result.push(element);
            }
            return result;
        },
        destroy: function() {
            this.sub.unsubscribe();
            this.sub1.unsubscribe();
        }
    };
}());
