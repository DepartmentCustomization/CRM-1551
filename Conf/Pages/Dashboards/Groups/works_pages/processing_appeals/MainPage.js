(function() {
    return {
        init: function() {
            let select2LibraryJS = 'select2LibraryJS';
            if (!document.getElementById(select2LibraryJS)) {
                let head = document.getElementsByTagName('head')[0];
                let script = document.createElement('script');
                script.id = 'jQueryLibraryJS';
                script.type = 'text/javascript';
                script.src = 'https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.min.js';
                head.appendChild(script);
                script.onload = function() {
                    let script2 = document.createElement('script');
                    script2.id = 'select2LibraryJS';
                    script2.type = 'text/javascript';
                    script2.src = 'https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.9/js/select2.min.js';
                    head.appendChild(script2);
                    script2.onload = function() {
                        let style = document.createElement('style');
                        let styleSelect = document.createElement('link');
                        styleSelect.rel = 'stylesheet';
                        styleSelect.href =
                            'https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css';
                        styleSelect.type = 'text/css';
                        let tag_head = document.getElementsByTagName('head');
                        tag_head[0].appendChild(styleSelect);
                        style.onload = function() {
                            let messageSelect = {
                                name: 'LoadLib',
                                package: {
                                    value: 1
                                }
                            }
                            self.messageService.publish(messageSelect);
                        }.bind(self);
                    }.bind(self);
                }.bind(self);
            }
            this.showPreloader = false;
            this.sub = this.messageService.subscribe('showPagePreloader', this.showMyPreloader, this);
            this.sub1 = this.messageService.subscribe('hidePagePreloader', this.hideMyPreloader, this);
            this.sub2 = this.messageService.subscribe('afterRenderTable', this.createCustomStyle, this);
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
        showMyPreloader: function() {
            this.showPagePreloader('Зачекайте, данні завантажуються');
        },
        hideMyPreloader: function() {
            this.hidePagePreloader();
        },
        createCustomStyle: function() {
            const elements = Array.from(document.querySelectorAll('.dx-datagrid-export-button'));
            elements.forEach(element => {
                const spanElement = this.createElement('span', { className: 'dx-button-text', innerText: 'Excel'});
                if(element.firstElementChild.childElementCount === 1) {
                    element.firstElementChild.appendChild(spanElement);
                }
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
        },
        destroy: function() {
            this.sub.unsubscribe;
            this.sub1.unsubscribe;
            this.sub2.unsubscribe;
            this.sub3.unsubscribe;
        }
    };
}());
