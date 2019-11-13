(function () {
  return {
    title: ' ',
    hint: '',
    formatTitle: function() {},
    customConfig:
                `
                <style>
                    #btn5Wrap{
                        text-align: right;
                        margin-right: 50px;
                    }
                    .btn5{
                        padding: 5px 10px;
                    }
                </style>
                <div id="btn5Wrap">
                </div>    
                `
    ,
    sub: [],
    init: function() {
    },
    afterViewInit: function(data) {
        const btn5Wrap = document.getElementById('btn5Wrap');
        
        const btn5 = document.createElement('button');
        btn5.innerText = 'Передати';
        btn5.classList.add('btn5');
       /* 
        btn5Wrap.appendChild(btn5);
        
        btn5.addEventListener('click',  function(event) {
            // alert ( 'добавить действие на кнопку')
            this.messageService.publish( {name: 'findAllRowsNeVKompetentcii' } );
        }.bind(this), false);
        */
    }
};
}());
