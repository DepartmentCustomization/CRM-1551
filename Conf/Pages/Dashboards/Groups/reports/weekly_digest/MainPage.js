(function() {
    return {
        init: function() {
            this.sub = this.messageService.subscribe('ApplyGlobalFilters', this.hideFilterPanel, this);
            let msg = {
                name: 'SetFilterPanelState',
                package: {
                    value: true
                }
            };
            this.messageService.publish(msg);
        },
        hideFilterPanel: function() {
            let msg = {
                name: 'SetFilterPanelState',
                package: {
                    value: false
                }
            };
            this.messageService.publish(msg);
        },
        destroy: function() {
            this.sub.unsubscribe();
        }
    };
}());
