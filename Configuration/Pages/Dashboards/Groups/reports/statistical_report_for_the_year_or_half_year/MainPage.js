(function () {
    return {
        init: function() {

            this.sub = this.messageService.subscribe('GlobalFilterChanged', this.getFilterParams, this );
            this.sub1 = this.messageService.subscribe('setYears', this.setYears, this );
            this.sub1 = this.messageService.subscribe('setStyles', this.setStyles, this );
        },
        
        getFilterParams: function (message) {
            let period = message.package.value.values.find(f => f.name === 'period').value;
            if( period !== null ){
                if( period.dateFrom !== '' && period.dateTo !== ''){
                    const dateFrom =  period.dateFrom;
                    const dateTo = period.dateTo;
                    const dateFromViewValues = this.changeDateTimeValues(dateFrom);
                    const dateToViewValues = this.changeDateTimeValues(dateTo);
                    const name = 'FiltersParams';
                    let previousYear = new Date(dateFrom).getFullYear();
                    let currentYear = new Date(dateTo).getFullYear();
                              
                    if( previousYear === currentYear) {
                        previousYear -= 1;
                        this.previousYear = previousYear;            
                        this.currentYear = currentYear;  
                        this.messageService.publish({  name, dateFrom, dateTo, previousYear, currentYear, dateFromViewValues, dateToViewValues })
                    } else {
                        this.messageService.publish( { name: 'showWarning' });
                    }
                }


            }
        },

        setStyles: function() {

            let tds = document.querySelectorAll('td');
            tdsArr = Array.from(tds);
            tdsArr.forEach( td => {
                td.style.whiteSpace = "pre-wrap";
            });

            function setTdPreWrap(){
                let noWrapTdCollection = document.querySelectorAll('.dx-datagrid-text-content');
                let noWrapTdArr = Array.from(noWrapTdCollection);
                noWrapTdArr.forEach( td => {
                    td.style.whiteSpace = "pre-wrap";
                    td.parentElement.style.verticalAlign = "middle";
                });
            }
            setTimeout(setTdPreWrap, 100);
        },

        setYears: function (message) {

            message.columns.forEach( col => {
                col.columns[0].caption = this.previousYear;
                col.columns[1].caption = this.currentYear;
            });
        },

        changeDateTimeValues: function(value){
            let date = new Date(value);
            let dd = date.getDate().toString();
            let mm = (date.getMonth() + 1).toString();
            let yyyy = date.getFullYear().toString();
            dd = dd.length === 1 ? '0' + dd : dd;
            mm = mm.length === 1 ? '0' + mm : mm;
            return dd + '.' + mm + '.' + yyyy;
        },  

        destroy: function () {
            this.sub.unsubscribe();
        }
    };
}());
