(function() {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig:
                `
                    <div id='modalContainer'></div>
                `
        ,
        init: function() {
            const msg = {
                name: 'SetFilterPanelState',
                package: {
                    value: true
                }
            };
            this.messageService.publish(msg);
            this.subscribers.push(this.messageService.subscribe('GlobalFilterChanged', this.getFiltersParam, this));
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
        afterViewInit: function() {
            const modalContainer = document.getElementById('modalContainer');
            const btn = this.createElement('button', {
                innerText: 'CLick on me to go to section!'
            });
            modalContainer.appendChild(btn);
            btn.addEventListener('click', () => {
                this.goToDashboard('StartPage_operator');
            })
        },
        getFiltersParam: function(message) {
            this.d1 = message.package.value.values.find(f => f.name === 'd1').value;
            this.d2 = message.package.value.values.find(f => f.name === 'd2_calendar').value;
            this.d3 = message.package.value.values.find(f => f.name === 'd3_time').value;
            this.d4 = message.package.value.values.find(f => f.name === 'd4_date').value;
            this.appeals_district = message.package.value.values.find(f => f.name === 'appeals_district').value;
            this.appeals_enter_number = message.package.value.values.find(f => f.name === 'appeals_enter_number').value;
            this.overdue = message.package.value.values.find(f => f.name === 'overdue').value;
        }
    };
}());