(function() {
    return {
        title: ' ',
        hint: '',
        customConfig:
                    `
                    <style>
                    #saveButtonWrapper{
                        position: fixed;
                        right: 20px;
                        bottom: 20px;
                    }
                    #saveButton{
                        height: 40px;
                        width: 40px;
                        background-color: #ff4081;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        border-radius: 50%;
                    }
                    .fa-save{
                        font-size: 25px;
                        color: #fff!important;
                    }
                    </style>
                    <div id="containerSave"></div>
                    `
        ,
        counter: 0,
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
            this.messageService.subscribe('saveValues', this.setSaveData, this);
        },
        afterViewInit: function() {
            const container = document.getElementById('containerSave');
            this.container = container;
            const saveButtonWrapper = this.createSaveButtonWrapper();
            container.appendChild(saveButtonWrapper);
        },
        createSaveButtonWrapper: function() {
            const saveButtonIcon = this.createElement('i', { className: 'fa fa-5x fa-save'});
            const saveButton = this.createElement(
                'div',{ id: 'saveButton' }, saveButtonIcon
            );
            saveButton.addEventListener('click', e => {
                e.stopImmediatePropagation();
                this.messageService.publish({name: 'saveAppeal'});
            });
            const saveButtonWrapper = this.createElement(
                'div', { id: 'saveButtonWrapper' }, saveButton
            );
            return saveButtonWrapper;
        },
        setSaveData: function(message) {
            if(message.accidentInfo) {
                this.event = message.accidentInfo;
                this.counter++;
            }
            if(message.callerInfo) {
                this.applicant = message.callerInfo;
                this.counter++;
            }
            if(message.patientInfo) {
                this.patient = message.patientInfo;
                this.counter++;
            }
            if(this.counter === 3) {
                this.counter = 0;
                this.setQuerySave();
            }
        },
        setQuerySave: function() {
            this.showPagePreloader('Зачекайте, данні зберігається');
            const querySave = {
                queryCode: 'ak_ButtonSave112',
                parameterValues: this.setQueryParameters(),
                limit: -1
            };
            this.queryExecutor(querySave, this.getQueryResponse, this);
            this.showPreloader = false;
        },
        setQueryParameters: function() {
            const parameters = [
                {
                    'key': '@applicant_last_name',
                    'value': this.applicant.name
                },
                {
                    'key': '@applicant_first_name',
                    'value': this.applicant.secondName
                },
                {
                    'key': '@applicant_middle_name',
                    'value': this.applicant.fatherName
                },
                {
                    'key': '@applicant_person_phone',
                    'value': this.applicant.phone
                },
                {
                    'key': '@applicant_sex',
                    'value': null
                },
                {
                    'key': '@applicant_birth_date',
                    'value': this.applicant.birthday
                },
                {
                    'key': '@applicant_building_id',
                    'value': this.applicant.address.addressId
                },
                {
                    'key': '@applicant_entrance',
                    'value': this.applicant.address.houseEntrance
                },
                {
                    'key': '@applicant_entercode',
                    'value': this.applicant.address.houseEntranceCode
                },
                {
                    'key': '@applicant_storeysnumber',
                    'value': this.applicant.address.houseFloorsCounter
                },
                {
                    'key': '@applicant_floor',
                    'value': this.applicant.address.flatFloor
                },
                {
                    'key': '@applicant_flat',
                    'value': this.applicant.address.flatApartmentOffice
                },
                {
                    'key': '@applicant_exit',
                    'value': this.applicant.address.flatExit
                },
                {
                    'key': '@applicant_moreinformation',
                    'value': this.applicant.address.searchTextContent
                },
                {
                    'key': '@applicant_longitude',
                    'value': this.applicant.address.longitude
                },
                {
                    'key': '@applicant_latitude',
                    'value': this.applicant.address.latitude
                },
                {
                    'key': '@pacient_last_name',
                    'value': this.patient.secondName
                },
                {
                    'key': '@pacient_first_name',
                    'value': this.patient.name
                },
                {
                    'key': '@pacient_middle_name',
                    'value': this.patient.fatherName
                },
                {
                    'key': '@pacient_person_phone',
                    'value': this.patient.phoneNumber
                },
                {
                    'key': '@pacient_sex',
                    'value': this.patient.sex
                },
                {
                    'key': '@pacient_birth_date',
                    'value': this.patient.birthday
                },
                {
                    'key': '@pacient_building_id',
                    'value': this.patient.address.addressId
                },
                {
                    'key': '@pacient_entrance',
                    'value': this.patient.address.houseEntrance
                },
                {
                    'key': '@pacient_entercode',
                    'value': this.patient.address.houseEntranceCode
                },
                {
                    'key': '@pacient_storeysnumber',
                    'value': this.patient.address.houseFloorsCounter
                },
                {
                    'key': '@pacient_floor',
                    'value': this.patient.address.flatFloor
                },
                {
                    'key': '@pacient_flat',
                    'value': this.patient.address.flatApartmentOffice
                },
                {
                    'key': '@pacient_exit',
                    'value': this.patient.address.flatExit
                },
                {
                    'key': '@pacient_moreinformation',
                    'value': this.patient.address.searchTextContent
                },
                {
                    'key': '@pacient_longitude',
                    'value': this.patient.address.longitude
                },
                {
                    'key': '@pacient_latitude',
                    'value': this.patient.address.latitude
                },
                {
                    'key': '@event_receipt_date',
                    'value': this.event.callDateTime
                },
                {
                    'key': '@event_event_date',
                    'value': this.event.accidentDateTime
                },
                {
                    'key': '@event_work_line_id',
                    'value': this.event.workLineId
                },
                {
                    'key': '@event_work_line_value',
                    'value': this.event.workLineValue
                },
                {
                    'key': '@event_category_id',
                    'value': this.event.categoryId
                },
                {
                    'key': '@event_applicant_type_id',
                    'value': this.event.callerTypeId
                },
                {
                    'key': '@event_building_id',
                    'value': this.event.address.addressId
                },
                {
                    'key': '@event_entrance',
                    'value': this.event.address.houseEntrance
                },
                {
                    'key': '@event_entercode',
                    'value': this.event.address.houseEntranceCode
                },
                {
                    'key': '@event_floor',
                    'value': this.event.address.flatFloor
                },
                {
                    'key': '@event_flat_office',
                    'value': this.event.address.flatApartmentOffice
                },
                {
                    'key': '@event_storeysnumber',
                    'value': this.event.address.houseFloorsCounter
                },
                {
                    'key': '@event_exit',
                    'value': this.event.address.flatExit
                },
                {
                    'key': '@event_moreinformation',
                    'value': this.event.address.searchTextContent
                },
                {
                    'key': '@event_longitude',
                    'value': this.event.address.longitude
                },
                {
                    'key': '@event_latitude',
                    'value': this.event.address.latitude
                },
                {
                    'key': '@event_content',
                    'value': this.event.accidentComment
                },
                {
                    'key': '@event_sipcallid',
                    'value': null
                },
                {
                    'key': '@for_yourself103',
                    'value': this.event.checkBoxMe
                },
                {
                    'key': '@for_another103',
                    'value': this.event.checkBoxAnother
                },
                {
                    'key': '@service_ids',
                    'value': null
                },
                {
                    'key': '@applicant_classes_ids',
                    'value': this.applicant.status
                },
                {
                    'key': '@police',
                    'value': this.event.police
                },
                {
                    'key': '@medical',
                    'value': this.event.medical
                },
                {
                    'key': '@fire',
                    'value': this.event.fire
                },
                {
                    'key': '@gas',
                    'value': this.event.gas
                }
            ]
            return parameters;
        },
        getQueryResponse: function() {
            this.hidePagePreloader();
            window.location.reload();
        }
    };
}());
