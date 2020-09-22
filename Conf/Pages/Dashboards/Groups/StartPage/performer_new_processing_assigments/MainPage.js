(function() {
    return {
        init: function() {
            this.showMyPreloader();
            this.sub = this.messageService.subscribe('showPagePreloader', this.showMyPreloader, this);
            this.sub1 = this.messageService.subscribe('hidePagePreloader', this.hideMyPreloader, this);
            this.sub2 = this.messageService.subscribe('checkDisplayWidth', this.setDataGridHeight, this);
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
        setDataGridHeight: function(message) {
            const context = message.context;
            if (window.matchMedia('(max-width: 960px)').matches) {
                context.dataGridInstance.height = window.innerHeight - 80;
                const container = document.querySelector('smart-bi-widget-wrapper');
                const cssText = container.style.cssText;
                container.style.cssText = cssText + 'flex-flow: column wrap;!important';
            } else {
                context.dataGridInstance.height = window.innerHeight - 300;
            }
        },
        showMyPreloader: function() {
            this.showPagePreloader('Зачекайте, сторінка завантажується');
        },
        hideMyPreloader: function() {
            this.hidePagePreloader();
        },
        destroy: function() {
            this.sub.unsubscribe();
            this.sub1.unsubscribe();
            this.sub2.unsubscribe();
            this.sub3.unsubscribe();
        }
    };
}());
