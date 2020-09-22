(function() {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig:
                    `
                        <div id = 'container'></div>
                    `
        ,
        init: function() {
            this.messageService.publish({ name: 'showPagePreloader' });
            const header = document.getElementById('header1');
            header.firstElementChild.style.overflow = 'visible';
            header.firstElementChild.firstElementChild.firstElementChild.style.overflow = 'visible';
            this.sub = this.messageService.subscribe('reloadMainTable', this.reloadMainTable, this);
            if(window.location.search === '') {
                let executeQuery = {
                    queryCode: 'organization_name',
                    parameterValues: [],
                    limit: -1
                };
                this.queryExecutor(executeQuery, this.userOrganization, this);
                this.showPreloader = false;
            }else{
                let getUrlParams = window
                    .location
                    .search
                    .replace('?', '')
                    .split('&')
                    .reduce(function(p, e) {
                        let a = e.split('=');
                        p[decodeURIComponent(a[0])] = decodeURIComponent(a[1]);
                        return p;
                    }, {}
                    );
                let tabInd = Number(getUrlParams.id);
                this.organizationId = tabInd;
                let executeQueryValues = {
                    queryCode: 'table2_686',
                    limit: -1,
                    parameterValues: [ { key: '@organization_id', value: this.organizationId} ]
                };
                this.queryExecutor(executeQueryValues, this.createTable.bind(this, false, null), this);
                this.showPreloader = false;
                let executeQuery = {
                    queryCode: 'organization_name',
                    parameterValues: [{ key: '@organizationId', value: this.organizationId}],
                    limit: -1
                };
                this.queryExecutor(executeQuery, this.userOrganization, this);
                this.showPreloader = false;
            }
            let executeOrganizationSelect = {
                queryCode: 'OrganizationSelect',
                limit: -1,
                parameterValues: []
            };
            this.queryExecutor(executeOrganizationSelect, this.setOrganizationSelect, this);
            this.showPreloader = false;
        },
        userOrganization: function(data) {
            let indexOfTypeName = data.columns.findIndex(el => el.code.toLowerCase() === 'organizationname');
            let indexOfTypeId = data.columns.findIndex(el => el.code.toLowerCase() === 'organizationid');
            let indexOfTypeDistribute = data.columns.findIndex(el => el.code.toLowerCase() === 'distribute');
            this.organizationId = [];
            if(data.rows[0]) {
                this.organizationId = (data.rows[0].values[indexOfTypeId]);
                this.distribute = (data.rows[0].values[indexOfTypeDistribute]);
                this.messageService.publish({name: 'messageWithOrganizationId', value: this.organizationId, distribute:  this.distribute});
                document.getElementById('organizationName').value = (data.rows[0].values[indexOfTypeId]);
                document.getElementById('organizationName').innerText = (data.rows[0].values[indexOfTypeName]);
                if(window.location.search !== String('?id=' + data.rows[0].values[indexOfTypeId])) {
                    window.location.search = String('id=' + data.rows[0].values[indexOfTypeId]);
                }
            }
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
            const container = document.getElementById('container')
            const tabsWrapper = this.createElement('div', { id: 'tabsWrapper', className: 'tabsWrapper'});
            const filtersWrapper = this.createElement('div', { id: 'filtersWrapper', className: 'filtersWrapper'});
            const tableContainer = this.createElement('div', { id: 'tableContainer', className: 'tableContainer'});
            this.tableContainer = tableContainer;
            const tableWrapper = this.createElement('div', { id: 'tableWrapper', className: 'tableWrapper'}, tableContainer);
            container.appendChild(tabsWrapper);
            container.appendChild(filtersWrapper);
            container.appendChild(tableWrapper);
            this.createTabs(tabsWrapper);
            this.createFilters(filtersWrapper);
        },
        setOrganizationSelect: function(data) {
            this.organizationSelect = [];
            if(data.rows.length > 0) {
                const organizationSelect = [];
                const indexId = data.columns.findIndex(el => el.code.toLowerCase() === 'id');
                const indexName = data.columns.findIndex(el => el.code.toLowerCase() === 'name');
                data.rows.forEach(row => {
                    let obj = {
                        id: row.values[indexId],
                        name: row.values[indexName]
                    }
                    organizationSelect.push(obj);
                });
                this.organizationSelect = organizationSelect;
            }
        },
        createTabs: function(tabsWrapper) {
            let tabFinder__title = this.createElement('div', { className: ' tab_title', innerText: 'Розширений пошук'});
            const tabFinder = this.createElement('div',
                { id: 'tabFinder', url: 'poshuk_table', className: 'tabFinder tab tabTo'},
                tabFinder__title
            );
            let tabTemplates__title = this.createElement('div', { className: ' tab_title', innerText: 'Шаблони'});
            const tabTemplates = this.createElement('div',
                { id: 'tabTemplates', url: 'Templates', className: 'tabTemplates tab tabTo'},
                tabTemplates__title
            );
            let tabExecutivePosition__title = this.createElement('div', { className: ' tab_title', innerText: 'Вибір посади-виконавця'});
            const tabExecutivePosition = this.createElement('div',
                { id: 'tabExecutivePosition', url: 'PersonExecutorChoose', className: 'tabExecutivePosition tab tabTo'},
                tabExecutivePosition__title
            );
            let tabInformation__title = this.createElement('div',
                { className: 'tabInformation tab_title', innerText: 'ЗАГАЛЬНА ІНФОРМАЦІЯ'}
            );
            const tabInformation = this.createElement('div',
                { id: 'tabInformation', url: 'monitoring_and_responding', className: 'tabInformation tab tabTo'},
                tabInformation__title
            );
            let tabAction__title = this.createElement('div', { className: 'tabAction tab_title', innerText: 'ЗАХІД'});
            const tabAction = this.createElement('div',
                { id: 'tabAction', url: 'performer_new_actions', className: 'tabAction tab tabTo'},
                tabAction__title
            );
            let tabProcessingOrders__title = this.createElement('div',
                { className: 'tabProcessingOrders tab_title', innerText: 'ОБРОБКА ДОРУЧЕНЬ'}
            );
            const tabProcessingOrders = this.createElement('div',
                { id: 'tabProcessingOrders', url: 'performer_new_processing_assigments', className: 'tabHover tabProcessingOrders tab'},
                tabProcessingOrders__title
            );
            let tabOrganizations__title = this.createElement('div', { className: 'tabOrganizations tab_title', innerText: 'ОРГАНІЗАЦІЇ'});
            const tabOrganizations = this.createElement('div',
                { id: 'tabOrganizations', url: 'performer_new_organizations', className: 'tabOrganizations tab tabTo'},
                tabOrganizations__title
            );
            let tabPerformers__title = this.createElement('div', { className: ' tab_title', innerText: 'Виконавці'});
            const tabPerformers = this.createElement('div',
                { id: 'tabPerformers', url: 'performers', className: 'tabPerformers  tab tabTo'},
                tabPerformers__title
            );
            const tabsContainer = this.createElement('div',
                { id: 'tabsContainer', className: 'tabsContainer'},
                tabInformation, tabAction, tabProcessingOrders, tabOrganizations,
                tabPerformers, tabFinder, tabExecutivePosition, tabTemplates
            );
            const orgLinkСhangerBox__icon = this.createElement('div',
                { id: 'orgLinkСhangerBox__icon', className:'material-icons', innerText:'more_vert' }
            );
            const orgLinkChangerBox = this.createElement('div', { id: 'orgLinkСhangerBox'}, orgLinkСhangerBox__icon);
            const linkСhangerContainer = this.createElement('div', { id: 'organizationsContainer'}, orgLinkChangerBox);
            tabsWrapper.appendChild(tabsContainer);
            tabsWrapper.appendChild(linkСhangerContainer);
            orgLinkСhangerBox__icon.addEventListener('click', event => {
                if(this.organizationSelect.length > 0) {
                    event.stopImmediatePropagation();
                    if(orgLinkChangerBox.children.length === 1) {
                        let orgLinksWrapper__triangle = this.createElement('div', { className: 'orgLinksWrapper__triangle' });
                        let orgLinksWrapper = this.createElement('div', { id: 'orgLinksWrapper'}, orgLinksWrapper__triangle);
                        orgLinkChangerBox.appendChild(orgLinksWrapper);
                        this.organizationSelect.forEach(el => {
                            let organizationLink = this.createElement('div',
                                { className: 'organizationLink', orgId: String(String(el.id)), innerText: el.name }
                            );
                            orgLinksWrapper.appendChild(organizationLink);
                            organizationLink.addEventListener('click', event => {
                                event.stopImmediatePropagation();
                                let target = event.currentTarget;
                                window.open(String(location.origin + localStorage.getItem('VirtualPath') +
                                '/dashboard/page/performer_new_processing_assigments?id=' + target.orgId));
                            });
                        });
                    }else if(orgLinkChangerBox.children.length === 2) {
                        let container = document.getElementById('orgLinksWrapper');
                        orgLinkChangerBox.removeChild(container);
                    }
                }
            });
            const tabs = Array.from(document.querySelectorAll('.tabTo'));
            tabs.forEach(el => {
                el.addEventListener('click', event => {
                    let target = event.currentTarget;
                    document.getElementById('container').style.display = 'none';
                    if(target.id === 'tabFinder' || target.id === 'tabInformation') {
                        this.goToDashboard(target.url);
                    } else if (target.id === 'tabExecutivePosition' || target.id === 'tabTemplates') {
                        this.goToSection(target.url);
                    }else{
                        this.goToDashboard(target.url, { queryParams: { id: this.organizationId } });
                    }
                });
            });
        },
        createFilters: function(filtersWrapper) {
            const searchContainer__input = this.createElement('input',
                {
                    id: 'searchContainer__input',
                    type: 'search',
                    placeholder: 'Пошук доручення за номером',
                    className: 'searchContainer__input'
                }
            );
            this.searchContainer__input = searchContainer__input;
            const searchContainer = this.createElement('div',
                {id: 'searchContainer', className: 'searchContainer'},
                searchContainer__input
            );
            searchContainer__input.addEventListener('input', event => {
                event.stopImmediatePropagation();
                if(searchContainer__input.value.length === 0) {
                    this.resultSearch('clearInput', 0);
                    this.showTable(searchContainer__input);
                }
            });
            searchContainer__input.addEventListener('keypress', function(e) {
                let key = e.which || e.keyCode;
                if (key === 13) {
                    this.resultSearch('resultSearch', searchContainer__input.value, this.organizationId);
                    this.resultSearch('clickOnTable2', 'none');
                    this.hideAllItems(0);
                }
            }.bind(this));
            const organizationName = this.createElement('div', { id: 'organizationName', className: 'organizationName' });
            this.organizationName = organizationName;
            filtersWrapper.appendChild(organizationName);
            filtersWrapper.appendChild(searchContainer);
        },
        reloadMainTable: function(message) {
            const tableContainer = this.tableContainer;
            this.column = message.column;
            this.navigator = message.navigator;
            let targetId = message.targetId;
            while (tableContainer.hasChildNodes()) {
                tableContainer.removeChild(tableContainer.childNodes[0]);
            }
            let executeQueryValues = {
                queryCode: 'table2_686',
                limit: -1,
                parameterValues: [ { key: '@organization_id', value: this.organizationId} ]
            };
            this.queryExecutor(executeQueryValues, this.createTable.bind(this, true, targetId), this);
            this.showPreloader = false;
        },
        createTable: function(reloadTable, targetId, data) {
            const tableContainer = this.tableContainer;
            for(let i = 2; i < data.columns.length; i++) {
                let item = data.columns[i];
                let columnTriangle = this.createElement('div', { });
                let columnHeader = this.createElement('div',
                    {
                        id: String('columnHeader_' + i),
                        code: String(String(item.code)),
                        className: 'columnHeader',innerText: String(String(item.name))
                    },
                    columnTriangle
                );
                let columnsWrapper = this.createElement('div', { id: String('columnsWrapper_' + i), className: 'columnsWrapper'});
                if(i === 2) {
                    columnHeader.style.backgroundColor = 'rgb(74, 193, 197)';
                    columnTriangle.classList.add(String('triangle' + i));
                }else if(i === 3) {
                    columnHeader.style.backgroundColor = 'rgb(173, 118, 205)';
                    columnTriangle.classList.add(String('triangle' + i));
                }else if(i === 4) {
                    columnHeader.style.backgroundColor = 'rgb(240, 114, 93)';
                    columnTriangle.classList.add(String('triangle' + i));
                }else if(i === 5) {
                    columnHeader.style.backgroundColor = 'rgb(238, 163, 54)';
                    columnTriangle.classList.add(String('triangle' + i));
                }else if(i === 6) {
                    columnHeader.style.backgroundColor = 'rgb(132, 199, 96)';
                    columnTriangle.classList.add(String('triangle' + i));
                }else if(i === 7) {
                    columnHeader.style.backgroundColor = 'rgb(248, 195, 47)';
                    columnTriangle.classList.add(String('triangle' + i));
                }else if(i === 8) {
                    columnHeader.style.backgroundColor = 'rgb(94, 202, 162)';
                    columnTriangle.classList.add(String('triangle' + i));
                }else if(i === 9) {
                    columnHeader.style.backgroundColor = 'rgb(73, 155, 199)';
                    columnTriangle.classList.add(String('triangle' + i));
                }
                let column = this.createElement('div',
                    { id: String('column_' + i), code: String(String(item.code)), className: 'column'},
                    columnHeader, columnsWrapper
                );
                column.classList.add(String('column_' + i));
                tableContainer.appendChild(column);
            }
            for(let i = 0; i < data.rows.length; i++) {
                let elRow = data.rows[i];
                for(let j = 2; j < elRow.values.length; j++) {
                    let el = elRow.values[j];
                    if(el !== 0) {
                        let columnCategorie__value = this.createElement('div',
                            { className: 'columnCategorie__value', innerText: '(' + el + ')'}
                        );
                        let columnCategorie__title = this.createElement('div',
                            {
                                className: 'columnCategorie__title',
                                code: String(String(elRow.values[1])),
                                innerText: String(String(elRow.values[1]))}
                        );
                        let columnCategorie = this.createElement('div',
                            {
                                className: 'columnCategorie',
                                code: String(String(elRow.values[1]))
                            },
                            columnCategorie__title, columnCategorie__value
                        );
                        document.getElementById(String('columnsWrapper_' + j)).appendChild(columnCategorie);
                    }
                }
            }
            let headers = document.querySelectorAll('.columnHeader');
            let categories = document.querySelectorAll('.columnCategorie');
            categories = Array.from(categories);
            headers = Array.from(headers);
            headers.forEach(el => {
                el.addEventListener('click', event => {
                    let target = event.currentTarget;
                    this.searchContainer__input.value = '';
                    this.resultSearch('clearInput', 0);
                    categories.forEach(el => {
                        el.style.display = 'none';
                    });
                    let navigator = 'Усі';
                    let column = this.columnName(target);
                    this.showTable(target, column, navigator);
                });
            });
            categories.forEach(el => {
                el.addEventListener('click', event => {
                    let target = event.currentTarget;
                    categories.forEach(el => {
                        el.style.display = 'none';
                    });
                    let navigator = target.firstElementChild.innerText;
                    target = target.parentElement.parentElement.firstElementChild;
                    let column = this.columnName(target);
                    this.showTable(target, column, navigator);
                });
            });
            if(reloadTable === true) {
                categories.forEach(el => {
                    el.style.display = 'none';
                });
                let target = document.getElementById(targetId);
                this.showTable(target, this.column, this.navigator);
            }
            this.messageService.publish({ name: 'hidePagePreloader' });
        },
        columnName: function(target) {
            let column = '';
            if(target.code === 'nadiyshlo') {
                column = 'Надійшло'
            }else if(target.code === 'neVKompetentsii') {
                column = 'Не в компетенції'
            }else if(target.code === 'prostrocheni') {
                column = 'Прострочені'
            }else if(target.code === 'uvaga') {
                column = 'Увага'
            }else if(target.code === 'vroboti') {
                column = 'В роботі'
            }else if(target.code === 'dovidoma') {
                column = 'До відома'
            }else if(target.code === 'naDoopratsiyvanni') {
                column = 'На доопрацюванні'
            }else if(target.code === 'neVykonNeMozhl') {
                column = 'План/Програма'
            }
            return column
        },
        showTable: function(target, columnName, navigator) {
            let headers = document.querySelectorAll('.columnHeader');
            headers = Array.from(headers);
            if(target.classList.contains('check') || target.classList.contains('hover') || target.id === 'searchContainer__input') {
                headers.forEach(el => {
                    el.firstElementChild.classList.remove('triangle');
                });
                document.getElementById('columnHeader_2').style.backgroundColor = 'rgb(74, 193, 197)';
                document.getElementById('columnHeader_3').style.backgroundColor = 'rgb(173, 118, 205)';
                document.getElementById('columnHeader_4').style.backgroundColor = 'rgb(240, 114, 93)';
                document.getElementById('columnHeader_5').style.backgroundColor = 'rgb(238, 163, 54)';
                document.getElementById('columnHeader_6').style.backgroundColor = 'rgb(132, 199, 96)';
                document.getElementById('columnHeader_7').style.backgroundColor = 'rgb(248, 195, 47)';
                document.getElementById('columnHeader_8').style.backgroundColor = 'rgb(94, 202, 162)';
                document.getElementById('columnHeader_9').style.backgroundColor = 'rgb(73, 155, 199)';
                document.getElementById('columnHeader_2').firstElementChild.classList.add('triangle2');
                document.getElementById('columnHeader_3').firstElementChild.classList.add('triangle3');
                document.getElementById('columnHeader_4').firstElementChild.classList.add('triangle4');
                document.getElementById('columnHeader_5').firstElementChild.classList.add('triangle5');
                document.getElementById('columnHeader_6').firstElementChild.classList.add('triangle6');
                document.getElementById('columnHeader_7').firstElementChild.classList.add('triangle7');
                document.getElementById('columnHeader_8').firstElementChild.classList.add('triangle8');
                headers.forEach(function(el) {
                    el.classList.remove('hover');
                    el.classList.remove('check');
                }.bind(this));
                this.hideAllItems(1);
                this.sendMesOnBtnClick('clickOnTable2', 'none', 'none');
            }else{
                target.classList.add('hover');
                headers.forEach(function(target, header) {
                    let headers = document.querySelectorAll('.columnHeader');
                    headers = Array.from(headers);
                    if(target.id !== header.id) {
                        header.style.backgroundColor = '#d3d3d3';
                        header.classList.add('check');
                        header.firstElementChild.classList.remove(header.firstElementChild.classList[0]);
                        header.firstElementChild.classList.add('triangle');
                    }
                    headers[7].firstElementChild.classList.remove('triangle');
                }.bind(this, target));
                this.sendMesOnBtnClick('clickOnTable2', columnName, navigator, target.id);
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
            this.messageService.publish({
                name: message,
                column: column,
                navigation: navigator,
                orgId: this.organizationId,
                orgName: this.organizationName.innerText,
                targetId:  targetId
            });
        },
        resultSearch: function(message, value, id) {
            this.messageService.publish({name: message, value: value, orgId: id });
        },
        destroy: function() {
            this.sub.unsubscribe();
        }
    };
}());
