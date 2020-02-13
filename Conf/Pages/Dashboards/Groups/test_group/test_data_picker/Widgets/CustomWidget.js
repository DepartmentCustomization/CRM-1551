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
            this.sub = this.messageService.subscribe('GlobalFilterChanged', this.getFiltersParam, this);
        },
        getFiltersParam: function(message) {
            this.d1 = message.package.value.values.find(f => f.name === 'd1').value;
            this.d2 = message.package.value.values.find(f => f.name === 'd2').value;
            this.d3 = message.package.value.values.find(f => f.name === 'd3').value;
            this.d4 = message.package.value.values.find(f => f.name === 'd4').value;
            this.appeals_district = message.package.value.values.find(f => f.name === 'appeals_district').value;
            this.appeals_enter_number = message.package.value.values.find(f => f.name === 'appeals_enter_number').value;
            this.overdue = message.package.value.values.find(f => f.name === 'overdue').value;
        }
    };
}());