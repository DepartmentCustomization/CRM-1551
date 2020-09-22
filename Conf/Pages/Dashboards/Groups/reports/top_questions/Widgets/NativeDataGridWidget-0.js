(function() {
    return {
        config: {
            query: {
                code: 'db_Report_2',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [
                {
                    dataField: 'Id',
                    caption: '№ п/п',
                    width: 60
                }, {
                    dataField: 'questionType',
                    caption: 'Тип питання'
                }, {
                    dataField: 'questionQty',
                    caption: 'Кількість',
                    alignment: 'center'
                }
            ],
            summary: {
                totalItems: [
                    {
                        column: 'questionQty',
                        summaryType: 'sum',
                        customizeText: function(data) {
                            return 'Разом: ' + data.value;
                        }
                    }
                ]
            },
            keyExpr: 'Id',
            scrolling: {
                mode: 'virtual'
            },
            filterRow: {
                visible: true,
                applyFilter: 'auto'
            },
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
            groupingAutoExpandAll: null
        },
        init: function() {
            this.dataGridInstance.height = window.innerHeight - 150;
            this.sub = this.messageService.subscribe('GlobalFilterChanged', this.getFiltersParams, this);
            this.sub1 = this.messageService.subscribe('showTopQuestions', this.showTopQuestionsTable, this);
            this.sub2 = this.messageService.subscribe('ApplyGlobalFilters', this.applyChanges, this);
            this.config.onToolbarPreparing = this.createTableButton.bind(this);
        },
        showTopQuestionsTable: function() {
            document.getElementById('rep_2_1_top_questions').style.display = 'block';
            document.getElementById('rep_2_2_classifier_questions').style.display = 'none';
        },
        createTableButton: function(e) {
            let toolbarItems = e.toolbarOptions.items;
            toolbarItems.push({
                widget: 'dxButton',
                location: 'after',
                options: {
                    icon: 'exportxlsx',
                    type: 'default',
                    text: 'Excel',
                    onClick: (e) => {
                        e.event.stopImmediatePropagation();
                        let exportQuery = {
                            queryCode: this.config.query.code,
                            limit: -1,
                            parameterValues: this.config.query.parameterValues
                        };
                        this.queryExecutor(exportQuery, this.myCreateExcel, this);
                    }
                }
            });
            toolbarItems.push({
                widget: 'dxButton',
                location: 'after',
                options: {
                    icon: 'arrowright',
                    type: 'default',
                    text: 'До класифікатору питань',
                    onClick: (e) => {
                        e.event.stopImmediatePropagation();
                        this.messageService.publish({ name: 'showClassifierQuestions' });
                    }
                }
            });
        },
        myCreateExcel: function(data) {
            if (data.rows.length > 0) {
                this.showPagePreloader('Зачекайте, формується документ');
                this.indexArr = [];
                let columns = this.config.columns;
                columns.forEach(el => {
                    let elDataField = el.dataField;
                    let elCaption = el.caption;
                    for (let i = 0; i < data.columns.length; i++) {
                        if (elDataField === data.columns[i].code) {
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
                const worksheet = workbook.addWorksheet('«Топ питань', {
                    pageSetup: { orientation: 'portrait', fitToPage: false, fitToWidth: true }
                });
                let cellInfoCaption = worksheet.getCell('A1');
                cellInfoCaption.value = 'Розподіл зверненнь громадян по питанням, ';
                let cellInfo = worksheet.getCell('A2');
                cellInfo.value = ' що надійшли через КБУ "Контактний центр міста Києва.';
                let cellPeriod = worksheet.getCell('A3');
                cellPeriod.value = 'Період вводу з (включно) : дата з ' +
                    this.changeDateTimeValues(this.dateFrom) + ' дата по ' +
                    this.changeDateTimeValues(this.dateTo);
                worksheet.mergeCells('A1:C1');
                worksheet.mergeCells('A2:C2');
                worksheet.mergeCells('A3:C3');
                worksheet.getRow(1).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true, italic: false };
                worksheet.getRow(1).alignment = { vertical: 'middle', horizontal: 'center' };
                worksheet.getRow(2).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true, italic: false };
                worksheet.getRow(2).alignment = { vertical: 'middle', horizontal: 'center' };
                worksheet.getRow(3).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true, italic: false };
                worksheet.getRow(3).alignment = { vertical: 'middle', horizontal: 'center' };
                let indexArr = this.indexArr;
                let rows = [];
                let captions = [];
                let columnsHeader = [];
                let columnNumber = {
                    key: 'number',
                    width: 10
                }
                columnsHeader.push(columnNumber);
                let rowNumber = '№ з/п';
                captions.push(rowNumber);
                indexArr.forEach(el => {
                    if (el.name === 'questionType') {
                        let obj = {
                            key: 'questionType',
                            width: 70,
                            height: 20
                        };
                        columnsHeader.push(obj);
                        captions.push('Тип питання');
                    } else if (el.name === 'questionQty') {
                        let obj = {
                            key: 'questionQty',
                            width: 15
                        };
                        columnsHeader.push(obj);
                        captions.push('Кiлькiсть');
                    }
                });
                worksheet.getRow(5).values = captions;
                worksheet.columns = columnsHeader;
                this.addetedIndexes = [];
                let indexQuestionType = data.columns.findIndex(el => el.code.toLowerCase() === 'questiontype');
                let indexQuestionQty = data.columns.findIndex(el => el.code.toLowerCase() === 'questionqty');
                for (let j = 0; j < data.rows.length; j++) {
                    let row = data.rows[j];
                    let rowItem = { number: j + 1 };
                    for (let i = 0; i < indexArr.length; i++) {
                        let el = indexArr[i];
                        if (el.name === 'questionType') {
                            rowItem.questionType = row.values[indexQuestionType];
                        } else if (el.name === 'questionQty') {
                            rowItem.questionQty = row.values[indexQuestionQty];
                        }
                    }
                    rows.push(rowItem);
                }
                rows.forEach(el => {
                    let number = el.number + '.'
                    let row = {
                        number: number,
                        questionType: el.questionType,
                        questionQty: el.questionQty
                    }
                    worksheet.addRow(row);
                });
                worksheet.pageSetup.margins = {
                    left: 0.4, right: 0.3,
                    top: 0.4, bottom: 0.4,
                    header: 0.0, footer: 0.0
                };
                for (let i = 0; i < rows.length + 1; i++) {
                    let number = i + 5;
                    let row = worksheet.getRow(number);
                    row.height = 100;
                    worksheet.getRow(number).border = {
                        top: { style: 'thin' },
                        left: { style: 'thin' },
                        bottom: { style: 'thin' },
                        right: { style: 'thin' }
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
                        bold: false,
                        italic: false
                    };
                }
                worksheet.getRow(4).border = {
                    bottom: { style: 'thin' }
                };
                worksheet.getRow(5).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true, italic: false };
                worksheet.getRow(5).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };
                this.helperFunctions.excel.save(workbook, 'Заявки', this.hidePagePreloader);
            }
        },
        changeDateTimeValues: function(value) {
            let trueDate;
            if (value !== null) {
                let date = new Date(value);
                let dd = date.getDate();
                let MM = date.getMonth();
                let yyyy = date.getFullYear();
                let HH = date.getUTCHours()
                let mm = date.getMinutes();
                MM += 1;
                if ((dd.toString()).length === 1) {
                    dd = '0' + dd;
                }
                if ((MM.toString()).length === 1) {
                    MM = '0' + MM;
                }
                if ((HH.toString()).length === 1) {
                    HH = '0' + HH;
                }
                if ((mm.toString()).length === 1) {
                    mm = '0' + mm;
                }
                trueDate = dd + '.' + MM + '.' + yyyy;
            } else {
                trueDate = ' ';
            }
            return trueDate;
        },
        applyChanges: function() {
            const msg = {
                name: 'SetFilterPanelState',
                package: {
                    value: false
                }
            };
            this.messageService.publish(msg);
            this.loadData(this.afterLoadDataHandler);
        },
        getFiltersParams: function(message) {
            let period = message.package.value.values.find(f => f.name === 'period').value;
            let questionType = message.package.value.values.find(f => f.name === 'questionTypes').value;
            let questionGroup = message.package.value.values.find(f => f.name === 'questionGroup').value;
            let organization = message.package.value.values.find(f => f.name === 'organization').value;
            let organizationGroup = message.package.value.values.find(f => f.name === 'organizationGroup').value;
            let sources = message.package.value.values.find(f => f.name === 'sources').value;
            if (period !== null) {
                if (period.dateFrom !== '' && period.dateTo !== '') {
                    this.sources = this.extractValues(sources);
                    this.dateFrom = period.dateFrom;
                    this.dateTo = period.dateTo;
                    this.questionType = questionType === null ? 0 : questionType === '' ? 0 : questionType.value;
                    this.questionGroup = questionGroup === null ? 0 : questionGroup === '' ? 0 : questionGroup.value;
                    this.organization = organization === null ? 0 : organization === '' ? 0 : organization.value;
                    this.organizationGroup = organizationGroup === null ? 0 : organizationGroup === '' ? 0 : organizationGroup.value;
                    this.sources = sources.toString() === '' ? '0' : this.sources.toString();
                    if (this.questionType !== 0) {
                        this.config.query.parameterValues = [
                            { key: '@dateFrom', value: this.dateFrom },
                            { key: '@dateTo', value: this.dateTo },
                            { key: '@questionType', value: this.questionType },
                            { key: '@questionGroup', value: this.questionGroup },
                            { key: '@organization', value: this.organization },
                            { key: '@organizationGroup', value: this.organizationGroup },
                            { key: '@sourceId', value: this.sources.toString() }
                        ];
                    }
                }
            }
        },
        extractValues: function(items) {
            if (items.length && items !== '') {
                const valuesList = [];
                items.forEach(item => valuesList.push(item.value));
                return valuesList;
            }
            return [];
        },
        afterLoadDataHandler: function() {
            this.render();
        },
        destroy: function() {
            this.sub.unsubscribe();
            this.sub1.unsubscribe();
            this.sub2.unsubscribe();
        }
    };
}());
