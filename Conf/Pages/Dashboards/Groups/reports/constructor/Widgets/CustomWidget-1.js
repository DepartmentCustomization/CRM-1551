(function() {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig:
                `
                <div id='container'></div>
                `
        ,
        afterViewInit: function() {
            this.sub = this.messageService.subscribe('setData', this.setData, this);
            this.counter = 0
            const CONTAINER = document.getElementById('container');
            let btnReturn = this.createElement('button', { id: 'btnReturn', innerText: 'Повернуться до фільтрації'});
            let btnWrap = this.createElement('div', { className: 'btnWrap' }, btnReturn);
            CONTAINER.appendChild(btnWrap);
            btnReturn.addEventListener('click', () => {
                document.getElementById('summary__table').style.display = 'none';
                document.getElementById('content').style.display = 'block';
            });
        },
        createElement: function(tag, props, ...children) {
            const element = document.createElement(tag);
            Object.keys(props).forEach(key => element[key] = props[key]);
            if(children.length > 0) {
                children.forEach(child =>{
                    element.appendChild(child);
                });
            } return element;
        }
    };
}());
