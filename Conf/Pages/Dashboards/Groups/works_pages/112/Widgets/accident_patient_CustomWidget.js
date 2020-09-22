(function() {
    return {
        title: ' ',
        hint: '',
        customConfig:
                    `
                    <style>
                    .patientSexWrapper{
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        justify-content: center;
                        width: 220px;
                    }
                    .patientCheckBoxWrapper {
                        justify-content: center;
                    }
                    </style>
                    <div id="containerPatient"></div>
                    `
        ,
        patientSexValue: null,
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
            const widget = document.getElementById('accident_patient');
            this.widget = widget;
            const status = 'none';
            const name = 'showHideWidget';
            const message = { name, widget, status};
            this.messageService.publish(message);
            this.messageService.subscribe('headerAccidentPatient', this.setHeader, this);
            this.messageService.subscribe('changeHeaderCaption', this.changeHeaderCaption, this);
            this.messageService.subscribe('saveAppeal', this.setPatientValues, this);
            this.messageService.subscribe('sendCallerSearchAddress', this.setCallerSearchAddress, this);
            this.messageService.subscribe('sendInfoSearchAddress', this.setInfoSearchAddress, this);
            this.messageService.subscribe('sendPatientSearchAddress', this.setPatientSearchAddress, this);
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
            const container = document.getElementById('containerPatient');
            this.container = container;
            this.createHeader();
            const propertiesWrapper = this.createPropertiesWrapper();
            const patientNameWrapper = this.createPatientNameWrapper();
            const addressWrapper = this.createAddressWrapper();
            this.addContainerChild(
                this.header,
                propertiesWrapper,
                patientNameWrapper,
                addressWrapper
            );
            this.showHideElement('btnPatientAddressClear','none');
        },
        createHeader: function() {
            const header = {
                text: 'Пацієнт',
                iconClass: 'fa fa-user',
                widget: 'AccidentPatient'
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
            const patientSexWrapper = this.createPatientSexWrapper();
            const patientAge = this.createTextInput('Вiк', 'text', true, 'patientAge');
            const patientBirthday = this.createTextInput('Дата народження', 'date', true, 'patientBirthday');
            const patientPhoneNumber = this.createTextInput('Телефон', 'text', false, 'patientPhoneNumber');
            const propertiesWrapper = this.createElement(
                'div',
                { className: 'propertiesWrapper bgcLightGrey'},
                patientSexWrapper, patientBirthday, patientAge, patientPhoneNumber
            );
            return propertiesWrapper;
        },
        createTextInput: function(text, type, separator, id) {
            const input = this.createElement('input',
                {
                    type: type,
                    className: 'input textInput',
                    id: id
                }
            );
            this.setTextInputValue(id, input);
            input.addEventListener('change', e => {
                e.stopImmediatePropagation();
                this.setTextInputValue(id, input);
            });
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
            if(separator) {
                wrapper.classList.add('rightSeparator');
            }
            return wrapper;
        },
        setTextInputValue: function(id, input) {
            switch (id) {
                case 'patientAge':
                    this.patientAge = input;
                    this.patientAgeValue = input.value;
                    break;
                case 'patientBirthday':
                    this.patientBirthday = input;
                    this.patientBirthdayValue = input.value;
                    break;
                case 'patientPhoneNumber':
                    this.patientPhoneNumber = input;
                    this.patientPhoneNumberValue = input.value;
                    break;
                case 'patientSecondName':
                    this.patientSecondName = input;
                    this.patientSecondNameValue = input.value;
                    break;
                case 'patientName':
                    this.patientName = input;
                    this.patientNameValue = input.value;
                    break;
                case 'patientFatherName':
                    this.patientFatherName = input;
                    this.patientFatherNameValue = input.value;
                    break;
                default:
                    break;
            }
        },
        createPatientSexWrapper: function() {
            const checkBoxMale = this.createPatientCheckBox('Ч', 'Male', 2);
            const checkBoxFemale = this.createPatientCheckBox('Ж', 'Female', 1);
            const patientSexWrapper = this.createElement(
                'div',
                { className: 'patientSexWrapper rightSeparator wrapBorderBot bgcLightGrey'},
                checkBoxMale, checkBoxFemale
            );
            return patientSexWrapper;
        },
        createPatientCheckBox: function(text, id, valueId) {
            const label = this.createElement(
                'span',
                {className: 'patientCheckBoxLabel', innerText: text}
            );
            const checkBox = this.createElement(
                'input',
                { className: 'patientCheckBox checkBox', type: 'checkBox', id: id, valueId: valueId}
            );
            this.setCheckBoxValue(id, checkBox);
            checkBox.addEventListener('change', e => {
                const checkBox = e.currentTarget;
                this.patientSexValue = checkBox.valueId;
                if(checkBox.id === 'Male') {
                    this.checkBoxFemale.checked = false;
                } else if(checkBox.id === 'Female') {
                    this.checkBoxMale.checked = false;
                }
            });
            const patientCheckBoxWrapper = this.createElement(
                'div',
                { className: 'patientCheckBoxWrapper checkBoxWrapper bgcLightGrey'},
                checkBox, label
            );
            return patientCheckBoxWrapper;
        },
        setCheckBoxValue: function(id, checkBox) {
            switch (id) {
                case 'Male':
                    this.checkBoxMale = checkBox;
                    break;
                case 'Female':
                    this.checkBoxFemale = checkBox;
                    break;
                default:
                    break;
            }
        },
        createPatientNameWrapper: function() {
            const callerSecondName = this.createTextInput('Прізвище', 'text', true, 'patientSecondName');
            const callerName = this.createTextInput('Iм\'я', 'text', true, 'patientName');
            const callerFatherName = this.createTextInput('По батькові', 'text', false, 'patientFatherName');
            const callerNameWrapper = this.createElement(
                'div',
                { className: 'callerNameWrapper wrapBorderBot bgcLightGrey'},
                callerSecondName, callerName, callerFatherName
            );
            return callerNameWrapper;
        },
        createAddressWrapper: function() {
            const addressHeader = this.createAddressHeader();
            const addressContentWrapper = this.createAddressContentWrapper(
                'patientAddressContent'
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
                {className: 'addressCaption', innerText: 'Адреса пацієнта *'}
            );
            const addressEditorWrapper = this.createAddressEditorWrapper(
                'btnPatientAddressClear',
                'btnPatientAddressEdit'
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
                const message = 'sendPatientSearchAddress';
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
            this.showHideElement('patientAddressContent', 'none');
            this.showHideElement('btnPatientAddressClear', 'none');
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
        changeHeaderCaption: function(message) {
            const caption = message.caption;
            this.header.lastElementChild.innerText = caption;
        },
        setPatientValues: function() {
            const patientInfo = {
                name: this.patientNameValue,
                secondName: this.patientSecondNameValue,
                fatherName: this.patientFatherNameValue,
                phoneNumber: this.patientPhoneNumberValue,
                birthday: new Date(this.patientBirthdayValue),
                age: this.patientAgeValue,
                sex: Number(this.patientSexValue),
                address: this.address
            }
            const name = 'saveValues';
            this.messageService.publish({ name, patientInfo});
        },
        setPatientSearchAddress: function(message) {
            this.searchAddress.innerText = message.address.fullAddress;
            this.address = message.address;
            this.showHideElement('patientAddressContent', 'flex');
            this.showHideElement('btnPatientAddressClear', 'block');
        },
        setCallerSearchAddress: function(message) {
            this.callerAddress = message.address;
        },
        setInfoSearchAddress: function(message) {
            this.infoAddress = message.address;
        }
    };
}());
