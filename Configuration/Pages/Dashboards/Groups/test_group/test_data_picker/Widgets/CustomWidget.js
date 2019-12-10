(function() {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig: `
                <div id='modalContainer'></div>
                `,
        init: function() {
            this.sub = this.messageService.subscribe('GlobalFilterChanged', this.getFiltersParam, this);
        },
        getFiltersParam: function (message) {
            let d1 = message.package.value.values.find(f => f.name === 'd1').value;
            let d2 = message.package.value.values.find(f => f.name === 'd2').value;
            let d3 = message.package.value.values.find(f => f.name === 'd3').value;
            let d4 = message.package.value.values.find(f => f.name === 'd4').value;
            console.log(d1);
            console.log(d2);
            console.log(d3);
            console.log(d4);
        }
    };
}());