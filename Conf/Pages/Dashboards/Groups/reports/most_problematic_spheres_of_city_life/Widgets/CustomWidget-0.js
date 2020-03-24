(function() {
    return {
        title: ' ',
        hint: ' ',
        formatTitle: function() { },
        customConfig:
            `
            <div id='widgetTitle' ></div>
            `
        ,
        afterViewInit: function() {
            document.getElementById('widgetTitle').innerText = 'ТОП-10 найпроблемніших сфер життєдіяльності міста за перiод: ';
        }
    };
}());
