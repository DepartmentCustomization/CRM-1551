(function() {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig:
                `
                <div id='container' ></div>
                `
        ,
        init: function() {
            this.sub = this.messageService.subscribe('GlobalFilterChanged', this.getFiltersParams, this);
        },
        getFiltersParams: function(message) {
            this.year = message.package.value.values.find(f => f.name === 'FilterYear').value;
            if(this.year !== '' && this.year !== null) {
                let executeQuery = {
                    queryCode: 'workDaysCalendar',
                    limit: -1,
                    parameterValues: [
                        { key: '@year', value: this.year.viewValue }
                    ]
                };
                this.queryExecutor(executeQuery, this.load, this);
                this.showPreloader = false;
            }
        },
        getLastDayOfMonth: function(year, month) {
            let date = new Date(year, month, 0);
            return date.getDate();
        },
        load: function(data) {
            this.yearCalendar = [];
            for(let i = 0; i < data.rows.length; i++) {
                let indexDateCode = data.columns.findIndex(el => el.code.toLowerCase() === 'date');
                let indexId = data.columns.findIndex(el => el.code.toLowerCase() === 'id');
                let date = new Date(data.rows[i].values[indexDateCode]);
                let year = date.getFullYear();
                let month = date.getMonth();
                let day = date.getDay();
                month += 1;
                let monthLength = this.getLastDayOfMonth(year, month);
                day = day === 0 ? 7 : day;
                let arr = [];
                let len = i + monthLength
                for(let t = i; t < len; t++) {
                    let day = data.rows[t];
                    arr.push(day.values[indexId]);
                }
                let obj = {
                    year,
                    month,
                    monthLength,
                    day,
                    arr
                }
                this.yearCalendar.push(obj);
                i = i + monthLength - 1;
            }
            this.createCalendarWrapper(data);
        },
        createCalendarWrapper: function(data) {
            let container = document.getElementById('container');
            while (container.hasChildNodes()) {
                container.removeChild(container.childNodes[0]);
            }
            let createNewYearBtn = this.createElement('button', { id: 'createNewYearBtn', innerText: 'Додати наступний рік' });
            let createNewYearContainer = this.createElement('div', { id: 'createNewYearContainer' }, createNewYearBtn);
            let yearContainer = this.createElement('div', { id: 'yearContainer' });
            container.appendChild(createNewYearContainer);
            container.appendChild(yearContainer);
            createNewYearBtn.addEventListener('click', () => {
                let executeQuery = {
                    queryCode: 'ak_workDaysCalendarAddNewYear',
                    limit: -1,
                    parameterValues: []
                };
                this.queryExecutor(executeQuery);
                this.showPreloader = false;
            });
            this.yearCalendar.forEach(month => {
                let dayBox;
                let monday = this.createElement('div', { className: 'calenDay', innerText: 'ПН'});
                let tuesday = this.createElement('div', { className: 'calenDay', innerText: 'ВТ'});
                let wednesday = this.createElement('div', { className: 'calenDay', innerText: 'СР'});
                let thursday = this.createElement('div', { className: 'calenDay', innerText: 'ЧТ'});
                let friday = this.createElement('div', { className: 'calenDay', innerText: 'ПТ'});
                let saturday = this.createElement('div', { className: 'calenDay', innerText: 'СБ'});
                let sunday = this.createElement('div', { className: 'calenDay', innerText: 'ВС'});
                let monthBox = this.createElement('div',
                    {
                        id: 'monthBox_' + month.year + '_' + month.month, className: 'month'
                    },
                    monday, tuesday, wednesday, thursday, friday, saturday, sunday
                );
                for (let i = 0; i < month.day - 1; i++) {
                    dayBox = this.createElement('div',
                        {
                            id: 'day_' + month.year + '_' + month.month + '_00', className: 'calenDay emptyDay'
                        }
                    );
                    monthBox.appendChild(dayBox);
                }
                for(let i = 0; i < month.monthLength; i++) {
                    dayBox = this.createElement('div',
                        {
                            dayId: month.arr[i],
                            id: 'day_' + month.year + '_' + month.month + '_' + (i + 1),
                            innerText: i + 1,
                            className: 'calenDay day',
                            isWork: true
                        }
                    );
                    monthBox.appendChild(dayBox);
                }
                let ml = monthBox.childNodes.length;
                if(ml < 42 && ml > 36) {
                    let c = 42 - ml;
                    for(let i = 0; i < c; i++) {
                        let dayBox = this.createElement('div',
                            {
                                id: 'day_' + month.year + '_' + month.month + '_00', className: 'calenDay emptyDay'
                            }
                        );
                        monthBox.appendChild(dayBox);
                    }
                }else if(ml < 49 && ml > 42) {
                    let c = 49 - ml;
                    for(let i = 0; i < c; i++) {
                        let dayBox = this.createElement('div',
                            {
                                id: 'day_' + month.year + '_' + month.month + '_00', className: 'calenDay emptyDay'
                            }
                        );
                        monthBox.appendChild(dayBox);
                    }
                }
                let title;
                switch (month.month) {
                    case 1:
                        title = 'Січень'
                        break
                    case 2:
                        title = 'Лютий'
                        break
                    case 3:
                        title = 'Березень'
                        break
                    case 4:
                        title = 'Квітень'
                        break
                    case 5:
                        title = 'Травень'
                        break
                    case 6:
                        title = 'Червень'
                        break
                    case 7:
                        title = 'Липень'
                        break
                    case 8:
                        title = 'Серпень'
                        break
                    case 9:
                        title = 'Вересень'
                        break
                    case 10:
                        title = 'Жовтень'
                        break
                    case 11:
                        title = 'Листопад'
                        break
                    case 12:
                        title = 'Грудень'
                        break
                    default:
                        break
                }
                let monthTitle = this.createElement('div', { className: 'monthTitle', innerText: title});
                let monthWrapper = this.createElement('div', { className: 'monthWrapper' }, monthTitle, monthBox);
                yearContainer.appendChild(monthWrapper);
            });
            let days = document.querySelectorAll('.day');
            days = Array.from(days);
            days.forEach(day => {
                day.addEventListener('dblclick', event => {
                    event.stopImmediatePropagation();
                    let target = event.currentTarget;
                    let executeQuery = {
                        queryCode: 'ak_workDaysCalendarUpdate',
                        limit: -1,
                        parameterValues: [ { key: '@Id', value: target.dayId} ]
                    };
                    this.queryExecutor(executeQuery);
                    this.showPreloader = false;
                    if(target.isWork === true) {
                        target.isWork = false;
                        target.style.backgroundColor = '#f4b084';
                    }else{
                        target.isWork = true;
                        target.style.backgroundColor = '#a9d08e';
                    }
                });
            });
            this.setThisYearCalendar(data);
        },
        setThisYearCalendar: function(data) {
            data.rows.forEach(day => {
                let dateCode = data.columns.findIndex(el => el.code.toLowerCase() === 'date');
                let isWorkCode = data.columns.findIndex(el => el.code.toLowerCase() === 'is_work');
                let fullDay = new Date(day.values[dateCode]);
                let year = fullDay.getFullYear();
                let month = fullDay.getMonth();
                let date = fullDay.getDate();
                month = month + 1;
                let cellDay = document.getElementById(String('day_' + year + '_' + month + '_' + date));
                if(day.values[isWorkCode] === false) {
                    cellDay.isWork = false;
                    cellDay.style.backgroundColor = '#f4b084';
                }else{
                    cellDay.isWork = true;
                    cellDay.style.backgroundColor = '#a9d08e';
                }
            });
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
        destroy: function() {
            this.sub.unsubscribe();
        }
    };
}());
