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
        isLoadDistrict: false,
        isLoadCategory: false,
        isDistrictFull: false,
        isCategoryFull: false,
        init: function() {
            this.hidePagePreloader();
            this.messageService.publish({ name: 'showPagePreloader'});
            this.sub = this.messageService.subscribe('reloadMainTable', this.reloadMainTable, this);
            this.column = [];
            this.navigator = [];
            const header1 = document.getElementById('header1');
            header1.parentElement.style.flexFlow = 'column nowrap';
            header1.firstElementChild.style.overflow = 'visible';
            header1.firstElementChild.firstElementChild.firstElementChild.style.overflow = 'visible';
            let status = 'new';
            let location = undefined;
            let executeQueryTable = {
                queryCode: 'CoordinatorController_table',
                limit: -1,
                parameterValues: []
            };
            this.queryExecutor(executeQueryTable, this.createTable.bind(this, false), this);
            this.showPreloader = false;
            let executeQueryFiltersDist = {
                queryCode: 'cc_FilterName',
                limit: -1,
                parameterValues: []
            };
            this.queryExecutor(executeQueryFiltersDist, this.setDistrictData.bind(this, status, location), this);
            this.showPreloader = false;
            let executeQueryFiltersDepart = {
                queryCode: 'cc_FilterNameDepartment',
                limit: -1,
                parameterValues: []
            };
            this.queryExecutor(executeQueryFiltersDepart, this.setDepartmentData.bind(this, status, location), this);
            this.showPreloader = false;
            let executeQueryDistinct = {
                queryCode: 'cc_FilterDistrict',
                limit: -1,
                parameterValues: []
            };
            this.queryExecutor(executeQueryDistinct, this.setDistrictCategories, this);
            this.showPreloader = false;
            let executeQueryCategories = {
                queryCode: 'cc_FilterQuestionTypes',
                limit: -1,
                parameterValues: []
            };
            this.queryExecutor(executeQueryCategories, this.setQuestionTypesCategories, this);
            this.showPreloader = false;
            let executeQueryDepartment = {
                queryCode: 'cc_FilterDepartment',
                limit: -1,
                parameterValues: []
            };
            this.queryExecutor(executeQueryDepartment, this.setDepartmentCategories, this);
            this.showPreloader = false;
        },
        afterViewInit: function() {
            const container = document.getElementById('container');
            const filtersContainerDepart = this.createElement('div', {
                id: 'filtersContainerDepart',
                className: 'filtersContainer'
            });
            const filtersContainerDistrict = this.createElement('div', {
                id: 'filtersContainerDistrict',
                className: 'filtersContainer'
            });
            const tabsWrapper = this.createElement('div', { id: 'tabsWrapper', className: 'tabsWrapper'});
            const filtersWrapper = this.createElement('div', { id: 'filtersWrapper', className: 'filtersWrapper'});
            const filtersInfo = this.createElement('div', { id: 'filtersInfo', className: 'filtersInfo'});
            const tableContainer = this.createElement('div', { id: 'tableContainer', className: 'tableContainer'});
            const tableWrapper = this.createElement('div', {
                id: 'tableWrapper',
                className: 'tableWrapper'
            }, tableContainer);
            filtersInfo.appendChild(filtersContainerDistrict);
            filtersInfo.appendChild(filtersContainerDepart);
            container.appendChild(tabsWrapper);
            filtersWrapper.appendChild(filtersInfo);
            container.appendChild(filtersWrapper);
            container.appendChild(tableWrapper);
            this.createTabs();
            this.createFilterAddBox();
            this.createSearchInput(filtersWrapper);
        },
        createTabs: function() {
            let tabPhone__title = this.createElement('div', {
                className: 'tabPhone tabTitle',
                innerText: 'ВХІДНИЙ ДЗВІНОК'
            });
            let tabProzvon__title = this.createElement('div', {
                className: 'tabProzvon tabTitle',
                innerText: 'Прозвон'
            });
            let tabAppeal__title = this.createElement('div', {
                className: 'tabAppeal tabTitle',
                innerText: 'РЕЄСТРАЦІЯ ЗВЕРНЕНЬ'
            });
            let tabAssignment__title = this.createElement('div', {
                className: 'tabAssigment tabTitle',
                innerText: 'ОБРОБКА ДОРУЧЕНЬ'
            });
            let tabFinder__title = this.createElement('div', { className: ' tabTitle', innerText: 'Розширений пошук'});
            const tabPhone = this.createElement('div', {
                id: 'tabPhone',
                location: 'dashboard',
                url: 'StartPage_operator',
                className: 'tabPhone tab tabTo'
            }, tabPhone__title);
            const tabProzvon = this.createElement('div', {
                id: 'tabProzvon__title',
                location: 'dashboard',
                url: 'prozvon',
                className: 'tabProzvon tab tabTo'
            }, tabProzvon__title);
            const tabAppeal = this.createElement('div', {
                id: 'tabAppeal',
                location: 'section',
                url: '',
                className: 'tabAppeal tab tabTo'
            }, tabAppeal__title);
            const tabAssigment = this.createElement('div', {
                id: 'tabAssigment',
                location: 'dashboard',
                url: 'curator',
                className: 'tabAssigment tab tabHover'
            }, tabAssignment__title);
            const tabFinder = this.createElement('div', {
                id: 'tabFinder',
                location: 'dashboard',
                url: 'poshuk_table',
                className: 'tabFinder tab tabTo'
            }, tabFinder__title);
            const tabsContainer = this.createElement('div', {
                id: 'tabsContainer',
                className: 'tabsContainer'
            },tabPhone, tabProzvon, tabAppeal, tabAssigment, tabFinder);
            const techBox__icon = this.createElement('div', {
                id: 'techBox__icon',
                className:'material-icons',
                innerText:'help' });
            const techBox = this.createElement('div', { id: 'techWrapper' }, techBox__icon);
            const techInfoCont = this.createElement('div', { id: 'techInfoCont', className: 'techInfoCont'}, techBox);
            let tabsWrapper = document.getElementById('tabsWrapper');
            tabsWrapper.appendChild(tabsContainer);
            tabsWrapper.appendChild(techInfoCont);
            techBox__icon.addEventListener('click', event => {
                event.stopImmediatePropagation();
                if(techBox.children.length === 1) {
                    let techInfoWrapper__triangle = this.createElement('div', {
                        className: 'techInfoWrapper__triangle'
                    });
                    let techInfo__messageTitle = this.createElement('div', {
                        id: 'techInfo__messageTitle',
                        innerText: 'Текст повідомлення'
                    });
                    let techInfo__messageText = this.createElement('textarea', {
                        id: 'techInfo__messageText',
                        placeholder: 'Введiть текст...'
                    });
                    let techInfo__sendBtn = this.createElement('button', {
                        id: 'techInfo__sendBtn',
                        className: 'disabledBtn',
                        innerText: 'Відправити ',
                        disabled: 'true'
                    });
                    let techInfo__infoText = this.createElement('div', {
                        id: 'techInfo__infoText',
                        innerText: 'Звертайтеся за допомогою цієї форми з будь-якими питаннями у будь який час ' +
                        'або телефонуйте за номером телефону 044-366-80-47'
                    });
                    let techInfoWrapper = this.createElement(
                        'div',
                        {
                            id: 'techInfoWrapper'
                        }, techInfoWrapper__triangle,
                        techInfo__messageTitle,
                        techInfo__messageText,
                        techInfo__sendBtn,
                        techInfo__infoText
                    );
                    techInfo__messageText.addEventListener('input', function() {
                        if(techInfo__messageText.textLength) {
                            techInfo__sendBtn.disabled = false;
                            techInfo__sendBtn.classList.remove('disabledBtn');
                        } else {
                            techInfo__sendBtn.disabled = true;
                            techInfo__sendBtn.classList.add('disabledBtn');
                        }
                    });
                    techInfo__sendBtn.addEventListener('click', () => {
                        if(techInfo__messageText.textLength) {
                            techBox.removeChild(techBox.lastElementChild);
                        }
                    });
                    techBox.appendChild(techInfoWrapper);
                }else if(techBox.children.length === 2) {
                    techBox.removeChild(techBox.lastElementChild);
                }
            });
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
        createFilterAddBox: function() {
            let filtersCaptionBox = this.createElement('div', { id: 'filtersCaptionBox' });
            const modalWindowContainer = this.createElement('div', { id: 'modalWindowContainer' });
            const filterEditDistrict__title = this.createElement('div', {
                className: 'filterEditDistrict__title',
                innerText: 'Район'
            });
            const filterEditDistrict__icon = this.createElement('div', {
                className: 'material-icons filterEditDistrict__icon',
                innerText: 'add_circle_outline'
            });
            const filterDistrictAddWrap = this.createElement('div', {
                className: 'filterDistrictAddWrap filterWrap'
            }, filterEditDistrict__icon, filterEditDistrict__title);
            const filterEditDepart__title = this.createElement('div', {
                className: 'filterEditDistrict__title',
                innerText: 'Департамент'
            });
            const filterEditDepart__icon = this.createElement('div', {
                className: 'material-icons filterEditDistrict__icon',
                innerText: 'add_circle_outline'
            });
            const filterEditDepartAddWrap = this.createElement('div', {
                className: 'filterEditDepartAddWrap filterWrap'
            }, filterEditDepart__icon, filterEditDepart__title);
            filterDistrictAddWrap.addEventListener('click', function() {
                if(!modalWindowContainer.classList.contains('modalWindowShowClass')) {
                    let location = 'district';
                    this.createModalForm(modalWindowContainer, location, this.districtData);
                }
            }.bind(this, modalWindowContainer));
            filterEditDepartAddWrap.addEventListener('click', function() {
                if(!modalWindowContainer.classList.contains('modalWindowShowClass')) {
                    let location = 'departament';
                    this.createModalForm(modalWindowContainer, location, this.departData);
                }
            }.bind(this, modalWindowContainer));
            filtersCaptionBox.appendChild(filterDistrictAddWrap);
            filtersCaptionBox.appendChild(filterEditDepartAddWrap);
            let filtersWrapper = document.getElementById('filtersWrapper');
            filtersWrapper.appendChild(filtersCaptionBox);
            filtersWrapper.appendChild(modalWindowContainer);
        },
        createSearchInput: function(filtersWrapper) {
            const searchContainer__input = this.createElement('input', {
                id: 'searchContainer__input',
                type: 'search',
                placeholder: 'Пошук доручення за номером',
                className: 'searchContainer__input'
            });
            const searchContainer = this.createElement('div', {
                id: 'searchContainer',
                className: 'searchContainer'
            }, searchContainer__input);
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
        setDistrictData: function(status, location, data) {
            let dataDistrict = [];
            let indexId = data.columns.findIndex(el => el.code.toLowerCase() === 'id');
            let indexFilterName = data.columns.findIndex(el => el.code.toLowerCase() === 'filter_name');
            let indexDistrictId = data.columns.findIndex(el => el.code.toLowerCase() === 'district_id');
            let indexQuestionDirectionId = data
                .columns.findIndex(el => el.code.toLowerCase() === 'questiondirection_id');
            let indexDistrictName = data.columns.findIndex(el => el.code.toLowerCase() === 'district_name');
            let indexQuestionDirectionName = data
                .columns.findIndex(el => el.code.toLowerCase() === 'questiondirection_name');
            data.rows.forEach(row => {
                let obj = {
                    id: row.values[indexId],
                    filterName: row.values[indexFilterName],
                    districtId: row.values[indexDistrictId],
                    questDirectId: row.values[indexQuestionDirectionId],
                    districtName: row.values[indexDistrictName],
                    questDirectName: row.values[indexQuestionDirectionName]
                }
                dataDistrict.push(obj);
            });
            this.districtData = dataDistrict;
            if (status === 'new') {
                this.createFilterDistrictElements(this.districtData);
            } else if(status === 'reload') {
                this.createFilterDistrictElements(this.districtData);
                let modalWindowContainer = document.getElementById('modalWindowContainer');
                this.createModalForm(modalWindowContainer, location, this.districtData);
            } else if(status === 'delete') {
                this.reloadMainTable();
            }
        },
        createFilterDistrictElements: function(data) {
            let container = document.getElementById('filtersContainerDistrict');
            while (container.hasChildNodes()) {
                container.removeChild(container.lastElementChild);
            }
            for (let i = 0; i < data.length; i++) {
                let row = data[i];
                let filter_closer = this.createElement('div', {
                    className: 'filter_closer filter_closer_district filter_closer_hide'});
                let filter__icon = this.createElement('div', {
                    className: ' filterIcon material-icons', innerText: 'filter_list'});
                let filter__title = this.createElement('div', {
                    className: 'filterTitle', innerText: String(String(row.filterName))});
                let filterWrapper = this.createElement('div', {
                    id: String(String(row.id)),
                    district_id: String(String(row.districtId)),
                    question_id: String(String(row.questDirectId)),
                    className: 'filter_district filter'
                }, filter__icon, filter__title, filter_closer);
                let filtersContainerDistrict = document.getElementById('filtersContainerDistrict');
                filtersContainerDistrict.appendChild(filterWrapper);
            }
            this.changeFilterItemDistrict();
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
                    this.sendMesOnBtnClick('clickOnСoordinator_table', 'none', 'none');
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
        setDepartmentData: function(status, location, data) {
            let dataDepartament = [];
            let indexId = data.columns.findIndex(el => el.code.toLowerCase() === 'id');
            let indexOrganizationId = data.columns.findIndex(el => el.code.toLowerCase() === 'organization_id');
            let indexDepartamentName = data.columns.findIndex(el => el.code.toLowerCase() === 'name');
            data.rows.forEach(row => {
                let obj = {
                    id: row.values[indexId],
                    organizationId: row.values[indexOrganizationId],
                    departamentName: row.values[indexDepartamentName]
                }
                dataDepartament.push(obj);
            });
            this.departData = dataDepartament;
            if(status === 'new') {
                this.createFilterDepartElements(this.departData);
            }else if(status === 'reload') {
                this.createFilterDepartElements(this.departData);
                let modalWindowContainer = document.getElementById('modalWindowContainer');
                this.createModalForm(modalWindowContainer, location, this.departData);
            }else if(status === 'delete') {
                this.reloadMainTable();
            }
        },
        createFilterDepartElements: function(data) {
            let container = document.getElementById('filtersContainerDepart');
            while (container.hasChildNodes()) {
                container.removeChild(container.lastElementChild);
            }
            for (let i = 0; i < data.length; i++) {
                let row = data[i];
                let filter_closer = this.createElement('div', {
                    className: 'filter_closer filter_closer_depart filter_closer_hide'
                });
                let filter__icon = this.createElement('div', {
                    className: ' filterIcon material-icons',
                    innerText: 'filter_list'
                });
                let filter__title = this.createElement('div', {
                    className: 'filterTitle',
                    innerText: String(String(row.departamentName))
                });
                let filterWrapper = this.createElement('div', {
                    id: String(String(row.id)),
                    question_id: String(String(row.organizationId)),
                    className: 'filter_depart filter'
                }, filter__icon, filter__title, filter_closer);
                let filtersContainerDepart = document.getElementById('filtersContainerDepart');
                filtersContainerDepart.appendChild(filterWrapper);
            }
            this.changeFilterItemDepart();
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
                    this.sendMesOnBtnClick('clickOnСoordinator_table', 'none', 'none');
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
        setDistrictCategories: function(data) {
            let dataDistrictNameCategories = [];
            let indexId = data.columns.findIndex(el => el.code.toLowerCase() === 'id');
            let indexDistrictName = data.columns.findIndex(el => el.code.toLowerCase() === 'name');
            data.rows.forEach(row => {
                let obj = {
                    id: row.values[indexId],
                    filterName: row.values[indexDistrictName]
                }
                dataDistrictNameCategories.push(obj);
            });
            this.districtNameCategories = dataDistrictNameCategories;
        },
        setQuestionTypesCategories: function(data) {
            let dataQuestionTypeCategories = [];
            let indexId = data.columns.findIndex(el => el.code.toLowerCase() === 'id');
            let indexQuestionTypeName = data.columns.findIndex(el => el.code.toLowerCase() === 'name');
            data.rows.forEach(row => {
                let obj = {
                    id: row.values[indexId],
                    questionTypeName: row.values[indexQuestionTypeName]
                }
                dataQuestionTypeCategories.push(obj);
            });
            this.questionTypeCategories = dataQuestionTypeCategories;
        },
        setDepartmentCategories: function(data) {
            let dataDepartamentCategories = [];
            let indexId = data.columns.findIndex(el => el.code.toLowerCase() === 'id');
            let indexQuestionTypeName = data.columns.findIndex(el => el.code.toLowerCase() === 'name');
            data.rows.forEach(row => {
                let obj = {
                    id: row.values[indexId],
                    departamentName: row.values[indexQuestionTypeName]
                }
                dataDepartamentCategories.push(obj);
            });
            this.departamentCategories = dataDepartamentCategories;
        },
        reloadFilterAfterDelete:  function(element, location) {
            let status = 'delete';
            element.parentElement.removeChild(document.getElementById(element.id));
            if(location === 'district') {
                let executeQueryFilters = {
                    queryCode: 'cc_FilterName',
                    limit: -1,
                    parameterValues: []
                };
                this.queryExecutor(executeQueryFilters, this.setDistrictData.bind(this, status, location), this);
                this.showPreloader = false;
            }else if(location === 'departament') {
                let executeQueryFilters = {
                    queryCode: 'cc_FilterNameDepartment',
                    limit: -1,
                    parameterValues: []
                };
                this.queryExecutor(executeQueryFilters, this.setDepartmentData.bind(this, status, location), this);
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
        reloadMainTable: function(message) {
            this.messageService.publish({ name: 'showPagePreloader'});
            let tableContainer = document.getElementById('tableContainer');
            while (tableContainer.hasChildNodes()) {
                tableContainer.removeChild(tableContainer.childNodes[0]);
            }
            let reloadTable = false;
            if(message) {
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
        createModalForm: function(modalWindowContainer, location, data) {
            if(modalWindowContainer.parentElement === null) {
                let filtersWrapper = document.getElementById('filtersWrapper');
                filtersWrapper.appendChild(modalWindowContainer);
            }
            while (modalWindowContainer.hasChildNodes()) {
                modalWindowContainer.removeChild(modalWindowContainer.childNodes[0]);
            }
            modalWindowContainer.classList.add('modalWindowShowClass');
            let modalFiltersHeader = {};
            if (location === 'district') {
                const modalFiltersHeader__categorie = this.createElement('div', {
                    className: 'filHeadCategorie headerSelectFilter',
                    id: 'modalFiltersHeader__categorie',
                    innerText: 'НАПРЯМОК РОБIТ'
                });
                const modalFiltersHeader__district = this.createElement('div', {
                    className: 'filHeadDistrict headerSelectFilter',
                    id: 'modalFiltersHeader__district',
                    innerText: 'РАЙОН'
                });
                modalFiltersHeader = this.createElement('div', {
                    id: 'modalFiltersHeader'
                }, modalFiltersHeader__district, modalFiltersHeader__categorie);
            } else if(location === 'departament') {
                const modalFiltersHeader__depart = this.createElement('div', {
                    className: 'filHeadDepart headerSelectFilter',
                    id: 'modalFiltersHeader__departament',
                    innerText: 'ДЕПАРТАМЕНТ'
                });
                modalFiltersHeader = this.createElement('div', { id: 'modalFiltersHeader'}, modalFiltersHeader__depart);
            }
            const modalFiltersContainer = this.createElement('div', { id: 'modalFiltersContainer'});
            const modalFilters = this.createElement('div', {
                id: 'modalFilters'
            }, modalFiltersHeader, modalFiltersContainer);
            const modalHeader__button_close = this.createElement('button', {
                id: 'modalHeader__button_close',
                className: 'modalBtn',
                innerText: 'Закрити'
            });
            const modalHeader__buttonWrapper = this.createElement('div', {
                id: 'modalHeader__buttonWrapper'
            }, modalHeader__button_close);
            const modalHeader__caption = this.createElement('div', {
                id: 'modalHeader__caption',
                innerText: 'Налаштування фiльтрiв'
            });
            const modalHeader = this.createElement('div', {
                id: 'modalHeader'
            }, modalHeader__caption, modalHeader__buttonWrapper);
            const modalWindow = this.createElement('div', { id: 'modalWindow'}, modalHeader, modalFilters);
            modalWindow.style.display = 'block';
            modalWindowContainer.appendChild(modalWindow);
            this.createModalFiltersContainerItems(data, modalFiltersContainer, location);
            modalHeader__button_close.addEventListener('click', function() {
                modalWindowContainer.classList.remove('modalWindowShowClass');
                modalWindowContainer.remove(modalWindowContainer.childNodes[0]);
                this.reloadMainTable();
            }.bind(this));
        },
        createModalFiltersContainerItems: function(data, modalFiltersContainer, location) {
            if(location === 'district') {
                data.forEach(el => {
                    let districtId = el.districtId;
                    let categorieId = el.questDirectId;
                    let categorieItemSelect = this.createElement('select', {
                        className: 'categorieItemSelect selectItem js-example-basic-single'
                    });
                    let categorieItem = this.createElement('div', { className: 'districtItem'}, categorieItemSelect);
                    let districtItemSelect = this.createElement('select', {
                        className: 'districtItemSelect selectItem  js-example-basic-single'
                    });
                    let districtItem = this.createElement('div', { className: 'districtItem'}, districtItemSelect);
                    const modalFiltersContainerItem__categorie = this.createElement('div', {
                        className: 'modalFiltersContainer__categorie'
                    }, categorieItem);
                    const modalFiltersContainerItem__district = this.createElement('div', {
                        className: 'modalFiltersContainer__district'
                    }, districtItem);
                    const modalFiltersContainerItem = this.createElement('div', {
                        className: 'modalFiltersContainerItem'
                    }, modalFiltersContainerItem__district, modalFiltersContainerItem__categorie);
                    this.isLoadDistrict = false;
                    this.isLoadCategory = false;
                    this.messageService.publish({ name: 'showPagePreloader'});
                    modalFiltersContainer.appendChild(modalFiltersContainerItem);
                    this.createFilterDistrict(districtId, districtItemSelect, this.districtNameCategories);
                    this.createFilterCategories(categorieId, categorieItemSelect, this.questionTypeCategories);
                });
                let categorieNewItemSelect = this.createElement('select', {
                    id: 'categorieNewItemSelect',
                    className: 'categorieItemSelect selectItem js-example-basic-single js-example-placeholder-categorie'
                });
                let categorieNewItem = this.createElement('div', { className: 'districtItem'}, categorieNewItemSelect);
                let districtNewItemSelect = this.createElement('select', {
                    id: 'districtNewItemSelect',
                    className: 'districtItemSelect selectItem  js-example-basic-single js-example-placeholder-district'
                });
                let districtNewItem = this.createElement('div', { className: 'districtItem'}, districtNewItemSelect);
                const modalFiltersContainerItemNew__categorie = this.createElement('div', {
                    className: 'modalFiltersContainer__categorie'
                }, categorieNewItem);
                const modalFiltersContainerItemNew__district = this.createElement('div', {
                    className: 'modalFiltersContainer__district'
                }, districtNewItem);
                const modalFiltersContainerItemNew = this.createElement('div', {
                    className: 'modalFiltersContainerItem'
                }, modalFiltersContainerItemNew__district, modalFiltersContainerItemNew__categorie);
                modalFiltersContainer.appendChild(modalFiltersContainerItemNew);
                this.createNewFilterDistrict(districtNewItemSelect, location, this.districtNameCategories);
                this.createNewFilterCategories(categorieNewItemSelect, location, this.questionTypeCategories);
            }else if(location === 'departament') {
                data.forEach(function(el) {
                    let departamentId = el.organizationId;
                    let departamentItemSelect = this.createElement('select', {
                        className: 'departamentItemSelect selectItem js-example-basic-single'
                    });
                    let departamentItem = this.createElement('div', {
                        className: 'departamentItem'
                    }, departamentItemSelect);
                    const modalFiltersContainerItem__departament = this.createElement('div', {
                        className: 'modalFiltersContainer__depart'
                    }, departamentItem);
                    const modalFiltersContainerItem = this.createElement('div', {
                        className: 'modalFiltersContainerItem'
                    }, modalFiltersContainerItem__departament);
                    this.messageService.publish({ name: 'showPagePreloader'});
                    modalFiltersContainer.appendChild(modalFiltersContainerItem);
                    this.createFilterDepartment(departamentId, departamentItemSelect, this.departamentCategories);
                    this.showPreloader = false;
                }.bind(this));
                let departamentNewItemSelect = this.createElement('select', {
                    id: 'departamentNewItemSelect',
                    className:
                        'departamentItemSelect ' +
                        'selectItem ' +
                        'js-example-basic-single ' +
                        'js-example-placeholder-departament'
                });
                let departamentNewItem = this.createElement('div', {
                    className: 'departamentItem'
                }, departamentNewItemSelect);
                const modalFiltersContainerItemNew__departament = this.createElement('div', {
                    className: 'modalFiltersContainer__depart'
                }, departamentNewItem);
                const modalFiltersContainerItemNew = this.createElement('div', {
                    className: 'modalFiltersContainerItem'
                }, modalFiltersContainerItemNew__departament);
                modalFiltersContainer.appendChild(modalFiltersContainerItemNew);
                this.createNewFilterDepartament(departamentNewItemSelect, location, this.departamentCategories)
            }
        },
        createFilterDistrict: function(districtId, districtItemSelect, data) {
            data.forEach(el => {
                let districtItemSelect__option = this.createElement('option', {
                    innerText: el.filterName,
                    value: el.id,
                    className: 'districtItemSelect__option'
                });
                if(districtId === el.id) {
                    districtItemSelect__option.selected = true;
                }
                districtItemSelect.appendChild(districtItemSelect__option);
            });
        },
        createFilterCategories: function(categorieId, categorieItemSelect, data) {
            data.forEach(el => {
                let categorieItemSelect__option = this.createElement('option', {
                    innerText: el.questionTypeName,
                    value: el.id,
                    className: 'districtItemSelect__option'
                });
                if(categorieId === el.id) {
                    categorieItemSelect__option.selected = true;
                }
                categorieItemSelect.appendChild(categorieItemSelect__option);
            });
        },
        createFilterDepartment: function(departamentId, departamentItemSelect, data) {
            data.forEach(el => {
                let departamentItemSelect__option = this.createElement('option', {
                    innerText: el.departamentName,
                    value: el.id, className:
                    'districtItemSelect__option'
                });
                if(departamentId === el.id) {
                    departamentItemSelect__option.selected = true;
                }
                departamentItemSelect.appendChild(departamentItemSelect__option);
            });
        },
        createNewFilterDepartament: function(departamentNewItemSelect, location, data) {
            let districtItemSelect__optionEmpty = this.createElement('option', {
                className: 'districtItemSelect__option'
            });
            departamentNewItemSelect.appendChild(districtItemSelect__optionEmpty)
            data.forEach(function(el) {
                let districtItemSelect__option = this.createElement('option', {
                    innerText: el.departamentName,
                    value: el.id,
                    className: 'districtItemSelect__option'
                });
                departamentNewItemSelect.appendChild(districtItemSelect__option);
            }.bind(this));
            this.createOptions();
            this.isLoadDistrict = true;
            this.closePreload(location);
            this.districtId = 0;
            $('#departamentNewItemSelect').on('select2:select', function(e) {
                let districtId = Number(e.params.data.id);
                this.isDistrictFull = true;
                let positionFilter = 'district';
                this.addNewItem(location, positionFilter, districtId);
            }.bind(this));
        },
        createNewFilterDistrict: function(districtNewItemSelect, location, data) {
            let districtItemSelect__optionEmpty = this.createElement('option', {
                className: 'districtItemSelect__option'
            });
            districtNewItemSelect.appendChild(districtItemSelect__optionEmpty)
            data.forEach(function(el) {
                let districtItemSelect__option = this.createElement('option', {
                    innerText: el.filterName,
                    value: el.id,
                    className: 'districtItemSelect__option'
                });
                districtNewItemSelect.appendChild(districtItemSelect__option);
            }.bind(this));
            this.createOptions();
            this.isLoadDistrict = true;
            this.closePreload(location);
            this.districtId = 0;
            $('#districtNewItemSelect').on('select2:select', function(e) {
                let districtId = Number(e.params.data.id);
                this.isDistrictFull = true;
                let positionFilter = 'district';
                this.addNewItem(location, positionFilter, districtId);
            }.bind(this));
        },
        createNewFilterCategories: function(categorieNewItemSelect, location, data) {
            let categorieItemSelect__optionEmpty = this.createElement('option', {
                className: 'districtItemSelect__option'
            });
            categorieNewItemSelect.appendChild(categorieItemSelect__optionEmpty)
            data.forEach(function(el) {
                let categorieItemSelect__option = this.createElement('option', {
                    innerText: el.questionTypeName,
                    value: el.id,
                    className: 'districtItemSelect__option'
                });
                categorieNewItemSelect.appendChild(categorieItemSelect__option);
            }.bind(this));
            this.createOptions();
            this.isLoadCategorie = true;
            this.closePreload(location);
            this.categorieId = 0;
            $('#categorieNewItemSelect').on('select2:select', function(e) {
                let categorieId = Number(e.params.data.id);
                this.isCategorieFull = true;
                let positionFilter = 'categorie';
                this.addNewItem(location, positionFilter, categorieId);
            }.bind(this));
        },
        addNewItem: function(location, positionFilter, id) {
            if(location === 'district') {
                if(positionFilter === 'district') {
                    this.districtId = id;
                }else if(positionFilter === 'categorie') {
                    this.categorieId = id;
                }
                if(this.isCategorieFull && this.isDistrictFull) {
                    this.isCategorieFull = false;
                    this.isDistrictFull = false;
                    let executeQueryInsertItem = {
                        queryCode: 'cc_FilterInsert',
                        limit: -1,
                        parameterValues: [
                            { key: '@district_id', value:  this.districtId },
                            { key: '@questiondirection_id', value: this.categorieId }
                        ]
                    };
                    this.queryExecutor(executeQueryInsertItem, this.reloadFilters.bind(this, location), this);
                    this.showPreloader = false;
                }
            }else if(location === 'departament') {
                this.departamentId = id;
                this.isCategorieFull = false;
                this.isDistrictFull = false;
                let executeQueryInsertItem = {
                    queryCode: 'cc_FilterInsert',
                    limit: -1,
                    parameterValues: [
                        { key: '@department_id', value:  this.departamentId }
                    ]
                };
                this.queryExecutor(executeQueryInsertItem, this.reloadFilters.bind(this, location), this);
                this.showPreloader = false;
            }
        },
        reloadFilters: function(location) {
            let status = 'reload';
            if(location === 'district') {
                let executeQueryFilters = {
                    queryCode: 'cc_FilterName',
                    limit: -1,
                    parameterValues: []
                };
                this.queryExecutor(executeQueryFilters, this.setDistrictData.bind(this, status, location), this);
                this.showPreloader = false;
            } else if (location === 'departament') {
                let executeQueryFilters = {
                    queryCode: 'cc_FilterNameDepartment',
                    limit: -1,
                    parameterValues: []
                };
                this.queryExecutor(executeQueryFilters, this.setDepartmentData.bind(this, status, location), this);
                this.showPreloader = false;
            }
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
                let columnHeader = this.createElement('div', {
                    id: String('columnHeader_' + i),
                    code: String(String(item.code)),
                    className: 'columnHeader',
                    innerText: String(String(item.name))
                });
                if (i === 2) {
                    columnHeader.style.backgroundColor = 'rgb(248, 195, 47)';
                } else if (i === 3) {
                    columnHeader.style.backgroundColor = 'rgb(74, 193, 197)';
                } else if (i === 4) {
                    columnHeader.style.backgroundColor = 'rgb(132, 199, 96)';
                } else if (i === 5) {
                    columnHeader.style.backgroundColor = 'rgb(240, 114, 93)';
                } else if (i === 6) {
                    columnHeader.style.backgroundColor = 'rgba(238, 163, 54, 1)';
                }
                let column = this.createElement('div', {
                    id: String('column_' + i),
                    code: String(String(item.code)),
                    className: 'column'
                }, columnHeader);
                let tableContainer = document.getElementById('tableContainer');
                tableContainer.appendChild(column);
            }
            for(let i = 0; i < data.rows.length - 1; i++) {
                let elRow = data.rows[i];
                let navigationIndex = data.columns.findIndex(el => el.code.toLowerCase() === 'navigation');
                for(let j = 2; j < elRow.values.length; j++) {
                    let el = elRow.values[j];
                    if(el !== 0) {
                        let columnCategorie__value = this.createElement('div', {
                            className: 'columnCategorie__value',
                            innerText: '(' + el + ')'
                        });
                        let columnCategorie__title = this.createElement('div', {
                            className: 'columnCategorie__title',
                            code: String(String(elRow.values[navigationIndex])),
                            innerText: String(String(elRow.values[navigationIndex]))
                        });
                        let columnCategorie = this.createElement('div', {
                            className: 'columnCategorie',
                            code: String(String(elRow.values[navigationIndex]))
                        }, columnCategorie__title, columnCategorie__value);
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
            }
            return column
        },
        showTable: function(target, columnName, navigator) {
            let headers = document.querySelectorAll('.columnHeader');
            headers = Array.from(headers);
            if (target.classList.contains('check') ||
                target.classList.contains('hover') ||
                target.id === 'searchContainer__input') {
                document.getElementById('columnHeader_2').style.backgroundColor = 'rgb(248, 195, 47)';
                document.getElementById('columnHeader_3').style.backgroundColor = 'rgb(74, 193, 197)';
                document.getElementById('columnHeader_4').style.backgroundColor = 'rgb(132, 199, 96)';
                document.getElementById('columnHeader_5').style.backgroundColor = 'rgb(240, 114, 93)';
                document.getElementById('columnHeader_6').style.backgroundColor = 'rgba(238, 163, 54, 1)';
                document.getElementById('columnHeader_3').firstElementChild.classList.add('triangle3');
                document.getElementById('columnHeader_4').firstElementChild.classList.add('triangle4');
                document.getElementById('columnHeader_5').firstElementChild.classList.add('triangle5');
                document.getElementById('columnHeader_6').firstElementChild.classList.add('triangle6');
                for(let i = 0; i < headers.length; i++) {
                    let header = headers[i];
                    header.firstElementChild.classList.remove('triangle');
                    header.firstElementChild.classList.add(String('triangle' + (i + 2)));
                    header.classList.remove('hover');
                    header.classList.remove('check');
                }
                this.hideAllItems(1);
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
