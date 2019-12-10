(function () {
    return {
        title: ' ',
        hint: ' ',
        formatTitle: function () { },
        customConfig:
            `
            <style>
                #sumWrapper{
                    height: 100%;
                }
                .sumText{
                    font-size: 22px;
                    font-weight: 600;
                    text-align: center;
                    height: 100%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-weight: 600;
                    font-size: 20px;
                    margin: 0 auto;
                }
            </style>
            <div id='sumInfo' class='contentBox' ></div>
            `
        ,

        subsctiptions: [],

        MESSAGES: {
            CHART_INFO: 'CHART_INFO'
        },

        init: function () {
            const sub = this.messageService.subscribe(this.MESSAGES.CHART_INFO, this.setSumText, this);
            this.subsctiptions.push(sub);
        },

        destroy: function () {
            this.subsctiptions.forEach((item) => {
                item.unsubscribe();
            });
        },

        setSumText: function (message) {
            const data = message.package.chartData;
            var result = data.rows.reduce(function (sum, current) {
                return sum + current.values[2];
            }, 0);
            const sumInfo = document.getElementById('sumInfo');
            this.clearSumInfo(sumInfo);
            let sumText = this.createElement('div', {
                className: 'sumText',
                innerText: 'Всього по ТОП 10 сфер: ' + result
            });
            let sumWrapper = this.createElement('div', {
                id: 'sumWrapper'
            }, sumText);
            sumInfo.appendChild(sumWrapper);
        },

        createElement: function (tag, props, ...children) {
            const element = document.createElement(tag);
            Object.keys(props).forEach(key => element[key] = props[key]);
            if (children.length > 0) {
                children.forEach(child => {
                    element.appendChild(child);
                });
            }
            return element;
        },

        clearSumInfo: function (sumInfo) {
            while (sumInfo.hasChildNodes()) {
                sumInfo.removeChild(sumInfo.lastElementChild);
            }
        }
    };
}());
