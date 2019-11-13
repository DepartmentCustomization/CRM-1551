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
    init: function() {
        this.sub = this.messageService.subscribe('showWarning', this.showWarning, this);
        this.sub1 = this.messageService.subscribe('setData', this.setData, this );
        this.sub2 = this.messageService.subscribe('GlobalFilterChanged', this.getFilterParams, this );
    },
    getFilterParams: function (message) {
        let period = message.package.value.values.find(f => f.name === 'period').value;
        if( period !== null ){
            if( period.dateFrom !== '' && period.dateTo !== ''){
                this.dateFrom =  period.dateFrom;
                this.dateTo = period.dateTo;
                let  datePrev = new Date(this.dateFrom);   
                let  dateCurr = new Date(this.dateTo);               
                this.previousYear = datePrev.getFullYear();
                this.currentYear =  dateCurr.getFullYear();
                this.previousYear = this.currentYear === this.previousYear ? this.currentYear - 1 : this.previousYear;
                this.dateFromViewValues = this.changeDateTimeValues(this.dateFrom);
                this.dateToViewValues = this.changeDateTimeValues(this.dateTo);
            }
        }
    },
    afterViewInit: function(data) {
        const reportTitle = document.getElementById('reportTitle');
        const organizationNameInput = document.createElement('span');
        reportTitle.appendChild(organizationNameInput);
        organizationNameInput.id = 'organizationName';
        
        
        let CONTAINER = document.getElementById('container');
        this.counter = 0
        let btnExcel = this.createElement('button', { id: 'btnExcel', innerText: 'Вигрузити в Excel', disabled: true } );
        let btnWrap = this.createElement('div', { className: 'btnWrap' }, btnExcel );
        CONTAINER.appendChild(btnWrap);
        
        btnExcel.addEventListener('click', event => {
            event.stopImmediatePropagation();
            this.createTableExcel();
        });         
    },
    setYears: function (message) {
        this.previousYear = message.previousYear;
        this.currentYear = message.currentYear;
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
    setData: function(message){
        if( message.rep1_data){
            this.rep1_data =  message.rep1_data;
            this.counter += 1;
        }else if( message.rep2_data){
            this.rep2_data =  message.rep2_data;
            this.counter += 1;
        }else if( message.rep3_data){
            this.rep3_data =  message.rep3_data;
            this.counter += 1;
        }else if( message.rep4_data){
            this.rep4_data =  message.rep4_data;
            this.counter += 1;
        }else if( message.rep5_data){
            this.rep5_data =  message.rep5_data;
            this.counter += 1;
        }
        if( this.counter === 5 ){
            this.dataArray = [ this.rep1_data, this.rep2_data, this.rep3_data, this.rep4_data, this.rep5_data];
            document.getElementById('btnExcel').disabled = false;
            this.counter = 0;
        }
    },
    createTableExcel: function(){
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
    changeDateTimeValues: function(value){
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
        let trueDate = dd+'.'+MM+'.' + yyyy;
        return trueDate;
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
