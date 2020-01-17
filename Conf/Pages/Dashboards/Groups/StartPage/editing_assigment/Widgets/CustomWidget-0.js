(function () {
  return {
    title: ' ',
    hint: '',
    formatTitle: function() {},
    customConfig:
                `
                
                <div id='container' ></div>
                `
    ,
    afterViewInit: function(){
        this.sub = this.messageService.subscribe( 'validationCheck', this.openModalForm, this);
        let CONTAINER = document.getElementById('container');
        
        const searchContainer__input = this.createElement('input', {id: 'searchContainer__input', type: 'search', placeholder: 'Пошук доручення за номером', className: "searchContainer__input"});
        const searchContainer = this.createElement('div', {id: 'searchContainer', className: "searchContainer"}, searchContainer__input);

        searchContainer__input.addEventListener('keypress', function (e) {
            var key = e.which || e.keyCode;
            if (key === 13) {
                this.messageService.publish( { name: 'sendSearchValue', searchValue: searchContainer__input.value });
            }
        }.bind(this));
        CONTAINER.appendChild(searchContainer);    
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
    openModalForm: function(message) {
        let status = message.status;
        let CONTAINER = document.getElementById('container');
        
        const modalBtnTrue =  this.createElement('button', { id:'modalBtnTrue', className: 'btn', innerText: 'Так'});
        const modalBtnExit =  this.createElement('button', { id:'modalBtnExit', className: 'btn', innerText: 'Вийти'});
        const modalBtnWrapper =  this.createElement('div', { id:'modalBtnWrapper', className: 'modalBtnWrapper'}, modalBtnTrue, modalBtnExit);
        const modalTitle =  this.createElement('div', { id:'modalTitle', innerText: 'Ви дійсно впевнені, що бажаєте видалити Звернення?'});
        const modalWindow = this.createElement('div', { id:'modalWindow', className: 'modalWindow'}, modalTitle, modalBtnWrapper); 
        const modalWindowWrapper = this.createElement('div', { id:'modalWindowWrapper', className: 'modalWindowWrapper'}, modalWindow); 
        CONTAINER.appendChild(modalWindowWrapper);
        
        modalBtnTrue.addEventListener( 'click', event => {
            let target = event.currentTarget;
            this.messageService.publish( { name: 'deleteAssigments', status: status  });
            CONTAINER.removeChild(container.lastElementChild);
        });
        modalBtnExit.addEventListener( 'click', event => {
            let target = event.currentTarget;
            CONTAINER.removeChild(container.lastElementChild);
        });
    },
    destroy:  function(){
        this.sub.unsubscribe();
    }
};
}());
