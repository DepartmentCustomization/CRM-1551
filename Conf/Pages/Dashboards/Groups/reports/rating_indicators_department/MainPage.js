(function() {
    return {
        init: function() {
            this.sub = this.messageService.subscribe('GlobalFilterChanged', this.setFiltersParam, this);
        },
        setFiltersParam: function(message) {
            const date = message.package.value.values.find(f => f.name === 'date').value;
            const name = 'setFiltersParams';
            this.messageService.publish({ name, date});
        },
        destroy: function() {
            this.sub.unsubscribe();
        }
    };
}());
