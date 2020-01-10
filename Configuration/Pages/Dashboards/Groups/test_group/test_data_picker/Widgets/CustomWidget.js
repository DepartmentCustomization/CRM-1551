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
                name: "SetFilterPanelState",
                package: {
                    value: true
                }
            };
            this.messageService.publish(msg);
            this.sub = this.messageService.subscribe('GlobalFilterChanged', this.getFiltersParam, this);
        },

        getFiltersParam: function (message) {
            let d1 = message.package.value.values.find(f => f.name === 'd1').value;
            let d2 = message.package.value.values.find(f => f.name === 'd2').value;
            let d3 = message.package.value.values.find(f => f.name === 'd3').value;
            let d4 = message.package.value.values.find(f => f.name === 'd4').value;
            let appeals_district = message.package.value.values.find(f => f.name === 'appeals_district').value;
            let appeals_enter_number = message.package.value.values.find(f => f.name === 'appeals_enter_number').value;
            let overdue = message.package.value.values.find(f => f.name === 'overdue').value;
            // ЭТИ КОНСОЛИ НЕ УДАЛЯТЬ
            console.log(d1);
            console.log(d2);
            console.log(d3);
            console.log(d4);
            console.log(appeals_district);
            console.log(appeals_enter_number);
            console.log(overdue);
        }
    };
}());