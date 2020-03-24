(function() {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig:
                    `
                    <div id='reportTitle'>ТОП-10 найпроблемніших питань в розрізі районів</div>
                    `
        ,
        init: function() {
            const msg = {
                name: 'SetFilterPanelState',
                package: {
                    value: true
                }
            };
            this.messageService.publish(msg);
        },
        afterViewInit: function() {
            const reportTitle = document.getElementById('reportTitle');
            const organizationNameInput = document.createElement('span');
            reportTitle.appendChild(organizationNameInput);
            organizationNameInput.id = 'organizationName';
        }
    };
}());
