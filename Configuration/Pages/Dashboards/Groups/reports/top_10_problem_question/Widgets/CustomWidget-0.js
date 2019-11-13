(function () {
  return {
    title: ' ',
    hint: '',
    formatTitle: function() {},
    customConfig:
                `
                <style>
                #reportTitle{
                    text-align: center;
                    font-size: 20px;
                    font-weight: 600;
                }
                </style>
                
                 <div id='reportTitle'>ТОП-10 найпроблемніших питань в розрізі районів</div>
                `
    ,
    init: function() {
    },
    afterViewInit: function(data) {
        const reportTitle = document.getElementById('reportTitle');
        const organizationNameInput = document.createElement('span');
        reportTitle.appendChild(organizationNameInput);
        organizationNameInput.id = 'organizationName';
    }
};
}());
