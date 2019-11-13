(function () {
  return {
    title: ' ',
    hint: '',
    formatTitle: function() {},
    customConfig:
                `
                <style>
                    .btnWrap{
                        text-align: center;
                    }
                    #btnReturn{
                        background-color: rgba(21, 189, 244, 1)!important;
                        border-color: transparent;
                        color: #fff;
                        display: inline-block;
                        cursor: pointer;
                        text-align: center;
                        vertical-align: middle;
                        padding: 7px 18px 8px;
                        border-radius: 5px;                        
                    }
                </style>
                <div id='container'></div>
                `
    ,
    afterViewInit: function() {
        this.sub = this.messageService.subscribe('setData', this.setData, this );
        this.counter = 0
        const CONTAINER = document.getElementById('container');
        let btnReturn = this.createElement('button', { id: 'btnReturn', innerText: 'Повернуться до фільтрації'} );
        let btnWrap = this.createElement('div', { className: 'btnWrap' }, btnReturn );
        CONTAINER.appendChild(btnWrap);
        
        btnReturn.addEventListener('click', event => {
            document.getElementById('summary__table').style.display = 'none';
            document.getElementById('content').style.display = 'block';
        });
    },
	createElement: function(tag, props, ...children) {
        const element = document.createElement(tag);
        Object.keys(props).forEach( key => element[key] = props[key] );
        if(children.length > 0){
            children.forEach( child =>{
                element.appendChild(child);
            });
        } return element;
    },      
};
}());
