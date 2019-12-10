(function () {
  return {
    title: ' ',
    hint: '',
    formatTitle: function() {},
    customConfig:
                `
                <style>
                #reportTitle{
                    text-align: center;
                    font-size: 20px;
                    font-weight: 600;
                }
                .btnWrap{
                    text-align: center;
                }
                #btnExcel{
                    background-color: rgba(21, 189, 244, 1)!important;
                    border-color: transparent;
                    color: #fff;
                    display: inline-block;
                    cursor: pointer;
                    text-align: center;
                    vertical-align: middle;
                    padding: 7px 18px 8px;
                    border-radius: 5px;  
                    margin: 10px;
                }                
                </style>
                
                 <div id='reportTitle'>Статистичний звіт за рік чи півріччя</div>
                 <div id='container'></div>
                `
    ,

    data: [],

    counter: 0,

    excelColumnsStart: 0,

    init: function() {
        this.sub = this.messageService.subscribe('showWarning', this.showWarning, this);
        this.sub1 = this.messageService.subscribe('setData', this.setData, this );
        this.sub2 = this.messageService.subscribe( 'FiltersParams', this.setFilterParams, this );
    },

    setFilterParams: function (message) {
        this.dateFrom = message.dateFrom;
        this.dateTo = message.dateTo;
        this.previousYear = message.previousYear;
        this.currentYear = message.currentYear;
        this.dateFromViewValues = message.dateFromViewValues;
        this.dateToViewValues = message.dateToViewValues;
    },

    afterViewInit: function() {
        const reportTitle = document.getElementById('reportTitle');
        const organizationNameInput = document.createElement('span');
        reportTitle.appendChild(organizationNameInput);
        organizationNameInput.id = 'organizationName';
        
        let CONTAINER = document.getElementById('container');
        let btnExcel = this.createElement('button', { id: 'btnExcel', innerText: 'Вигрузити в Excel', disabled: true } );
        let btnWrap = this.createElement('div', { className: 'btnWrap' }, btnExcel );
        CONTAINER.appendChild(btnWrap);
        
        btnExcel.addEventListener('click', event => {
            event.stopImmediatePropagation();
            this.createExcelWorkbook();
        });         
    },

    showWarning: function(message) {
        let CONTAINER = document.getElementById('container');
        const modalBtnTrue =  this.createElement('button', { id:'modalBtnTrue', className: 'btn', innerText: 'Сховати'});
        const modalBtnWrapper =  this.createElement('div', { id:'modalBtnWrapper', className: 'modalBtnWrapper'}, modalBtnTrue);
        const modalTitle =  this.createElement('div', { id:'modalTitle', innerText: 'Оберiть правильну дату!'});
        const modalWindow = this.createElement('div', { id:'modalWindow', className: 'modalWindow'}, modalTitle, modalBtnWrapper); 
        const modalWindowWrapper = this.createElement('div', { id:'modalWindowWrapper', className: 'modalWindowWrapper'}, modalWindow); 
        CONTAINER.appendChild(modalWindowWrapper);
        
        modalBtnTrue.addEventListener( 'click', event => {
            let target = event.currentTarget;
            CONTAINER.removeChild(container.lastElementChild);
        });
    },

    setData: function(message) {

        let table = {
            data: message.data,
            columns: message.columns   
        }
        this.data[message.position] = table;
        this.counter += 1;

        if( this.counter === 5 ){
            document.getElementById('btnExcel').disabled = false;
            this.counter = 0;
        }
    },

    createExcelWorkbook: function () {
        const workbook = this.createExcel();
        const worksheet = workbook.addWorksheet('Заявки', {
            pageSetup:{
                orientation: 'landscape',
                fitToPage: false,
                margins: {
                    left: 0.4, right: 0.3,
                    top: 0.4, bottom: 0.4,
                    header: 0.0, footer: 0.0
                }
            }
        });
        this.years = [ this.previousYear, this.currentYear];
        this.yearsTemp = [ this.previousYear, this.currentYear];
        this.startStep = 5;
        this.step = 10;

        this.numberRowsArray = [];
        const columnsHeader = [];
        for (let i = 0; i < 16; i++) {
            let width = { width: 7.8 };
            columnsHeader.push(width);
        }
        worksheet.columns = columnsHeader;
        for (let i = 0; i < this.data.length; i++) {
            const data = this.data[i];
            const columns = data.columns;
            
            if( i === 0) {
                this.setTableType1Header(columns, worksheet, data);
            } else if ( i === 1) {
                this.setTableType2Header(columns, worksheet, data);
            } else {
                this.setTableType3Header(columns, worksheet, data);
            }
        }
        this.setCellValuesStyles(worksheet);
        this.setExcelTitle(worksheet);
        this.helperFunctions.excel.save(workbook, 'Заявки', this.hidePagePreloader);
    },

    setExcelTitle: function (worksheet) {
        const title = worksheet.getCell('A1');
        title.value = 'Статистичний звіт за період з ' + this.dateFromViewValues + ' по ' + this.dateToViewValues;
        title.font = { name: 'Times New Roman', family: 4, size: 12, underline: false, bold: true , italic: false};
        title.alignment = { vertical: 'middle', horizontal: 'center', wrapText: false  };
        worksheet.mergeCells('A1:N1'); 
    },

    setTableType1Header: function (columns, worksheet, data) {
        let position = this.excelColumnsStart - 1;
        for (let i = 0; i < columns.length; i++) {
            const column = columns[i];
            const headerTop = this.startStep;
            const headerBot = this.startStep;
            const headerLeft = position + 2;
            const headerRight = position + column.columns.length * 2 + 1;
            position = this.setSubHeaders(column, worksheet, position, this.startStep);
            worksheet.mergeCells(headerTop, headerLeft, headerBot, headerRight);
            const cell = worksheet.getCell(headerTop, headerLeft);
            cell.value = column.caption;
            this.setCellStyle(cell);
            this.setRowStyle(headerTop, worksheet, 30);
        }
        const headerHeight = 3;
        this.setRowValues(data, worksheet, headerHeight);
        this.startStep += 10;
    },

    setTableType2Header: function (columns, worksheet, data) {
        let position = this.excelColumnsStart;

        for (let i = 0; i < columns.length; i++) {
            const column = columns[i];
            const headerBot = headerTop = this.startStep;
            const headerRight = position + column.columns.length;
            const headerLeft = position + 1;
            for (let j = 0; j < column.columns.length; j++) {
                const element = column.columns[j];
                const cellBot = cellTop = this.startStep + 1;
                position += 1;
                worksheet.mergeCells( cellTop, position, cellBot, position);
                const cell = worksheet.getCell( cellTop, position);
                cell.value = element.caption;
                this.setCellStyle(cell);
                this.setRowStyle(cellTop, worksheet, 50);
            }
            worksheet.mergeCells( headerTop, headerLeft, headerBot, headerRight );
            const cell = worksheet.getCell(headerTop, headerLeft);
            cell.value = column.caption;
            this.setCellStyle(cell);
            this.setRowStyle(headerTop, worksheet, 100);
        }
        const headerHeight = 2;
        this.setRowValues(data, worksheet, headerHeight);
        this.startStep += 7;
    },

    setCellYearsValue: function (subHeader, position, worksheet) {
        for (let i = 0; i < subHeader.columns.length; i++) {
            const year = subHeader.columns[i];
            const yearTop = yearBot = this.startStep + 2;
            const yearPosition = position + i;
            worksheet.mergeCells( yearTop, yearPosition, yearBot, yearPosition);
            const cell = worksheet.getCell( yearTop, yearPosition);
            cell.value = year.caption;
            this.setCellStyle(cell);
            this.setRowStyle(yearTop, worksheet, 50);
        }
    },

    setTableType3Header: function (columns, worksheet, data) {
        let position = this.excelColumnsStart + 1;
        columns.forEach( column => {
            if(column.columns) {
                const headerTop = this.startStep;
                const headerBot = this.startStep;
                const headerLeft = position + 2;
                const headerRight = position + column.columns.length * 2 + 1;     
                worksheet.mergeCells( headerTop, headerLeft, headerBot, headerRight );
                const cell = worksheet.getCell(headerTop, headerLeft);
                cell.value = column.caption;
                this.setCellStyle(cell);
                this.setRowStyle(headerTop, worksheet, 50);
                position = this.setSubHeaders(column, worksheet, position, this.startStep);
            } else {
                const numberStart = 1;
                const numberCaption = '№ з\п';
                const emptyStart = 2;
                const emptyCaption = '';
                this.setStandardCells(numberStart, numberCaption, worksheet);
                this.setStandardCells(emptyStart, emptyCaption, worksheet);
            }
        });
        const headerHeight = 3;
        this.setRowValues(data, worksheet, headerHeight);
        this.startStep += this.step + 8;
    },

    setSubHeaders: function (column, worksheet, position, startStep) {
        for (let i = 0; i < column.columns.length; i++) {
            position += 2;
            const subHeader = column.columns[i];
            const cellBot = cellTop = startStep + 1;
            const cellLeft = position;
            const cellRight = cellLeft + 1;
            worksheet.mergeCells( cellTop, cellLeft, cellBot, cellRight);
            const cell = worksheet.getCell( cellTop, cellLeft);
            cell.value = subHeader.caption;
            this.setCellYearsValue(subHeader, position, worksheet);
            this.setCellStyle(cell);
            this.setRowStyle(cellTop, worksheet, 130);
        }
        return position;
    },

    setStandardCells: function (start, caption, worksheet) {
        const top = this.startStep;
        const bot = this.startStep + 2;
        const right = this.excelColumnsStart + start;
        const left = this.excelColumnsStart + start;
        worksheet.mergeCells( top, right, bot, left);
        const cell = worksheet.getCell( top, right);
        cell.value = caption;
        this.setCellStyle(cell);
    },

    setCellStyle: function (cell) {
        cell.border = {   top: {style:'thin'}, left: {style:'thin'}, bottom: {style:'thin'}, right: {style:'thin'} };
        cell.alignment = { vertical: 'middle', horizontal: 'center', wrapText: true  };
        cell.font = { name: 'Times New Roman', family: 4, size: 10,  underline: false, bold: false , italic: false };
    },

    setRowValues: function (message, worksheet, headerHeight) {
        for (let i = 0; i < message.data.length; i++) {
            const values = message.data[i];
            const number = this.startStep + headerHeight + i;
            const obj = {values, number}
            this.numberRowsArray.push(obj);
            worksheet.getRow(number).values = values;
            const height = 70;
            this.setRowStyle(number, worksheet, height);
        }
    },

    setRowStyle: function (number, worksheet, cellHeight) {
        height = cellHeight ? cellHeight : 60;
        worksheet.getRow(number).height = height;
        worksheet.getRow(number).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: false , italic: false};
        worksheet.getRow(number).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true  };
    },

    setCellValuesStyles: function (worksheet) {
        this.numberRowsArray.forEach( row => {
            for (let j = 0; j < row.values.length; j++) {
                const top = row.number;
                const left = j + 1;
                const cell = worksheet.getCell( top, left);
                this.setCellStyle(cell);
            }
        });
    },

    createTableExcel: function() {
        this.showPagePreloader('Зачекайте, формується документ');
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
        let years = [ this.previousYear, this.currentYear];
        let yearsTemp = [ this.previousYear, this.currentYear];
        let tds = [];
        let mainHeaders = [];
        for(let i = 0; i <  this.dataArray.length; i++){
            let data =  this.dataArray[i];   
               
            if(i === 0){
                let viewValues = [];
                let title = worksheet.getCell('A1');
                title.value = 'Статистичний звіт за період з ' + this.dateToViewValues + ' по ' + this.dateFromViewValues;
                title.font = { name: 'Times New Roman', family: 4, size: 12, underline: false, bold: true , italic: false};
                title.alignment = { vertical: 'middle', horizontal: 'center', wrapText: false  };
                worksheet.mergeCells('A1:N1'); 

                let cellInfoCaption0 = worksheet.getCell('A3');
                cellInfoCaption0.value = 'Кількість звернень:';
                worksheet.mergeCells('A3:F3'); 
                let cellInfoCaption1 = worksheet.getCell('G3');
                cellInfoCaption1.value = 'Результати розгляду звернень:';
                worksheet.mergeCells('G3:N3'); 
                let subCaption1_0 = worksheet.getCell('A4');
                subCaption1_0.value = 'усіх';
                worksheet.mergeCells('A4:B4'); 
                let subCaption1_1 = worksheet.getCell('C4');
                subCaption1_1.value = 'що надійшли поштою (п. 1.1)*';
                worksheet.mergeCells('C4:D4'); 
                let subCaption1_2 = worksheet.getCell('E4');
                subCaption1_2.value = 'на особистому прийомі (п. 1.2)*';
                worksheet.mergeCells('E4:F4'); 
                let subCaption2_0 = worksheet.getCell('G4');
                subCaption2_0.value = 'вирішено позитивно (виконано) п. 9.1';
                worksheet.mergeCells('G4:H4'); 
                let subCaption2_1 = worksheet.getCell('I4');
                subCaption2_1.value = 'відмолено у задоволенні (не виконано) п. 9.2';
                worksheet.mergeCells('I4:J4'); 
                let subCaption2_2 = worksheet.getCell('K4');
                subCaption2_2.value = 'дано роз’яснення п. 9.3';
                worksheet.mergeCells('K4:L4'); 
                let subCaption2_3 = worksheet.getCell('M4');
                subCaption2_3.value = 'інше п. 9.4 - 9.6';
                worksheet.mergeCells('M4:N4'); 
                let captionsArr = [ cellInfoCaption0, cellInfoCaption1,  subCaption1_0, subCaption1_1, subCaption1_2, subCaption2_0, subCaption2_1, subCaption2_2, subCaption2_3];              
                captionsArr.forEach( td => {
                    td.border = {   top: {style:'thin'}, left: {style:'thin'}, bottom: {style:'thin'}, right: {style:'thin'} };
                    td.alignment = { vertical: 'middle', horizontal: 'center', wrapText: true  };
                    td.font = { name: 'Times New Roman', family: 4, size: 10,  underline: false, bold: false , italic: false };
                });
                let years = [];
                for (let i = 0; i < data[0].length / 2; i++) {
                    let element = data[0];
                    yearsTemp.forEach( year => years.push(year));
                }
                worksheet.getRow(5).values = years;
                let rowValues = [];
                data[0].forEach( el => rowValues.push(el));
                worksheet.getRow(6).values = rowValues;
                mainHeaders.push(3);
                mainHeaders.push(4);
                viewValues.push(5);
                viewValues.push(6);
                viewValues.forEach( number => {
                    ['A'+number, 'B'+number, 'C'+number, 'D'+number, 'E'+number, 'F'+number, 'G'+number, 'H'+number, 'I'+number, 'J'+number, 'K'+number, 'L'+number, 'M'+number, 'N'+number ].map(key => {
                        worksheet.getCell(key).border = {   top: {style:'thin'}, left: {style:'thin'}, bottom: {style:'thin'}, right: {style:'thin'} };
                        worksheet.getCell(key).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true  };
                        worksheet.getCell(key).font = { name: 'Times New Roman', family: 4, size: 10,  underline: false, bold: false , italic: false };
                    });
                    worksheet.getRow(number).height = 50;
                    worksheet.getRow(number).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: false , italic: false};
                    worksheet.getRow(number).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true  };
                });                  

            }else if(i === 1){
                let viewValues = [];
                let subCaption3_0 = worksheet.getCell('A10');
                subCaption3_0.value = 'Повторних (п. 2.2)';
                worksheet.mergeCells('A10:B10'); 
                let subCaption3_1 = worksheet.getCell('C10');
                subCaption3_1.value = 'колективних (п. 5.2)';
                worksheet.mergeCells('C10:D10'); 
                let subCaption3_2 = worksheet.getCell('E10');
                subCaption3_2.value = 'від учасників та інвалідів війни, учасників бойових дій (п. 7.1, 7.3, 7.4, 7.5)';
                worksheet.mergeCells('E10:F10'); 
                let subCaption3_3 = worksheet.getCell('G10');
                subCaption3_3.value = 'від інвалідів I, II, III групи (п. 7.7, 7.8, 7.9)';
                worksheet.mergeCells('G10:H10'); 
                let subCaption3_4 = worksheet.getCell('I10');
                subCaption3_4.value = 'від ветеранів праці (п. 7.6)';
                worksheet.mergeCells('I10:J10'); 
                let subCaption3_5 = worksheet.getCell('K10');
                subCaption3_5.value = 'від дітей війни (п. 7.2)';
                worksheet.mergeCells('K10:L10'); 
                let subCaption3_6 = worksheet.getCell('M10');
                subCaption3_6.value = 'від членів багатодітних сімей, одиноких матерів, матерів-героїнь (п. 7.11, 7.12, 7.13)';
                worksheet.mergeCells('M10:N10'); 
                let subCaption3_7 = worksheet.getCell('O10');
                subCaption3_7.value = 'від учасників ліквідації аварії на ЧАЕС та осіб, що потерпіли від Чорнобильської катастрофи (п. 7.14, 7.15)';
                worksheet.mergeCells('O10:P10'); 
                let captionsArr = [ subCaption3_0, subCaption3_1,  subCaption3_2, subCaption3_3, subCaption3_4, subCaption3_5, subCaption3_6, subCaption3_7];               
                captionsArr.forEach( td => {
                    td.border = {   top: {style:'thin'}, left: {style:'thin'}, bottom: {style:'thin'}, right: {style:'thin'} };
                    td.alignment = { vertical: 'middle', horizontal: 'center', wrapText: true  };
                    td.font = { name: 'Times New Roman', family: 4, size: 10,  underline: false, bold: false , italic: false };
                });
                              
                let years = [];
                for (let i = 0; i < data[0].length / 2; i++) {
                    let element = data[0];
                    yearsTemp.forEach( year => years.push(year));
                }
                worksheet.getRow(11).values = years;
                let rowValues = [];
                data[0].forEach( el => rowValues.push(el));
                worksheet.getRow(12).values = rowValues;
                mainHeaders.push(10);
                viewValues.push(11);
                viewValues.push(12);
                viewValues.forEach( number => {
                    ['A'+number, 'B'+number, 'C'+number, 'D'+number, 'E'+number, 'F'+number, 'G'+number, 'H'+number, 'I'+number, 'J'+number, 'K'+number, 'L'+number, 'M'+number, 'N'+number, 'O'+number, 'P'+number  ].map(key => {
                        worksheet.getCell(key).border = {   top: {style:'thin'}, left: {style:'thin'}, bottom: {style:'thin'}, right: {style:'thin'} };
                        worksheet.getCell(key).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true  };
                        worksheet.getCell(key).font = { name: 'Times New Roman', family: 4, size: 10,  underline: false, bold: false , italic: false };
                    });
                    worksheet.getRow(number).height = 50;
                    worksheet.getRow(number).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: false , italic: false};
                    worksheet.getRow(number).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true  };
                });                 
            }else if(i === 2){
                let number = 20;
                let viewValues = [];
                mainHeaders.push(number);
                mainHeaders.push(number+1);
                let caption4 = worksheet.getCell('B'+number);
                caption4.value = 'у тому числі питання:';
                worksheet.mergeCells('B'+number+':O'+number);

                let subCaption4_0 = worksheet.getCell('B'+(number+1));
                subCaption4_0.value = 'Кількість питань,порушених у зверненнях громадян';
                worksheet.mergeCells('B'+(number+1)+':C'+(number+1)); 
                let subCaption4_1 = worksheet.getCell('D'+(number+1));
                subCaption4_1.value = 'аграрної політики і земельних відносин';
                worksheet.mergeCells('D'+(number+1)+':E'+(number+1)); 
                let subCaption4_2 = worksheet.getCell('F'+(number+1));
                subCaption4_2.value = 'транспорту і зв’язку';
                worksheet.mergeCells('F'+(number+1)+':G'+(number+1)); 
                let subCaption4_3 = worksheet.getCell('H'+(number+1));
                subCaption4_3.value = 'фінансової, податкової,митної політики';
                worksheet.mergeCells('H'+(number+1)+':I'+(number+1)); 
                let subCaption4_4 = worksheet.getCell('J'+(number+1));
                subCaption4_4.value = 'соціального захисту';
                worksheet.mergeCells('J'+(number+1)+':K'+(number+1)); 
                let subCaption4_5 = worksheet.getCell('L'+(number+1));
                subCaption4_5.value = 'праціі заробітної плати, охорони праці, промислової безпеки';
                worksheet.mergeCells('L'+(number+1)+':M'+(number+1)); 
                let subCaption4_6 = worksheet.getCell('N'+(number+1));
                subCaption4_6.value = 'охорони здоров’я';
                worksheet.mergeCells('N'+(number+1)+':O'+(number+1)); 
                let captionsArr = [caption4, subCaption4_0, subCaption4_1,  subCaption4_2, subCaption4_3, subCaption4_4, subCaption4_5, subCaption4_6];               
                captionsArr.forEach( td => {
                    td.border = {   top: {style:'thin'}, left: {style:'thin'}, bottom: {style:'thin'}, right: {style:'thin'} };
                    td.alignment = { vertical: 'middle', horizontal: 'center', wrapText: true  };
                    td.font = { name: 'Times New Roman', family: 4, size: 10,  underline: false, bold: false , italic: false };
                });

                let years = [''];
                for (let i = 0; i < 7; i++) {
                    let element = data[0];
                    yearsTemp.forEach( year => years.push(year));
                }
                worksheet.getRow(number+2).values = years;
                for (let i = 0; i < data.length; i++) {
                    rowNumber = number+3+i;
                    let values = data[i];
                    let rowValues = [];
                    values.forEach( el => rowValues.push(el));
                    worksheet.getRow(number+3+i).values = rowValues;
                }
                viewValues.push(number+2);
                viewValues.push(number+3);
                viewValues.push(number+4);
                viewValues.push(number+5);
                viewValues.push(number+6);
                viewValues.push(number+7);
                viewValues.forEach( number => {
                    ['B'+number, 'C'+number, 'D'+number, 'E'+number, 'F'+number, 'G'+number, 'H'+number, 'I'+number, 'J'+number, 'K'+number, 'L'+number, 'M'+number, 'N'+number, 'O'+number  ].map(key => {
                        worksheet.getCell(key).border = {   top: {style:'thin'}, left: {style:'thin'}, bottom: {style:'thin'}, right: {style:'thin'} };
                        worksheet.getCell(key).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true  };
                        worksheet.getCell(key).font = { name: 'Times New Roman', family: 4, size: 10,  underline: false, bold: false , italic: false };
                    });
                    worksheet.getRow(number).height = 50;
                    worksheet.getRow(number).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: false , italic: false};
                    worksheet.getRow(number).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true  };
                }); 

                ['A'+(number+3), 'A'+(number+4), 'A'+(number+5), 'A'+(number+6), 'A'+(number+7)].map(key => {
                    worksheet.getRow(number).height = 70;
                    worksheet.getCell(key).border = { top: {style:'thin'}, left: {style:'thin'}, bottom: {style:'thin'}, right: {style:'thin'} };
                    worksheet.getCell(key).alignment = { vertical: 'middle', horizontal: 'left', wrapText: true  };
                    worksheet.getCell(key).font = { name: 'Times New Roman', family: 4, size: 10,  underline: false, bold: false , italic: false };
                });
            }else if(i === 3){
                let number = 35;
                let viewValues = [];
                mainHeaders.push(number);
                mainHeaders.push(number+1);
                let caption4 = worksheet.getCell('B'+number);
                caption4.value = 'у тому числі питання:';
                worksheet.mergeCells('B'+number+':O'+number);

                let subCaption4_0 = worksheet.getCell('B'+(number+1));
                subCaption4_0.value = 'комунального господарства';
                worksheet.mergeCells('B'+(number+1)+':C'+(number+1)); 
                let subCaption4_1 = worksheet.getCell('D'+(number+1));
                subCaption4_1.value = 'житлової політики';
                worksheet.mergeCells('D'+(number+1)+':E'+(number+1)); 
                let subCaption4_2 = worksheet.getCell('F'+(number+1));
                subCaption4_2.value = 'екології та природних ресурсів';
                worksheet.mergeCells('F'+(number+1)+':G'+(number+1)); 
                let subCaption4_3 = worksheet.getCell('H'+(number+1));
                subCaption4_3.value = 'забезпечення дотримання законності та охорони правопорядку, запобігання дискримінації';
                worksheet.mergeCells('H'+(number+1)+':I'+(number+1)); 
                let subCaption4_4 = worksheet.getCell('J'+(number+1));
                subCaption4_4.value = 'сімейної та гендерної політики, захисту прав дітей';
                worksheet.mergeCells('J'+(number+1)+':K'+(number+1)); 
                let subCaption4_5 = worksheet.getCell('L'+(number+1));
                subCaption4_5.value = 'праціі заробітної плати, охорони праці, промислової безпеки';
                worksheet.mergeCells('L'+(number+1)+':M'+(number+1)); 
                let subCaption4_6 = worksheet.getCell('N'+(number+1));
                subCaption4_6.value = 'освіти, наукової, науково-технічної, інноваційної діяльності та інтелектуальної власності';
                worksheet.mergeCells('N'+(number+1)+':O'+(number+1)); 
                let captionsArr = [caption4, subCaption4_0, subCaption4_1,  subCaption4_2, subCaption4_3, subCaption4_4, subCaption4_5, subCaption4_6];               
                captionsArr.forEach( td => {
                    td.border = {   top: {style:'thin'}, left: {style:'thin'}, bottom: {style:'thin'}, right: {style:'thin'} };
                    td.alignment = { vertical: 'middle', horizontal: 'center', wrapText: true  };
                    td.font = { name: 'Times New Roman', family: 4, size: 10,  underline: false, bold: false , italic: false };
                });

                let years = [''];
                for (let i = 0; i < 6; i++) {
                    let element = data[0];
                    yearsTemp.forEach( year => years.push(year));
                }
                worksheet.getRow(number+2).values = years;
                for (let i = 0; i < data.length; i++) {
                    rowNumber = number+3+i;
                    let values = data[i];
                    let rowValues = [];
                    values.forEach( el => rowValues.push(el));
                    worksheet.getRow(number+3+i).values = rowValues;
                }
                viewValues.push(number+2);
                viewValues.push(number+3);
                viewValues.push(number+4);
                viewValues.push(number+5);
                viewValues.push(number+6);
                viewValues.push(number+7);
                viewValues.forEach( number => {
                    ['B'+number, 'C'+number, 'D'+number, 'E'+number, 'F'+number, 'G'+number, 'H'+number, 'I'+number, 'J'+number, 'K'+number, 'L'+number, 'M'+number, 'N'+number, 'O'+number  ].map(key => {
                        worksheet.getCell(key).border = {   top: {style:'thin'}, left: {style:'thin'}, bottom: {style:'thin'}, right: {style:'thin'} };
                        worksheet.getCell(key).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true  };
                        worksheet.getCell(key).font = { name: 'Times New Roman', family: 4, size: 10,  underline: false, bold: false , italic: false };
                    });
                    worksheet.getRow(number).height = 50;
                    worksheet.getRow(number).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: false , italic: false};
                    worksheet.getRow(number).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true  };
                }); 

                ['A'+(number+3), 'A'+(number+4), 'A'+(number+5), 'A'+(number+6), 'A'+(number+7)].map(key => {
                    worksheet.getRow(number).height = 70;
                    worksheet.getCell(key).border = { top: {style:'thin'}, left: {style:'thin'}, bottom: {style:'thin'}, right: {style:'thin'} };
                    worksheet.getCell(key).alignment = { vertical: 'middle', horizontal: 'left', wrapText: true  };
                    worksheet.getCell(key).font = { name: 'Times New Roman', family: 4, size: 10,  underline: false, bold: false , italic: false };
                });
            }else if(i === 4){
                let number = 50;
                let viewValues = [];
                mainHeaders.push(number);
                mainHeaders.push(number+1);
                let caption4 = worksheet.getCell('B'+number);
                caption4.value = 'у тому числі питання:';
                worksheet.mergeCells('B'+number+':O'+number);

                let subCaption4_0 = worksheet.getCell('B'+(number+1));
                subCaption4_0.value = 'діяльність об’єднань громадян, релігії та міжконфесійних відносин';
                worksheet.mergeCells('B'+(number+1)+':C'+(number+1)); 
                let subCaption4_1 = worksheet.getCell('D'+(number+1));
                subCaption4_1.value = 'діяльність центральних органів виконавчої влади';
                worksheet.mergeCells('D'+(number+1)+':E'+(number+1)); 
                let subCaption4_2 = worksheet.getCell('F'+(number+1));
                subCaption4_2.value = 'діяльність місцевих органів виконавчої влади';
                worksheet.mergeCells('F'+(number+1)+':G'+(number+1)); 
                let subCaption4_3 = worksheet.getCell('H'+(number+1));
                subCaption4_3.value = 'діяльність органів місцевого самоврядування';
                worksheet.mergeCells('H'+(number+1)+':I'+(number+1)); 
                let subCaption4_4 = worksheet.getCell('J'+(number+1));
                subCaption4_4.value = 'державного будівництва, адміністративно-територіального устрою';
                worksheet.mergeCells('J'+(number+1)+':K'+(number+1)); 
                let subCaption4_5 = worksheet.getCell('L'+(number+1));
                subCaption4_5.value = 'інші';
                worksheet.mergeCells('L'+(number+1)+':M'+(number+1)); 
                let subCaption4_6 = worksheet.getCell('N'+(number+1));
                subCaption4_6.value = 'Штатна чисельність роботи підрозділу зі зверненнями громадян';
                worksheet.mergeCells('N'+(number+1)+':O'+(number+1)); 
                let captionsArr = [caption4, subCaption4_0, subCaption4_1,  subCaption4_2, subCaption4_3, subCaption4_4, subCaption4_5, subCaption4_6];               
                captionsArr.forEach( td => {
                    td.border = {   top: {style:'thin'}, left: {style:'thin'}, bottom: {style:'thin'}, right: {style:'thin'} };
                    td.alignment = { vertical: 'middle', horizontal: 'center', wrapText: true  };
                    td.font = { name: 'Times New Roman', family: 4, size: 10,  underline: false, bold: false , italic: false };
                });

                let years = [''];
                for (let i = 0; i < 7; i++) {
                    let element = data[0];
                    yearsTemp.forEach( year => years.push(year));
                }
                worksheet.getRow(number+2).values = years;
                for (let i = 0; i < data.length; i++) {
                    rowNumber = number+3+i;
                    let values = data[i];
                    let rowValues = [];
                    values.forEach( el => rowValues.push(el));
                    worksheet.getRow(number+3+i).values = rowValues;
                }
                viewValues.push(number+2);
                viewValues.push(number+3);
                viewValues.push(number+4);
                viewValues.push(number+5);
                viewValues.push(number+6);
                viewValues.push(number+7);
                viewValues.forEach( number => {
                    ['B'+number, 'C'+number, 'D'+number, 'E'+number, 'F'+number, 'G'+number, 'H'+number, 'I'+number, 'J'+number, 'K'+number, 'L'+number, 'M'+number, 'N'+number, 'O'+number  ].map(key => {
                        worksheet.getCell(key).border = {   top: {style:'thin'}, left: {style:'thin'}, bottom: {style:'thin'}, right: {style:'thin'} };
                        worksheet.getCell(key).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true  };
                        worksheet.getCell(key).font = { name: 'Times New Roman', family: 4, size: 10,  underline: false, bold: false , italic: false };
                    });
                    worksheet.getRow(number).height = 50;
                    worksheet.getRow(number).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: false , italic: false};
                    worksheet.getRow(number).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true  };
                }); 

                ['A'+(number+3), 'A'+(number+4), 'A'+(number+5), 'A'+(number+6), 'A'+(number+7)].map(key => {
                    worksheet.getRow(number).height = 70;
                    worksheet.getCell(key).border = { top: {style:'thin'}, left: {style:'thin'}, bottom: {style:'thin'}, right: {style:'thin'} };
                    worksheet.getCell(key).alignment = { vertical: 'middle', horizontal: 'left', wrapText: true  };
                    worksheet.getCell(key).font = { name: 'Times New Roman', family: 4, size: 10,  underline: false, bold: false , italic: false };
                });
            }
            mainHeaders.forEach( number => {
                worksheet.getRow(number).height = 70;
                worksheet.getRow(number).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
                worksheet.getRow(number).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true  };
            });
        }
        worksheet.getRow(1).height = 70;
        worksheet.getRow(21).height = 100;
        worksheet.getRow(10).height = 150;
        worksheet.getRow(36).height = 150;
        worksheet.getRow(51).height = 150;
        this.helperFunctions.excel.save(workbook, 'Заявки', this.hidePagePreloader);
    },
       
	createElement: function(tag, props, ...children) {
        const element = document.createElement(tag);
        Object.keys(props).forEach( key => element[key] = props[key] );
        if(children.length > 0){
            children.forEach( child =>{
                element.appendChild(child);
            });
        } return element;
    },

    destroy: function(){
        this.sub.unsubscribe();
        this.sub1.unsubscribe();
        this.sub2.unsubscribe();
    },
};
}());
