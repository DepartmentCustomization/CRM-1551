(function() {
    return {
        init: function() {
            this.showMyPreloader();
            this.sub = this.messageService.subscribe('showPagePreloader', this.showMyPreloader, this);
            this.sub1 = this.messageService.subscribe('hidePagePreloader', this.hideMyPreloader, this);
            this.sub2 = this.messageService.subscribe('emptyPage', this.emptyPage, this);
            this.sub3 = this.messageService.subscribe('createMasterDetail', this.createMasterDetail, this);
        },
        createMasterDetail: function(message) {
            const fields = message.fields;
            const data = message.currentEmployeeData;
            const container = message.container;
            const elementsWrapper = this.createElement('div', {className: 'elementsWrapper'});
            container.appendChild(elementsWrapper);
            for (const field in fields) {
                for (const property in data) {
                    if(property === field) {
                        if(data[property] === null || data[property] === undefined) {
                            data[property] = '';
                        }
                        const content = this.createElement('div',
                            {
                                className: 'content',innerText: data[property]
                            }
                        );
                        const caption = this.createElement('div',
                            {
                                className: 'caption',innerText: fields[field], style: 'min-width: 200px'
                            }
                        );
                        const masterDetailItem = this.createElement('div',
                            {
                                className: 'element', style: 'display: flex; margin: 15px 10px'
                            },
                            caption, content
                        );
                        elementsWrapper.appendChild(masterDetailItem);
                    }
                }
            }
        },
        createElement: function(tag, props, ...children) {
            const element = document.createElement(tag);
            Object.keys(props).forEach(key => element[key] = props[key]);
            if(children.length > 0) {
                children.forEach(child =>{
                    element.appendChild(child);
                });
            } return element;
        },
        emptyPage: function() {
            this.showPagePreloader('Доручень немає');
        },
        showMyPreloader: function() {
            this.showPagePreloader('Зачекайте, сторінка завантажується');
        },
        hideMyPreloader: function() {
            this.hidePagePreloader('Зачекайте, сторінка завантажується');
        },
        destroy: function() {
            this.sub.unsubscribe();
            this.sub1.unsubscribe();
            this.sub2.unsubscribe();
            this.sub3.unsubscribe();
        }
    };
}());
