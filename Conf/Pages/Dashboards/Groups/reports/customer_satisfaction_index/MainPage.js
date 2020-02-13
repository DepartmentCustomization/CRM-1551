(function() {
    return {
        init: function() {
            this.sub = this.messageService.subscribe('GlobalFilterChanged', this.getFilterParams, this);
        },
        getFilterParams: function(message) {
            const period = message.package.value.values.find(f => f.name === 'period').value;
            if(period !== null) {
                if(period.dateFrom !== '' && period.dateTo !== '') {
                    const dateFrom = period.dateFrom;
                    const dateTo = period.dateTo;
                    const name = 'FilterParams';
                    const yAxis = 'Якiсть вiд 1 до 100%';
                    this.messageService.publish({ name, dateFrom, dateTo, yAxis })
                }
            }
        },
        destroy: function() {
            this.sub.unsubscribe();
        }
    };
}());
