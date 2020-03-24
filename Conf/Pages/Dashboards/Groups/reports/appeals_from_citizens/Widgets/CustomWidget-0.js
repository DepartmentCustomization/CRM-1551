(function() {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig:
                    `
                    <div id='reportTitle'>Звіт щодо перевірки виконання звернень від громадян</div>
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
