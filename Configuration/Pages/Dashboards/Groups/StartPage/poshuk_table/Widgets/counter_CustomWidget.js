(function() {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig:

            `
                <style>
                #counterWrap{
                    font-size: 18px;
                    font-weight: 600;
                    text-align: center;
                }
                </style>
                <div id='counterContainer'></div>
                `,
        init: function() {
            document.getElementById('counter').style.display = 'none';
            this.isSelected = false;
            this.sub = this.messageService.subscribe('dataLength', this.setDataLength, this);
            this.sub1 = this.messageService.subscribe('ApplyGlobalFilters', this.findAllCheckedFilter, this);
        },
        findAllCheckedFilter: function() {
            this.isSelected === true ? document.getElementById('counter').style.display = 'none' : document.getElementById('counter').style.display = 'block';
        },
        setDataLength: function(message) {
            let dataLength = message.value;
            document.getElementById('counterWrap').innerText = 'Вcього: ' + dataLength;
        },
        createElement: function(tag, props, ...children) {
            const element = document.createElement(tag);
            Object.keys(props).forEach(key => element[key] = props[key]);
            if (children.length > 0) {
                children.forEach(child => {
                    element.appendChild(child);
                });
            }
            return element;
        },
        afterViewInit: function name(params) {
            const container = document.getElementById('counterContainer');
            const counterWrap = this.createElement('div', { id: 'counterWrap' });
            container.appendChild(counterWrap);
        }
    };
}());