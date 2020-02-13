(function() {
    return {
        init: function() {
            this.messageService.subscribe('createHeader', this.createHeader, this);
            this.messageService.subscribe('showHideWidget', this.showHideWidget, this);
        },
        createHeader: function(message) {
            const text = message.header.text;
            const iconClass = message.header.iconClass;
            const widget = message.header.widget;
            const icon = this.createElement('span', { className: iconClass});
            const iconWrapper = this.createElement('span', { className: 'iconWrapper'}, icon);
            const headerText = this.createElement('span', { innerText: text});
            const header = this.createElement('div', { className: 'header'}, iconWrapper, headerText);
            const name = 'header' + widget;
            this.messageService.publish({ name, header});
        },
        createElement: function(tag, props, ...children) {
            const element = document.createElement(tag);
            Object.keys(props).forEach(key => element[key] = props[key]);
            const zeroLength = 0;
            if(children.length > zeroLength) {
                children.forEach(child =>{
                    element.appendChild(child);
                });
            }
            return element;
        },
        showHideWidget:  function(message) {
            const widget = message.widget;
            const status = message.status;
            widget.style.display = status;
        }
    };
}());