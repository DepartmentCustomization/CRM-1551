(function() {
    return (function() {
        return {
            title: ' ',
            hint: '',
            formatTitle: function() {},
            customConfig:
                        `
                        <style>
                            #container {
                                display: flex;
                                justify-content: center;
                                font-size: 16px;
                            }

                            .url {
                                margin-left: 4px;
                                color: #1a88e6;
                                text-decoration: underline;
                                cursor: pointer;
                            }
                        </style>

                        <div id='container'></div>
                        `
            ,
            init: function() {
            },
            afterViewInit: function() {
                const CONTAINER = document.getElementById('container');
                const ulr = this.createElement('div', { className: 'url', innerText: 'тут', url: 'http://crm.1551.gov.ua:8075'});
                const text = this.createElement('div', { className: 'text', innerText: 'Для Вас відбулося оновлення CРМ-1551, для переходу в нову версію натисніть '});
                CONTAINER.appendChild(text);
                CONTAINER.appendChild(ulr);
                ulr.addEventListener('click', e => {
                    const target = e.currentTarget;
                    location.href = target.url;
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
        }
    }());
}());
