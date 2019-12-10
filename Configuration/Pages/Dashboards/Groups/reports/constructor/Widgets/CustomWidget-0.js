(function () {
  return {
    title: ' ',
    hint: '',
    formatTitle: function() {},
    customConfig:
                `
                <style>
                // #selectionWrapper{
                //     display: flex;
                //     justify-content: space-around;    
                //     align-items: center;
                //     width: 50%;
                //     margin: 0 auto;                    
                // }
                // #questionDefaultSelect{
                //     border: 1px solid black;
                //     padding: 10px;
                //     background-color: #dddddd;                    
                // }
                // #questionGroupSelect{
                //     border: 1px solid black;
                //     background-color:  rgba(21, 189, 244, 1);
                //     padding: 11px;
                // }
                // .radio{
                //     width: 20px;
                //     height: 20px;                    
                // }
                </style>
                <div id='tabsContainer' ></div>
                `
    ,
    afterViewInit: function(data){
        const TABS_CONTAINER = document.getElementById('tabsContainer');

        let groupItems__title  = this.createElement('div', { className: 'tabInformation tab_title', innerText: 'Група питань'});
        let defaultItems__title  = this.createElement('div', { className: 'tabAction tab_title', innerText: 'Типи питань'});
        let tabDefaultItems = this.createElement('div', { id: 'tabDefaultItems', className: ' tab',  messageValue: 'default'}, defaultItems__title);
        let tabGroupItems = this.createElement('div', { id: 'tabGroupItems', className: 'tabHover tab', messageValue: 'group'}, groupItems__title);
    
        
        TABS_CONTAINER.appendChild(tabGroupItems);
        TABS_CONTAINER.appendChild(tabDefaultItems);
 
        let tabs = document.querySelectorAll('.tab');
        tabs = Array.from(tabs);
        tabs.forEach( tab => {
            tab.addEventListener( 'click', event => {
                tabs.forEach( tab => {
                    tab.classList.remove('tabHover');
                });
                let target =  event.currentTarget;
                target.classList.add('tabHover');
                this.messageService.publish( { name: 'showTable', value: target.messageValue });
                this.messageService.publish( { name: 'sendDataCleanup'});
                
            });    
        });        
    },
    sendMessage: function(target){
        this.messageService.publish( { name: 'showTable', value: target.messageValue });
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
