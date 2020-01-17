(function () {
  return {
    title: ' ',
    hint: '',
    formatTitle: function() {},
    customConfig:
        `
        <style>
        #searchContainer{
            display: flex;
            justify-content: space-around;
            flex-direction: column;
            width: 50%;
            margin: auto;
            margin-bottom: 0;
        }
        #searchResultItemsContainer{
            display: flex;
            justify-content: space-around;
            flex-direction: column;
            margin-top: 15px;
        }
        #searchResultItem, #searchHeader, #searchResultItemsHeader{
            display: flex;
            justify-content: space-around;
            flex-direction: row;
        }
        #searchResultItemsHeader{
            font-size: 22px;
            font-weight: 600;
        }
        #searchContainer__btn{
            padding: 5px 10px;
            cursor: pointer;
            background-color: #5cb85c;
            border-color: transparent;
            color: #fff;
            border-radius: 4px;
            border-width: 1px;
            border-style: solid;
            font-weight: 400;
            font-size: 14px;
            padding: 7px 18px 8px ;
            font-family: 'Helvetica Neue','Segoe UI',Helvetica,Verdana,sans-serif;            
        }
        #searchContainer__input{
            width: 50%;
        }
        .searchBlock{
            height: 30px;
        }
        .searchResultItem{
            margin: 5px 0;
            font-size: 20px;
            cursor: pointer;
        }
        .searchResultItem:hover{
            background-color: #dedede;
        }
        </style>
         <div id='searchContainer'></div>
                `
    ,
    sub: [],
    createElement: function(tag, props, ...children) {
        const element = document.createElement(tag);
        Object.keys(props).forEach( key => element[key] = props[key] );
        if(children.length > 0){
            children.forEach( child =>{
                element.appendChild(child);
            });
        } return element;
    },
    afterViewInit: function(data) {
        
        
        const searchContainer = document.getElementById('searchContainer');
        const searchContainer__input = this.createElement( 'input', {className: 'searchBlock', id: 'searchContainer__input', placeholder: 'Пошук за номером'});
        const searchContainer__btn = this.createElement( 'button', {className: 'searchBlock', id: 'searchContainer__btn', innerText: 'Знайти'});
        const searchHeader = this.createElement( 'div', {className: 'searchHeader', id: 'searchHeader'}, searchContainer__input,  searchContainer__btn);
        searchContainer.appendChild(searchHeader);
        
        searchContainer__input.addEventListener('input', event =>  {
            if(searchContainer__input.value.length == 0 ){
                this.resultSearch('clearInput', 0);
            }
        });
        
        searchContainer__btn.addEventListener('click', event => {
            var valueForSearch = document.getElementById('searchContainer__input').value;
            var self = this;
            this.resultSearch('resultSearch', valueForSearch);
        });
    },
    resultSearch: function(message, valueForSearch){
        this.messageService.publish({name: message, value: valueForSearch});

    }
};
}());
