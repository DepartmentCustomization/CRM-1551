(function () {
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
            showInLegend: false
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
  
      init: function () {
        this.sub = this.messageService.subscribe('GlobalFilterChanged', this.getFiltersParams, this);
      },
  
      executeQuery: function () {
        const query = {
          "queryCode": "db_Report_8_1",
          "limit": -1,
          "parameterValues": [
            {
              "key": "@dateFrom",
              "value": this.dateFrom
            },
            {
              "key": "@dateTo",
              "value": this.dateTo
            }
          ]
        };
        this.queryExecutor(query, this.load, this);
      },
  
      load: function (data) {
        this.fillIndexes(data);
        this.publishMessage(data);
        this.setChartSeries(data);
        this.render();
      },
  
      publishMessage: function (data) {
        const message = {
          name: this.MESSAGES.CHART_INFO,
          package: {
            colors: this.colors,
            groupQuestionId: this.groupQuestionId,
            groupQuestionName: this.groupQuestionName,
            qty: this.qty,
            chartData: data
          }
        };
        this.messageService.publish(message);
      },
  
      getFiltersParams: function (message) {
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
  
      fillIndexes: function (data) {
        this.groupQuestionId = this.getIndex(data, 'groupquestionid');
        this.groupQuestionName = this.getIndex(data, 'groupquestionname');
        this.qty = this.getIndex(data, 'qty');
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
  
      getIndex: function (data, name) {
        return data.columns.findIndex((el) => {
          return el.code.toLowerCase() === name;
        })
      },
  
      getSeriesData: function (data) {
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
      }
    };
}());
  