(function() {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig:
                    `
                    <div id='reportTitle'>Звіт щодо кількості відключених будинків по комунальним послугам</div>
                    `
        ,
        init: function() {},
        afterViewInit: function() {
            const reportTitle = document.getElementById('reportTitle');
            const organizationNameInput = document.createElement('span');
            reportTitle.appendChild(organizationNameInput);
            organizationNameInput.id = 'organizationName';
        }
    };
}());
