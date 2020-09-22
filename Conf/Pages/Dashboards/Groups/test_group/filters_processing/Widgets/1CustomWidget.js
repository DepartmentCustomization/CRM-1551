(function() {
    return {
        title: ' ',
        hint: ' ',
        formatTitle: function() {},
        customConfig:
                `
                    <div id='modalContainer'></div>
                `
        ,
        init: async function() {
            this.activeFilterHelper = await import('/modules/Helpers/Filters/ActiveFilterHelper.js');
            this.queryHelper = await import('/modules/Helpers/Filters/QueryHelper.js');
            this.FiltersPackageHelper = await import('/modules/Helpers/Filters/FiltersPackageHelper.js');
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
            });
            const btnSetFilters = this.createElement('button', {
                innerText: 'btn Set Filters'
            });
            modalContainer.appendChild(btnSetFilters);
            btnSetFilters.addEventListener('click', () => {
                const filters = [
                    {
                        name: 'rating',
                        placeholder: 'Рейтинг',
                        type: 'Select',
                        value: '2',
                        viewValue: 'Благоустрій'
                    }
                ];
                const FiltersPackageHelper = new this.FiltersPackageHelper.FiltersPackageHelper();
                const filtersPackage = FiltersPackageHelper.getFiltersPackage(filters);
                this.applyFilters(filtersPackage);
            });
        },
        getFiltersParam: function(message) {
            const filters = message.package.value.values;
            const activeFilterHelper = new this.activeFilterHelper.ActiveFilterHelper();
            const activeFilters = activeFilterHelper.getActiveFilters(filters);
            const queryHelper = new this.queryHelper.QueryHelper();
            this.queryParameters = queryHelper.getQueryParameters(filters, activeFilters);
        }
    };
}());
