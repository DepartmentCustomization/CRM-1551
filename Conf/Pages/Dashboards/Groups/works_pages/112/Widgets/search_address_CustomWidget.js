(function() {
    return {
        title: ' ',
        hint: '',
        customConfig:
                    `
                    <style>
                        #searchAddressFields{
                            margin-top: 10px;
                        }
                        #searchTextContent{
                            margin: 10px 0 7px;
                            width: 100%;
                            height: 100%;
                            border: none;
                            outline: none;
                            padding: 5px;
                            border: 1px solid rgb(169, 169, 169);
                        }
                        #fullAddressValue{
                            background-color: #fff;
                            box-shadow: 0 0 2px 3px rgba(0,0,0,.1);
                            padding: 5px;
                        }
                        .searchButtonsWrapper{
                            margin: 10px 0;
                            display: flex;
                            justify-content: space-around;
                        }
                        .searchBtnCancel{
                            border: 1px solid #c4c4c4;
                            color: #3e50b4 !important;
                            box-shadow: 0 0 2px 3px rgba(0,0,0,.1);
                        }
                        .searchBtnAccept{
                            background-color: #3e50b4;
                            border-color: #3e50b4;
                            color: white !important;
                        }
                        #searchInputWrapper{
                            position: absolute;
                            height: 40px;
                            width: 50%;
                            top: 0;
                            right: 6px;
                            background-color: rgba(128, 128, 128, .4);
                            z-index: 10000000;
                        }
                        .searchInput{
                            border-bottom: 1px solid black;
                            color: black;
                            font-weight: 600;
                            font-size: 17px;
                        }
                    </style>
                    <div id="searchAddressFields"></div>
                    `
        ,
        houseEntrance: null,
        houseEntranceCode: null,
        houseFloorsCounter: null,
        flatFloor: null,
        flatApartmentOffice: null,
        flatExit: null,
        fullAddressValue: null,
        activeAddressId: undefined,
        viewAddress: undefined,
        stringEmpty: '',
        address: {
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
        },
        searchTextInputs: [],
        init: function() {
            this.searchAddressContainer = document.getElementById('searchAddressContainer');
            this.searchAddressContainer.style.position = 'relative';
            this.hideSearchAddressContainer();
            this.messageService.subscribe('showSearchAddressContainer', this.showSearchAddressContainer, this);
            this.messageService.subscribe('hideSearchAddressContainer', this.hideSearchAddressContainer, this);
            this.messageService.subscribe('sendSearchAddress', this.setSearchAddress, this);
            this.houseEntranceValue = this.stringEmpty;
            this.houseEntranceCodeValue = this.stringEmpty;
            this.houseFloorsCounterValue = this.stringEmpty;
            this.flatFloorValue = this.stringEmpty;
            this.flatApartmentOfficeValue = this.stringEmpty;
            this.flatExitValue = this.stringEmpty;
        },
        showSearchAddressContainer: function(message) {
            this.activeAddressId = message.id;
            this.activeAddressMessage = message.message;
            this.searchAddressContainer.style.display = 'block';
        },
        hideSearchAddressContainer: function() {
            this.searchAddressContainer.style.display = 'none';
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
            const container = document.getElementById('searchAddressFields');
            this.container = container;
            const housePropertiesWrapper = this.createHousePropertiesWrapper();
            const flatPropertiesWrapper = this.createFlatPropertiesWrapper();
            const searchAddInfoWrapper = this.createSearchAddInfoWrapper();
            const fullAddressWrapper = this.createFullAddressWrapper();
            const searchButtonsWrapper = this.createSearchButtonsWrapper();
            const searchInputWrapper = this.createSearchInputWrapper();
            this.addContainerChild(
                housePropertiesWrapper,
                flatPropertiesWrapper,
                searchAddInfoWrapper,
                fullAddressWrapper,
                searchButtonsWrapper
            );
            this.searchAddressContainer.appendChild(searchInputWrapper);
        },
        addContainerChild: function(...params) {
            params.forEach(item => this.container.appendChild(item));
        },
        createHousePropertiesWrapper: function() {
            const houseEntrance = this.createTextInput('Під\'їзд', 'text', true, 'houseEntrance');
            const houseEntranceCode = this.createTextInput('Код під\'їзду', 'text', true, 'houseEntranceCode');
            const houseFloorsCounter = this.createTextInput('Кількість поверхів', 'text', false, 'houseFloorsCounter');
            const propertiesWrapper = this.createElement(
                'div',
                { className: 'propertiesWrapper bgcLightGrey'},
                houseEntrance, houseEntranceCode, houseFloorsCounter
            );
            return propertiesWrapper;
        },
        createFlatPropertiesWrapper: function() {
            const flatFloor = this.createTextInput('Поверх', 'text', true, 'flatFloor');
            const flatApartmentOffice = this.createTextInput('Квартира/Офіс', 'text', true, 'flatApartmentOffice');
            const flatExit = this.createTextInput('Вхід', 'text', false, 'flatExit');
            const propertiesWrapper = this.createElement(
                'div',
                { className: 'propertiesWrapper bgcLightGrey'},
                flatFloor, flatApartmentOffice, flatExit
            );
            return propertiesWrapper;
        },
        createTextInput: function(text, type, borderRight, id) {
            const input = this.createElement('input',
                {
                    type: type,
                    className: 'input textInput searchTextInput',
                    id: id,
                    value: this.stringEmpty
                }
            );
            input.disabled = true;
            this.searchTextInputs.push(input);
            input.addEventListener('change', e => {
                e.stopImmediatePropagation();
                const input = e.currentTarget;
                const id = input.id;
                const value = input.value;
                this.setAddressProps(id, value);
            });
            this.setTextInput(id, input);
            const placeholder = this.createElement('span', { className: 'placeholder placeholderInt',innerText: text});
            const textInputWrapper = this.createElement(
                'div',
                {
                    className: 'textInputWrapper borderBottom'
                },
                placeholder, input
            );
            const wrapper = this.createElement(
                'div', {className: 'textWrapper topLeftRightPadding botPadding'}, textInputWrapper
            );
            if(borderRight) {
                wrapper.classList.add('rightSeparator');
            }
            return wrapper;
        },
        setTextInput: function(id, input) {
            switch (id) {
                case 'houseEntrance':
                    this.houseEntrance = input;
                    break;
                case 'houseEntranceCode':
                    this.houseEntranceCode = input;
                    break;
                case 'houseFloorsCounter':
                    this.houseFloorsCounter = input;
                    break;
                case 'flatFloor':
                    this.flatFloor = input;
                    break;
                case 'flatApartmentOffice':
                    this.flatApartmentOffice = input;
                    break;
                case 'flatExit':
                    this.flatExit = input;
                    break;
                default:
                    break;
            }
        },
        createSearchAddInfoWrapper: function() {
            const searchTextContent = this.createElement(
                'textarea',
                { id: 'searchTextContent', placeholder: 'Додаткова інформація'}
            );
            this.searchTextContent = searchTextContent;
            searchTextContent.addEventListener('change', e => {
                e.stopImmediatePropagation();
                const input = e.currentTarget;
                const value = input.value;
                this.address.searchTextContent = value;
            });
            const searchAddInfoWrapper = this.createElement(
                'div',
                { className: 'accidentTextContentWrapper' },
                searchTextContent
            );
            return searchAddInfoWrapper;
        },
        createFullAddressWrapper: function() {
            const params = {
                text: 'Адреса',
                iconClass: 'fa fa-map'
            }
            const fullAddressHeader = this.createHeader(params);
            const fullAddressValue = this.createElement(
                'div',
                { id: 'fullAddressValue', innerText: this.stringEmpty }
            );
            this.fullAddressValue = fullAddressValue;
            const fullAddressWrapper = this.createElement(
                'div',
                { className: 'fullAddressWrapper'},
                fullAddressHeader, fullAddressValue
            );
            return fullAddressWrapper;
        },
        createHeader: function(params) {
            const text = params.text;
            const iconClass = params.iconClass;
            const icon = this.createElement('span', { className: iconClass});
            const iconWrapper = this.createElement('span', { className: 'iconWrapper'}, icon);
            const headerText = this.createElement('span', { innerText: text});
            const header = this.createElement('div', { className: 'header'}, iconWrapper, headerText);
            return header;
        },
        createSearchButtonsWrapper: function() {
            const btnSearchAccept = this.createStatusBtn('btnSearchAccept', 'Прийняти', 'searchBtnAccept');
            const btnSearchCancel = this.createStatusBtn('btnSearchCancel', 'Скасувати', 'searchBtnCancel');
            const searchButtonsWrapper = this.createElement(
                'div',
                { className: 'searchButtonsWrapper'},
                btnSearchAccept, btnSearchCancel
            );
            return searchButtonsWrapper;
        },
        createStatusBtn: function(id, text, className) {
            const btn = this.createElement(
                'button',
                { className: 'btn callerStatusBtn ', id: id, innerText: text, value: 0 }
            );
            btn.addEventListener('click', e => {
                const btn = e.currentTarget;
                if(this.fullAddressValue.innerText.length) {
                    if(btn.id === 'btnSearchAccept') {
                        const address = this.address;
                        const name = this.activeAddressMessage;
                        this.messageService.publish({name, address});
                    }
                }
                this.activeAddressMessage = undefined;
                this.clearAllInputs();
                this.clearAddressValues();
                this.hideSearchAddressContainer();
                this.changeTextInputStatus(true);
                this.messageService.publish({name: 'showAllAppealLeafLetMap'});
            });
            btn.classList.add(className);
            return btn;
        },
        clearAllInputs: function() {
            this.fullAddressValue.innerText = this.stringEmpty;
            this.searchTextContent.value = this.stringEmpty;
            this.activeAddressMessage = undefined;
            this.houseEntrance.value = this.stringEmpty;
            this.houseEntranceCode.value = this.stringEmpty;
            this.houseFloorsCounter.value = this.stringEmpty;
            this.flatApartmentOffice.value = this.stringEmpty;
            this.flatFloor.value = this.stringEmpty;
            this.flatExit.value = this.stringEmpty;
            this.searchInput.value = this.stringEmpty;
            this.searchTextContent.value = this.stringEmpty;
        },
        clearAddressValues: function() {
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
            this.fullAddressValue.innerText = this.stringEmpty;
            this.activeAddressId = undefined;
            this.viewAddress = undefined;
            this.houseEntranceValue = this.stringEmpty;
            this.houseEntranceCodeValue = this.stringEmpty;
            this.houseFloorsCounterValue = this.stringEmpty;
            this.flatFloorValue = this.stringEmpty;
            this.flatApartmentOfficeValue = this.stringEmpty;
            this.flatExitValue = this.stringEmpty;
        },
        createSearchInputWrapper: function() {
            const searchInput = this.createSearchMapInput();
            const searchInputWrapper = this.createElement('div',
                {
                    id: 'searchInputWrapper'
                },
                searchInput
            );
            return searchInputWrapper;
        },
        createSearchMapInput: function() {
            const searchInput = this.createElement('input',
                {
                    id: 'searchInput',
                    type: 'text',
                    className: 'input',
                    value: this.stringEmpty
                }
            );
            this.searchInput = searchInput;
            searchInput.addEventListener('keyup', e => {
                if (event.keyCode === 13) {
                    event.preventDefault();
                    const input = e.currentTarget;
                    const querySearch = {
                        queryCode: 'ak_listAddressSearch',
                        parameterValues: [
                            { key: '@search', value: input.value}
                        ],
                        filterColumns: [],
                        limit: -1
                    };
                    this.queryExecutor(querySearch, this.getSearchingValue, this);
                }
            });
            return searchInput;
        },
        getSearchingValue: function(data) {
            const name = 'setSearchMarker';
            this.messageService.publish({name, data});
        },
        setSearchAddress: function(message) {
            if(message) {
                this.changeTextInputStatus(false);
                this.viewAddress = 'Вул. ' + message.address + ', ';
                this.address.latitude = message.latitude;
                this.address.longitude = message.longitude;
                this.address.addressId = message.addressId;
            }
            this.setFullAddress();
        },
        changeTextInputStatus: function(status) {
            this.searchTextInputs.forEach(input => {
                input.disabled = status;
            });
        },
        setAddressProps: function(id, value) {
            if(this.viewAddress) {
                switch (id) {
                    case 'houseEntrance':
                        this.houseEntranceValue = 'під\'їзд ' + value;
                        this.address.houseEntrance = Number(value);
                        break;
                    case 'houseEntranceCode':
                        this.houseEntranceCodeValue = ' (код ' + value + ') ';
                        this.address.houseEntranceCode = Number(value);
                        break;
                    case 'houseFloorsCounter':
                        this.houseFloorsCounterValue = '/' + value;
                        this.address.houseFloorsCounter = Number(value);
                        break;
                    case 'flatFloor':
                        this.flatFloorValue = ', поверх: ' + value;
                        this.address.flatFloor = Number(value);
                        break;
                    case 'flatApartmentOffice':
                        this.flatApartmentOfficeValue = 'кв. ' + value + ', ';
                        this.address.flatApartmentOffice = value;
                        break;
                    case 'flatExit':
                        this.flatExitValue = ', ' + value;
                        this.address.flatExit = value;
                        break;
                    default:
                        break;
                }
            }
            this.setFullAddress();
        },
        setFullAddress: function() {
            this.fullAddressValue.innerText = this.viewAddress + this.flatApartmentOfficeValue + this.houseEntranceValue +
            this.houseEntranceCodeValue + this.flatFloorValue + this.houseFloorsCounterValue + this.flatExitValue;
            this.address.fullAddress = this.fullAddressValue.innerText;
        }
    };
}());
