(function() {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig:
                    `
                    <div id='container'></div>
                    `
        ,
        init: function() {
            this.sub = this.messageService.subscribe('GlobalFilterChanged', this.getFiltersParams, this);
            this.sub1 = this.messageService.subscribe('setData', this.setData, this);
            this.counter = 0;
        },
        afterViewInit: function() {
            const CONTAINER = document.getElementById('container');
            let reportTitle = this.createElement('div', { id: 'reportTitle', innerText: 'Звіт для метрополітену' });
            let subTitle = this.createElement('div', { id: 'subTitle' });
            CONTAINER.appendChild(reportTitle);
            CONTAINER.appendChild(subTitle);
            subTitle.innerText = 'Статистична інформація за період з ' +
                this.changeDateTimeValues(this.dateFrom) + 'до ' +
                this.changeDateTimeValues(this.dateTo) + ' Виконавець: КП «Київський метрополітен»';
            this.subTitle = subTitle;
            let btnExcel = this.createElement('button', { id: 'btnExcel', innerText: 'Вигрузити в Excel', disabled: true });
            let btnWrap = this.createElement('div', { className: 'btnWrap' }, btnExcel);
            CONTAINER.appendChild(btnWrap);
            btnExcel.addEventListener('click', event => {
                event.stopImmediatePropagation();
                this.createTableExcel();
            });
        },
        getFiltersParams: function(message) {
            let period = message.package.value.values.find(f => f.name === 'period').value;
            if(period !== null) {
                if(period.dateFrom !== '' && period.dateTo !== '') {
                    this.dateFrom = period.dateFrom;
                    this.dateTo = period.dateTo;
                }
                let subTitle = document.getElementById('subTitle');
                if(subTitle !== null) {
                    subTitle.innerText = 'Статистична інформація за період з ' +
                    this.changeDateTimeValues(this.dateFrom) + 'до ' +
                    this.changeDateTimeValues(this.dateTo) + ' Виконавець: КП «Київський метрополітен»';
                }
            }
        },
        setData: function(message) {
            if(message.rep1_data) {
                this.rep1_data = message.rep1_data;
                this.counter += 1;
            }else if(message.rep2_data) {
                this.rep2_data = message.rep2_data;
                this.counter += 1;
            }
            if(this.counter === 2) {
                this.dataArray = [ this.rep1_data, this.rep2_data];
                document.getElementById('btnExcel').disabled = false;
                this.counter = 0;
            }
        },
        createTableExcel: function() {
            this.showPagePreloader('Зачекайте, формується документ');
            const workbook = this.createExcel();
            const worksheet = workbook.addWorksheet('Заявки', {
                pageSetup:{
                    orientation: 'landscape',
                    fitToPage: false
                }
            });
            worksheet.pageSetup.margins = {
                left: 0.4, right: 0.3,
                top: 0.4, bottom: 0.4,
                header: 0.0, footer: 0.0
            };
            worksheet.mergeCells('A1:B1');
            worksheet.mergeCells('A2:B2');
            worksheet.mergeCells('A3:B3');
            let cellInfoCaption = worksheet.getCell('A1');
            cellInfoCaption.value = 'Виконавець: КП «Київський метрополітен»';
            let cellInfo = worksheet.getCell('A2');
            cellInfo.value = 'Статистична інформація за період';
            let cellPeriod = worksheet.getCell('A3');
            cellPeriod.value = 'з ' + this.changeDateTimeValues(this.dateFrom) + 'до ' + this.changeDateTimeValues(this.dateTo);
            worksheet.getRow(1).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
            worksheet.getRow(1).alignment = { vertical: 'middle', horizontal: 'center' };
            worksheet.getRow(2).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
            worksheet.getRow(2).alignment = { vertical: 'middle', horizontal: 'center' };
            worksheet.getRow(3).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
            worksheet.getRow(3).alignment = { vertical: 'middle', horizontal: 'center' };
            let tds = [];
            let tdsCounter = [];
            let mainHeaders = [];
            for(let i = 0; i < this.dataArray.length; i++) {
                let data = this.dataArray[i];
                let name = { key: 'orgName', width: 44 };
                let counter = { key: 'questionQty', width: 15 };
                let captions = ['', 'Кiлькiсть'];
                let columnsHeader = [name, counter];
                worksheet.columns = columnsHeader;
                if(i === 0) {
                    worksheet.getRow(5).values = captions;
                    let firstColumnCaption = worksheet.getCell('A5');
                    firstColumnCaption.value = 'Показники';
                    mainHeaders.push(5);
                    for(let i = 6; i < (data.length + 6); i++) {
                        let value = data[i - 6];
                        let columnText = worksheet.getCell('A' + i);
                        let columnCounter = worksheet.getCell('B' + i);
                        columnText.value = value[1];
                        columnCounter.value = value[2];
                        tds.push('A' + i);
                        tdsCounter.push('B' + i);
                    }
                } else if(i === 1) {
                    this.rowTable1Length = (this.dataArray[0].length + 7);
                    worksheet.getRow(this.rowTable1Length).values = captions;
                    let firstColumnCaption = worksheet.getCell('A' + this.rowTable1Length);
                    firstColumnCaption.value = 'Питання';
                    let summary = [];
                    data.forEach(el => summary.push(el[2]));
                    let result = summary.reduce(function(sum, current) {
                        return sum + current;
                    }, 0);
                    mainHeaders.push(this.rowTable1Length);
                    for(let i = this.rowTable1Length + 1; i < (data.length + this.rowTable1Length + 1); i++) {
                        let value = data[i - (this.rowTable1Length + 1)];
                        let columnText = worksheet.getCell('A' + i);
                        let columnCounter = worksheet.getCell('B' + i);
                        columnText.value = value[1];
                        columnCounter.value = value[2];
                        tds.push('A' + i);
                        tds.push('A' + (i - 1));
                        tdsCounter.push('B' + i);
                        tdsCounter.push('B' + (i - 1));
                    }
                    let dataLength = data.length === 0 ? 0 : data.length;
                    this.sumLength = dataLength + this.rowTable1Length + 1;
                    let allTitle = worksheet.getCell('A' + (this.sumLength));
                    allTitle.value = 'Всього:';
                    let allValue = worksheet.getCell('B' + (this.sumLength));
                    allValue.value = result;
                    mainHeaders.push(this.sumLength);
                }
            }
            for(let i = 0; i < tds.length; i++) {
                let td = tds[i];
                worksheet.getCell(td).border = {
                    top: {style:'thin'},
                    left: {style:'thin'},
                    bottom: {style:'thin'},
                    right: {style:'thin'}
                };
                worksheet.getCell(td).alignment = {
                    vertical: 'middle',
                    horizontal: 'left',
                    wrapText: true
                };
                worksheet.getCell(td).font = {
                    name: 'Times New Roman',
                    family: 4, size: 10,
                    underline: false,
                    bold: false ,
                    italic: false
                };
            }
            for(let i = 0; i < tdsCounter.length; i++) {
                let td = tdsCounter[i];
                worksheet.getCell(td).border = {
                    top: {style:'thin'},
                    left: {style:'thin'},
                    bottom: {style:'thin'},
                    right: {style:'thin'}
                };
                worksheet.getCell(td).alignment = {
                    vertical: 'middle',
                    horizontal: 'center',
                    wrapText: true
                };
                worksheet.getCell(td).font = {
                    name: 'Times New Roman',
                    family: 4, size: 10,
                    underline: false,
                    bold: false ,
                    italic: false
                };
            }
            worksheet.getCell('A5').border = { top: {style:'thin'}, left: {style:'thin'}, bottom: {style:'thin'}, right: {style:'thin'} };
            worksheet.getCell('A' + (this.sumLength)).border = {
                top: {style:'thin'}, left: {style:'thin'}, bottom: {style:'thin'}, right: {style:'thin'}
            };
            worksheet.getCell('B5').border = { top: {style:'thin'}, left: {style:'thin'}, bottom: {style:'thin'}, right: {style:'thin'} };
            worksheet.getCell('B' + (this.sumLength)).border = {
                top: {style:'thin'}, left: {style:'thin'}, bottom: {style:'thin'}, right: {style:'thin'}
            };
            mainHeaders.forEach(number => {
                worksheet.getRow(number).height = 50;
                worksheet.getRow(number).font =
                    { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
                worksheet.getRow(number).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };
            });
            this.helperFunctions.excel.save(workbook, 'Заявки', this.hidePagePreloader);
        },
        changeDateTimeValues: function(value) {
            let date = new Date(value);
            let dd = date.getDate();
            let mm = date.getMonth() + 1;
            let yyyy = date.getFullYear();
            if((dd.toString()).length === 1) {
                dd = '0' + dd;
            }
            if((mm.toString()).length === 1) {
                mm = '0' + mm;
            }
            let trueDate = dd + '.' + mm + '.' + yyyy;
            return trueDate;
        },
        createElement: function(tag, props, ...children) {
            const element = document.createElement(tag);
            Object.keys(props).forEach(key => element[key] = props[key]);
            if(children.length > 0) {
                children.forEach(child =>{
                    element.appendChild(child);
                });
            } return element;
        },
        destroy: function() {
            this.sub.unsubscribe();
            this.sub1.unsubscribe();
        }
    };
}());
