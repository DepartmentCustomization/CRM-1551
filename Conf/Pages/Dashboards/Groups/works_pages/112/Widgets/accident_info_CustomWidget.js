(function() {
    return {
        title: ' ',
        hint: '',
        customConfig:
                    `
                    <style>
                    #containerInfo, #containerCaller, #containerPatient{
                        background-color: #fff;
                    }
                        .header{
                            padding: 0.5em 0.5em 0.5em 1em;
                            margin: 0;
                            color: white;
                            font-size: 100%;
                            font-weight: normal;
                            text-transform: uppercase;
                            line-height: 1.5em;
                            border: 1px solid #2d9cdb;
                            background: #2d9cdb;
                            display: flex;
                            align-items: center;
                        }
                        .iconWrapper{
                            background: #fff;
                            height: 28px;
                            width: 28px;
                            display: flex;
                            justify-content: center;
                            flex-direction: column;
                            border-radius: 50%;
                            margin-right: 0.5em;
                            text-align: center;
                        }
                        .fa{
                            font-size: 100%;
                            color: #2d9cdb;
                            cursor: pointer;
                        }

                        .modalList{
                            position: absolute;
                            background-color: #fff;
                            width: calc(100% - 20px);
                            max-height: 200px;
                            overflow-y: scroll;
                            box-shadow: 0 0 2px 3px rgba(0,0,0,.1);
                            z-index: 10000;
                        }
                        .listItem{
                            font-weight:400;
                            text-transform: uppercase;
                            padding: 10px;
                            font-size: 14px;
                            color: #000;
                        }
                        .listItem:hover{
                            background-color: #eee;
                        }

                        .accident-type-wrapper{
                            padding: 1em 1em;
                            background-color: #eeeeee;
                            width: 100%;
                        }

                        .button{
                            cursor: pointer;
                            text-align: center;
                            display: inline-block;
                            font-weight: bold;
                            width: 23%;
                            height: 100%;
                            margin-left: 2px;
                            margin-right: 2px;
                            border-radius: 3px;
                            font-size: 1em;
                            text-transform: uppercase;
                        }
                        .accidentBtnUnchecked{
                            border: 1px solid #c4c4c4;
                            color: #3e50b4 !important;
                        }
                        .accidentBtnChecked{
                            background-color: #3e50b4;
                            border-color: #3e50b4;
                            color: white !important;
                        }
                        .btnExtern{
                            border: solid 1px;
                            border-radius: 0;
                            position: relative;
                            width: 100%;
                            line-height: 36px;
                            padding-left: calc(1em + 8px);
                            padding-right: calc(1em + 8px);
                            outline: none;
                            height: 50px;
                            border-radius: 4px;
                            margin-bottom: 1px;
                        }
                        .btnExternUnchecked{
                            background: transparent;
                            color: red;
                        }
                        .btnExternChecked{
                            background: red;
                            color: #fff;
                        }
                        .bgcLightGrey{
                            background-color: #fafafa
                        }


                        .separator{
                            border-bottom: 1px solid #e0e0e0;
                        }
                        .rightSeparator{
                            border-right: 1px solid #e0e0e0;
                        }
                        .v-line-separator:after {
                            content: '';
                            display: inline-block;
                            height: 100%;
                            width: 1px;
                            background: #e0e0e0;
                            position: absolute;
                            top: 0;
                            right: 0;
                        }
                        .fix-neg-margin-right {
                            padding-right: 1em;
                        }

                        .botPadding {
                            padding-bottom: 1.25em;
                        }
                        .topLeftRightPadding{
                            padding-left: 0.75em;
                            padding-top: 0.75em;
                            padding-right: 0.75em;
                        }

                        .externWrapper{
                            position: relative;
                        }
                        .categoriesWrapper{
                            display: flex;
                            flex-wrap: nowrap;
                            margin-left: -0.25em;
                            margin-right: -0.25em;
                            width: 100%
                        }

                        .extern__arrow{
                            color: inherit;
                            margin-left: 6px;
                            top: 16px;
                        }

                        .selectWrapper{
                            padding-top: 0!important;
                            position: relative;
                            flex: auto;
                            min-width: 0;
                            width: 180px;
                        }

                        .borderBottom{
                            border-bottom:  1px solid #000;
                        }
                        cursorPointer{
                            cursor: pointer;
                        }
                        .inputWrapper{
                            display: flex;
                            justify-content: center;
                            flex-direction: row;
                            margin-bottom: 2px;
                        }
                        .selectInput{
                            width: 100%
                        }
                        .selectArrow{
                            display: flex;
                            align-items: center;
                        }
                        .input{
                            font: inherit;
                            background: 0 0;
                            color: currentColor;
                            border: none;
                            outline: 0;
                            padding: 0;
                            margin: 0;
                            width: 100%;
                            max-width: 100%;
                            vertical-align: bottom;
                            text-align: inherit;
                            font-size: 16px;
                            margin-top: 10px;
                        }
                        .placeholder{
                        }
                        .placeholderInt{
                            white-space: pre;
                            font-size: 10px;
                        }

                        .accidentDateTimerWrapper{
                            display: flex;
                        }
                        .accidentDateTimeInput{
                            outline: none;
                            border: none;
                            background-color: inherit;
                        }
                        .accidentTimerWrapper{
                            display: flex;
                            flex-direction: row;
                            justify-content: center;
                            align-items: center;
                        }
                        .integerInputWrapper{
                            display: flex;
                            flex-direction: row;
                            justify-content: center;
                            align-items: center;
                        }
                        .integerInput{
                            margin: 0 10px;
                            text-align: right;
                        }
                        .checkBoxWrapper{
                            display: flex;
                            flex-direction: row;
                            width: 100%;
                        }
                        #medicalCheckBoxWrapper{
                            text-align: left;
                        }
                        .checkBox{
                            display: inline-block;
                            height: 20px;
                            line-height: 0;
                            margin-right: 8px;
                            order: 0;
                            position: relative;
                            vertical-align: middle;
                            white-space: nowrap;
                            width: 20px;
                            flex-shrink: 0;
                        }

                        #accidentTextContent{
                            width: 100%;
                            height: 100%;
                            border: none;
                            outline: none;
                        }

                        .wrapBorderBot{
                            border-bottom: 1px solid #e0e0e0;
                        }

                        .accidentPropertiesWrapper{
                            display: flex;
                        }

                        #selectBackground{
                            position: fixed;
                            top: 0;
                            left: 0;
                            right: 0;
                            bottom: 0;
                            height: 100%;
                            width: 100%;
                            background-color: rgba(128, 128, 128, 0.3);
                            z-index: 9000;
                        }

                </style>
                    <div id="containerInfo"></div>
                    `
        ,
        police: false,
        medical: false,
        fire: false,
        gas: false,
        externList: [],
        categoryList: [],
        callerTypeList: [],
        workLineList: [],
        differentMinutesValue: 0,
        differentHoursValue: 0,
        differentDaysValue: 0,
        activeCheckBox: null,
        accidentCallDateTime: new Date(),
        createElement: function(tag, props, ...children) {
            const element = document.createElement(tag);
            Object.keys(props).forEach(key => element[key] = props[key]);
            if(children.length) {
                children.forEach(child =>{
                    element.appendChild(child);
                });
            }
            return element;
        },
        init: function() {
            this.address = {
                houseEntrance: null,
                houseEntranceCode: null,
                houseFloorsCounter: null,
                flatFloor: null,
                flatApartmentOffice: null,
                flatExit: null,
                latitude: null,
                longitude: null,
                addressId: null,
                fullAddress: null,
                searchTextContent: null
            }
            const queryExternList = {
                queryCode: 'ak_listCategories_urg112',
                parameterValues: [
                    { key: '@pageOffsetRows', value: 0},
                    { key: '@pageLimitRows', value: 10}
                ],
                filterColumns: [],
                limit: -1
            };
            const externListType = 'externListType';
            this.queryExecutor(queryExternList, this.getList.bind(this, externListType), this);
            this.showPreloader = false;
            const queryCallerTypeList = {
                queryCode: 'ak_listApplicantTypes112',
                parameterValues: [
                    { key: '@pageOffsetRows', value: 0},
                    { key: '@pageLimitRows', value: 10}
                ],
                filterColumns: [],
                limit: -1
            };
            const callerTypeList = 'callerTypeList';
            this.queryExecutor(queryCallerTypeList, this.getList.bind(this, callerTypeList), this);
            this.showPreloader = false;
            const queryWorkLineList = {
                queryCode: 'ak_listWorkLines112',
                parameterValues: [
                    { key: '@pageOffsetRows', value: 0},
                    { key: '@pageLimitRows', value: 10}
                ],
                filterColumns: [],
                limit: -1
            };
            const workLineList = 'workLineList';
            this.queryExecutor(queryWorkLineList, this.getList.bind(this, workLineList), this);
            this.showPreloader = false;
            this.messageService.subscribe('headerAccidentInfo', this.setHeader, this);
            this.messageService.subscribe('saveAppeal', this.setInfoValues, this);
            this.messageService.subscribe('sendInfoSearchAddress', this.sendInfoSearchAddress, this);
            this.messageService.subscribe('getInputElements', this.sendInputElements, this);
        },
        sendInputElements: function() {
            const elements = {
                accidentDateTimeInput: this.accidentDateTimeInput,
                accidentComment: this.accidentTextContentValue
            };
            const name = 'sendWidgetElements';
            const widget = 'event';
            this.messageService.publish({name, widget, elements});
        },
        setCategoryList: function() {
            const queryCategoryList = {
                queryCode: 'ak_listCategories112',
                parameterValues: [
                    { key: '@pageOffsetRows', value: 0},
                    { key: '@pageLimitRows', value: 50},
                    { key: '@police', value: this.police},
                    { key: '@medical', value: this.medical},
                    { key: '@fire', value: this.fire},
                    { key: '@gas', value: this.gas}
                ],
                filterColumns: [],
                limit: -1
            };
            const categoryListType = 'categoryListType';
            this.queryExecutor(queryCategoryList, this.getList.bind(this, categoryListType), this);
            this.showPreloader = false;
        },
        afterViewInit: function() {
            const container = document.getElementById('containerInfo');
            this.container = container;
            this.createHeader();
            const buttonsWrapper = this.createButtons();
            const categoriesWrapper = this.createCategories();
            const accidentDateTimerWrapper = this.createAccidentDateTimer();
            const accidentPropertiesWrapper = this.createAccidentPropertiesWrapper();
            const medicalCheckBoxWrapper = this.createMedicalCheckBoxWrapper();
            const accidentTextContentWrapper = this.createAccidentTextContentWrapper();
            const addressWrapper = this.createAddressWrapper();
            this.addContainerChild(
                this.header,
                buttonsWrapper,
                categoriesWrapper,
                accidentDateTimerWrapper,
                accidentPropertiesWrapper,
                medicalCheckBoxWrapper,
                accidentTextContentWrapper,
                addressWrapper
            );
            this.setDateTimeDefaultValue();
            this.setTimerDefaultValue();
            this.showHideElement('btnInfoAddressClear','none');
            this.setDefaultSelectValue();
        },
        addContainerChild: function(...params) {
            params.forEach(item => this.container.appendChild(item));
        },
        createHeader: function() {
            const header = {
                text: 'Подія',
                iconClass: 'fa fa-bell',
                widget: 'AccidentInfo'
            }
            const name = 'createHeader';
            this.messageService.publish({ name, header });
        },
        setHeader: function(message) {
            this.header = message.header;
        },
        createButtons: function() {
            const btnPolice = this.createAccidentBtn('btnPolice', '102');
            const btnMedical = this.createAccidentBtn('btnMedical', '103');
            const btnFire = this.createAccidentBtn('btnFire', '101');
            const btnGas = this.createAccidentBtn('btnGas', '104');
            const buttonsWrapper = this.createElement(
                'div',
                {className: 'separator accident-type-wrapper'},
                btnFire,
                btnPolice,
                btnMedical,
                btnGas
            );
            return buttonsWrapper;
        },
        createAccidentBtn: function(id, text) {
            const btn = this.createElement('div',
                {
                    className: 'button accidentBtnUnchecked',
                    innerText: text,
                    id: id,
                    value: 0
                }
            );
            btn.addEventListener('click', e => {
                const btn = e.currentTarget;
                const id = btn.id;
                const value = Number(btn.value) === 0 ? 1 : 0;
                const remove = value === 0 ? 'accidentBtnChecked' : 'accidentBtnUnchecked';
                const add = value === 0 ? 'accidentBtnUnchecked' : 'accidentBtnChecked';
                this.changeAccidentBtn(id, value, remove, add);
            });
            return btn;
        },
        changeAccidentBtn: function(id, value, remove, add) {
            document.getElementById(id).value = value;
            document.getElementById(id).classList.remove(remove);
            document.getElementById(id).classList.add(add);
            this.changeInfoProps(id, value);
        },
        changeInfoProps: function(id, value) {
            if(id === 'btnMedical') {
                if(value === 1) {
                    this.showMedicalCheckBoxWrapper();
                    if(this.activeCheckBox !== null) {
                        if(this.activeCheckBox === this.checkBoxMe) {
                            this.changeCheckBoxMe(this.checkBoxMe);
                        }
                        if(this.activeCheckBox === this.checkBoxAnother) {
                            this.changeCheckBoxAnother(this.checkBoxAnother);
                        }
                    }
                } else {
                    const statusPatient = 'none';
                    const idPatient = 'accident_patient';
                    this.showHideWidget(statusPatient, idPatient);
                    const accident_caller = 'block';
                    const idCaller = 'accident_caller';
                    this.showHideWidget(accident_caller, idCaller);
                    this.changePatientHeader('Пацієнт');
                    this.showHideAddress('block');
                    this.hideMedicalCheckBoxWrapper();
                }
                this.medical = value === 1 ? true : false;
            } else if (id === 'btnPolice') {
                this.police = value === 1 ? true : false;
            } else if (id === 'btnFire') {
                this.fire = value === 1 ? true : false;
            } else if (id === 'btnGas') {
                this.gas = value === 1 ? true : false;
            }
            this.setCategoryList();
        },
        createCategories: function() {
            const btnExtern = this.createBtnExtern();
            const category = {
                placeholder: 'Категорія *',
                borderRight: false,
                array: this.categoryList,
                id: 'categoryList',
                inputId: '_valueCat'
            }
            const allCategories = this.createSelect(category);
            const categoriesWrapper = this.createElement('div',
                {className: 'categoriesWrapper separator bgcLightGrey'},
                btnExtern, allCategories
            );
            return categoriesWrapper;
        },
        createBtnExtern: function() {
            const extern__text = this.createElement('span', { className: 'extern__text', innerText: 'Екстренно'});
            const extern__arrow = this.createElement('span', { className: 'extern__arrow fa fa-angle-down'});
            const externItemsWrapper = this.createElement(
                'div',
                {className: 'externItemsWrapper'},
                extern__text,
                extern__arrow
            );
            const btnExtern = this.createElement(
                'button',
                {
                    className: 'btnExtern btnExternUnchecked',
                    id: 'btnExtern',
                    showModal: false,
                    changeText: false
                },
                externItemsWrapper
            );
            const externWrapper = this.createElement('div',
                {className: 'externWrapper topLeftRightPadding rightSeparator botPadding'},
                btnExtern
            );
            extern__arrow.addEventListener('click', e => {
                e.stopImmediatePropagation();
                this.showModalList(externWrapper, btnExtern.id, btnExtern, this.externList);
            });
            return externWrapper;
        },
        createSelect: function(element) {
            const input = this.createElement('input',
                {
                    type: 'text',
                    className: 'input',
                    id: element.id,
                    value: ' ',
                    valueId: undefined
                }
            );
            const placeholder = this.createElement('span', { className: 'placeholder',innerText: element.placeholder});
            const selectInput = this.createElement('div',
                {
                    className: 'selectInput',
                    id: element.inputId
                },
                placeholder, input
            );
            const arrow = this.createElement('span', { className: 'selectArrow fa fa-angle-down'});
            const inputWrapper = this.createElement('div',
                {
                    className: 'inputWrapper borderBottom',
                    showModal: false,
                    changeText: false
                },
                selectInput,
                arrow
            );
            const selectWrapper = this.createElement('div',
                {
                    className: 'selectWrapper topLeftRightPadding fix-neg-margin-right botPadding'
                },
                inputWrapper
            );
            if(element.borderRight) {
                selectWrapper.classList.add('rightSeparator');
            }
            arrow.addEventListener('click', e => {
                e.stopImmediatePropagation();
                const listItems = this.setTrueItemsList(selectInput.id, input);
                if(listItems.length) {
                    this.showModalList(selectWrapper, selectInput.id, inputWrapper, listItems);
                }
            });
            return selectWrapper;
        },
        setDefaultSelectValue: function() {
            this.changeCategoryInput('Інша подія', 10);
            this.changeCallerTypeInput('Свідок', 3);
            this.changeWorkLineInput('Телефонний виклик', 1);
        },
        setTrueItemsList: function(id, input) {
            let listItems = undefined;
            switch (id) {
                case '_valueCat':
                    this._categoryValueId = input.valueId;
                    listItems = this.categoryList;
                    break;
                case '_valueCallerType':
                    this._callerTypeValueId = input.valueId;
                    listItems = this.callerTypeList;
                    break;
                case '_valueWorkLine':
                    this._workLineValueId = input.valueId;
                    this._workLineValue = input.value;
                    listItems = this.workLineList;
                    break;
                default:
                    break;
            }
            return listItems;
        },
        showModalList:  function(container, inputId, wrapper, listItems) {
            const status = wrapper.showModal;
            const changeText = wrapper.changeText;
            if(this.activeModalContainer === undefined) {
                this.addSelectBackground(wrapper);
                if(!status) {
                    if(!changeText) {
                        document.getElementById(inputId);
                    }
                    wrapper.showModal = !status;
                    const modalList = this.createElement('div',
                        {
                            className: 'modalList'
                        }
                    );
                    if(listItems) {
                        listItems.forEach(item => {
                            const id = item.id;
                            const innerText = item.value;
                            const className = 'listItem';
                            const listItem = this.createElement('div', {id, innerText, className});
                            listItem.addEventListener('click', e => {
                                const target = e.currentTarget;
                                const id = Number(target.id);
                                const value = target.innerText;
                                switch (inputId) {
                                    case 'btnExtern':
                                        this.changeExternBtn(inputId);
                                        this.getItemProps(id);
                                        this.changeCategoryInput(value, id);
                                        break;
                                    case '_valueCat':
                                        this.getItemProps(id);
                                        this.changeCategoryInput(value, id);
                                        this.messageService.publish({name: 'sendCategoryId', id: id});
                                        break;
                                    case '_valueCallerType':
                                        this.changeCallerTypeInput(value, id);
                                        break;
                                    case '_valueWorkLine':
                                        this.changeWorkLineInput(value, id);
                                        break;
                                    default:
                                        break;
                                }
                                this.removeSelectBackground(wrapper, '1');
                            });
                            modalList.appendChild(listItem);
                        });
                        container.appendChild(modalList);
                    }
                    this.activeModalContainer = container;
                } else {
                    if(listItems.length) {
                        this.removeSelectBackground(wrapper, '2');
                    }
                }
            }
        },
        addSelectBackground: function(wrapper) {
            const selectBackground = this.createElement('div', { id: 'selectBackground'});
            this.selectBackground = selectBackground;
            selectBackground.addEventListener('click', e => {
                e.stopImmediatePropagation();
                this.removeSelectBackground(wrapper, '3');
            });
            this.container.appendChild(selectBackground)
        },
        removeSelectBackground: function(wrapper) {
            this.container.removeChild(this.selectBackground);
            this.hideModal(wrapper);
        },
        changeCategoryInput: function(value, id) {
            document.getElementById('categoryList').value = value;
            this._categoryValueId = id;
        },
        changeCallerTypeInput: function(value, id) {
            document.getElementById('callerTypeList').value = value;
            this._callerTypeValueId = id;
        },
        changeWorkLineInput: function(value, id) {
            document.getElementById('workLineList').value = value;
            this._workLineValueId = id;
        },
        changeExternBtn: function(inputId) {
            document.getElementById(inputId).classList.remove('btnExternUnchecked');
            document.getElementById(inputId).classList.add('btnExternChecked');
        },
        getItemProps: function(id) {
            const queryItemId = {
                queryCode: 'ak_listService112',
                parameterValues: [
                    { key: '@pageOffsetRows', value: 0},
                    { key: '@pageLimitRows', value: 10},
                    { key: '@Category_Id', value: id}
                ],
                filterColumns: [],
                limit: -1
            };
            this.queryExecutor(queryItemId, this.changeServiceButtons, this);
        },
        changeServiceButtons: function(data) {
            const indexName = data.columns.findIndex(el => el.code.toLowerCase() === 'name');
            const indexService = data.columns.findIndex(el => el.code.toLowerCase() === 'service_is');
            this.setAccidentBtnGlobalVariables(data);
            for (let i = 0; i < data.rows.length; i++) {
                const element = data.rows[i];
                const service = element.values[indexName];
                const btnId = this.getServiceBtnId(service);
                const dataValue = element.values[indexService];
                const value = dataValue === 'true' ? 1 : 0;
                const remove = value === 0 ? 'accidentBtnChecked' : 'accidentBtnUnchecked';
                const add = value === 0 ? 'accidentBtnUnchecked' : 'accidentBtnChecked';
                this.changeAccidentBtn(btnId, value, remove, add);
            }
        },
        getServiceBtnId: function(service) {
            let value = undefined;
            switch (service) {
                case '101':
                    value = 'btnFire'
                    break;
                case '102':
                    value = 'btnPolice'
                    break;
                case '103':
                    value = 'btnMedical'
                    break;
                case '104':
                    value = 'btnGas'
                    break;
                default:
                    break;
            }
            return value
        },
        setAccidentBtnGlobalVariables: function(data) {
            const indexName = data.columns.findIndex(el => el.code.toLowerCase() === 'name');
            const indexService = data.columns.findIndex(el => el.code.toLowerCase() === 'service_is');
            data.rows.forEach(service => {
                const name = service.values[indexName];
                switch (name) {
                    case '101':
                        this.fire = service.values[indexService];
                        break;
                    case '102':
                        this.police = service.values[indexService];
                        break;
                    case '103':
                        this.medical = service.values[indexService];
                        break;
                    case '104':
                        this.gas = service.values[indexService];
                        break;
                    default:
                        break;
                }
            });
        },
        hideModal: function(wrapper) {
            this.activeModalContainer.removeChild(this.activeModalContainer.lastElementChild);
            this.activeModalContainer = undefined;
            wrapper.showModal = false;
        },
        getList: function(type, data) {
            let list = undefined;
            switch (type) {
                case 'externListType':
                    list = this.externList
                    break;
                case 'callerTypeList':
                    list = this.callerTypeList
                    break;
                case 'workLineList':
                    list = this.workLineList
                    break;
                case 'categoryListType':
                    if(this.categoryList.length) {
                        this.categoryList = [];
                    }
                    list = this.categoryList
                    break;
                default:
                    break;
            }
            if(list) {
                data.rows.forEach(row => {
                    const indexId = 0;
                    const indexValue = 1;
                    const id = row.values[indexId];
                    const value = row.values[indexValue];
                    const listItem = { id, value };
                    list.push(listItem);
                });
            }
        },
        createAccidentDateTimer: function() {
            const accidentDateWrapper = this.createAccidentDateWrapper();
            const accidentTimerWrapper = this.createAccidentTimerWrapper();
            const accidentDateTimerWrapper = this.createElement('div',
                {className: 'accidentDateTimerWrapper separator bgcLightGrey'},
                accidentDateWrapper, accidentTimerWrapper
            );
            return accidentDateTimerWrapper;
        },
        createAccidentDateWrapper: function() {
            const accidentDateTimeInput = this.createElement(
                'input',
                {
                    type: 'datetime-local',
                    className: 'accidentDateTimeInput',
                    id: 'accidentDateTimeInput'
                }
            );
            accidentDateTimeInput.addEventListener('change', e => {
                const target = e.currentTarget;
                const oldMsSec = new Date(this.accidentDateTimeValue).setMilliseconds('0');
                const newMsSec = new Date(target.value).setMilliseconds('0');
                this.accidentCallDateTime = new Date(target.value);
                const differenceTime = (oldMsSec - newMsSec) / 1000;
                if(differenceTime > 0) {
                    this.setTimerDifferentTime(differenceTime);
                } else {
                    this.setDifferentDays('0');
                    this.setDifferentHours('0');
                    this.setDifferentMinutes('0');
                }
            });
            this.accidentDateTimeInput = accidentDateTimeInput;
            const accidentDateCaption = this.createElement(
                'div',{ className: 'placeholder', innerText: 'Дата та час'}
            );
            const elementsWrapper = this.createElement(
                'div',{ className: 'elementsWrapper borderBottom'}, accidentDateCaption, accidentDateTimeInput
            );
            const accidentDateWrapper = this.createElement(
                'div',
                {
                    className: 'accidentDateWrapper bgcLightGrey topLeftRightPadding rightSeparator botPadding ',
                    id: 'accidentDateWrapper'
                },
                elementsWrapper
            );
            return accidentDateWrapper;
        },
        setTimerDifferentTime: function(differenceTime) {
            const oneMinute = 60;
            const oneHour = 60 * 60;
            const oneDay = 60 * 60 * 24;
            if(differenceTime >= oneDay) {
                const days = Math.round(differenceTime / oneDay);
                const hours = Math.round(differenceTime / oneHour);
                const hour = Math.round(hours % 24);
                const minutes = Math.round(differenceTime / oneMinute);
                const minute = Math.round(minutes % oneMinute);
                this.setDifferentDays(days);
                this.setDifferentHours(hour);
                this.setDifferentMinutes(minute);
            } else if(differenceTime >= oneHour) {
                const hours = Math.round(differenceTime / oneHour);
                const minutes = Math.round(differenceTime / oneMinute);
                const minute = Math.round(minutes % oneMinute);
                this.setDifferentDays(this.differentDaysValue);
                this.setDifferentHours(hours);
                this.setDifferentMinutes(minute);
            } else if(differenceTime >= oneMinute) {
                this.setDifferentDays('0');
                this.setDifferentHours('0');
                this.setDifferentMinutes(differenceTime / oneMinute);
            }
        },
        setDifferentMinutes: function(differentMinutes) {
            this.differentMinutesValue = differentMinutes;
            document.getElementById('differentMinutes').value = this.differentMinutesValue;
        },
        setDifferentHours: function(differentHours) {
            this.differentHoursValue = differentHours;
            document.getElementById('differentHours').value = this.differentHoursValue;
        },
        setDifferentDays: function(differentDays) {
            this.differentDaysValue = differentDays;
            document.getElementById('differentDays').value = this.differentDaysValue;
        },
        setDateTimeValues: function() {
            let date = new Date();
            let dd = date.getDate().toString();
            let mm = (date.getMonth() + 1).toString();
            let yyyy = date.getFullYear().toString();
            let HH = date.getHours().toString();
            let MM = date.getMinutes().toString();
            dd = dd.length === 1 ? '0' + dd : dd;
            mm = mm.length === 1 ? '0' + mm : mm;
            HH = HH.length === 1 ? '0' + HH : HH;
            MM = MM.length === 1 ? '0' + MM : MM;
            return `${yyyy}-${mm}-${dd}T${HH}:${MM}`;
        },
        setDateTimeDefaultValue: function() {
            this.accidentDateTimeValue = this.setDateTimeValues();
            this.accidentDateTimeInput.value = this.accidentDateTimeValue;
        },
        createAccidentTimerWrapper: function() {
            const days = this.createIntegerInput('дн', 'differentDays');
            const hours = this.createIntegerInput('г', 'differentHours');
            const minutes = this.createIntegerInput('хвилини назад', 'differentMinutes');
            const accidentTimerWrapper = this.createElement(
                'div',{ className: 'accidentTimerWrapper', id: 'accidentTimerWrapper' },days, hours, minutes
            );
            return accidentTimerWrapper;
        },
        createIntegerInput: function(text, id) {
            const input = this.createElement('input',
                {
                    id: id,
                    type: 'text',
                    className: 'input integerInput',
                    value: ' '
                }
            );
            input.disabled = true;
            if(text === 'дн') {
                this.differentDays = input;
                this.differentDaysValue = input.value;
            } else if(text === 'г') {
                this.differentHours = input;
                this.differentHoursValue = input.value;
            } else if(text === 'хвилини назад') {
                this.differentMinutes = input;
                this.differentMinutesValue = input.value;
            }
            const placeholder = this.createElement('span', { className: 'placeholder placeholderInt',innerText: text});
            const integerInput = this.createElement('div',
                {
                    className: 'integerInputWrapper'
                },
                input, placeholder
            );
            const wrapper = this.createElement(
                'div', {className: 'integerInput borderBottom'}, integerInput
            )
            return wrapper;
        },
        setTimerDefaultValue: function() {
            this.differentMinutes.value = '0';
        },
        createAccidentPropertiesWrapper: function() {
            const callerType = {
                placeholder: 'Тип заявника',
                borderRight: true,
                array: this.callerTypeList,
                id: 'callerTypeList',
                inputId: '_valueCallerType'
            }
            const selectCallerType = this.createSelect(callerType);
            const workLine = {
                placeholder: 'Лiнiя роботи',
                borderRight: false,
                array: this.workLineList,
                id: 'workLineList',
                inputId: '_valueWorkLine'
            }
            const selectWorkLine = this.createSelect(workLine);
            const accidentPropertiesWrapper = this.createElement(
                'div',
                {className: 'accidentPropertiesWrapper bgcLightGrey wrapBorderBot'},
                selectCallerType, selectWorkLine
            );
            return accidentPropertiesWrapper;
        },
        createMedicalCheckBoxWrapper: function() {
            const checkBoxMe = this.createMedicalCheckBox('Визов 103 для себе', 'checkBoxMe');
            const checkBoxAnother = this.createMedicalCheckBox('Визов 103 для іншого', 'checkBoxAnother');
            const medicalCheckBoxWrapper = this.createElement(
                'div',
                {
                    id: 'medicalCheckBoxWrapper',
                    className: 'bgcLightGrey checkBoxWrapper wrapBorderBot topLeftRightPadding botPadding '
                },
                checkBoxMe, checkBoxAnother
            );
            this.medicalCheckBoxWrapper = medicalCheckBoxWrapper;
            this.medicalCheckBoxWrapper.style.display = 'none';
            return medicalCheckBoxWrapper;
        },
        createMedicalCheckBox: function(text, id) {
            const label = this.createElement(
                'span',
                { className: 'medicalCheckBoxLabel', innerText: text}
            );
            const checkBox = this.createElement(
                'input',
                {id: id, className: 'medicalCheckBox checkBox', type: 'checkBox'}
            );
            if(id === 'checkBoxMe') {
                this.checkBoxMe = checkBox;
            } else if (id === 'checkBoxAnother') {
                this.checkBoxAnother = checkBox;
            }
            checkBox.addEventListener('change', e => {
                const checkBox = e.currentTarget;
                this.activeCheckBox = checkBox;
                if(checkBox.id === 'checkBoxMe') {
                    this.changeCheckBoxMe(checkBox);
                } else if(checkBox.id === 'checkBoxAnother') {
                    this.changeCheckBoxAnother(checkBox);
                }
            });
            const medicalCheckBoxWrapper = this.createElement(
                'div',
                { className: 'checkBoxWrapper'},
                checkBox, label
            );
            return medicalCheckBoxWrapper;
        },
        changeCheckBoxMe: function(checkBox) {
            this.checkBoxAnother.checked = false;
            if(!checkBox.checked) {
                this.activeCheckBox = null;
                checkBox.checked = false;
                const statusPatient = 'none';
                const idPatient = 'accident_patient';
                this.showHideWidget(statusPatient, idPatient);
                const accident_caller = 'block';
                const idCaller = 'accident_caller';
                this.showHideWidget(accident_caller, idCaller);
                this.changePatientHeader('Пацієнт');
                this.showHideAddress('block');
            } else {
                checkBox.checked = true;
                const statusPatient = 'block';
                const idPatient = 'accident_patient';
                this.showHideWidget(statusPatient, idPatient);
                const accident_caller = 'none';
                const idCaller = 'accident_caller';
                this.showHideWidget(accident_caller, idCaller);
                this.changePatientHeader('Заявник/Пацієнт');
                this.showHideAddress('none');
            }
        },
        changeCheckBoxAnother: function(checkBox) {
            this.checkBoxMe.checked = false;
            if(!checkBox.checked) {
                this.activeCheckBox = null;
                checkBox.checked = false;
                const statusPatient = 'none';
                const idPatient = 'accident_patient';
                this.showHideWidget(statusPatient, idPatient);
                const accident_caller = 'block';
                const idCaller = 'accident_caller';
                this.showHideWidget(accident_caller, idCaller);
                this.changePatientHeader('Пацієнт');
                this.showHideAddress('block');
            } else {
                checkBox.checked = true;
                const statusPatient = 'block';
                const idPatient = 'accident_patient';
                this.showHideWidget(statusPatient, idPatient);
                const accident_caller = 'block';
                const idCaller = 'accident_caller';
                this.showHideWidget(accident_caller, idCaller);
                this.changePatientHeader('Пацієнт');
                this.showHideAddress('none');
            }
        },
        showHideAddress: function(status) {
            document.getElementById('infoAddressWrapper').style.display = status;
        },
        changePatientHeader: function(caption) {
            const name = 'changeHeaderCaption';
            const message = { name, caption };
            this.messageService.publish(message);
        },
        showHideWidget: function(status, id) {
            const widget = document.getElementById(id);
            const name = 'showHideWidget';
            const message = { name, widget, status};
            this.messageService.publish(message);
        },
        createAccidentTextContentWrapper: function() {
            const accidentTextContent = this.createElement(
                'textarea',
                { id: 'accidentTextContent', placeholder: 'Опис...'}
            );
            this.accidentTextContentValue = accidentTextContent;
            const accidentTextContentWrapper = this.createElement(
                'div',
                { className: 'accidentTextContentWrapper wrapBorderBot topLeftRightPadding botPadding' },
                accidentTextContent
            );
            return accidentTextContentWrapper;
        },
        createAddressWrapper: function() {
            const addressHeader = this.createAddressHeader();
            const addressContentWrapper = this.createAddressContentWrapper(
                'infoAddressContent'
            );
            const addressWrapper = this.createElement(
                'div',
                {
                    id: 'infoAddressWrapper',
                    className: 'addressWrapper wrapBorderBot topLeftRightPadding botPadding bgcLightGrey'
                },
                addressHeader, addressContentWrapper
            );
            return addressWrapper;
        },
        createAddressHeader: function() {
            const addressCaption = this.createElement(
                'span',
                {className: 'addressCaption', innerText: 'Адреса події *'}
            );
            const addressEditorWrapper = this.createAddressEditorWrapper(
                'btnInfoAddressClear',
                'btnInfoAddressEdit'
            );
            const addressHeader = this.createElement(
                'div',
                { className: 'addressHeader'},
                addressCaption, addressEditorWrapper
            );
            return addressHeader;
        },
        createAddressEditorWrapper: function(idClear, idEdit) {
            const btnAddressEdit = this.createElement(
                'span',
                { id: idEdit, className: 'material-icons editBtn addressBtn', innerText: 'edit'}
            );
            const btnAddressClear = this.createElement(
                'span',
                { id: idClear, className: 'material-icons clearBtn addressBtn', innerText: 'clear'}
            );
            btnAddressEdit.addEventListener('click', e => {
                const btnEdit = e.currentTarget;
                const id = btnEdit.id;
                const message = 'sendInfoSearchAddress';
                const name = 'showSearchAddressContainer';
                this.messageService.publish({name, message, id});
                this.messageService.publish({name: 'hideAllAppealLeafLetMap'});
            });
            btnAddressClear.addEventListener('click', e => {
                e.stopImmediatePropagation();
                this.clearSearchAddress();
                this.showHideElement('btnInfoAddressClear', 'none');
            });
            const addressEditorWrapper = this.createElement(
                'div',
                { className: 'addressEditorWrapper'},
                btnAddressClear, btnAddressEdit
            );
            return addressEditorWrapper;
        },
        createAddressContentWrapper: function(id) {
            const marker = this.createElement(
                'span',
                { className: 'fa fa-map-marker marker'}
            );
            const content = this.createElement(
                'span',
                {innerText: ' ', className: 'addressContent'}
            );
            this.searchAddress = content;
            const addressContentWrapper = this.createElement(
                'div',
                {id: id, className: 'addressContentWrapper'},
                marker, content
            );
            addressContentWrapper.style.display = 'none';
            this.addressContentWrapper = addressContentWrapper;
            return addressContentWrapper;
        },
        clearSearchAddress: function() {
            this.searchAddress.innerText = ' ';
            this.showHideElement('infoAddressContent', 'none');
        },
        showHideElement: function(id, status) {
            document.getElementById(id).style.display = status;
        },
        showHideAddressContent: function(status) {
            this.addressContentWrapper.style.display = status;
        },
        showMedicalCheckBoxWrapper: function() {
            this.medicalCheckBoxWrapper.style.display = 'flex';
        },
        hideMedicalCheckBoxWrapper: function() {
            this.medicalCheckBoxWrapper.style.display = 'none';
        },
        setInfoValues: function() {
            const activeCheckBoxId = this.activeCheckBox !== null ? this.activeCheckBox.id : null;
            const accidentInfo = {
                fire: this.fire,
                police: this.police,
                medical: this.medical,
                gas: this.gas,
                categoryId: this._categoryValueId,
                callerTypeId: this._callerTypeValueId,
                workLineId: this._workLineValueId,
                workLineValue: this._workLineValue,
                callMedical: activeCheckBoxId,
                accidentDateTime: new Date(this.accidentDateTimeValue),
                callDateTime: new Date(this.accidentCallDateTime),
                accidentComment: this.accidentTextContentValue.value,
                address: this.address,
                checkBoxMe: this.checkBoxMe.checked,
                checkBoxAnother: this.checkBoxAnother.checked
            }
            const name = 'saveValues';
            this.messageService.publish({ name, accidentInfo});
        },
        sendInfoSearchAddress: function(message) {
            this.searchAddress.innerText = message.address.fullAddress;
            this.address = message.address;
            this.showHideElement('infoAddressContent', 'flex');
            this.showHideElement('btnInfoAddressClear', 'block');
        },
        setPatientSearchAddress: function(message) {
            this.patientAddress = message.address;
        },
        setCallerSearchAddress: function(message) {
            this.callerAddress = message.address;
        }
    };
}());
