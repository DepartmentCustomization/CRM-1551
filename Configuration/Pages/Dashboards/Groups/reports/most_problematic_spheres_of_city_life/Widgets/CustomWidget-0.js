(function () {
    return {
        title: ' ',
        hint: ' ',
        formatTitle: function () { },
        customConfig:
            `
            <style>
                #widgetTitle{
                    height: 100%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-weight: 600;
                    font-size: 20px;
                }
            </style>
            <div id='widgetTitle' ></div>
                `
        ,
        afterViewInit: function () {
            // document.getElementById('widgetTitle').innerText = 'ТОП-10 найпроблемніших сфер життєдіяльності міста за перiод: ' +this.dateFromViewValues+ ' по: '+this.dateToViewValues;
            document.getElementById('widgetTitle').innerText = 'ТОП-10 найпроблемніших сфер життєдіяльності міста за перiод: ';
        }
    };
}());
