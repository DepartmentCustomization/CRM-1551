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
        displayNone: 'none',
        displayBlock: 'block',
        init: async function() {
            this.FiltersPackageHelper = await import('/modules/Helpers/Filters/FiltersPackageHelper.js');
            this.executeQueryShowUserFilterGroups();
            this.setGlobalFilterPanelVisibility(true);
            this.subscribers.push(this.messageService.subscribe('filters', this.showApplyFiltersValue, this));
            this.subscribers.push(this.messageService.subscribe('showModalWindow', this.showModalWindow, this));
            this.filterColumns = [];
            this.defaultCheckedItem = [];
        },
        executeQueryShowUserFilterGroups: function() {
            let executeQuery = {
                queryCode: 'SearchTableFilters_SRows',
                limit: -1,
                parameterValues: [
                    { key: '@pageOffsetRows', value: 0 },
                    { key: '@pageLimitRows', value: 10 }
                ]
            };
            this.queryExecutor(executeQuery, this.setUserFilterGroups, this);
            this.showPreloader = false;
        },
        setUserFilterGroups: function(groups) {
            this.userFilterGroups = [];
            groups.rows.forEach(group => {
                const indexOfId = 0;
                const indexOfName = 1;
                const indexOfFilters = 2;
                this.userFilterGroups.push({
                    id: group.values[indexOfId],
                    name: group.values[indexOfName],
                    filters: JSON.parse(group.values[indexOfFilters])
                });
            });
            this.hidePagePreloader();
        },
        clearUserFilterGroups: function() {
            this.userFilterGroups = [];
        },
        afterViewInit: function() {
            this.container = document.getElementById('container');
            this.createModalWindow();
            this.createSelectedFiltersContainer();
        },
        createModalWindow() {
            this.modalWindow = this.createElement('div', { id:'modalWindow', className: 'modalWindow'});
            this.modalWindowWrapper = this.createElement('div', {
                id:'modalWindowWrapper',
                className: 'modalWindowWrapper'
            }, this.modalWindow);
            this.modalWindowWrapper.style.display = this.displayNone;
        },
        createSelectedFiltersContainer() {
            this.selectedFiltersContainer = this.createElement('div',
                {
                    id:'selectedFiltersContainer',
                    className: 'selectedFiltersContainer'
                }
            );
            this.container.appendChild(this.selectedFiltersContainer);
        },
        showModalWindow: function(message) {
            if (this.modalWindowWrapper.style.display === this.displayNone) {
                this.modalWindowWrapper.style.display = this.displayBlock;
                const button = message.button;
                switch (button) {
                    case 'gear': {
                        const createSAveBtn = true;
                        this.createButtons(createSAveBtn, this.gearSaveMethod.bind(this));
                        this.appendModalWindow();
                        this.createFilterElements();
                        break;
                    }
                    case 'saveFilters': {
                        const createSAveBtn = true;
                        this.createButtons(createSAveBtn, this.saveNewFiltersGroup.bind(this));
                        this.appendModalWindow();
                        this.createFiltersGroupNameInput();
                        break;
                    }
                    case 'showFilters': {
                        const createSAveBtn = false;
                        this.createButtons(createSAveBtn);
                        this.appendModalWindow();
                        this.showUserFilterGroups();
                        break;
                    }
                    default:
                        break;
                }
            }
        },
        createButtons(createSAveBtn, saveMethod) {
            const modalBtnWrapper = this.createElement('div',
                {
                    id:'modalBtnWrapper',
                    className: 'modalBtnWrapper'
                }
            );
            if (createSAveBtn) {
                const modalBtnSave = this.createElement('button', {
                    id:'modalBtnSave',
                    className: 'btn',
                    innerText: 'Зберегти'
                });
                modalBtnSave.addEventListener('click', () => {
                    saveMethod();
                });
                modalBtnWrapper.appendChild(modalBtnSave);
            }
            const modalBtnExit = this.createElement('button', {
                id:'modalBtnExit',
                className: 'btn',
                innerText: 'Вийти'
            });
            modalBtnExit.addEventListener('click', () =>{
                this.hideModalWindow();
            });
            modalBtnWrapper.appendChild(modalBtnExit);
            this.modalWindow.appendChild(modalBtnWrapper);
        },
        appendModalWindow() {
            this.container.appendChild(this.modalWindowWrapper);
        },
        createFiltersGroupNameInput: function() {
            const newFilterNameInput = this.createElement('input', { id: 'newFilterNameInput', placeholder: 'Внесіть назву'});
            this.modalWindow.appendChild(newFilterNameInput);
        },
        saveNewFiltersGroup: function() {
            const name = document.getElementById('newFilterNameInput').value;
            if (name !== '') {
                this.showMyPagePreloader();
                const filterJson = JSON.stringify(this.getFiltersGroupPackage());
                this.hideModalWindow();
                this.executeSaveFilterGroup(name, filterJson);
            }
        },
        executeSaveFilterGroup: function(name, filterJson) {
            let executeQuery = {
                queryCode: 'SearchTableFilters_IRow',
                limit: -1,
                parameterValues: [
                    { key: '@filter_name', value: name },
                    { key: '@filters', value: filterJson }
                ]
            };
            this.queryExecutor(executeQuery, this.afterAddFilterGroup, this);
            this.showPreloader = false;
        },
        afterAddFilterGroup: function() {
            this.executeQueryShowUserFilterGroups();
        },
        getFiltersGroupPackage: function() {
            const filterPackage = [];
            this.selectedFilters.forEach(filter => {
                filterPackage.push({
                    value: filter.value,
                    type: filter.type,
                    placeholder: filter.placeholder,
                    viewValue: this.getSelectFilterViewValuesObject(filter).value,
                    displayValue: this.setFilterViewValues(filter),
                    name: filter.name,
                    timePosition: filter.timePosition
                });
            });
            return filterPackage;
        },
        showUserFilterGroups: function() {
            const userFiltersGroupContainer = this.createUserFilterGroupsContainer();
            this.modalWindow.appendChild(userFiltersGroupContainer);
        },
        createUserFilterGroupsContainer: function() {
            const userFilterGroupsWrapper = this.createElement('div',
                {
                    className: 'userFilterGroupsWrapper'
                }
            );
            this.userFilterGroups.forEach(userFilterGroup => {
                const groupFiltersList = this.createGroupFiltersList(userFilterGroup.filters, userFilterGroup.id);
                const groupName = this.createElement('input',
                    {value: userFilterGroup.name, className: 'userFilterGroupName', disabled: true, groupId: userFilterGroup.id}
                );
                groupName.addEventListener('keypress', event => {
                    const key = event.which || event.keyCode;
                    const target = event.currentTarget;
                    const groupId = target.groupId;
                    const name = target.value;
                    if (key === 13) {
                        target.disabled = !target.disabled;
                        groupEditBtn.edit = !groupEditBtn.edit;
                        this.showMyPagePreloader();
                        this.executeQueryChangeName(groupId, name);
                    }
                });
                const displayBtn = this.createElement('div',
                    {className: 'displayBtn groupBtn fa fa-arrow-down', groupId: userFilterGroup.id, status: 'none'}
                );
                displayBtn.addEventListener('click', event => {
                    const target = event.currentTarget;
                    target.status = target.status === 'none' ? 'block' : 'none';
                    target.classList.remove(target.classList[3]);
                    target.classList.add(this.changeDisplayBtnIcon(target.status));
                    document.getElementById(`userFiltersListWrapper${target.groupId}`).style.display = target.status;
                });
                const groupSetFiltersBtn = this.createElement('div',
                    {
                        className: 'groupEditBtn groupBtn fa fa-arrow-right', groupId: userFilterGroup.id
                    }
                );
                groupSetFiltersBtn.addEventListener('click', event => {
                    const target = event.currentTarget;
                    const groupId = target.groupId;
                    this.showMyPagePreloader();
                    this.restoreFilters(groupId);
                });
                const groupEditBtn = this.createElement('div', {className: 'groupEditBtn groupBtn fa fa-edit', edit: false});
                groupEditBtn.addEventListener('click', event => {
                    const target = event.currentTarget;
                    target.edit = !target.edit;
                    groupName.disabled = !groupName.disabled;
                });
                const groupDeleteBtn = this.createElement('div',
                    {className: 'groupDeleteBtn groupBtn fa fa-trash', groupId: userFilterGroup.id}
                );
                groupDeleteBtn.addEventListener('click', event => {
                    const target = event.currentTarget;
                    // eslint-disable-next-line no-alert
                    const result = confirm(`Бажаєте видалити фільтр ${groupName.value}?`);
                    if (result) {
                        const groupId = target.groupId;
                        userFilterGroupsWrapper.removeChild(document.getElementById(`groupId${groupId}`));
                        this.showMyPagePreloader();
                        this.executeQueryDeleteFilterGroup(groupId);
                    }
                });
                const groupHeader = this.createElement('div',
                    {className: 'groupHeader'},
                    displayBtn, groupName, groupSetFiltersBtn, groupEditBtn, groupDeleteBtn
                );
                const group = this.createElement('div',
                    {id: `groupId${userFilterGroup.id}`, className: 'userFilterGroup'},
                    groupHeader, groupFiltersList
                );
                userFilterGroupsWrapper.appendChild(group);
            });
            return userFilterGroupsWrapper;
        },
        changeDisplayBtnIcon: function(status) {
            return status === 'none' ? 'fa-arrow-down' : 'fa-arrow-up';
        },
        createGroupFiltersList: function(filtersList, id) {
            const userFiltersListWrapper = this.createElement('div',
                {
                    id: `userFiltersListWrapper${id}`,
                    className: 'userFiltersListWrapper',
                    style: 'display: none'
                }
            );
            filtersList.forEach(listItem => {
                const filter = this.createElement('div',
                    {
                        className: 'userFilter',
                        innerText: listItem.displayValue,
                        value: listItem.value,
                        type: listItem.type,
                        placeholder: listItem.placeholder,
                        name: listItem.name,
                        timePosition: listItem.timePosition
                    }
                );
                userFiltersListWrapper.appendChild(filter);
            });
            return userFiltersListWrapper;
        },
        executeQueryChangeName: function(id, name) {
            let executeQuery = {
                queryCode: 'SearchTableFilters_UName',
                limit: -1,
                parameterValues: [
                    { key: '@Id', value: id },
                    { key: '@filter_name', value: name }
                ]
            };
            this.queryExecutor(executeQuery, this.executeQueryShowUserFilterGroups, this);
            this.showPreloader = false;
        },
        executeQueryDeleteFilterGroup: function(id) {
            let executeQuery = {
                queryCode: 'SearchTableFilters_DRow',
                limit: -1,
                parameterValues: [
                    { key: '@Id', value: id }
                ]
            };
            this.queryExecutor(executeQuery, this.executeQueryShowUserFilterGroups, this);
            this.showPreloader = false;
        },
        restoreFilters: function(id) {
            this.setGlobalFilterPanelVisibility(true);
            const filters = this.userFilterGroups.find(f => f.id === id).filters;
            const FiltersPackageHelper = new this.FiltersPackageHelper.FiltersPackageHelper();
            const filtersPackage = FiltersPackageHelper.getFiltersPackage(filters);
            this.clearAllFilter();
            this.applyFilters(filtersPackage);
            this.hideModalWindow();
            this.hidePagePreloader();
        },
        setGlobalFilterPanelVisibility: function(state) {
            const msg = {
                name: 'SetFilterPanelState',
                package: {
                    value: state
                }
            };
            this.messageService.publish(msg);
        },
        setFilterViewValues: function(filter) {
            const viewValue = this.getSelectFilterViewValuesObject(filter);
            return `${viewValue.title} : ${viewValue.value}`;
        },
        createFilterElements: function() {
            const group1__title = this.createElement('div', {
                className: 'group1__title groupTitle material-icons',
                innerText: 'view_stream Звернення'
            });
            const group2__title = this.createElement('div', {
                className: 'group1__title groupTitle material-icons',
                innerText: 'view_stream Заявник'
            });
            const group3__title = this.createElement('div', {
                className: 'group1__title groupTitle material-icons',
                innerText: 'view_stream Питання'
            });
            const group4__title = this.createElement('div', {
                className: 'group1__title groupTitle material-icons',
                innerText: 'view_stream Доручення'
            });
            const group5__title = this.createElement('div', {
                className: 'group1__title groupTitle material-icons',
                innerText: 'view_stream Дати'
            });
            const group1__element1_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 150,
                value: 'appeals_receipt_source',
                id: 'appeals_receipt_source'
            });
            const group1__element1_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Джерела надходження'
            });
            const group1__element1 = this.createElement('div', {
                className: 'group__element'
            }, group1__element1_checkBox, group1__element1_title);
            const group1__element5_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 150,
                value: 'appeals_enter_number',
                id: 'appeals_enter_number'
            });
            const group1__element5_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Вхідний номер'
            });
            const group1__element5 = this.createElement('div', {
                className: 'group__element'
            }, group1__element5_checkBox, group1__element5_title);
            const group1__element2_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 250,
                value: 'appeals_user',
                id: 'appeals_user'
            });
            const group1__element2_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Прийняв'
            });
            const group1__element2 = this.createElement('div', {
                className: 'group__element'
            }, group1__element2_checkBox, group1__element2_title);
            const group1__element3_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 120,
                value: 'appeals_district',
                id: 'appeals_district'
            });
            const group1__element3_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Район'
            });
            const group1__element3 = this.createElement('div', {
                className: 'group__element'
            }, group1__element3_checkBox, group1__element3_title);
            const group1__element4_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 90,
                value: 'appeals_files_check',
                id: 'appeals_files_check'
            });
            const group1__element4_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Ознака'
            });
            const group1__element4 = this.createElement('div', {
                className: 'group__element'
            }, group1__element4_checkBox, group1__element4_title);
            const group1__container = this.createElement('div', {
                className: 'groupContainer'
            }, group1__title, group1__element1, group1__element5, group1__element2, group1__element3, group1__element4);
            const group2__element2_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 120,
                value: 'zayavnyk_phone_number',
                id: 'zayavnyk_phone_number'
            });
            const group2__element2_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Номер телефону'
            });
            const group2__element2 = this.createElement('div', {
                className: 'group__element'
            }, group2__element2_checkBox, group2__element2_title);
            const group2__element4_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 60,
                value: 'zayavnyk_entrance',
                id: 'zayavnyk_entrance'
            });
            const group2__element4_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Під`їзд'
            });
            const group2__element4 = this.createElement('div', {
                className: 'group__element'
            }, group2__element4_checkBox, group2__element4_title);
            const group2__element6_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 120,
                value: 'zayavnyk_applicant_privilage',
                id: 'zayavnyk_applicant_privilage'
            });
            const group2__element6_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Пiльга'
            });
            const group2__element6 = this.createElement('div', {
                className: 'group__element'
            }, group2__element6_checkBox, group2__element6_title);
            const group2__element7_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 150,
                value: 'zayavnyk_social_state',
                id: 'zayavnyk_social_state'
            });
            const group2__element7_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Соц.стан'
            });
            const group2__element7 = this.createElement('div', {
                className: 'group__element'
            }, group2__element7_checkBox, group2__element7_title);
            const group2__element8_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 80,
                value: 'zayavnyk_sex',
                id: 'zayavnyk_sex'
            });
            const group2__element8_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Стать'
            });
            const group2__element8 = this.createElement('div', {
                className: 'group__element'
            }, group2__element8_checkBox, group2__element8_title);
            const group2__element12_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 110,
                value: 'zayavnyk_applicant_type',
                id: 'zayavnyk_applicant_type'
            });
            const group2__element12_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Тип заявника'
            });
            const group2__element12 = this.createElement('div', {
                className: 'group__element'
            }, group2__element12_checkBox, group2__element12_title);
            const group2__element9_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 60,
                value: 'zayavnyk_age',
                id: 'zayavnyk_age'
            });
            const group2__element9_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Вiк'
            });
            const group2__element9 = this.createElement('div', {
                className: 'group__element'
            }, group2__element9_checkBox, group2__element9_title);
            const group2__element10_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 250,
                value: 'zayavnyk_email',
                id: 'zayavnyk_email'
            });
            const group2__element10_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'E-mail'
            });
            const group2__element10 = this.createElement('div', {
                className: 'group__element'
            }, group2__element10_checkBox, group2__element10_title);
            const group2__container = this.createElement('div', {
                className: 'groupContainer'
            },
            group1__title, group2__element2, group2__element4, group2__element6, group2__element7, group2__element8,
            group2__element12, group2__element9, group2__element10);
            const group3__element2_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 150,
                value: 'question_ObjectTypes',
                id: 'question_ObjectTypes'
            });
            const group3__element2_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Тип об\'єкту'
            });
            const group3__element2 = this.createElement('div', {
                className: 'group__element'
            }, group3__element2_checkBox, group3__element2_title);
            const group3__element4_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 300,
                value: 'question_organization',
                id: 'question_organization'
            });
            const group3__element4_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Органiзацiя'
            });
            const group3__element4 = this.createElement('div', {
                className: 'group__element'
            }, group3__element4_checkBox, group3__element4_title);
            const group3__element6_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 120,
                value: 'question_question_state',
                id: 'question_question_state'
            });
            const group3__element6_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Стан питання'
            });
            const group3__element6 = this.createElement('div', {
                className: 'group__element'
            }, group3__element6_checkBox, group3__element6_title);
            const group3__element7_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 150,
                value: 'question_list_state',
                id: 'question_list_state'
            });
            const group3__element7_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Перелiк'
            });
            const group3__element7 = this.createElement('div', {
                className: 'group__element'
            }, group3__element7_checkBox, group3__element7_title);
            const group3__container = this.createElement('div', {
                className: 'groupContainer'
            }, group1__title, group3__element2, group3__element4, group3__element6, group3__element7);
            const group4__element2_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 100,
                value: 'assigm_main_executor',
                id: 'assigm_main_executor'
            });
            const group4__element2_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Головний'
            });
            const group4__element2 = this.createElement('div', {
                className: 'group__element'
            }, group4__element2_checkBox, group4__element2_title);
            const group4__element3_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 700,
                value: 'assigm_question_content',
                id: 'assigm_question_content'
            });
            const group4__element3_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Змiст'
            });
            const group4__element3 = this.createElement('div', {
                className: 'group__element'
            }, group4__element3_checkBox, group4__element3_title);
            const group4__element4_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 250,
                value: 'assigm_accountable',
                id: 'assigm_accountable'
            });
            const group4__element4_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Вiдповiдальний'
            });
            const group4__element4 = this.createElement('div', {
                className: 'group__element'
            }, group4__element4_checkBox, group4__element4_title);
            const group4__element5_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 120,
                value: 'assigm_assignment_state',
                id: 'assigm_assignment_state'
            });
            const group4__element5_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Стан'
            });
            const group4__element5 = this.createElement('div', {
                className: 'group__element'
            }, group4__element5_checkBox, group4__element5_title);
            const group4__element6_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 150,
                value: 'assigm_assignment_result',
                id: 'assigm_assignment_result'
            });
            const group4__element6_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Результат'
            });
            const group4__element6 = this.createElement('div', {
                className: 'group__element'
            }, group4__element6_checkBox, group4__element6_title);
            const group4__element7_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 150,
                value: 'assigm_assignment_resolution',
                id: 'assigm_assignment_resolution'
            });
            const group4__element7_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Резолюцiя'
            });
            const group4__element7 = this.createElement('div', {
                className: 'group__element'
            }, group4__element7_checkBox, group4__element7_title);
            const group4__element8_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 250,
                value: 'assigm_user_reviewed',
                id: 'assigm_user_reviewed'
            });
            const group4__element8_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Розглянув'
            });
            const group4__element8 = this.createElement('div', {
                className: 'group__element'
            }, group4__element8_checkBox, group4__element8_title);
            const group4__element9_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 250,
                value: 'assigm_user_checked',
                id: 'assigm_user_checked'
            });
            const group4__element9_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Перевiрив'
            });
            const group4__element9 = this.createElement('div', {
                className: 'group__element'
            }, group4__element9_checkBox, group4__element9_title);
            const group4__element10_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 250,
                value: 'ConsDocumentContent',
                id: 'ConsDocumentContent'
            });
            const group4__element10_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Повна відповідь'
            });
            const group4__element10 = this.createElement('div', {
                className: 'group__element'
            }, group4__element10_checkBox, group4__element10_title);
            const group4__element11_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 250,
                value: 'control_comment',
                id: 'control_comment'
            });
            const group4__element11_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Коментар виконавця'
            });
            const group4__element11 = this.createElement('div', {
                className: 'group__element'
            }, group4__element11_checkBox, group4__element11_title);
            const group4__container = this.createElement('div', {
                className: 'groupContainer'
            },
            group4__title, group4__element2, group4__element3, group4__element4, group4__element5,
            group4__element6, group4__element7, group4__element8 , group4__element9,
            group4__element11, group4__element10);
            const group5__element2_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 100,
                value: 'transfer_date',
                id: 'transfer_date'
            });
            const group5__element2_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Передано'
            });
            const group5__element2 = this.createElement('div', {
                className: 'group__element'
            }, group5__element2_checkBox, group5__element2_title);
            const group5__element3_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 100,
                value: 'state_changed_date',
                id: 'state_changed_date'
            });
            const group5__element3_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Розглянуто'
            });
            const group5__element3 = this.createElement('div', {
                className: 'group__element'
            }, group5__element3_checkBox, group5__element3_title);
            const group5__element4_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 100,
                value: 'state_changed_date_done',
                id: 'state_changed_date_done'
            });
            const group5__element4_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'На прозвон'
            });
            const group5__element4 = this.createElement('div', {
                className: 'group__element'
            }, group5__element4_checkBox, group5__element4_title);
            const group5__element5_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 100,
                value: 'execution_term',
                id: 'execution_term'
            });
            const group5__element5_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Контроль'
            });
            const group5__element5 = this.createElement('div', {
                className: 'group__element'
            }, group5__element5_checkBox, group5__element5_title);
            const group5__element6_checkBox = this.createElement('input', {
                type: 'checkbox',
                className: 'group__element_checkBox',
                columnWidth: 100,
                value: 'control_date',
                id: 'control_date'
            });
            const group5__element6_title = this.createElement('div', {
                className: 'group__element_title',
                innerText: 'Перевірка'
            });
            const group5__element6 = this.createElement('div', {
                className: 'group__element'
            }, group5__element6_checkBox, group5__element6_title);
            const group5__container = this.createElement('div', {
                className: 'groupContainer'
            }, group5__title, group5__element2, group5__element3, group5__element4, group5__element5, group5__element6);
            const group1 = this.createElement('div', {
                id:'group1',
                className: 'group1'
            }, group1__title, group1__container);
            const group2 = this.createElement('div', {
                id:'group2',
                className: 'group2'
            }, group2__title, group2__container);
            const group3 = this.createElement('div', {
                id:'group3',
                className: 'group3'
            }, group3__title, group3__container);
            const group4 = this.createElement('div', {
                id:'group4',
                className: 'group4'
            }, group4__title, group4__container);
            const group5 = this.createElement('div', {
                id:'group4',
                className: 'group4'
            }, group5__title, group5__container);
            const groupsContainer = this.createElement('div', {
                id:'groupsContainer',
                className: 'groupsContainer'
            }, group1, group2, group3, group4, group5);
            this.modalWindow.appendChild(groupsContainer);
            this.defaultCheckedItem.forEach(e => document.getElementById(e.displayValue).checked = true);
            this.checkItems();
        },
        checkItems: function() {
            let elements = this.filterColumns;
            elements.forEach(e => {
                document.getElementById(e.displayValue).checked = true;
            });
        },
        gearSaveMethod() {
            this.defaultCheckedItem = [];
            this.filterColumns = [];
            const checkedElements = Array.from(document.querySelectorAll('.group__element'));
            checkedElements.forEach(el => {
                if(el.firstElementChild.checked) {
                    const width = Number(el.firstElementChild.columnWidth);
                    const displayValue = el.firstElementChild.value;
                    const caption = el.lastElementChild.innerText;
                    const obj = { displayValue, caption, width }
                    this.filterColumns.push(obj);
                }
            });
            this.messageService.publish({
                name: 'findFilterColumns',
                value: this.filterColumns
            });
            this.hideModalWindow(this);
        },
        showApplyFiltersValue: function(message) {
            this.selectedFilters = message.filters;
            this.clearContainer(this.selectedFiltersContainer);
            const filtersBox = this.setSelectedFiltersViewValues();
            this.createFilterBox(filtersBox);
        },
        setSelectedFiltersViewValues: function() {
            const filtersBox = [];
            this.selectedFilters.forEach(filter => {
                filtersBox.push(this.getSelectFilterViewValuesObject(filter));
            });
            return filtersBox
        },
        getSelectFilterViewValuesObject(filter) {
            const obj = {}
            switch (filter.operation) {
                case true:
                case '=':
                    obj.title = filter.placeholder;
                    obj.value = 'Наявнiсть'
                    break;
                case 'like':
                    obj.title = filter.placeholder;
                    obj.value = filter.value
                    break;
                case '===':
                case '==':
                case 'in':
                case '+""+':
                    obj.title = filter.placeholder;
                    obj.value = filter.viewValue
                    break
                default:
                    obj.title = this.operation(filter.operation, filter.placeholder);
                    obj.value = this.changeDateValue(filter.value);
                    break;
            }
            return obj;
        },
        createFilterBox: function(filtersBox) {
            for(let i = 0; i < filtersBox.length; i++) {
                let el = filtersBox[i];
                let filterBox__value = this.createElement('div', {
                    className: 'filterBox__value tooltip',
                    title: el.value,
                    innerText: el.value
                });
                let filterBox__title = this.createElement('div', {
                    className: 'filterBox__title',
                    innerText: el.title + ' : '
                });
                let filterBox = this.createElement('div', {
                    className: 'filterBox'
                }, filterBox__title, filterBox__value);
                this.selectedFiltersContainer.appendChild(filterBox);
            }
        },
        operation: function(operation, title) {
            let result = title;
            switch (operation) {
                case '>=':
                    result = title + ' з'
                    break;
                case '<=':
                    result = title + ' по'
                    break;
                default:
                    break;
            }
            return result;
        },
        changeDateValue: function(date) {
            let dd = date.getDate().toString();
            let mm = (date.getMonth() + 1).toString();
            let yyyy = date.getFullYear().toString();
            dd = dd.length === 1 ? '0' + dd : dd;
            mm = mm.length === 1 ? '0' + mm : mm;
            return `${dd}-${mm}-${yyyy}`;
        },
        hideModalWindow() {
            this.clearContainer(this.modalWindow);
            this.modalWindowWrapper.style.display = this.displayNone;
        },
        clearContainer(container) {
            while(container.hasChildNodes()) {
                container.removeChild(container.lastElementChild);
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
        showMyPagePreloader: function() {
            this.showPagePreloader('Зачекайте, застосовуються зміни');
        }
    };
}());
