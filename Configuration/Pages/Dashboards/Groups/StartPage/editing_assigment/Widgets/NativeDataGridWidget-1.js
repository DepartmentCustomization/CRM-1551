(function () {
  return {
     config: {
        query: {
            code: 'ak_EditAssigmetsSearchResult',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                dataField: 'Registration_number',
                caption: 'Номер питання',
                width: 150
            }, {
                dataField: 'Ass_registration_date',
                caption: 'Дата надходження',
                dataType: "datetime",
                format: "dd.MM.yyyy HH:mm"
            }, {
                dataField: 'AssignmentState',
                caption: 'Стан',
            },  {
                dataField: 'QuestionType',
                caption: 'Тип питання',
            }, {
                dataField: 'Zayavnyk',
                caption: 'Заявник',
            }, {
                dataField: 'Adress',
                caption: 'Місце проблеми',
            }, {
                dataField: 'Vykonavets',
                caption: 'Виконавець',
            },  {
                dataField: 'Control_date',
                caption: 'Дата контролю',
                dataType: "datetime",
                format: "dd.MM.yyyy HH:mm"
            }
        ],
        filterRow: {
            visible: true,
            applyFilter: "auto"
        },
        export: {
            enabled: false,
            fileName: 'Excel'
        },
        pager: {
            showPageSizeSelector:  true,
            allowedPageSizes: [10, 15, 30],
            showInfo: true,
        },
        paging: {
            pageSize: 10
        },        
        scrolling: {
            mode: 'standart',
            rowRenderingMode: null,
            columnRenderingMode: null,
            showScrollbar: null
        },
        searchPanel: {
            visible: false,
            highlightCaseSensitive: true
        },
        selection:{
            mode: 'multiple',
        },
        sorting: {
            mode: "multiple"
        },
        keyExpr: 'Id',
        showBorders: false,
        showColumnLines: false,
        showRowLines: true,
        remoteOperations: null,
        allowColumnReordering: null,
        rowAlternationEnabled: null,
        columnAutoWidth: null,
        hoverStateEnabled: true,
        columnWidth: null,
        wordWrapEnabled: true,
        allowColumnResizing: true,
        showFilterRow: true,
        showHeaderFilter: false,
        showColumnChooser: false,
        showColumnFixing: true,
    
    },
    init: function() {
        this.dataGridInstance.height = window.innerHeight - 200;
        
        this.config.onToolbarPreparing = this.createTableButton.bind(this);
        this.sub = this.messageService.subscribe( 'sendSearchValue', this.getMessageValue, this);
        this.sub = this.messageService.subscribe( 'deleteAssigments', this.deleteAssigments, this);
        this.loadData(this.afterLoadDataHandler);
    },
    getMessageValue: function(message){
        this.searchValue = message.searchValue;
        this.config.query.parameterValues = [
            { key: '@appealNum', value: this.searchValue }
        ]
        this.loadData(this.afterLoadDataHandler);
    },
    createTableButton: function(e) {
        let toolbarItems = e.toolbarOptions.items;
        
        toolbarItems.push({
            widget: "dxButton", 
            options: { 
                icon: "exportxlsx",
                type: "default",
                text: "Excel",
                onClick: function(e) { 
                    e.event.stopImmediatePropagation();
                    let executeQuery = {
                        queryCode: 'ak_EditAssigmetsSearchResult',
                        parameterValues: [ { key: '@appealNum', value: this.searchValue },
                            { key: '@pageOffsetRows', value: 0 },
                            { key: '@pageLimitRows', value: 50 },
                        ],
                        limit: -1
                    };
                    this.queryExecutor(executeQuery, this.createTableExcel, this );
                    
                }.bind(this)
            },
            location: "after"
        });
        toolbarItems.push({
            widget: "dxButton", 
            options: { 
                icon: "trash",
                type: "default",
                text: "Видалити",
                elementAttr: {
                    id: "button_ozpodil",
                },
                onClick: function(e) {
                    e.event.stopImmediatePropagation();
                    let status = 'delete';
                    this.validationCheck(status);
                }.bind(this)
            },
            location: "after"
        });        
        toolbarItems.push({
            widget: "dxButton", 
            options: { 
                icon: "todo",
                type: "default",
                text: "Роз'яснено",
                elementAttr: {
                    id: "button_ozpodil",
                },
                onClick: function(e) {
                    e.event.stopImmediatePropagation();
                    let status = 'understand';
                    this.findAllSelectRows(status);
                }.bind(this)
            },
            location: "after"
        });
        toolbarItems.push({
            widget: "dxButton", 
            options: { 
                icon: "close",
                type: "default",
                text: "Не в компетенції",
                elementAttr: {
                    id: "button_arrived",
                },                
                onClick: function(e) {
                    e.event.stopImmediatePropagation();
                    let status = 'noCompetence';
                    this.findAllSelectRows(status);
                }.bind(this)
            },
            location: "after"
        });
    }, 
    validationCheck: function(status){
        let keys = this.dataGridInstance.selectedRowKeys;
        if(keys.length > 0){
            this.messageService.publish( { name: 'validationCheck', status: status } );
        }
    },
    deleteAssigments: function(message){
        this.findAllSelectRows(message.status);
    },
    findAllSelectRows: function(status){
        let queryCodeValue;
        switch(status){
            case 'noCompetence':
                queryCodeValue = 'ak_EditAssigmentsNoCompetence';
                break
            case 'understand':
                queryCodeValue = 'ak_EditAssigmentsClarified';
                break
            case 'delete':
                queryCodeValue = 'ak_EditAssigmentsDeleteRow';
                break
        }
        let keys = this.dataGridInstance.selectedRowKeys;
        let self = this;
        function makeRequest(index) {
            if(keys[index]){
                let executeQuery = {
                    queryCode: queryCodeValue,
                    parameterValues: [ {key: '@Id', value: keys[index]} ],
                    limit: -1
                };
                self.queryExecutor(executeQuery, requestResponse, this);
            }else{
                self.loadData(self.afterLoadDataHandler); 
            }
            function requestResponse(data){
                return makeRequest(index+1);
            }
        }
        makeRequest(0);
    },
    createTableExcel: function(data){
        this.showPagePreloader('Зачекайте, формується документ');
        this.indexArr = [];

        let columns = this.config.columns;
        columns.forEach( el => {
            let elDataField = el.dataField;
            let elCaption = el.caption;
            for ( i = 0; i < data.columns.length; i ++){
                if( elDataField === data.columns[i].code ){
                    let obj = {
                        name: elDataField,
                        index: i,
                        caption: elCaption
                    }
                    this.indexArr.push(obj);
                }
            }
        });
        const workbook = this.createExcel();
        const worksheet = workbook.addWorksheet('Заявки', {
            pageSetup:{
                orientation: 'landscape',
                fitToPage: false,
            }
        });
        worksheet.pageSetup.margins = {
            left: 0.4, right: 0.3,
            top: 0.4, bottom: 0.4,
            header: 0.0, footer: 0.0
        };
        /*TITLE*/
        let cellInfoCaption = worksheet.getCell('A1');
        worksheet.mergeCells('A1:I1'); //вставить другой конец колонок
        cellInfoCaption.value = 'Редагування доручення';
        worksheet.getRow(1).font = { name: 'Times New Roman', family: 4, size: 15, underline: false, bold: true , italic: false};
        worksheet.getRow(1).alignment = { vertical: 'middle', horizontal: 'center' };

        let indexArr = this.indexArr;
        let rows = [];
        let captions = [];
        let columnsHeader = [];
        let columnNumber = { key: 'number', width: 5 }
        columnsHeader.push(columnNumber);
        let rowNumber = '№ з/п';
        captions.push(rowNumber);

        indexArr.forEach( el => {
            if( el.name === 'Registration_number'){
                let obj =  {
                    key: el.name,
                    width: 12,
                    height: 20,
                };
                columnsHeader.push(obj);
                captions.push('Номеп питання');
            }else if(el.name === 'Ass_registration_date'){
                let obj =  { 
                    key: el.name,
                    width: 12
                };
                columnsHeader.push(obj);
                captions.push('Дата надходження');
            }else if(el.name === 'AssignmentState'){
                let obj =  {
                    key: el.name,
                    width: 14
                };
                columnsHeader.push(obj);
                captions.push('Стан');
            }else if( el.name === 'QuestionType'){
                let obj =  { 
                    key: el.name,
                    width: 16
                };
                columnsHeader.push(obj);
                captions.push('Тип питання');
            }else if( el.name === 'Zayavnyk'){
                let obj =  { 
                    key: el.name,
                    width: 20
                };
                columnsHeader.push(obj);
                captions.push('Заявник'); 
            }else if( el.name === 'Adress'){
                let obj =  { 
                    key: el.name,
                    width: 20
                };
                columnsHeader.push(obj);
                captions.push('Місце проблеми'); 
            }else if( el.name === 'Vykonavets'){
                let obj =  { 
                    key: el.name,
                    width: 20
                };
                columnsHeader.push(obj);
                captions.push('Виконавець'); 
            }else if( el.name === 'Control_date'){
                let obj =  { 
                    key: el.name,
                    width: 10
                };
                columnsHeader.push(obj);
                captions.push('Дата контролю'); 
            }
        });
        worksheet.getRow(2).values = captions;
        worksheet.columns = columnsHeader;
        
        let indexId = data.columns.findIndex(el => el.code.toLowerCase() === 'id' );
        let indexRegistrationNumber = data.columns.findIndex(el => el.code.toLowerCase() === 'registration_number' );
        let indexQuestionType = data.columns.findIndex(el => el.code.toLowerCase() === 'questiontype' );
        let indexZayavnikName = data.columns.findIndex(el => el.code.toLowerCase() === 'zayavnyk' );
        let indexAdress = data.columns.findIndex(el => el.code.toLowerCase() === 'adress' );
        let indexVykonavets = data.columns.findIndex(el => el.code.toLowerCase() === 'vykonavets' );
        let indexQuestionId = data.columns.findIndex(el => el.code.toLowerCase() === 'questionid' );
        let indexZayavnikId = data.columns.findIndex(el => el.code.toLowerCase() === 'zayavnikid' );
        let indexShortAnswer = data.columns.findIndex(el => el.code.toLowerCase() === 'short_answer' );
        let indexQuestionContent = data.columns.findIndex(el => el.code.toLowerCase() === 'Zayavnyk_zmist' );
        let indexAdressZ = data.columns.findIndex(el => el.code.toLowerCase() === 'zayavnyk_adress' );
        let indexRegistrDate = data.columns.findIndex(el => el.code.toLowerCase() === 'ass_registration_date' );
        let indexTransferOrgId = data.columns.findIndex(el => el.code.toLowerCase() === 'transfer_to_organization_id' );
        let indexTransferOrgName = data.columns.findIndex(el => el.code.toLowerCase() === 'transfer_to_organization_name' );        
        let indexControlDate = data.columns.findIndex(el => el.code.toLowerCase() === 'control_date' );               
        let indexAssignmentState = data.columns.findIndex(el => el.code.toLowerCase() === 'assignmentstate' );               
        
        for( let  j = 0; j < data.rows.length; j ++ ){  
            let row = data.rows[j];
            let rowArr = [];
            let rowItem = { number: j + 1 };
            for( i = 0; i < indexArr.length; i ++){
                let el = indexArr[i];
                if( el.name === 'Registration_number'  ){
                    rowItem.Registration_number = row.values[indexRegistrationNumber];
                }else if(el.name === 'Ass_registration_date' ){
                    rowItem.Ass_registration_date = this.changeDateTimeValues(row.values[indexRegistrDate]);
                }else if(el.name === 'AssignmentState' ){
                    rowItem.AssignmentState = row.values[indexAssignmentState];;
                }else if( el.name === 'QuestionType'  ){
                    rowItem.QuestionType = row.values[indexQuestionType];
                }else if( el.name === 'Zayavnyk'  ){
                    rowItem.Zayavnyk = row.values[indexZayavnikName];
                }else if( el.name === 'Adress'  ){
                    rowItem.Adress = row.values[indexAdress];
                }else if( el.name === 'Vykonavets'  ){
                    rowItem.Vykonavets = row.values[indexVykonavets];
                }else if( el.name === 'Control_date'  ){
                    rowItem.Control_date = this.changeDateTimeValues(row.values[indexControlDate]);
                }
            };
            rows.push( rowItem );
        };
        rows.forEach( el => {
            let number = el.number + '.'
            let row = {
                number: number,
                Registration_number: el.Registration_number ,
                Ass_registration_date: el.Ass_registration_date ,
                AssignmentState: el.AssignmentState ,
                QuestionType: el.QuestionType ,
                Zayavnyk: el.Zayavnyk ,
                Adress: el.Adress ,
                Vykonavets: el.Vykonavets ,
                Control_date: el.Control_date 
            }
            worksheet.addRow(row);
        });
        for(let  i = 0; i < rows.length + 1; i++ ){
            let number = i + 2 ;
            let row = worksheet.getRow(number);
            row.height = 100;
            worksheet.getRow(number).border = {
                top: {style:'thin'},
                left: {style:'thin'},
                bottom: {style:'thin'},
                right: {style:'thin'}
            };
            worksheet.getRow(number).alignment = { 
                vertical: 'middle',
                horizontal: 'center',
                wrapText: true 
            };
            worksheet.getRow(number).font = {
                name: 'Times New Roman',
                family: 4, size: 10,
                underline: false,
                bold: false ,
                italic: false
            };
        };
        
        worksheet.getRow(1).border = {
            bottom: {style:'thin'}
        };
        worksheet.getRow(2).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
        worksheet.getRow(2).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };
        this.helperFunctions.excel.save(workbook, 'Заявки', this.hidePagePreloader);
    }, 
    changeDateTimeValues: function(value){
        let trueDate ;
        if( value !== null){
            let date = new Date(value);
            let dd = date.getDate();
            let MM = date.getMonth();
            let yyyy = date.getFullYear();
            let HH = date.getUTCHours()
            let mm = date.getMinutes();
            MM += 1 ;
            if( (dd.toString()).length === 1){  dd = '0' + dd; }
            if( (MM.toString()).length === 1){ MM = '0' + MM ; }
            if( (HH.toString()).length === 1){  HH = '0' + HH; }
            if( (mm.toString()).length === 1){ mm = '0' + mm; }
            trueDate = dd+'.'+MM+'.' + yyyy;
        }else{
            trueDate = ' ';
        }
        return trueDate;
    },      
    afterLoadDataHandler: function(data) {
        this.render();
    },
    destroy:  function(){
        this.sub.unsubscribe();
    },
};
}());
