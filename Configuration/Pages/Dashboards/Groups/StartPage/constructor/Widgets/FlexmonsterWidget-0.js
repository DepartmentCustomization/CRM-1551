(function () {
    return 
    {
    config: {
        toolbar: true,
        height: 700
    },
    init: function() {
        document.getElementById('summary__table').style.display = 'none';
        
        this.sub = this.messageService.subscribe( 'ApplyGlobalFilters', this.getFiltersParams, this);
        this.sub1 = this.messageService.subscribe( 'renderTable', this.renderTable, this);
        this.sub2 = this.messageService.subscribe( 'GlobalFilterChanged', this.setBtnState, this);
    },
    loadData: function() {
        document.querySelector('.filter-block').style.zIndex = '16';
        const msg = {
            name: "SetFilterPanelState",
            package: {
                value: false
            }
        };
        this.messageService.publish(msg);  
        
        const query = this.getQueryOptions();
        this.getChunkedValues(query, this.setData, this);
    },
    setData: function(values) {

        indexRegistration_date = values[0].findIndex(el => el.code.toLowerCase() === 'registration_date');
        indexVykon_date = values[0].findIndex(el => el.code.toLowerCase() === 'vykon_date');
        indexClose_date = values[0].findIndex(el => el.code.toLowerCase() === 'close_date');
        indexQuestionState = values[0].findIndex(el => el.code.toLowerCase() === 'questionstate');
        indexCount = values[0].findIndex(el => el.code === 'Count_' );
        indexСount_prostr = values[0].findIndex(el => el.code.toLowerCase() === 'сount_prostr');
        indexOrgExecutName = values[0].findIndex(el => el.code.toLowerCase() === 'orgexecutname');
        indexOrgatization_Level_1 = values[0].findIndex(el => el.code.toLowerCase() === 'orgatization_level_1');
        indexOrgatization_Level_2 = values[0].findIndex(el => el.code.toLowerCase() === 'orgatization_level_2');
        indexOrgatization_Level_3 = values[0].findIndex(el => el.code.toLowerCase() === 'orgatization_level_3');
        indexOrgatization_Level_4 = values[0].findIndex(el => el.code.toLowerCase() === 'orgatization_level_4');
        indexOrgExecutLabelName = values[0].findIndex(el => el.code.toLowerCase() === 'orgexecutlabelname');
        indexOrgExecutLabelName2 = values[0].findIndex(el => el.code.toLowerCase() === 'orgexecutlabelname2');
        indexGroupOrganisations = values[0].findIndex(el => el.code.toLowerCase() === 'grouporganisations');
        indexGroupQuestionTypes = values[0].findIndex(el => el.code.toLowerCase() === 'groupquestiontypes');
        indexReceiptSources = values[0].findIndex(el => el.code.toLowerCase() === 'receiptsources');
        indexQuestionTypeName = values[0].findIndex(el => el.code.toLowerCase() === 'questiontypename');
        indexQuestionStateRegistered = values[0].findIndex(el => el.code.toLowerCase() === 'stateregistered');
        indexQuestionStateInWork = values[0].findIndex(el => el.code.toLowerCase() === 'stateinwork');
        indexQuestionStateOnCheck = values[0].findIndex(el => el.code.toLowerCase() === 'stateoncheck');
        indexQuestionStateOnRefinement = values[0].findIndex(el => el.code.toLowerCase() === 'stateonrefinement');
        indexQuestionStateClose = values[0].findIndex(el => el.code.toLowerCase() === 'stateclose');
        const columns = values.shift();
        const reportData = values.map((row, index) => ({ 
            "Батькiвська 1 рiвень": values[index][indexOrgatization_Level_1],
            "Батькiвська 2 рiвень": values[index][indexOrgatization_Level_2],
            "Батькiвська 3 рiвень": values[index][indexOrgatization_Level_3],
            "Батькiвська 4 рiвень": values[index][indexOrgatization_Level_4],
            "Дата регистрации": values[index][indexRegistration_date],
            "Дата виконання": values[index][indexVykon_date],
            "Дата закриття": values[index][indexClose_date],
            "Стан питання": values[index][indexQuestionState],
            "Загальна кiлькiсть": values[index][indexCount],
            "Кiлькость прострочено": values[index][indexСount_prostr],
            "Виконавець": values[index][indexOrgExecutName],
            "Шлях органiзацii. Варiант 1": values[index][indexOrgExecutLabelName],
            "Шлях органiзацii. Варiант 2": values[index][indexOrgExecutLabelName2],
            "Група органiзацiй": values[index][indexGroupOrganisations],
            "Група типiв питань": values[index][indexGroupQuestionTypes],
            "Джерело надходження": values[index][indexReceiptSources],
            "Тип питання": values[index][indexQuestionTypeName],
            "Стан питання. Зареєстровано": values[index][indexQuestionStateRegistered],
            "Стан питання. В роботі": values[index][indexQuestionStateInWork],
            "Стан питання. На перевірці": values[index][indexQuestionStateOnCheck],
            "Стан питання. На доопрацюванні": values[index][indexQuestionStateOnRefinement],
            "Стан питання. Закрито": values[index][indexQuestionStateClose],
        }));
        const report = {
            dataSource: {
                data: reportData
            }
        };
        this.flexmonster.setReport(report);
    },
    setBtnState: function(message){
        let btn = document.getElementById('apply-filters-button');
        let dateReceipt  = message.package.value.values.find(f => f.name === 'date_receipt').value;    
        let organization = message.package.value.values.find(f => f.name === 'organization').value;
        let groupOrganization = message.package.value.values.find(f => f.name === 'group_organization').value;
        let receiptSource = message.package.value.values.find(f => f.name === 'receipt_source').value;
        if(btn){
            if(dateReceipt){
                if( dateReceipt.dateFrom !== '' && dateReceipt.dateTo !== '' ){
                    if( organization && groupOrganization ){
                        document.getElementById('apply-filters-button').disabled = true; 
                    }else{
                        document.getElementById('apply-filters-button').disabled = false;
                    }
                }
            }else{
               document.getElementById('apply-filters-button').disabled = true; 
            }
        }
    },
    renderTable: function(message){
        this.QuestionGroupId = message.questionGroupId;
        this.questionTypesData = message.questionTypesArr;
        // this.loadData();
    },
    getFiltersParams: function(message){
        this.dateClosingData = [];
        this.operationCloseDate = 0
        this.dateExecutionData = [];
        this.operationVykonDate = 0
        let dateReceipt  = message.package.value.find(f => f.name === 'date_receipt').value;
        let dateExecution = message.package.value.find(f => f.name === 'date_execution').value;
        let dateClosing = message.package.value.find(f => f.name === 'date_closing').value;
        let organization = message.package.value.find(f => f.name === 'organization').value;
        let groupOrganization = message.package.value.find(f => f.name === 'group_organization').value;
        let receiptSource = message.package.value.find(f => f.name === 'receipt_source').value;

        if( dateReceipt !== null  ){
            if( dateReceipt.dateFrom !== '' && dateReceipt.dateTo !== ''){
                this.dateReceipt__from = dateReceipt.dateFrom;
                this.dateReceipt__to = dateReceipt.dateTo;
                
                if( dateExecution !== null){
                    this.dateExecution__from = dateExecution.dateFrom === '' ? null :  dateExecution.dateFrom;
                    this.dateExecution__to = dateExecution.dateTo === '' ? null :  dateExecution.dateTo;
                    
                    if(  this.dateExecution__from === null && this.dateExecution__to === null ){
                        this.dateExecutionData = [];
                        this.operationVykonDate = 0;
                        
                    }else if(  this.dateExecution__from !== null && this.dateExecution__to === null ){
                        this.dateExecutionData = [this.dateExecution__from];
                        this.operationVykonDate = 1;
                        
                    }else if(  this.dateExecution__from === null && this.dateExecution__to !== null ){
                        this.dateExecutionData = [this.dateExecution__to];
                        this.operationVykonDate = 2;
                        
                    }else if(  this.dateExecution__from !== null && this.dateExecution__to !== null ){
                        this.dateExecutionData = [ this.dateExecution__from, this.dateExecution__to];
                        this.operationVykonDate = 3;
                    }
                }
                if( dateClosing !== null){
                    this.dateClosing__from = dateClosing.dateFrom === '' ? null :  dateClosing.dateFrom;
                    this.dateClosing__to = dateClosing.dateTo === '' ? null :  dateClosing.dateTo;
                    
                    if(  this.dateClosing__from === null && this.dateClosing__to === null ){
                        this.dateClosingData = [];
                        this.operationCloseDate = 0;
                        
                    }else if(  this.dateClosing__from !== null && this.dateClosing__to === null ){
                        this.dateClosingData = [this.dateClosing__from];
                        this.operationCloseDate = 1;
                        
                    }else if(  this.dateClosing__from === null && this.dateClosing__to !== null ){
                        this.dateClosingData = [this.dateClosing__to];
                        this.operationCloseDate = 2;
                        
                    }else if(  this.dateClosing__from !== null && this.dateClosing__to !== null ){
                        this.dateClosingData = [ this.dateClosing__from, this.dateClosing__to];
                        this.operationCloseDate = 3;
                    }
                }
                
                this.organization = organization === null ? null : organization === '' ? null : organization.value;
                this.groupOrganization = groupOrganization === null ? null : groupOrganization === '' ? null : groupOrganization.value;
                this.receiptSource = receiptSource === null ? null : receiptSource === '' ? null : receiptSource.value;
                
                let filterArray = [this.dateReceipt__from, this.dateReceipt__to, this.dateExecution__from, this.dateExecution__to, this.dateClosing__from, this.dateClosing__to, this.organization, this.receiptSource ];
            }
            document.getElementById('summary__table').style.display = 'block';
            document.getElementById('content').style.display = 'none';
            this.loadData();
        }   
    },     
    getQueryOptions: function() {
        return {
            code: 'ak_ConstructrQuestionTable',
            parameterValues: [
                
                { key: '@RegistrationDateFrom', value: this.dateReceipt__from}, 
                { key: '@RegistrationDateTo', value: this.dateReceipt__to},
                { key: '@OrganizationExecId', value:  this.organization },    
                { key: '@OrganizationExecGroupId', value:  this.groupOrganization},    
                { key: '@ReceiptSourcesId', value: this.receiptSource},
                { key: '@QuestionGroupId', value: this.QuestionGroupId},
            ],
            filterColumns: [
                {
                    key: "QuestionTypeId",
                    value: {
                                operation: 0,
                                not: false,
                                values: this.questionTypesData
                            }
                },
                {
                    key: "Vykon_date",
                    value: {
                                operation: this.operationVykonDate,
                                not: false,
                                values: this.dateExecutionData
                            }
                },
                {
                    key: "Close_date",
                    value: {
                                operation: this.operationCloseDate,
                                not: false,
                                values: this.dateClosingData
                            }
                }
            ],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        };
    },
};
}());