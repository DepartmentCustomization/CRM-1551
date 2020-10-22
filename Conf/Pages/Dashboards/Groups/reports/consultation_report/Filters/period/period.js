(function() {
    return {
        placeholder: 'Дата та час',
        showTime: true,
        type: 'DateTime',
        stepMinute: 1,
        onItemSelect: function(date) {
            this.datePeriod(date);
        },
        datePeriod(date) {
            let message = {
                name: '',
                package: {
                    dateFrom: date.dateFrom,
                    dateTo: date.dateTo
                }
            }
            this.messageService.publish(message);
        },
        init: function() {
        },
        getDataFromLink: function(par) {
            let getDataFromLink = window
                .location
                .search
                .replace('?', '')
                .split('&')
                .reduce(
                    function(p, e) {
                        let a = e.split('=');
                        p[decodeURIComponent(a[0])] = decodeURIComponent(a[1]);
                        return p;
                    }, {}
                );
            return getDataFromLink[par];
        },
        initValue: function() {
            const dateFrom = this.getDataFromLink('DateStart')
            const dateTo = this.getDataFromLink('DateEnd')
            if(dateFrom || dateTo) {
                let defaultValue = {
                    dateFrom: new Date(dateFrom),
                    dateTo: new Date(dateTo)
                }
                this.setDefaultValue(defaultValue);
            } else {
                let currentDate = new Date();
                let year = currentDate.getFullYear();
                let monthFrom = currentDate.getMonth();
                let dayTo = currentDate.getDate();
                let hh = currentDate.getHours();
                let mm = currentDate.getMinutes();
                let defaultValue = {
                    dateFrom: new Date(year, monthFrom , '01', '00', '00'),
                    dateTo: new Date(year, monthFrom , dayTo, hh, mm)
                }
                this.setDefaultValue(defaultValue);
            }
        },
        destroy() {
        }
    };
}());
