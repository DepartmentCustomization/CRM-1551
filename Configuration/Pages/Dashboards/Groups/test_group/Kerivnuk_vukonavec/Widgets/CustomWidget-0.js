(function () {
  return {
    title: ' ',
    hint: '',
    formatTitle: function() {},
    customConfig:
                `
                <style>
                #organizationNameWrapper{
                    text-align: center;
                    font-size: 20px;
                    font-weight: 600;
                }
                </style>
                
                 <div id='organizationNameWrapper'>
                </div>
                `
    ,
    init: function() {
    },
    afterViewInit: function(data) {
        const organizationNameWrapper = document.getElementById('organizationNameWrapper');
        const organizationNameInput = document.createElement('span');
        organizationNameWrapper.appendChild(organizationNameInput);
        organizationNameInput.id = 'organizationName';
    }
};
}());
