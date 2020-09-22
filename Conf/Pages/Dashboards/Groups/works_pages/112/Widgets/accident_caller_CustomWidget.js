(function() {
    return {
        title: ' ',
        hint: '',
        customConfig:
                    `
                    <style>
                        .textInputWrapper{
                            
                        }
                        .propertiesWrapper {
                            display: flex;
                            flex-direction: row;
                            justify-content: center;
                        }
                        .callerCBW{
                            justify-content: center;
                            align-items: center;
                        }
                        .textWrapper{
                            width: 100%;
                        }
                        .callerNameWrapper{
                            display: flex;
                        }

                        .callerStatusButtonsWrapper{
                            padding: 1em 1em;
                            background-color: #eeeeee;
                            width: 100%;
                            display: flex;
                            flex-direction: row;
                            justify-content: center;
                        }
                        .callerStatusBtnUnchecked{
                            border: 1px solid #c4c4c4;
                            color: #3e50b4 !important;
                        }
                        .callerStatusBtnChecked{
                            background-color: #3e50b4;
                            border-color: #3e50b4;
                            color: white !important;
                        }
                        .callerStatusBtn{
                            text-align: center;
                            display: inline-block;
                            font-weight: bold;
                            width: auto;
                            height: 100%;
                            margin-left: 2px;
                            margin-right: 2px;
                            border-radius: 3px;
                            font-size: 0.875em;
                            text-transform: uppercase;
                            user-select: none;
                            display: inline-block;
                            line-height: 36px;
                            padding: 0 16px;
                            cursor: pointer;
                            outline: none;
                        }
                        .addressHeader{
                            display: flex;
                            flex-direction: row;
                            justify-content: space-between;
                        }
                        .addressCaption{
                            font-size: 14px;
                            text-transform: uppercase;
                            color: #000;
                            font-weight: 700;
                        }

                        .marker{
                            font-size: 150%;
                            width: 24px;
                            height: 24px;
                            text-align: center;
                            color: #000;
                            margin-right: 10px;
                        }
                        .addressBtn{
                            cursor: pointer;
                        }

                        .addressEditorWrapper{
                            display: flex;
                        }

                        .questionWrapper{
                            display: flex;
                            flex-direction: row;
                            justify-content: center;
                            padding: 10px;
                        }
                        .questionBtn{
                            color: white;
                            font-size: 100%;
                            font-weight: normal;
                            text-transform: uppercase;
                            line-height: 1.5em;
                            border: 1px solid #2d9cdb;
                            background: #2d9cdb;
                            display: flex;
                            align-items: center;
                            padding: 7px 25px;
                            border-radius: 15px;
                            cursor: pointer;
                        }

                    </style>
                    <div id="containerCaller"></div>
                    `
        ,
        stringEmpty: '',
        fullName: [],
        statusCaller: {
            DeafAndDumb: {id: 0, value: 0},
            Inadequate: {id: 0, value: 0},
            Blind: {id: 0, value: 0},
            Deaf: {id: 0, value: 0},
            Dumb: {id: 0, value: 0}
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
            const getUrlParams = window
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
            const urlPhoneNumber = getUrlParams.phone;
            this.urlPhoneNumber = urlPhoneNumber;
            this.messageService.subscribe('captionAccidentCaller', this.createCaption, this);
            this.messageService.subscribe('headerAccidentCaller', this.setHeader, this);
            this.messageService.subscribe('saveAppeal', this.setInfoValues, this);
            this.messageService.subscribe('sendCallerSearchAddress', this.setCallerSearchAddress, this);
            this.messageService.subscribe('sendInfoSearchAddress', this.setInfoSearchAddress, this);
            this.messageService.subscribe('sendPatientSearchAddress', this.setPatientSearchAddress, this);
            this.messageService.subscribe('getInputElements', this.sendInputElements, this);
            this.executeStatusCallerQuery();
            if(urlPhoneNumber) {
                this.showPagePreloader('Зачекайте, данні заповнюються');
                this.executeQuestionQuery(urlPhoneNumber);
            }
        },
        executeStatusCallerQuery: function() {
            const queryStatusCaller = {
                queryCode: 'ak_listClasses112',
                parameterValues: [
                    { key: '@pageOffsetRows', value: 0},
                    { key: '@pageLimitRows', value: 10}
                ],
                filterColumns: [],
                limit: -1
            };
            this.queryExecutor(queryStatusCaller, this.setStatusCallerId, this);
            this.showPreloader = false;
        },
        executeQuestionQuery: function(urlPhoneNumber) {
            const queryQuestion = {
                queryCode: 'GetEmergensyContactByPhone',
                parameterValues: [
                    { key: '@Phone', value: urlPhoneNumber}
                ],
                limit: -1
            };
            this.queryExecutor(queryQuestion,this.getApplicantsProps.bind(this, urlPhoneNumber), this);
            this.showPreloader = false;
        },
        setStatusCallerId: function(data) {
            const indexId = data.columns.findIndex(el => el.code.toLowerCase() === 'id');
            const indexName = data.columns.findIndex(el => el.code.toLowerCase() === 'name');
            for (let i = 0; i < data.rows.length; i++) {
                const element = data.rows[i];
                const name = element.values[indexName];
                switch (name) {
                    case 'Глухонімий':
                        this.statusCaller.DeafAndDumb.id = element.values[indexId];
                        break;
                    case 'Глухий':
                        this.statusCaller.Deaf.id = element.values[indexId];
                        break;
                    case 'Німий':
                        this.statusCaller.Dumb.id = element.values[indexId];
                        break;
                    case 'Сліпий':
                        this.statusCaller.Blind.id = element.values[indexId];
                        break;
                    case 'Неадекватний':
                        this.statusCaller.Inadequate.id = element.values[indexId];
                        break;
                    default:
                        break;
                }
            }
        },
        createCaption: function(message) {
            this.container.appendChild(message.caption)
        },
        createElement: function(tag, props, ...children) {
            const element = document.createElement(tag);
            Object.keys(props).forEach(key => element[key] = props[key]);
            if(children.length) {
                children.forEach(child =>{
                    element.appendChild(child);
                });
            } return element;
        },
        afterViewInit: function() {
            const container = document.getElementById('containerCaller');
            this.container = container;
            this.createHeader();
            const propertiesWrapper = this.createPropertiesWrapper();
            const callerNameWrapper = this.createCallerNameWrapper();
            const callerStatusButtonsWrapper = this.createCallerStatusButtonsWrapper();
            const addressWrapper = this.createAddressWrapper();
            this.addContainerChild(
                this.header,
                propertiesWrapper,
                callerNameWrapper,
                addressWrapper,
                callerStatusButtonsWrapper
            );
            this.showHideElement('btnCallerAddressClear','none');
        },
        sendInputElements: function() {
            const elements = {
                anonymous: this.anonymousCheckBox,
                name: this.callerName,
                secondName: this.callerSecondName,
                fatherName: this.callerFatherName,
                phone: this.callerPhone,
                birthday: this.callerBirthday,
                address: this.address,
                addressInput: this.searchAddress,
                callerStatusBtn: this.statusCaller
            };
            const name = 'sendWidgetElements';
            const widget = 'caller';
            this.messageService.publish({name, widget, elements});
        },
        createHeader: function() {
            const header = {
                text: 'Заявник',
                iconClass: 'fa fa-user',
                widget: 'AccidentCaller'
            }
            const name = 'createHeader';
            this.messageService.publish({ name, header });
        },
        setHeader: function(message) {
            this.header = message.header;
        },
        addContainerChild: function(...params) {
            params.forEach(item => this.container.appendChild(item));
        },
        createPropertiesWrapper: function() {
            const anonymousCheckBox = this.createAnonymousCheckBox('Анонiм', 'anonymousCheckBox');
            const callerPhoneNumber = this.createTextInput('Телефон', 'text', true, 'CallerPhone', true);
            const callerBirthday = this.createTextInput('Дата народження', 'date', false, 'CallerBirthday', true);
            const propertiesWrapper = this.createElement(
                'div',
                { className: 'propertiesWrapper bgcLightGrey'},
                anonymousCheckBox, callerPhoneNumber, callerBirthday
            );
            return propertiesWrapper;
        },
        createAnonymousCheckBox: function(text, id) {
            const label = this.createElement(
                'span',
                { className: 'callerCheckBoxLabel', id: id, innerText: text}
            );
            const checkBox = this.createElement(
                'input',
                { className: 'callerCheckBox checkBox', type: 'checkBox', checked: true}
            );
            this.anonymousCheckBox = checkBox;
            checkBox.addEventListener('change', e => {
                const checkBox = e.currentTarget;
                if(!checkBox.checked) {
                    checkBox.checked = false;
                } else {
                    checkBox.checked = true;
                    this.setAnonymousProp();
                }
            });
            const callerCheckBoxWrapper = this.createElement(
                'div',
                {className: 'checkBoxWrapper callerCBW topLeftRightPadding botPadding rightSeparator wrapBorderBot'},
                checkBox, label
            );
            return callerCheckBoxWrapper;
        },
        createTextInput: function(text, type, borderRight, id, position) {
            const input = this.createElement('input',
                {
                    type: type,
                    className: 'input textInput',
                    innerText: this.stringEmpty,
                    id: id
                }
            );
            this.setTextInputValue(id, input);
            if(position) {
                input.addEventListener('change', e => {
                    e.stopImmediatePropagation();
                    if(id !== 'CallerPhone' && id !== 'CallerBirthday') {
                        this.anonymousCheckBox.checked = false;
                    }
                    this.setTextInputValue(id, input);
                });
            }
            const placeholder = this.createElement('span', { className: 'placeholder placeholderInt',innerText: text});
            const textInputWrapper = this.createElement(
                'div',
                {
                    className: 'textInputWrapper borderBottom'
                },
                placeholder, input
            );
            const wrapper = this.createElement(
                'div', {className: 'textWrapper topLeftRightPadding botPadding wrapBorderBot'}, textInputWrapper
            );
            if(borderRight) {
                wrapper.classList.add('rightSeparator');
            }
            return wrapper;
        },
        setTextInputValue: function(id, input) {
            switch (id) {
                case 'CallerName':
                    this.callerName = input;
                    this.callerNameValue = input.value;
                    this.checkedAnonymousStatus();
                    this.fullName.push(input);
                    break;
                case 'CallerSecondName':
                    this.callerSecondName = input;
                    this.callerSecondNameValue = input.value;
                    this.checkedAnonymousStatus();
                    this.fullName.push(input);
                    break;
                case 'CallerFatherName':
                    this.callerFatherName = input;
                    this.callerFatherNameValue = input.value;
                    this.checkedAnonymousStatus();
                    this.fullName.push(input);
                    break;
                case 'CallerBirthday':
                    this.callerBirthday = input;
                    this.callerBirthdayValue = input.value;
                    break;
                case 'CallerPhone':
                    this.callerPhone = input;
                    this.callerPhoneValue = input.value;
                    break;
                default:
                    break;
            }
        },
        checkedAnonymousStatus: function() {
            if(this.callerName && this.callerSecondName && this.callerFatherName) {
                if(
                    this.callerSecondName.value === this.stringEmpty &&
                    this.callerFatherName.value === this.stringEmpty &&
                    this.callerFatherNameValue === this.stringEmpty
                ) {
                    if(this.anonymousCheckBox) {
                        this.anonymousCheckBox.checked = true;
                    }
                } else {
                    this.anonymousCheckBox.checked = false;
                }
            }
        },
        createCallerNameWrapper: function() {
            const callerSecondName = this.createTextInput('Прізвище', 'text', true, 'CallerName', true);
            const callerName = this.createTextInput('Iм\'я', 'text', true, 'CallerSecondName', true);
            const callerFatherName = this.createTextInput('По батькові', 'text', false, 'CallerFatherName', true);
            const callerNameWrapper = this.createElement(
                'div',
                { className: 'callerNameWrapper wrapBorderBot bgcLightGrey'},
                callerSecondName, callerName, callerFatherName
            );
            return callerNameWrapper;
        },
        createCallerStatusButtonsWrapper: function() {
            const btnDeafAndDumb = this.createStatusBtn('btnDeafAndDumb', 'Глухонімий');
            const btnDeaf = this.createStatusBtn('btnDeaf', 'Глухий');
            const btnDumb = this.createStatusBtn('btnDumb', 'Німий');
            const btnBlind = this.createStatusBtn('btnBlind', 'Cлiпий');
            const btnInadequate = this.createStatusBtn('btnInadequate', 'Неадекватний');
            const callerStatusButtonsWrapper = this.createElement(
                'div',
                { className: 'callerStatusButtonsWrapper wrapBorderBot bgcLightGrey'},
                btnDeafAndDumb, btnDeaf, btnDumb, btnBlind, btnInadequate
            );
            return callerStatusButtonsWrapper;
        },
        createStatusBtn: function(id, text) {
            const btn = this.createElement(
                'button',
                { className: 'btn callerStatusBtn callerStatusBtnUnchecked', id: id, innerText: text, value: 0 }
            );
            btn.addEventListener('click', e => {
                const btn = e.currentTarget;
                const value = Number(btn.value);
                this.changeButtonStatus(btn, value);
            });
            return btn;
        },
        changeButtonStatus: function(btn, value) {
            const zero = 0;
            switch (btn.id) {
                case 'btnDeafAndDumb':
                    this.setBtnDeafAndDumbStatus(value, zero);
                    break;
                case 'btnDeaf':
                    this.setBtnDeafStatus(value, zero);
                    break;
                case 'btnDumb':
                    this.setBtnDumbStatus(value, zero);
                    break;
                case 'btnBlind':
                    this.setBtnBlindStatus(btn, value, zero);
                    break;
                case 'btnInadequate':
                    this.setBtnInadequateStatus(btn, value, zero);
                    break;
                default:
                    break;
            }
        },
        setBtnDeafAndDumbStatus: function(value, zero) {
            if(value === zero) {
                this.statusCaller.Deaf.value = 1;
                this.setActiveStatusBtn('btnDeaf');
                this.statusCaller.Dumb.value = 1;
                this.setActiveStatusBtn('btnDumb');
                this.statusCaller.DeafAndDumb.value = 1;
                this.setActiveStatusBtn('btnDeafAndDumb');
            } else {
                this.statusCaller.Deaf.value = 0;
                this.setPassiveStatusBtn('btnDeaf');
                this.statusCaller.Dumb.value = 0;
                this.setPassiveStatusBtn('btnDumb');
                this.statusCaller.DeafAndDumb.value = 0;
                this.setPassiveStatusBtn('btnDeafAndDumb');
            }
        },
        setBtnDeafStatus: function(value, zero) {
            if(value === zero) {
                this.statusCaller.Deaf.value = 1;
                this.setActiveStatusBtn('btnDeaf');
                if(this.statusCaller.Dumb.value === 1) {
                    this.statusCaller.DeafAndDumb.value = 1;
                    this.setActiveStatusBtn('btnDeafAndDumb');
                }
            } else {
                this.statusCaller.Deaf.value = 0;
                this.setPassiveStatusBtn('btnDeaf');
                this.statusCaller.DeafAndDumb.value = 0;
                this.setPassiveStatusBtn('btnDeafAndDumb');
            }
        },
        setBtnDumbStatus: function(value, zero) {
            if(value === zero) {
                this.statusCaller.Dumb.value = 1;
                this.setActiveStatusBtn('btnDumb');
                if(this.statusCaller.Deaf.value === 1) {
                    this.statusCaller.DeafAndDumb.value = 1;
                    this.setActiveStatusBtn('btnDeafAndDumb');
                }
            } else {
                this.statusCaller.Dumb.value = 0;
                this.setPassiveStatusBtn('btnDumb');
                this.statusCaller.DeafAndDumb.value = 0;
                this.setPassiveStatusBtn('btnDeafAndDumb');
            }
        },
        setBtnBlindStatus: function(btn, value, zero) {
            if(value === zero) {
                this.statusCaller.Blind.value = 1;
                this.setActiveStatusBtn(btn.id);
            } else {
                this.statusCaller.Blind.value = 0;
                this.setPassiveStatusBtn(btn.id);
            }
        },
        setBtnInadequateStatus: function(btn, value, zero) {
            if(value === zero) {
                this.statusCaller.Inadequate.value = 1;
                this.setActiveStatusBtn(btn.id);
            } else {
                this.statusCaller.Inadequate.value = 0;
                this.setPassiveStatusBtn(btn.id);
            }
        },
        setActiveStatusBtn: function(id) {
            document.getElementById(id).value = 1;
            document.getElementById(id).classList.remove('callerStatusBtnUnchecked');
            document.getElementById(id).classList.add('callerStatusBtnChecked');
        },
        setPassiveStatusBtn: function(id) {
            document.getElementById(id).value = 0;
            document.getElementById(id).classList.add('callerStatusBtnUnchecked');
            document.getElementById(id).classList.remove('callerStatusBtnChecked');
        },
        createAddressWrapper: function() {
            const addressHeader = this.createAddressHeader();
            const addressContentWrapper = this.createAddressContentWrapper(
                'callerAddressContent'
            );
            const addressWrapper = this.createElement(
                'div',
                { className: 'addressWrapper wrapBorderBot topLeftRightPadding botPadding bgcLightGrey'},
                addressHeader, addressContentWrapper
            );
            return addressWrapper;
        },
        createAddressHeader: function() {
            const addressCaption = this.createElement(
                'span',
                {className: 'addressCaption', innerText: 'Адреса заявника *'}
            );
            const addressEditorWrapper = this.createAddressEditorWrapper(
                'btnCallerAddressClear',
                'btnCallerAddressEdit'
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
            btnAddressClear.addEventListener('click', e => {
                e.stopImmediatePropagation();
                this.clearSearchAddress();
                this.showHideElement('btnCallerAddressClear', 'none');
            });
            btnAddressEdit.addEventListener('click', e => {
                const btnEdit = e.currentTarget;
                const id = btnEdit.id;
                const message = 'sendCallerSearchAddress';
                const name = 'showSearchAddressContainer';
                this.messageService.publish({name, message, id});
                this.messageService.publish({name: 'hideAllAppealLeafLetMap'});
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
                {innerText: ' ', id: 'searchCallerAddress', className: 'addressContent'}
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
            this.showHideElement('callerAddressContent', 'none');
        },
        showHideElement: function(id, status) {
            document.getElementById(id).style.display = status;
        },
        showAddressContent: function() {
            this.addressContentWrapper.style.display = 'block';
        },
        hideAddressContent: function() {
            this.addressContentWrapper.style.display = 'none';
        },
        setAnonymousProp: function() {
            this.callerName.value = this.stringEmpty;
            this.callerNameValue = this.stringEmpty;
            this.callerSecondName.value = this.stringEmpty;
            this.callerSecondNameValue = this.stringEmpty
            this.callerFatherName.value = this.stringEmpty;
            this.callerFatherNameValue = this.stringEmpty;
        },
        setInfoValues: function() {
            const callerStatus = this.setCallerStatusToString();
            const callerInfo = {
                anonymous: this.anonymousCheckBox.checked,
                name: this.callerNameValue,
                secondName: this.callerSecondNameValue,
                fatherName: this.callerFatherNameValue,
                phone: this.callerPhoneValue ,
                birthday: new Date(this.callerBirthdayValue),
                status: callerStatus,
                address: this.address
            }
            const name = 'saveValues';
            this.messageService.publish({ name, callerInfo});
        },
        setCallerStatusToString: function() {
            let callerStatus = '';
            for (const property in this.statusCaller) {
                if(this.statusCaller[property].value === 1) {
                    callerStatus = callerStatus + this.statusCaller[property].id + ', ';
                }
            }
            if(callerStatus.length > 0) {
                callerStatus = callerStatus.slice(0, -2);
            }
            return callerStatus
        },
        setCallerSearchAddress: function(message) {
            this.searchAddress.innerText = message.address.fullAddress;
            this.address = message.address;
            this.showHideElement('callerAddressContent', 'flex');
            this.showHideElement('btnCallerAddressClear', 'block');
        },
        setInfoSearchAddress: function(message) {
            this.infoAddress = message.address;
        },
        setPatientSearchAddress: function(message) {
            this.patientAddress = message.address;
        },
        getApplicantsProps: function(urlPhoneNumber, data) {
            const queryCounter = {
                queryCode: 'CoutQuestionForNumber112',
                parameterValues: [
                    { key: '@Phone', value: urlPhoneNumber}
                ],
                limit: -1
            };
            this.queryExecutor(queryCounter,this.callerQuestionCounter.bind(this, data, urlPhoneNumber), this);
            this.showPreloader = false;
        },
        callerQuestionCounter: function(applicantProps, urlPhoneNumber, data) {
            const indexApplicantId = data.columns.findIndex(el => el.code.toLowerCase() === 'applicantid');
            const indexCounter = data.columns.findIndex(el => el.code.toLowerCase() === 'count_questions');
            const counter = data.rows[0].values[indexCounter];
            const applicantId = data.rows[0].values[indexApplicantId];
            this.setApplicantPhoneNumber(urlPhoneNumber);
            if(data.rows.length && counter) {
                const questionWrapper = this.createQuestionWrapper(counter, applicantId);
                this.container.appendChild(questionWrapper);
            }
            if(applicantProps.rows.length) {
                this.setCallerPropsByUrlPhoneNumber(applicantProps);
            }
            this.hidePagePreloader();
        },
        createQuestionWrapper: function(counter, applicantId) {
            const questionBtn = this.createElement(
                'button',
                { className: 'questionBtn', innerText: 'Питань: ' + counter, applicantId }
            );
            questionBtn.addEventListener('click', e => {
                e.stopImmediatePropagation();
                const btn = e.currentTarget;
                const id = btn.applicantId;
                window.open(location.origin + localStorage.getItem('VirtualPath') + '/sections/Applicants/edit/' + id);
            });
            const questionWrapper = this.createElement(
                'div',
                { className: 'questionWrapper'},
                questionBtn
            );
            return questionWrapper;
        },
        setCallerPropsByUrlPhoneNumber: function(data) {
            const indexName = data.columns.findIndex(el => el.code.toLowerCase() === 'last_name');
            const indexSecondName = data.columns.findIndex(el => el.code.toLowerCase() === 'first_name');
            const indexFatherName = data.columns.findIndex(el => el.code.toLowerCase() === 'middle_name');
            const indexBirthday = data.columns.findIndex(el => el.code.toLowerCase() === 'birth_date');
            const indexAddressBuildingId = data.columns.findIndex(el => el.code.toLowerCase() === 'building_id');
            const indexAddressHouseEntrance = data.columns.findIndex(el => el.code.toLowerCase() === 'entrance');
            const indexAddressHouseEntranceCode = data.columns.findIndex(el => el.code.toLowerCase() === 'entercode');
            const indexAddressHouseFloorsCounter = data.columns.findIndex(el => el.code.toLowerCase() === 'storeysnumber');
            const indexAddressFlatFloor = data.columns.findIndex(el => el.code.toLowerCase() === 'floor');
            const indexAddressFlatApartmentOffice = data.columns.findIndex(el => el.code.toLowerCase() === 'flat');
            const indexAddressFlatExit = data.columns.findIndex(el => el.code.toLowerCase() === 'exit');
            const indexAddressSearchTextContent = data.columns.findIndex(el => el.code.toLowerCase() === 'moreinformation');
            const indexAddressLongitude = data.columns.findIndex(el => el.code.toLowerCase() === 'longitude');
            const indexAddressLatitude = data.columns.findIndex(el => el.code.toLowerCase() === 'latitude');
            const indexAddressFullAddress = data.columns.findIndex(el => el.code.toLowerCase() === 'event_address');
            this.address.addressId = data.rows[0].values[indexAddressBuildingId];
            this.address.houseEntrance = data.rows[0].values[indexAddressHouseEntrance];
            this.address.houseEntranceCode = data.rows[0].values[indexAddressHouseEntranceCode];
            this.address.houseFloorsCounter = data.rows[0].values[indexAddressHouseFloorsCounter];
            this.address.flatFloor = data.rows[0].values[indexAddressFlatFloor];
            this.address.flatApartmentOffice = data.rows[0].values[indexAddressFlatApartmentOffice];
            this.address.flatExit = data.rows[0].values[indexAddressFlatExit];
            this.address.latitude = data.rows[0].values[indexAddressLatitude];
            this.address.longitude = data.rows[0].values[indexAddressLongitude];
            this.address.fullAddress = data.rows[0].values[indexAddressFullAddress];
            this.address.searchTextContent = data.rows[0].values[indexAddressSearchTextContent];
            this.callerName.value = data.rows[0].values[indexName];
            this.callerSecondName.value = data.rows[0].values[indexSecondName];
            this.callerFatherName.value = data.rows[0].values[indexFatherName];
            const birthday = this.setDateTimeValues(data.rows[0].values[indexBirthday]);
            this.callerBirthday.value = birthday;
            this.checkedAnonymousStatus();
        },
        setDateTimeValues: function(value) {
            let date = new Date(value);
            let DD = date.getDate().toString();
            let MM = (date.getMonth() + 1).toString();
            let YYYY = date.getFullYear().toString();
            DD = DD.length === 1 ? '0' + DD : DD;
            MM = MM.length === 1 ? '0' + MM : MM;
            return YYYY + '-' + MM + '-' + DD;
        },
        setApplicantPhoneNumber: function(urlPhoneNumber) {
            this.callerPhone.value = urlPhoneNumber;
        }
    };
}());
