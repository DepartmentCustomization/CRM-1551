(function() {
    return {
        init: function() {
            this.sub = this.messageService.subscribe('GlobalFilterChanged', this.getFiltersParams, this);
        },
        getFiltersParams: function(message) {
            let period = message.package.value.values.find((el) => {
                return el.name.toLowerCase() === 'period';
            });
            const value = period.value;
            if (value !== null) {
                if (value.dateFrom !== '' && value.dateTo !== '') {
                    this.dateFrom = value.dateFrom;
                    this.dateTo = value.dateTo;
                }
            }
        }
    };
}());
