(function() {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig:
                    `
                    <div id='reportTitle'>Тестоывй дашборд для реализации masterDetail DataGrid</div>
                    `
        ,
        afterViewInit: function() {
            const reportTitle = document.getElementById('reportTitle');
            const organizationNameInput = document.createElement('span');
            reportTitle.appendChild(organizationNameInput);
            organizationNameInput.id = 'organizationName';
        }
    };
}());
