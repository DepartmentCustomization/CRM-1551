(function() {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig:
                    `
                    <div id='reportTitle'>Статистичний звіт за рік чи півріччя</div>
                    <div id='container'></div>
                    `
        ,
        data: [],
        counter: 0,
        excelColumnsStart: 0,
        init: function() {
            this.sub = this.messageService.subscribe('showWarning', this.showWarning, this);
            this.sub1 = this.messageService.subscribe('setData', this.setData, this);
            this.sub2 = this.messageService.subscribe('FiltersParams', this.setFilterParams, this);
        },
        setFilterParams: function(message) {
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
            let btnExcel = this.createElement('button', { id: 'btnExcel', innerText: 'Вигрузити в Excel', disabled: true });
            let btnWrap = this.createElement('div', { className: 'btnWrap' }, btnExcel);
            CONTAINER.appendChild(btnWrap);
            btnExcel.addEventListener('click', event => {
                event.stopImmediatePropagation();
                this.createExcelWorkbook();
            });
        },
        showWarning: function() {
            const CONTAINER = document.getElementById('container');
            const modalBtnTrue = this.createElement('button', { id:'modalBtnTrue', className: 'btn', innerText: 'Сховати'});
            const modalBtnWrapper = this.createElement('div', { id:'modalBtnWrapper', className: 'modalBtnWrapper'}, modalBtnTrue);
            const modalTitle = this.createElement('div', { id:'modalTitle', innerText: 'Оберiть правильну дату!'});
            const modalWindow = this.createElement('div', { id:'modalWindow', className: 'modalWindow'}, modalTitle, modalBtnWrapper);
            const modalWindowWrapper = this.createElement('div', { id:'modalWindowWrapper', className: 'modalWindowWrapper'}, modalWindow);
            CONTAINER.appendChild(modalWindowWrapper);
            modalBtnTrue.addEventListener('click', event => {
                event.stopImmediatePropagation();
                CONTAINER.removeChild(CONTAINER.lastElementChild);
            });
        },
        setData: function(message) {
            let table = {
                data: message.data,
                columns: message.columns
            }
            this.data[message.position] = table;
            this.counter += 1;
            if(this.counter === 5) {
                document.getElementById('btnExcel').disabled = false;
                this.counter = 0;
            }
        },
        createExcelWorkbook: function() {
            const workbook = this.createExcel();
            const worksheet1 = this.createWorksheet(workbook, 'Таблицi 1');
            const worksheet2 = this.createWorksheet(workbook, 'Таблицi 2');
            this.years = [ this.previousYear, this.currentYear];
            this.yearsTemp = [ this.previousYear, this.currentYear];
            this.startStep = 3;
            this.step = 10;
            this.numberRowsArray = [];
            const columnsHeader1 = [];
            for (let i = 0; i < 16; i++) {
                let width = { width: 7 };
                columnsHeader1.push(width);
            }
            worksheet1.columns = columnsHeader1;
            const columnsHeader2 = [{ width: 5 }, { width: 24 }];
            for (let i = 0; i < 14; i++) {
                let width = { width: 7 };
                columnsHeader2.push(width);
            }
            worksheet2.columns = columnsHeader2;
            for (let i = 0; i < this.data.length; i++) {
                const data = this.data[i];
                const columns = data.columns;
                if(i === 0 || i === 1) {
                    if(i === 0) {
                        this.setTableType1Header(columns, worksheet1, data);
                    } else if (i === 1) {
                        this.setTableType2Header(columns, worksheet1, data);
                    }
                    this.setCellValuesStyles(worksheet1);
                    this.numberRowsArray = [];
                } else {
                    this.setTableType3Header(columns, worksheet2, data);
                    this.setCellValuesStyles(worksheet2);
                    this.numberRowsArray = [];
                }
            }
            this.setExcelTitle(worksheet1);
            this.setExcelTitle(worksheet2);
            this.helperFunctions.excel.save(workbook, 'Заявки', this.hidePagePreloader);
        },
        createWorksheet: function(workbook, name) {
            return workbook.addWorksheet(name, {
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
        },
        setExcelTitle: function(worksheet) {
            const title = worksheet.getCell('A1');
            title.value = 'Статистичний звіт за період з ' + this.dateFromViewValues + ' по ' + this.dateToViewValues;
            title.font = { name: 'Times New Roman', family: 4, size: 12, underline: false, bold: true , italic: false};
            title.alignment = { vertical: 'middle', horizontal: 'center', wrapText: false };
            worksheet.mergeCells('A1:N1');
        },
        setTableType1Header: function(columns, worksheet, data) {
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
            this.setHeaderRowValues(data, worksheet, headerHeight);
            this.startStep += 5;
        },
        setTableType2Header: function(columns, worksheet, data) {
            let position = this.excelColumnsStart;
            for (let i = 0; i < columns.length; i++) {
                const column = columns[i];
                const headerBot = this.startStep;
                const headerTop = this.startStep;
                const headerRight = position + column.columns.length;
                const headerLeft = position + 1;
                for (let j = 0; j < column.columns.length; j++) {
                    const element = column.columns[j];
                    const cellBot = this.startStep + 1;
                    const cellTop = this.startStep + 1;
                    position += 1;
                    worksheet.mergeCells(cellTop, position, cellBot, position);
                    const cell = worksheet.getCell(cellTop, position);
                    cell.value = element.caption;
                    this.setCellStyle(cell);
                    this.setRowStyle(cellTop, worksheet, 50);
                }
                worksheet.mergeCells(headerTop, headerLeft, headerBot, headerRight);
                const cell = worksheet.getCell(headerTop, headerLeft);
                cell.value = column.caption;
                this.setCellStyle(cell);
                this.setRowStyle(headerTop, worksheet, 120);
            }
            const headerHeight = 2;
            this.setHeaderRowValues(data, worksheet, headerHeight);
            this.startStep = 3;
        },
        setCellYearsValue: function(subHeader, position, worksheet) {
            for (let i = 0; i < subHeader.columns.length; i++) {
                const year = subHeader.columns[i];
                const yearTop = this.startStep + 2;
                const yearBot = this.startStep + 2;
                const yearPosition = position + i;
                worksheet.mergeCells(yearTop, yearPosition, yearBot, yearPosition);
                const cell = worksheet.getCell(yearTop, yearPosition);
                cell.value = year.caption;
                this.setCellStyle(cell);
                this.setRowStyle(yearTop, worksheet, 50);
            }
        },
        setTableType3Header: function(columns, worksheet, data) {
            let position = this.excelColumnsStart + 1;
            columns.forEach(column => {
                if(column.columns) {
                    const headerTop = this.startStep;
                    const headerBot = this.startStep;
                    const headerLeft = position + 2;
                    const headerRight = position + column.columns.length * 2 + 1;
                    worksheet.mergeCells(headerTop, headerLeft, headerBot, headerRight);
                    const cell = worksheet.getCell(headerTop, headerLeft);
                    cell.value = column.caption;
                    this.setCellStyle(cell);
                    this.setRowStyle(headerTop, worksheet, 50);
                    position = this.setSubHeaders(column, worksheet, position, this.startStep);
                } else {
                    const numberStart = 1;
                    const numberCaption = '№ з\\п';
                    const emptyStart = 2;
                    const emptyCaption = '';
                    this.setStandardCells(numberStart, numberCaption, worksheet);
                    this.setStandardCells(emptyStart, emptyCaption, worksheet);
                }
            });
            const headerHeight = 3;
            this.setHeaderRowValues(data, worksheet, headerHeight);
            this.startStep += this.step + 3;
        },
        setSubHeaders: function(column, worksheet, positionLast, startStep) {
            let position = positionLast;
            for (let i = 0; i < column.columns.length; i++) {
                position += 2;
                const subHeader = column.columns[i];
                const cellBot = startStep + 1;
                const cellTop = startStep + 1;
                const cellLeft = position;
                const cellRight = cellLeft + 1;
                worksheet.mergeCells(cellTop, cellLeft, cellBot, cellRight);
                const cell = worksheet.getCell(cellTop, cellLeft);
                cell.value = subHeader.caption;
                this.setCellYearsValue(subHeader, position, worksheet);
                this.setCellStyle(cell);
                this.setRowStyle(cellTop, worksheet, 130);
            }
            return position;
        },
        setStandardCells: function(start, caption, worksheet) {
            const top = this.startStep;
            const bot = this.startStep + 2;
            const right = this.excelColumnsStart + start;
            const left = this.excelColumnsStart + start;
            worksheet.mergeCells(top, right, bot, left);
            const cell = worksheet.getCell(top, right);
            cell.value = caption;
            this.setCellStyle(cell);
        },
        setCellStyle: function(cell) {
            cell.border = { top: {style:'thin'}, left: {style:'thin'}, bottom: {style:'thin'}, right: {style:'thin'} };
            cell.alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };
            cell.font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: false , italic: false };
        },
        setHeaderRowValues: function(message, worksheet, headerHeight) {
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
        setRowStyle: function(number, worksheet, cellHeight) {
            const height = cellHeight ? cellHeight : 60;
            worksheet.getRow(number).height = height;
            worksheet.getRow(number).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: false , italic: false};
            worksheet.getRow(number).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };
        },
        setCellValuesStyles: function(worksheet) {
            this.numberRowsArray.forEach(row => {
                for (let j = 0; j < row.values.length; j++) {
                    const top = row.number;
                    const left = j + 1;
                    const cell = worksheet.getCell(top, left);
                    this.setCellStyle(cell);
                }
            });
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
            this.sub2.unsubscribe();
        }
    };
}());
