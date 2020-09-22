(function() {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig:
                    `
                    <div id='notificationContainer' ></div>
                    `
        ,
        init: function() {
            this.isSelected = false;
            this.subscribers.push(this.messageService.subscribe('GlobalFilterChanged', this.setFiltersValue, this));
            this.subscribers.push(this.messageService.subscribe('ApplyGlobalFilters', this.findAllCheckedFilter, this));
            this.subscribers.push(this.messageService.subscribe('findFilterColumns', this.reloadTable, this));
        },
        setFiltersValue: function(message) {
            let elem = message.package.value.values;
            this.filtersLength = elem.length;
            this.filtersWithOutValues = 0;
            elem.forEach(elem => {
                if(elem.active === false) {
                    this.filtersWithOutValues += 1;
                }
            });
            this.isSelected = this.filtersWithOutValues === this.filtersLength ? false : true;
        },
        findAllCheckedFilter: function() {
            document.getElementById('notification').style.display = this.isSelected === true ? 'none' : 'block';
        },
        createElement: function(tag, props, ...children) {
            const element = document.createElement(tag);
            Object.keys(props).forEach(key => element[key] = props[key]);
            if(children.length > 0) {
                children.forEach(child =>{
                    element.appendChild(child);
                });
            } return element;
        },
        afterViewInit: function() {
            const container = document.getElementById('notificationContainer');
            const captionWarning = this.createElement('div',{ className: 'captionWarning', innerText: 'Оберiть фiльтри!'});
            const button = this.createElement('button',
                {
                    className: 'filtersListBtn dx-button dx-widget', innerText: 'Перелік збережених фільтрів'
                }
            );
            button.addEventListener('click', () => {
                const msg = {
                    name: 'SetFilterPanelState',
                    package: {
                        value: false
                    }
                };
                this.messageService.publish(msg);
                this.messageService.publish({name: 'showModalWindow', button: 'showFilters'});
            });
            container.appendChild(captionWarning);
            container.appendChild(button);
        }
    };
}());
