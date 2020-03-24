(function() {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig:
                    `
                    <div id='reportTitle'></div>
                    `
        ,
        afterViewInit: function() {
            const reportTitle = document.getElementById('reportTitle');
            const organizationNameInput = document.createElement('span');
            organizationNameInput.innerText = 'Індекс лояльності клієнтів (NPS)';
            reportTitle.appendChild(organizationNameInput);
            organizationNameInput.id = 'organizationName';
        }
    };
}());
