(function() {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig:
                `
                    <div id='container'></div>
                `
        ,
        column: null,
        navigator: null,
        targetId: null,
        emptyString: '',
        tabs: [
            {
                id: 'monitoring_and_responding',
                url: 'monitoring_and_responding',
                titleText: 'Загальна інформація',
                location: 'dashboard'
            },
            {
                id: 'performer_new_processing_assigments',
                url: 'performer_new_processing_assigments',
                titleText: 'ОБРОБКА ДОРУЧЕНЬ',
                location: 'dashboard'
            },
            {
                id: 'performer_new_organizations',
                url: 'performer_new_organizations',
                titleText: 'Організації',
                location: 'dashboard'
            },
            {
                id: 'performers',
                url: 'performers',
                titleText: 'Виконавці',
                location: 'dashboard'
            },
            {
                id: 'sector_controls',
                url: 'sector_controls',
                titleText: 'Контроль сектору інспектора',
                location: 'dashboard',
                hover: true
            },
            {
                id: 'PersonExecutorChoose',
                url: 'PersonExecutorChoose',
                titleText: 'Вибір посади-виконавця',
                location: 'section'
            }
        ],
        headers: [
            {
                name: 'arrived',
                id: 'headerItem__arrived',
                innerText: 'Надійшло',
                colorIndex: 0,
                backgroundColor: 'rgb(74, 193, 197)'
            },
            {
                name: 'in_work',
                id: 'headerItem__inWork',
                innerText: 'В роботі',
                colorIndex: 1,
                backgroundColor: 'rgb(132, 199, 96)'
            },
            {
                name: 'overdue',
                id: 'headerItem__overdue',
                innerText: 'Прострочено',
                colorIndex: 2,
                backgroundColor: 'rgb(240, 114, 93)'
            },
            {
                name: 'clarified',
                id: 'headerItem__checked',
                innerText: 'Роз\'яснено',
                colorIndex: 3,
                backgroundColor: 'rgb(248, 195, 47)'
            },
            {
                name: 'done',
                id: 'headerItem__done',
                innerText: 'Виконано',
                colorIndex: 4,
                backgroundColor: 'rgb(86 162 78)'
            },
            {
                name: 'for_revision',
                id: 'headerItem__onRefinement',
                innerText: 'На доопрацювання',
                colorIndex: 5,
                backgroundColor: 'rgb(94, 202, 162)'
            },
            {
                name: 'plan_program',
                id: 'headerItem__planOrProgram',
                innerText: 'План\\Програма',
                colorIndex: 6,
                backgroundColor:  'rgb(73, 155, 199)'
            }
        ],
        init: function() {
            this.messageService.publish({ name: 'showPagePreloader' });
            const header1 = document.getElementById('header1');
            header1.parentElement.style.flexFlow = 'column nowrap';
            header1.firstElementChild.style.overflow = 'visible';
            header1.firstElementChild.firstElementChild.firstElementChild.style.overflow = 'visible';
            this.subscribers.push(this.messageService.subscribe('reloadMainTable', this.reloadMainTable, this));
            this.executeMainTableQuery(false, null);
            this.executeOrganizationQuery();
        },
        executeOrganizationQuery: function() {
            let executeQuery = {
                queryCode: 'organization_name',
                parameterValues: [],
                limit: -1
            };
            this.queryExecutor(executeQuery, this.setUserOrganizationId, this);
            this.showPreloader = false;
        },
        setUserOrganizationId: function(data) {
            const indexOfTypeId = data.columns.findIndex(el => el.code.toLowerCase() === 'organizationid');
            if(data.rows[0]) {
                this.organizationId = (data.rows[0].values[indexOfTypeId]);
            }
        },
        executeMainTableQuery: function(isReload, targetId) {
            let executeQueryOrganizations = {
                queryCode: 'DB_ControS_s_main',
                limit: -1,
                parameterValues: [
                    { key: '@pageOffsetRows', value: 0 },
                    { key: '@pageLimitRows', value: 10 }
                ]
            };
            this.queryExecutor(executeQueryOrganizations, this.createInfoTable.bind(this, isReload, targetId), this);
            this.showPreloader = false;
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
            this.container = document.getElementById('container')
            const tabsWrapper = this.createElement('div', { id: 'tabsWrapper', className: 'tabsWrapper'});
            const filtersWrapper = this.createElement('div', { id: 'filtersWrapper', className: 'filtersWrapper'});
            const tableContainer = this.createElement('div', { id: 'tableContainer', className: 'tableContainer'});
            this.createElement('div', { id: 'tableWrapper', className: 'tableWrapper'}, tableContainer);
            this.container.appendChild(tabsWrapper);
            this.container.appendChild(filtersWrapper);
            this.createTabs(tabsWrapper);
            this.createFilters();
        },
        createTabs: function(tabsWrapper) {
            const tabsContainer = this.createElement('div',
                { id: 'tabsContainer', className: 'tabsContainer'}
            );
            tabsWrapper.appendChild(tabsContainer);
            this.tabs.forEach(tab => {
                let itemTitle = this.createElement('div', { className: 'tab_title', innerText: tab.titleText });
                const item = this.createElement('div',
                    { id: tab.id, url: tab.url, className: 'tab', location: tab.location },
                    itemTitle
                );
                if (tab.hover) {
                    item.classList.add('tabHover');
                } else {
                    item.addEventListener('click', event => {
                        const target = event.currentTarget;
                        if (target.location === 'dashboard') {
                            this.goToDashboard(target.url, { queryParams: { id: this.organizationId } });
                        } else {
                            this.goToSection(target.url);
                        }
                    });
                }
                item.addEventListener('click', () => {
                });
                tabsContainer.appendChild(item);
            });
        },
        createFilters: function() {
            this.organizationName = this.createElement('div', {id: 'organizationName', innerText: this.emptyString});
            let filtersWrapper = document.getElementById('filtersWrapper');
            filtersWrapper.appendChild(this.organizationName);
            this.setOrganizationName(this.emptyString);
        },
        setOrganizationName: function(value) {
            this.organizationName.innerText = value;
        },
        clearOrganizationName: function() {
            this.organizationName.innerText = this.emptyString;
        },
        reloadMainTable: function(message) {
            document.getElementById('container').removeChild(document.getElementById('orgHeader'));
            document.getElementById('container').removeChild(document.getElementById('orgContainer'));
            this.column = message.column;
            this.navigator = message.navigator;
            let targetId = message.targetId;
            this.executeMainTableQuery(true, targetId);
        },
        createInfoTable: function(isReload, targetId, data) {
            this.createInspectorOrganizationsHeaders();
            this.createInspectorOrganizations(isReload, targetId, data);
            this.messageService.publish({ name: 'hidePagePreloader' });
        },
        createInspectorOrganizationsHeaders: function() {
            const headerItems = this.createElement('div',
                {
                    id: 'headerItems',
                    className: 'displayFlex'
                }
            );
            const headerTitle = this.createElement('div', { id: 'headerTitle', innerText: 'Сектор'});
            const orgHeader = this.createElement('div',
                {
                    id: 'orgHeader',
                    className: 'orgContainer displayFlex'
                },
                headerTitle, headerItems
            );
            this.container.appendChild(orgHeader);
            this.headerItems = [];
            this.headers.forEach(headerStatus => {
                const triangle = this.createElement('div', { className: `${headerStatus.name}_triangle` });
                const headerItem = this.createElement('div',
                    {
                        id: `${headerStatus.id}`,
                        name: `${headerStatus.name}`,
                        className: 'headerItem displayFlex',
                        innerText: `${headerStatus.innerText}`,
                        style: `background-color: ${headerStatus.backgroundColor}`,
                        colorIndex: `${headerStatus.colorIndex}`
                    },
                    triangle
                );
                headerItem.addEventListener('click', event => {
                    let target = event.currentTarget;
                    let navigator = 'Усі';
                    let column = target.innerText;
                    this.setInfoTableVisibility(target, column, navigator, undefined,'headers');
                });
                this.headerItems.push(headerItem);
                headerItems.appendChild(headerItem);
            });
        },
        createInspectorOrganizations: function(isReload, targetId, data) {
            if (isReload) {
                let target = document.getElementById(targetId);
                let thisName = document.getElementById('organizationName').innerText;
                this.setInfoTableVisibility(target, this.column, this.navigator, thisName ,'item');
            }
            this.orgContainer = this.createElement('div', { id: 'orgContainer', className: 'orgContainer'});
            this.container.appendChild(this.orgContainer);
            if (data.rows.length) {
                this.appendItemsToOrgContainer(data);
            } else {
                this.messageService.publish({ name: 'emptyPage' });
            }
            this.setStylesForElements();
        },
        setStylesForElements: function() {
            const counterHeaderElements = Array.from(document.querySelectorAll('.counter'));
            counterHeaderElements.forEach(el => {
                if(el.childNodes.length === 0) {
                    el.style.backgroundColor = 'transparent';
                }else{
                    el.classList.add('counterBorder');
                }
            });
            const referralColumnElements = Array.from(document.querySelectorAll('.referralColumn'));
            referralColumnElements.forEach(el => {
                if(el.childNodes.length === 0) {
                    let emptyBox = this.createElement('div', { className: 'emptyBox'});
                    el.appendChild(emptyBox);
                }
            });
        },
        appendItemsToOrgContainer: function(data) {
            for (let index = 0; index < data.rows.length; index++) {
                const row = data.rows[index];
                const organizationId = row.values[0];
                const orgElementsCounter = this.createElement('div', { className: 'orgElementsCounter displayFlex' });
                const orgElements = this.createElement('div',{className: 'orgElements displayFlex'},orgElementsCounter);
                const orgTitle__name = this.createElement('div',{className: 'orgTitle__name', innerText: row.values[1]});
                const orgTitle = this.createElement('div',{className: 'orgTitle displayFlex'}, orgTitle__name);
                const organization = this.createElement('div',
                    {
                        className: 'organization displayFlex', id: String(organizationId)
                    },
                    orgTitle, orgElements
                );
                this.orgContainer.appendChild(organization);
                this.appendItemsToOrgElementsReferralWrapper(row, orgElementsCounter, organizationId);
            }
        },
        appendItemsToOrgElementsReferralWrapper: function(row, orgElementsCounter, organizationId) {
            const organizationName = row.values[1];
            for(let i = 2; i < row.values.length; i++) {
                if(row.values[i] !== 0) {
                    const referralHeader__value = this.createElement('div',
                        {
                            className: 'counter_value', innerText: row.values[i]
                        }
                    );
                    const referralHeader = this.createElement('div',
                        {
                            orgId: organizationId,
                            headerId: this.headers[i - 2].id,
                            headerName:  this.headers[i - 2].name,
                            orgName: organizationName,
                            className: 'counter counterHeader'
                        },
                        referralHeader__value
                    );
                    referralHeader.addEventListener('click', event => {
                        event.stopImmediatePropagation();
                        const target = event.currentTarget;
                        this.targetOrgId = target.orgId;
                        const columnHeader = document.getElementById(target.headerId);
                        this.setInfoTableVisibility(columnHeader, target.headerName, 'Усі', target.orgName, 'item');
                    });
                    orgElementsCounter.appendChild(referralHeader);
                } else {
                    orgElementsCounter.appendChild(this.createElement('div', { className: 'counter counterHeader'}));
                }
            }
        },
        setVisibilityOrganizationContainer: function(status) {
            this.orgContainer.style.display = status;
        },
        setInfoTableVisibility: function(target, columnName, navigator, orgName, position) {
            if(target.classList.contains('check') || target.classList.contains('hover')) {
                this.headerItems.forEach((header, index) => {
                    header.firstElementChild.classList.remove('triangle');
                    header.firstElementChild.classList.add(`${header.name}_triangle`);
                    header.classList.remove('hover');
                    header.classList.remove('check');
                    header.style.backgroundColor = this.headers[index].backgroundColor;
                });
                this.clearOrganizationName();
                this.setVisibilityOrganizationContainer('block');
                this.sendMesOnBtnClick('clickOnInfoTable', undefined, undefined);
            } else {
                if (position === 'item') {
                    this.setOrganizationName(orgName);
                    target.classList.add('hover');
                    this.setVisibilityOrganizationContainer('none');
                    this.headerItems.forEach(header => {
                        if(target.id !== header.id) {
                            header.style.backgroundColor = '#d3d3d3';
                            header.classList.add('check');
                            header.firstElementChild.classList.remove(header.firstElementChild.classList[0]);
                            header.firstElementChild.classList.add('triangle');
                        }
                        this.headerItems[6].firstElementChild.classList.remove('triangle');
                    });
                    this.sendMesOnBtnClick('clickOnInfoTable', columnName, navigator, orgName, this.targetOrgId, target.id);
                }
            }
        },
        sendMesOnBtnClick: function(message, columnName, navigator, orgName, organizationId, targetId) {
            this.messageService.publish({
                name: message,
                columnName: columnName,
                navigation: navigator,
                organizationId: organizationId,
                orgName: orgName,
                targetId: targetId
            });
        }
    };
}());
