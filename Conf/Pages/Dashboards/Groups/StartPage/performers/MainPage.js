(function() {
    return {
        init: function() {
            this.showMyPreloader();
            this.sub = this.messageService.subscribe('showPagePreloader', this.showMyPreloader, this);
            this.sub1 = this.messageService.subscribe('hidePagePreloader', this.hideMyPreloader, this);
            this.sub2 = this.messageService.subscribe('emptyPage', this.emptyPage, this);
            this.sub3 = this.messageService.subscribe('openForm', this.openForm, this);
            this.sub4 = this.messageService.subscribe('onCellPrepared', this.onCellPrepared, this);
        },
        emptyPage: function() {
            this.showPagePreloader('Доручень немає');
        },
        showMyPreloader: function() {
            this.showPagePreloader('Зачекайте, сторінка завантажується');
        },
        hideMyPreloader: function() {
            this.hidePagePreloader('Зачекайте, сторінка завантажується');
        },
        openForm: function(message) {
            const cell = message.row;
            if(cell.column) {
                if(cell.column.dataField === 'registration_number' && cell.row !== undefined) {
                    if(cell.data.is_rights === 'true') {
                        window.open(String(
                            location.origin +
                            localStorage.getItem('VirtualPath') +
                            '/sections/Assignments/edit/' +
                            cell.key
                        ));
                    }
                }
            }
        },
        onCellPrepared: function(message) {
            const options = message.options;
            if(options.rowType === 'data') {
                if(options.data.is_rights !== 'true') {
                    options.cellElement.style.backgroundColor = '#b9b7b7'
                }
            }
        },
        destroy: function() {
            this.sub.unsubscribe();
            this.sub1.unsubscribe();
            this.sub2.unsubscribe();
            this.sub3.unsubscribe();
            this.sub4.unsubscribe();
        }
    };
}());
