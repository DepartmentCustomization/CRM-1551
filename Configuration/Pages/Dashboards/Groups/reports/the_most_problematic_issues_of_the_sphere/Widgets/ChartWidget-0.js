(function () {
  return {
    title: ' ',
    hint: ' ',
    formatTitle: function() {},
    customConfig:
                `
                
                <style>
                    #TITLE__WRAPPER{
                        display: flex;
                        justify-content: space-between;
                        text-align: center;
                    }
                    #widgetTitle{
                        width: 37%;
                        font-weight: 600;
                        font-size: 20px;
                        margin: 0 auto;
                    }
                    #CONTENT__BOX{
                        margin-top: 50px;
                        display: flex;
                        justify-content: space-around;
                    }
                    #chartInfo{
                        margin-left: 50px;
                    }
                    .contentBox{
                        width: 50%;
                        height: 100%;
                    }
                    .sphere{
                        display: flex;
                        align-items: center;
                    }
                    .sphere__text{
                        display: flex;
                        align-items: center;
                        font-size: 18px;
                        font-weight: 600;
                        margin-left: 10px;
                        padding: 10px;
                    }
                    .sumText{
                        font-size: 22px;
                        font-weight: 600;
                        margin-top: 50px;                        
                    }
                    
                </style>
                <div id="container" /*style="height: 700px; width: 50%"*/>
                    <div id='TITLE__WRAPPER'>
                        <div id='widgetTitle' ></div>
                    </div>
                    <div id='CONTENT__BOX' >
                        <div id='pieChart'  class='contentBox'></div>
                        <div id='chartInfo' class='contentBox' ></div>
                    </div>
                
                
                
                </div>
                `
    , 
    init: function() {
        
        this.colors = {
            0: 'rgb(124, 181, 236)',
            1: 'rgb(241, 92, 128)',
            2: 'rgb(228, 211, 84)',
            3: 'rgb(128, 133, 233)',
            4: 'rgb(144, 237, 125)',
            5: 'rgb(56, 81, 123)',
            6: 'rgb(247, 163, 92)',
            7: 'rgb(18, 121, 13)',
            8: 'rgb(244, 91, 91)',
            9: 'rgb(145, 232, 225)',
        }
        
        let getUrlParams = window
                            .location
                                .search
                                    .replace('?', '')
                                        .split('&')
                                            .reduce(function(p, e) {
                                                      var a = e.split('=');
                                                      p[decodeURIComponent(a[0])] = decodeURIComponent(a[1]);
                                                      return p;
                                                    }, {}
                                                );                                            
        this.sphereId = Number(getUrlParams.sphereId);
        this.sphereName = getUrlParams.name;
        this.dateFromViewValues = this.changeDateTimeValues(getUrlParams.dateFrom);
        this.dateToViewValues = this.changeDateTimeValues(getUrlParams.dateTo);  
        dateFrom = getUrlParams.dateFrom;
        dateTo = getUrlParams.dateTo;
        this.dateFrom = new Date(dateFrom);
        this.dateTo = new Date(dateTo);
        
        let loadPie = {
            queryCode: 'db_Report_8_2',
            limit: -1,
            parameterValues: [
                { key: '@dateFrom', value: this.dateFrom},    
                { key: '@dateTo', value: this.dateTo},  
                { key: '@typeId', value: this.sphereId},
            ]
        };
        this.queryExecutor(loadPie, this.load, this);
        
    },
	createElement: function(tag, props, ...children) {
        const element = document.createElement(tag);
        Object.keys(props).forEach( key => element[key] = props[key] );
        if(children.length > 0){
            children.forEach( child =>{
                element.appendChild(child);
            });
        } return element;
    },    
    load: function(data){
        document.getElementById('widgetTitle').innerText = 'ТОП-10 найпроблемніших питань сфери «'+this.sphereName+'» за перiод: ' +this.dateFromViewValues+ ' по: '+this.dateToViewValues;
        this.createChartInfo(data);
        const self = this;
        function func(self) {
            
            this.seriesData = [];
            let indexId = data.columns.findIndex(el => el.code.toLowerCase() === 'id' );
            let indexName = data.columns.findIndex(el => el.code.toLowerCase() === 'qname' );
            let indexValue = data.columns.findIndex(el => el.code.toLowerCase() === 'qty' );
        
            for(let i = 0; i < data.rows.length; i++){
                let element = {
                    id: data.rows[i].values[indexId],
                    name:  data.rows[i].values[indexName],
                    y:  data.rows[i].values[indexValue],
                    color: self.colors[i]
                }
                this.seriesData.push(element);
            }
            this.Highcharts.chart('pieChart', {
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
                tooltip: {
                    pointFormat: '{series.name}: <b>{point.y}</b>'
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        cursor: 'pointer',
                        depth: 35,
                        dataLabels: {
                            enabled: true,
                            format: '<b>{point.percentage:.1f}%</b>'
                        }
                    }
                },
                series: [{
                    name: 'Кіл-ть заявок',
                    colorByPoint: true,
                    
                    data: this.seriesData
                }]
            });
            
        }
        setTimeout(func(self), 50);
    },
    createChartInfo: function(data){
        const CHART__INFO = document.getElementById('chartInfo');
        while(CHART__INFO.hasChildNodes()){
            CHART__INFO.removeChild(CHART__INFO.lastElementChild);
        }
        
        let infoWrapper = this.createElement('div', { id: 'infoWrapper' } );
        CHART__INFO.appendChild(infoWrapper);
        
        
        let indexId = data.columns.findIndex(el => el.code.toLowerCase() === 'Id' );
        let indexName = data.columns.findIndex(el => el.code.toLowerCase() === 'qname' );
        let indexValue = data.columns.findIndex(el => el.code.toLowerCase() === 'qty' );
        
        for(let i = 0; i < data.rows.length; i++){
            let sphere__dot = this.createElement('div', {className: 'sphere__dot material-icons', innerText: 'fiber_manual_record'} );
            sphere__dot.style.color = this.colors[i];
            let sphere__text = this.createElement('div', {className: 'sphere__text', innerText: data.rows[i].values[indexName] + ': ' + data.rows[i].values[indexValue]   } );
            let sphere = this.createElement('div', {className: 'sphere'}, sphere__dot, sphere__text );
            infoWrapper.appendChild(sphere);
        }
        var result = data.rows.reduce(function(sum, current) {
            return sum + current.values[0];
        }, 0);
        let sumText = this.createElement('div', { className: 'sumText', innerText: 'Всього по ТОП 10 питань: '  + result } );
        let sumWrapper = this.createElement('div', { id: 'sumWrapper' }, sumText );
        CHART__INFO.appendChild(sumWrapper);
    },
    changeDateTimeValues: function(value){
        let date = new Date(value);
        let dd = date.getDate().toString();
        let mm = (date.getMonth() + 1).toString();
        let yyyy = date.getFullYear();
        dd = dd.length === 1 ? '0' + dd : dd;
        mm = mm.length === 1 ? '0' + mm : mm;
        return dd + '.' + mm + '.' + yyyy ;
    },   
};
}());
