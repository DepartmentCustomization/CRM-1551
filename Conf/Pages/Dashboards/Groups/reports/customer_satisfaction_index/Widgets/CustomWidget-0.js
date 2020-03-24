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
        init: function() {
        },
        afterViewInit: function() {
            const reportTitle = document.getElementById('reportTitle');
            const organizationNameInput = document.createElement('span');
            organizationNameInput.innerText = 'Індекс задоволеності клієнтів (CSI)';
            reportTitle.appendChild(organizationNameInput);
            organizationNameInput.id = 'organizationName';
        }
    };
}());
