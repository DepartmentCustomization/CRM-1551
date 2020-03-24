(function() {
    return {
        title: ' ',
        hint: ' ',
        formatTitle: function() { },
        customConfig:
            `
            <div id='chartInfo' class='contentBox' ></div>
            `
        ,
        MESSAGES: {
            CHART_INFO: 'CHART_INFO'
        },
        subsctiptions: [],
        colors: {},
        groupQuestionId: undefined,
        groupQuestionName: undefined,
        qty: undefined,
        chartData: {},
        init: function() {
            const sub = this.messageService.subscribe(this.MESSAGES.CHART_INFO, this.setChartInfo, this);
            this.subsctiptions.push(sub);
        },
        createChartInfo: function() {
            const data = this.chartData;
            const chartInfo = document.getElementById('chartInfo');
            this.clearChartInfo(chartInfo);
            let infoWrapper = this.createElement('div', {
                id: 'infoWrapper'
            });
            chartInfo.appendChild(infoWrapper);
            for (let i = 0; i < data.rows.length; i++) {
                let sphereDot = this.createElement('div', {
                    className: 'sphere__dot material-icons',
                    innerText: 'fiber_manual_record'
                });
                sphereDot.style.color = this.colors[i];
                let sphereText = this.createElement('div', {
                    className: 'sphere__text',
                    innerText: data.rows[i].values[this.groupQuestionName] +
                        ' ' +
                        data.rows[i].values[this.qty]
                });
                let sphere = this.createElement('div', {
                    className: 'sphere'
                }, sphereDot, sphereText);
                infoWrapper.appendChild(sphere);
            }
        },
        createElement: function(tag, props, ...children) {
            const element = document.createElement(tag);
            Object.keys(props).forEach(key => element[key] = props[key]);
            if (children.length > 0) {
                children.forEach(child => {
                    element.appendChild(child);
                });
            }
            return element;
        },
        destroy: function() {
            this.subsctiptions.forEach((item) => {
                item.unsubscribe();
            });
        },
        setChartInfo: function(message) {
            this.colors = message.package.colors;
            this.groupQuestionId = message.package.groupQuestionId;
            this.groupQuestionName = message.package.groupQuestionName;
            this.qty = message.package.qty;
            this.chartData = message.package.chartData;
            this.createChartInfo();
        },
        clearChartInfo: function(chartInfo) {
            while (chartInfo.hasChildNodes()) {
                chartInfo.removeChild(chartInfo.lastElementChild);
            }
        }
    };
}());
