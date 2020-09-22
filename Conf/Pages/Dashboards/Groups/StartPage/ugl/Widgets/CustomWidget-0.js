(function() {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig:
                `
                
                <style>
               
                </style>
                    <div id = 'container'></div>
                `
        ,
        isLoadDistrict: false,
        isLoadCategorie: false,
        isDistrictFull: false,
        isCategorieFull: false,
        init: function() {
            this.hidePagePreloader();
            this.messageService.publish({ name: 'showPagePreloader'});
            this.sub = this.messageService.subscribe('reloadMainTable', this.reloadMainTable, this);
            this.column = [];
            this.navigator = [];
            const header = document.getElementById('header1');
            header.parentElement.style.flexFlow = 'column nowrap';
            header.firstElementChild.style.overflow = 'visible';
            header.firstElementChild.firstElementChild.firstElementChild.style.overflow = 'visible';
            let executeQueryTable = {
                queryCode: 'DepartmentUGL_table',
                limit: -1,
                parameterValues: []
            };
            this.queryExecutor(executeQueryTable, this.createTable.bind(this, false), this);
            this.showPreloader = false;
        },
        afterViewInit: function() {
            const container = document.getElementById('container');
            const tabsWrapper = this.createElement('div', { id: 'tabsWrapper', className: 'tabsWrapper'});
            const filtersWrapper = this.createElement('div', { id: 'filtersWrapper', className: 'filtersWrapper'});
            const filtersInfo = this.createElement('div', { id: 'filtersInfo', className: 'filtersInfo'});
            const tableContainer = this.createElement('div', { id: 'tableContainer', className: 'tableContainer'});
            const tableWrapper = this.createElement('div', { id: 'tableWrapper', className: 'tableWrapper'}, tableContainer);
            container.appendChild(tabsWrapper);
            filtersWrapper.appendChild(filtersInfo);
            container.appendChild(filtersWrapper);
            container.appendChild(tableWrapper);
            this.createTabs();
            this.createSearchInput(filtersWrapper);
        },
        createSearchInput: function(filtersWrapper) {
            const searchContainer__input = this.createElement('input',
                {
                    id: 'searchContainer__input',
                    type: 'search',
                    placeholder: 'Пошук доручення за номером',
                    className: 'searchContainer__input'
                }
            );
            const searchContainer = this.createElement('div',
                {
                    id: 'searchContainer', className: 'searchContainer'
                },
                searchContainer__input
            );
            filtersWrapper.appendChild(searchContainer);
            searchContainer__input.addEventListener('input', () => {
                if(searchContainer__input.value.length === 0) {
                    this.resultSearch('clearInput', 0);
                    this.showTable(searchContainer__input);
                }
            });
            searchContainer__input.addEventListener('keypress', function(e) {
                let key = e.which || e.keyCode;
                if (key === 13) {
                    this.resultSearch('resultSearch', searchContainer__input.value);
                    this.hideAllItems(0);
                }
            }.bind(this));
        },
        setDistrictData: function(data) {
            this.districtData = data;
            this.createFilterDistrictElements(data);
        },
        createFilterDistrictElements: function() {
            this.changeFilterItemDistrict();
        },
        setDepartmentData: function(data) {
            this.departData = data;
            this.createFilterDepartElements(data);
        },
        createFilterDepartElements: function() {
            this.changeFilterItemDepart();
        },
        changeFilterItemDistrict: function() {
            let filters = document.querySelectorAll('.filter_district');
            filters = Array.from(filters);
            filters.forEach(item => {
                item.addEventListener('mouseover', event => {
                    let target = event.currentTarget;
                    target.childNodes[2].classList.add('material-icons');
                    target.childNodes[2].classList.remove('filter_closer_hide');
                    target.childNodes[2].classList.add('filter_closer_show');
                    target.childNodes[2].innerText = 'close';
                });
            });
            filters.forEach(item => {
                item.addEventListener('mouseout', event => {
                    let target = event.currentTarget;
                    target.childNodes[2].classList.remove('material-icons');
                    target.childNodes[2].classList.remove('filter_closer_show');
                    target.childNodes[2].classList.add('filter_closer_hide');
                    target.childNodes[2].innerText = '';
                });
            });
            let filter_closer_district = document.querySelectorAll('.filter_closer_district');
            filter_closer_district = Array.from(filter_closer_district);
            filter_closer_district.forEach(function(el) {
                el.addEventListener('click', function(event) {
                    let target = event.currentTarget;
                    let executeQueryDeleteFilter = {
                        queryCode: 'cc_FilterDelete',
                        limit: -1,
                        parameterValues: [
                            { key: '@id', value: Number(target.parentElement.id)}
                        ]
                    };
                    let element = target.parentElement;
                    let location = 'district';
                    this.queryExecutor(executeQueryDeleteFilter, this.reloadFilterAfterDelete(element, location), this);
                    this.showPreloader = false;
                }.bind(this));
            }.bind(this));
        },
        changeFilterItemDepart: function() {
            let filters = document.querySelectorAll('.filter_depart');
            filters = Array.from(filters);
            filters.forEach(item => {
                item.addEventListener('mouseover', event => {
                    let target = event.currentTarget;
                    target.childNodes[2].classList.add('material-icons');
                    target.childNodes[2].classList.remove('filter_closer_hide');
                    target.childNodes[2].classList.add('filter_closer_show');
                    target.childNodes[2].innerText = 'close';
                });
            });
            filters.forEach(item => {
                item.addEventListener('mouseout', event => {
                    let target = event.currentTarget;
                    target.childNodes[2].classList.remove('material-icons');
                    target.childNodes[2].classList.remove('filter_closer_show');
                    target.childNodes[2].classList.add('filter_closer_hide');
                    target.childNodes[2].innerText = '';
                });
            });
            let filter_closer_depart = document.querySelectorAll('.filter_closer_depart');
            filter_closer_depart = Array.from(filter_closer_depart);
            filter_closer_depart.forEach(function(el) {
                el.addEventListener('click', function(event) {
                    let target = event.currentTarget;
                    let executeQueryDeleteFilter = {
                        queryCode: 'cc_FilterDelete',
                        limit: -1,
                        parameterValues: [
                            { key: '@id', value: Number(target.parentElement.id)}
                        ]
                    };
                    let element = target.parentElement;
                    let location = 'departament';
                    this.queryExecutor(executeQueryDeleteFilter, this.reloadFilterAfterDelete(element, location), this);
                    this.showPreloader = false;
                }.bind(this));
            }.bind(this));
        },
        reloadFilterAfterDelete:  function(element, location) {
            element.parentElement.removeChild(document.getElementById(element.id));
            let executeQueryFilters = {};
            if (location === 'district') {
                executeQueryFilters = {
                    queryCode: 'cc_FilterName',
                    limit: -1,
                    parameterValues: []
                };
            } else if(location === 'departament') {
                executeQueryFilters = {
                    queryCode: 'cc_FilterNameDepartment',
                    limit: -1,
                    parameterValues: []
                };
            }
            this.queryExecutor(executeQueryFilters, this.setNewData.bind(this, location), this);
            this.showPreloader = false;
        },
        setNewData: function(location, data) {
            if (location === 'district') {
                this.districtData = data;
            } else if (location === 'departament') {
                this.departData = data;
            }
            this.sendMesOnBtnClick('clickOnСoordinator_table', 'none', 'none');
            this.messageService.publish({ name: 'showPagePreloader'});
            this.reloadMainTable();
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
        reloadMainTable: function(message) {
            let tableContainer = document.getElementById('tableContainer');
            while (tableContainer.hasChildNodes()) {
                tableContainer.removeChild(tableContainer.childNodes[0]);
            }
            let reloadTable = false;
            if (message) {
                this.column = message.column;
                this.navigation = message.navigation;
                this.targetId = message.targetId;
                reloadTable = true;
            }
            let executeQueryTable = {
                queryCode: 'CoordinatorController_table',
                limit: -1,
                parameterValues: []
            };
            this.queryExecutor(executeQueryTable, this.createTable.bind(this, reloadTable), this);
            this.showPreloader = false;
        },
        createTabs: function() {
            let tabAppeal__title = this.createElement('div', { className: 'tabAppeal tabTitle', innerText: 'РЕЄСТРАЦІЯ ЗВЕРНЕНЬ'});
            let tabAssigment__title = this.createElement('div', { className: 'tabAssigment tabTitle', innerText: 'ОБРОБКА ДОРУЧЕНЬ'});
            let tabFinder__title = this.createElement('div', { className: ' tabTitle', innerText: 'Розширений пошук'});
            const tabAppeal = this.createElement('div',
                {
                    id: 'tabAppeal', location: 'dashboard', url: 'import_appeals_ugl', className: 'tabAppeal tab tabTo'
                },
                tabAppeal__title
            );
            const tabAssigment = this.createElement('div',
                {
                    id: 'tabAssigment', location: 'dashboard', url: 'curator', className: 'tabAssigment tab tabHover'
                },
                tabAssigment__title
            );
            const tabFinder = this.createElement('div',
                {
                    id: 'tabFinder', location: 'dashboard', url: 'poshuk_table', className: 'tabFinder tab tabTo'
                },
                tabFinder__title
            );
            const tabsContainer = this.createElement('div',
                {
                    id: 'tabsContainer', className: 'tabsContainer'
                },
                tabAppeal ,tabAssigment, tabFinder
            );
            let tabsWrapper = document.getElementById('tabsWrapper');
            tabsWrapper.appendChild(tabsContainer);
            let tabs = document.querySelectorAll('.tabTo');
            tabs = Array.from(tabs);
            tabs.forEach(function(el) {
                el.addEventListener('click', event => {
                    let target = event.currentTarget;
                    if(target.location === 'section') {
                        document.getElementById('container').style.display = 'none';
                        this.goToSection(target.url);
                    }else if(target.location === 'dashboard') {
                        document.getElementById('container').style.display = 'none';
                        this.goToDashboard(target.url);
                    }
                });
            }.bind(this));
        },
        closePreload: function(location) {
            if(location === 'district') {
                if (this.isLoadDistrict && this.isLoadCategorie) {
                    this.messageService.publish({ name: 'hidePagePreloader'});
                }
            }else if(location === 'departament') {
                this.messageService.publish({ name: 'hidePagePreloader'});
            }
        },
        createTable: function(reloadTable ,data) {
            for(let i = 2; i < data.columns.length; i++) {
                let item = data.columns[i];
                let columnHeader = this.createElement('div',
                    {
                        id: String('columnHeader_' + i),
                        code: String(String(item.code)),
                        className: 'columnHeader',
                        innerText: String(String(item.name))
                    }
                );
                if(i === 2) {
                    columnHeader.style.backgroundColor = 'rgb(248, 195, 47)';
                }else if(i === 3) {
                    columnHeader.style.backgroundColor = 'rgb(74, 193, 197)';
                }else if(i === 4) {
                    columnHeader.style.backgroundColor = 'rgb(132, 199, 96)';
                }else if(i === 5) {
                    columnHeader.style.backgroundColor = 'rgb(86 162 78)';
                }else if(i === 6) {
                    columnHeader.style.backgroundColor = 'rgb(240, 114, 93)';
                }else if(i === 7) {
                    columnHeader.style.backgroundColor = 'rgb(238, 123, 54)';
                }
                let column = this.createElement('div',
                    {
                        id: String('column_' + i),
                        code: String(String(item.code)),
                        className: 'column'
                    },
                    columnHeader
                );
                let tableContainer = document.getElementById('tableContainer');
                tableContainer.appendChild(column);
            }
            for(let i = 0; i < data.rows.length - 1; i++) {
                let elRow = data.rows[i];
                let navigationIndex = data.columns.findIndex(el => el.code.toLowerCase() === 'navigation');
                for(let j = 2; j < elRow.values.length; j++) {
                    let el = elRow.values[j];
                    if(el !== 0) {
                        let columnCategorie__value = this.createElement('div',
                            { className: 'columnCategorie__value', innerText: '(' + el + ')' }
                        );
                        let columnCategorie__title = this.createElement('div',
                            {
                                className: 'columnCategorie__title',
                                code: String(String(elRow.values[navigationIndex])),
                                innerText: String(String(elRow.values[navigationIndex]))
                            }
                        );
                        let columnCategorie = this.createElement('div',
                            {
                                className: 'columnCategorie',
                                code: String(String(elRow.values[navigationIndex]))
                            },
                            columnCategorie__title, columnCategorie__value
                        );
                        if(j === 2) {
                            columnCategorie.classList.add('columnCategorie__yellow');
                        }
                        document.getElementById(String('column_' + j)).appendChild(columnCategorie);
                    }
                }
            }
            for(let i = data.rows.length - 1; i < data.rows.length; i++) {
                let summaryHeader = data.rows[i];
                for(let j = 2; j < summaryHeader.values.length; j++) {
                    let el = summaryHeader.values[j];
                    let columnChild = document.getElementById(String('column_' + j)).firstElementChild;
                    let sub = columnChild.innerText;
                    columnChild.innerText = sub + ' (' + el + ') ';
                    let columnHeaderTriangle = this.createElement('div', {className: 'triangle' + j + ' ' });
                    columnChild.appendChild(columnHeaderTriangle);
                }
            }
            let categories = document.querySelectorAll('.columnCategorie');
            categories = Array.from(categories);
            let headers = document.querySelectorAll('.columnHeader');
            headers = Array.from(headers);
            if(reloadTable === true) {
                categories.forEach(el => {
                    el.style.display = 'none';
                });
                let target = document.getElementById(this.targetId);
                this.showTable(target, this.column, this.navigation);
            }
            headers.forEach(function(el) {
                el.addEventListener('click', function(event) {
                    let target = event.currentTarget;
                    categories.forEach(el => {
                        el.style.display = 'none';
                    });
                    let navigator = 'Усі';
                    let column = this.columnName(target);
                    this.showTable(target, column, navigator);
                }.bind(this));
            }.bind(this));
            categories.forEach(function(el) {
                el.addEventListener('click', function(event) {
                    let target = event.currentTarget;
                    categories.forEach(el => {
                        el.style.display = 'none';
                    });
                    let navigator = target.firstElementChild.innerText;
                    target = target.parentElement.firstElementChild;
                    let column = this.columnName(target);
                    this.showTable(target, column, navigator);
                }.bind(this));
            }.bind(this));
            this.messageService.publish({ name: 'hidePagePreloader'});
        },
        columnName: function(target) {
            let column = '';
            if(target.code === 'rozyasneno') {
                column = 'Роз`яcнено'
            }else if(target.code === 'neVKompetentsii') {
                column = 'Не в компетенції'
            }else if(target.code === 'doopratsiovani') {
                column = 'Доопрацьовані'
            }else if(target.code === 'prostrocheni') {
                column = 'Прострочені'
            }else if(target.code === 'neVykonNeMozhl') {
                column = 'План / Програма'
            }else if(target.code === 'vykon') {
                column = 'Виконано'
            }
            return column
        },
        showTable: function(target, columnName, navigator) {
            let headers = document.querySelectorAll('.columnHeader');
            headers = Array.from(headers);
            if(target.classList.contains('check') || target.classList.contains('hover') || target.id === 'searchContainer__input') {
                document.getElementById('columnHeader_2').style.backgroundColor = 'rgb(248, 195, 47)';
                document.getElementById('columnHeader_3').style.backgroundColor = 'rgb(74, 193, 197)';
                document.getElementById('columnHeader_4').style.backgroundColor = 'rgb(132, 199, 96)';
                document.getElementById('columnHeader_5').style.backgroundColor = 'rgb(86 162 78)';
                document.getElementById('columnHeader_6').style.backgroundColor = 'rgb(240, 114, 93)';
                document.getElementById('columnHeader_7').style.backgroundColor = 'rgb(238, 123, 54)';
                document.getElementById('columnHeader_3').firstElementChild.classList.add('triangle3');
                document.getElementById('columnHeader_4').firstElementChild.classList.add('triangle4');
                document.getElementById('columnHeader_5').firstElementChild.classList.add('triangle5');
                document.getElementById('columnHeader_6').firstElementChild.classList.add('triangle6');
                document.getElementById('columnHeader_7').firstElementChild.classList.add('triangle7');
                for(let i = 0; i < headers.length; i++) {
                    let header = headers[i];
                    header.firstElementChild.classList.remove('triangle');
                    header.firstElementChild.classList.add(String('triangle' + (i + 2)));
                    header.classList.remove('hover');
                    header.classList.remove('check');
                }
                this.hideAllItems(1)
                this.sendMesOnBtnClick('clickOnСoordinator_table', 'none', 'none');
            }else{
                target.classList.add('hover');
                for(let i = 0; i < headers.length; i++) {
                    let header = headers[i];
                    if(target.id !== header.id) {
                        header.firstElementChild.classList.remove(String('triangle' + (i + 2)));
                        header.firstElementChild.classList.add('triangle');
                        header.style.backgroundColor = '#d3d3d3';
                        header.classList.add('check');
                    }
                }
                headers[headers.length - 1].firstElementChild.classList.remove('triangle');
                this.sendMesOnBtnClick('clickOnСoordinator_table', columnName, navigator, target.id);
            }
        },
        hideAllItems: function(value) {
            let categories = document.querySelectorAll('.columnCategorie');
            categories = Array.from(categories);
            if(value === 0) {
                categories.forEach(el => {
                    el.style.display = 'none';
                });
            }else if(value === 1) {
                categories.forEach(el => {
                    el.style.display = 'flex';
                });
            }
        },
        sendMesOnBtnClick: function(message, column, navigator, targetId) {
            this.messageService.publish({name: message, column: column, value: navigator, targetId: targetId });
        },
        resultSearch: function(message, value) {
            this.messageService.publish({name: message, value: value});
        },
        createOptions: function() {
            $(document).ready(function() {
                $('.js-example-basic-single').select2();
                $('.js-example-placeholder-district').select2({
                    placeholder: 'Обрати район',
                    allowClear: true
                });
                $('.js-example-placeholder-categorie').select2({
                    placeholder: 'Обрати напрямок робiт',
                    allowClear: true
                });
                $('.js-example-placeholder-departament').select2({
                    placeholder: 'Обрати департамент',
                    allowClear: true
                });
            });
        },
        destroy: function() {
            this.sub.unsubscribe();
        }
    };
}());
