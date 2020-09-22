(function() {
    return {
        title: ' ',
        hint: '',
        customConfig:
                    `
                    <style>
                    .cardsWrapper{

                    }
                    .cardHeader{
                        display: flex;
                        flex-direction: row;
                        justify-content: space-between;
                        background: green !important;
                        padding: 0.4em !important;
                        color: #fff;
                    }
                    .cardInfoWrapper{
                        display: flex;
                        flex-direction: column;
                        padding: 10px;
                    }
                    .cardInfoItem{
                        border-bottom: 1px dashed black;
                        color: black;
                        padding: 10px;
                    }
                    .eventCard{
                        padding: 0.5em 1em;
                        box-shadow: 0 0 1px 1px rgba(0,0,0,.1);
                        background-color: rgb(232, 231, 231);
                        margin: 15px 10px;
                        cursor: pointer;
                    }
                    </style>

                    <div id="containerEventCards"></div>
                    `
        ,
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
            this.messageService.subscribe('LeafletMap_SelectRow', this.executeCardToView, this);
            this.messageService.subscribe('sendWidgetElements', this.setWidgetsElements, this);
            this.eventCardsContainer = document.getElementById('eventCardsContainer');
            const queryEventCardsList = {
                queryCode: 'ak_LastCard112',
                parameterValues: [
                    { key: '@pageOffsetRows', value: 0},
                    { key: '@pageLimitRows', value: 10}
                ],
                filterColumns: [],
                limit: -1
            };
            this.queryExecutor(queryEventCardsList, this.getCards, this);
            this.messageService.publish({name: 'getInputElements'});
            this.showPreloader = false;
        },
        setWidgetsElements: function(message) {
            const widget = message.widget;
            switch (widget) {
                case 'caller':
                    this.callerWidget = message.elements;
                    break;
                case 'event':
                    this.event = message.elements;
                    break;
                case 'patient':
                    this.patient = message.elements;
                    break;
                default:
                    break;
            }
        },
        showHideAddressContent: function(message) {
            this.eventCardsContainer.style.display = message.status;
        },
        afterViewInit: function() {
            const container = document.getElementById('containerEventCards');
            this.container = container;
        },
        getCards: function(data) {
            const cardsWrapper = this.createCardsWrapper(data);
            this.container.appendChild(cardsWrapper);
        },
        createCardsWrapper: function(data) {
            const cardsWrapper = this.createElement(
                'div',
                {
                    className: 'cardsWrapper'
                }
            );
            if(data.rows.length) {
                for (let i = 0; i < data.rows.length; i++) {
                    const cardProps = data.rows[i];
                    const card = this.createCard(data, cardProps);
                    cardsWrapper.appendChild(card);
                }
            }
            return cardsWrapper;
        },
        createCard: function(data, props) {
            const indexId = data.columns.findIndex(el => el.code.toLowerCase() === 'id');
            const indexReceiptDate = data.columns.findIndex(el => el.code.toLowerCase() === 'receipt_date');
            const indexPersonPhone = data.columns.findIndex(el => el.code.toLowerCase() === 'person_phone');
            const indexContent = data.columns.findIndex(el => el.code.toLowerCase() === 'content');
            const indexFullName = data.columns.findIndex(el => el.code.toLowerCase() === 'fio');
            const indexAddress = data.columns.findIndex(el => el.code.toLowerCase() === 'event_address');
            const indexCategoryName = data.columns.findIndex(el => el.code.toLowerCase() === 'category_name');
            const idValue = props.values[indexId];
            const receiptDateValue = props.values[indexReceiptDate];
            const addressEventValue = props.values[indexAddress];
            const personPhoneValue = props.values[indexPersonPhone];
            const contentValue = props.values[indexContent];
            const fullNameValue = props.values[indexFullName];
            const categoryName = props.values[indexCategoryName];
            const dateTime = this.setDateTimeValues(receiptDateValue);
            const card__number = this.createElement('div', {className: 'card__number', innerText: 'Номер: ' + idValue});
            const card__category = this.createElement('div', {className: 'card__number', innerText: categoryName });
            const curd__receiptDate = this.createElement('div',
                {className: 'card__receiptDate', innerText: dateTime }
            );
            const cardHeader = this.createElement('div', {className: 'cardHeader'},
                card__number, card__category, curd__receiptDate
            );
            const cardInfo__location_icon = this.createElement('i', {className: 'fa fa-map-marker typ marker'});
            const cardInfo__location_text = this.createElement('i', {className: 'cardInfoItemText', innerText: addressEventValue });
            const cardInfo__location = this.createElement('div', {className: 'cardInfoItem'},
                cardInfo__location_icon, cardInfo__location_text
            );
            const cardInfo__content_icon = this.createElement('i', {className: 'fa fa-file-text typ marker'});
            const cardInfo__content_text = this.createElement('i', {className: 'cardInfoItemText', innerText: contentValue});
            const cardInfo__content = this.createElement('div', {className: 'cardInfoItem'},
                cardInfo__content_icon, cardInfo__content_text
            );
            const cardInfo__phone_icon = this.createElement('i', {className: 'fa fa-phone fa-lg  marker'});
            const cardInfo__phone_text = this.createElement('i', {className: 'cardInfoItemText', innerText: personPhoneValue});
            const cardInfo__phone = this.createElement('div', {className: 'cardInfoItem'},
                cardInfo__phone_icon, cardInfo__phone_text
            );
            const cardInfo__fullName_icon = this.createElement('i', {className: 'fa fa-user fa-lg marker'});
            const cardInfo__fullName_text = this.createElement('i', {className: 'cardInfoItemText', innerText: fullNameValue});
            const cardInfo__fullName = this.createElement('div', {className: 'cardInfoItem'},
                cardInfo__fullName_icon, cardInfo__fullName_text
            );
            const cardInfo = this.createElement('div', {className: 'cardInfoWrapper'},
                cardInfo__location,
                cardInfo__content,
                cardInfo__phone,
                cardInfo__fullName
            );
            const card = this.createElement('div', {className: 'eventCard', id: idValue},
                cardHeader, cardInfo
            );
            card.addEventListener('click', e => {
                const card = e.currentTarget;
                const message = {
                    id: card.id
                }
                this.executeCardToView(message);
            });
            return card
        },
        executeCardToView: function(message) {
            const id = message.id;
            const queryEventCardsList = {
                queryCode: 'ak_EventSelectRow112',
                parameterValues: [
                    { key: '@event_id', value: id}
                ],
                filterColumns: [],
                limit: -1
            };
            this.queryExecutor(queryEventCardsList, this.getCardFullInfo, this);
        },
        getCardFullInfo: function(data) {
            if(data.rows.length) {
                /*
                const indexId = data.columns.findIndex(el => el.code.toLowerCase() === 'id');
                const indexEventId = data.columns.findIndex(el => el.code.toLowerCase() === 'event_id');
                const indexReceiptDate = data.columns.findIndex(el => el.code.toLowerCase() === 'event_receipt_date');
                const indexWorkLineId = data.columns.findIndex(el => el.code.toLowerCase() === 'event_work_line_id');
                const indexWorkLineValue = data.columns.findIndex(el => el.code.toLowerCase() === 'event_work_line_value');
                const indexCategoryId = data.columns.findIndex(el => el.code.toLowerCase() === 'event_category_id');
                const indexCategoryName = data.columns.findIndex(el => el.code.toLowerCase() === 'event_category_name');
                const indexEventDate = data.columns.findIndex(el => el.code.toLowerCase() === 'event_event_date');
                const indexEventApplicantTypeId = data.columns.findIndex(el => el.code.toLowerCase() === 'event_applicant_type_id');
                const indexEventBuildingId = data.columns.findIndex(el => el.code.toLowerCase() === 'event_building_id');
                const indexEventAddress = data.columns.findIndex(el => el.code.toLowerCase() === 'event_address');
                const indexEventEntrance = data.columns.findIndex(el => el.code.toLowerCase() === 'event_entrance');
                const indexEventEntranceCode = data.columns.findIndex(el => el.code.toLowerCase() === 'event_entercode');
                const indexEventFloorsCounter = data.columns.findIndex(el => el.code.toLowerCase() === 'event_storeysnumber');
                const indexEventFlatFloor = data.columns.findIndex(el => el.code.toLowerCase() === 'event_floor');
                const indexEventFlat = data.columns.findIndex(el => el.code.toLowerCase() === 'event_flat/office');
                const indexEventExit = data.columns.findIndex(el => el.code.toLowerCase() === 'event_exit');
                const indexEventMoreInfo = data.columns.findIndex(el => el.code.toLowerCase() === 'event_moreinformation');
                const indexEventLongitude = data.columns.findIndex(el => el.code.toLowerCase() === 'event_longitude');
                const indexEventLatitude = data.columns.findIndex(el => el.code.toLowerCase() === 'event_latitude');
                const indexEventComment = data.columns.findIndex(el => el.code.toLowerCase() === 'event_content');
                const indexEventSIPCallId = data.columns.findIndex(el => el.code.toLowerCase() === 'event_sipcallid');
                const indexApplicantBuildingId = data.columns.findIndex(el => el.code.toLowerCase() === 'applicant_building_id');
                const indexApplicantAddress = data.columns.findIndex(el => el.code.toLowerCase() === 'applicant_address');
                const indexApplicantEntrance = data.columns.findIndex(el => el.code.toLowerCase() === 'applicant_entrance');
                const indexApplicantEntranceCode = data.columns.findIndex(el => el.code.toLowerCase() === 'applicant_entercode');
                const indexApplicantFloorsCounter = data.columns.findIndex(el => el.code.toLowerCase() === 'applicant_storeysnumber');
                const indexApplicantFlatFloor = data.columns.findIndex(el => el.code.toLowerCase() === 'applicant_floor');
                const indexApplicantFlat = data.columns.findIndex(el => el.code.toLowerCase() === 'applicant_flat');
                const indexApplicantExit = data.columns.findIndex(el => el.code.toLowerCase() === 'applicant_exit');
                const indexApplicantMoreInfo = data.columns.findIndex(el => el.code.toLowerCase() === 'applicant_moreinformation');
                const indexApplicantLongitude = data.columns.findIndex(el => el.code.toLowerCase() === 'applicant_longitude');
                const indexApplicantLatitude = data.columns.findIndex(el => el.code.toLowerCase() === 'applicant_latitude');
                const indexApplicantId = data.columns.findIndex(el => el.code.toLowerCase() === 'applicant_id');
                const indexApplicantSecondName = data.columns.findIndex(el => el.code.toLowerCase() === 'applicant_last_name');
                const indexApplicantFirstName = data.columns.findIndex(el => el.code.toLowerCase() === 'applicant_first_name');
                const indexApplicantFatherName = data.columns.findIndex(el => el.code.toLowerCase() === 'applicant_middle_name');
                const indexApplicantPhone = data.columns.findIndex(el => el.code.toLowerCase() === 'applicant_person_phone');
                const indexApplicantSex = data.columns.findIndex(el => el.code.toLowerCase() === 'applicant_sex');
                const indexApplicantBirthday = data.columns.findIndex(el => el.code.toLowerCase() === 'applicant_birth_date');
                const indexPatientBuildingId = data.columns.findIndex(el => el.code.toLowerCase() === 'pacient_building_id');
                const indexPatientAddress = data.columns.findIndex(el => el.code.toLowerCase() === 'pacient_address');
                const indexPatientEntrance = data.columns.findIndex(el => el.code.toLowerCase() === 'pacient_entrance');
                const indexPatientEntranceCode = data.columns.findIndex(el => el.code.toLowerCase() === 'pacient_entercode');
                const indexPatientFloorsCounter = data.columns.findIndex(el => el.code.toLowerCase() === 'pacient_storeysnumber');
                const indexPatientFlatFloor = data.columns.findIndex(el => el.code.toLowerCase() === 'pacient_floor');
                const indexPatientFlat = data.columns.findIndex(el => el.code.toLowerCase() === 'pacient_flat');
                const indexPatientExit = data.columns.findIndex(el => el.code.toLowerCase() === 'pacient_exit');
                const indexPatientMoreInfo = data.columns.findIndex(el => el.code.toLowerCase() === 'pacient_moreinformation');
                const indexPatientLongitude = data.columns.findIndex(el => el.code.toLowerCase() === 'pacient_longitude');
                const indexPatientLatitude = data.columns.findIndex(el => el.code.toLowerCase() === 'pacient_latitude');
                const indexPatientId = data.columns.findIndex(el => el.code.toLowerCase() === 'pacient_id');
                const indexPatientSecondName = data.columns.findIndex(el => el.code.toLowerCase() === 'pacient_last_name');
                const indexPatientFirstName = data.columns.findIndex(el => el.code.toLowerCase() === 'pacient_first_name');
                const indexPatientFatherName = data.columns.findIndex(el => el.code.toLowerCase() === 'pacient_middle_name');
                const indexPatientPhone = data.columns.findIndex(el => el.code.toLowerCase() === 'pacient_person_phone');
                const indexPatientSex = data.columns.findIndex(el => el.code.toLowerCase() === 'pacient_sex');
                const indexPatientBirthday = data.columns.findIndex(el => el.code.toLowerCase() === 'pacient_birth_date');
                const indexBtnFire = data.columns.findIndex(el => el.code.toLowerCase() === 'pacient_birth_date');
                const indexBtnPolice = data.columns.findIndex(el => el.code.toLowerCase() === 'pacient_birth_date');
                const indexBtnMedical = data.columns.findIndex(el => el.code.toLowerCase() === 'pacient_birth_date');
                const indexBtnGas = data.columns.findIndex(el => el.code.toLowerCase() === 'pacient_birth_date');
                const indexCallerStatusId = data.columns.findIndex(el => el.code.toLowerCase() === 'applicant_classes_names');
                */
            }
        },
        setDateTimeValues: function(receiptDateValue) {
            let date = new Date(receiptDateValue);
            let DD = date.getDate().toString();
            let MM = (date.getMonth() + 1).toString();
            let YYYY = date.getFullYear().toString();
            DD = DD.length === 1 ? '0' + DD : DD;
            MM = MM.length === 1 ? '0' + MM : MM;
            return DD + '.' + MM + '.' + YYYY;
        }
    };
}());