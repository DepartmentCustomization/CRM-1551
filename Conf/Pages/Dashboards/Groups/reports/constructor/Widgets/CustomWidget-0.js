(function() {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig:
                `
                <div id='tabsContainer' ></div>
                `
        ,
        afterViewInit: function() {
            const TABS_CONTAINER = document.getElementById('tabsContainer');
            let groupItems__title = this.createElement('div', {
                className: 'tabInformation tab_title',
                innerText: 'Група питань'
            });
            let defaultItems__title = this.createElement('div', {
                className: 'tabAction tab_title',
                innerText: 'Типи питань'
            });
            let tabDefaultItems = this.createElement('div', {
                id: 'tabDefaultItems',
                className: ' tab',
                messageValue: 'default'
            }, defaultItems__title);
            let tabGroupItems = this.createElement('div', {
                id: 'tabGroupItems',
                className: 'tabHover tab',
                messageValue: 'group'
            }, groupItems__title);
            TABS_CONTAINER.appendChild(tabGroupItems);
            TABS_CONTAINER.appendChild(tabDefaultItems);
            let tabs = document.querySelectorAll('.tab');
            tabs = Array.from(tabs);
            tabs.forEach(tab => {
                tab.addEventListener('click', event => {
                    tabs.forEach(tab => {
                        tab.classList.remove('tabHover');
                    });
                    let target = event.currentTarget;
                    target.classList.add('tabHover');
                    this.messageService.publish({ name: 'showTable', value: target.messageValue });
                    this.messageService.publish({ name: 'sendDataCleanup'});
                });
            });
        },
        sendMessage: function(target) {
            this.messageService.publish({ name: 'showTable', value: target.messageValue });
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
