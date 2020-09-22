(function() {
    return {
        config: {
            query: {
                code: 'db_Report_3',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [
                {
                    dataField: 'questionType',
                    caption: 'Тип питання',
                    width: 450
                }, {
                    dataField: 'Golosiivsky',
                    caption: 'Голосіївський',
                    alignment: 'center'
                }, {
                    dataField: 'Darnitsky',
                    caption: 'Дарницький',
                    alignment: 'center'
                }, {
                    dataField: 'Desnyansky',
                    caption: 'Деснянський',
                    alignment: 'center'
                }, {
                    dataField: 'Dnirovsky',
                    caption: 'Дніпровський',
                    alignment: 'center'
                }, {
                    dataField: 'Obolonsky',
                    caption: 'Оболонський',
                    alignment: 'center'
                }, {
                    dataField: 'Pechersky',
                    caption: 'Печерський',
                    alignment: 'center'
                }, {
                    dataField: 'Podilsky',
                    caption: 'Подільський',
                    alignment: 'center'
                }, {
                    dataField: 'Svyatoshinsky',
                    caption: 'Святошинський',
                    alignment: 'center'
                }, {
                    dataField: 'Solomiansky',
                    caption: 'Солом`янський',
                    alignment: 'center'
                }, {
                    dataField: 'Shevchenkovsky',
                    caption: 'Шевченківський',
                    alignment: 'center'
                }, {
                    dataField: 'allQuestionsQty',
                    caption: 'Всього по питанням',
                    alignment: 'center',
                    sorting: 'ask',
                    width: 100
                }
            ],
            summary: {
                totalItems: [
                    {
                        column: 'Golosiivsky',
                        summaryType: 'sum',
                        customizeText: function(data) {
                            return 'Разом: ' + data.value;
                        }
                    }, {
                        column: 'Darnitsky',
                        summaryType: 'sum',
                        customizeText: function(data) {
                            return 'Разом: ' + data.value;
                        }
                    }, {
                        column: 'Desnyansky',
                        summaryType: 'sum',
                        customizeText: function(data) {
                            return 'Разом: ' + data.value;
                        }
                    }, {
                        column: 'Dnirovsky',
                        summaryType: 'sum',
                        customizeText: function(data) {
                            return 'Разом: ' + data.value;
                        }
                    }, {
                        column: 'Obolonsky',
                        summaryType: 'sum',
                        customizeText: function(data) {
                            return 'Разом: ' + data.value;
                        }
                    }, {
                        column: 'Pechersky',
                        summaryType: 'sum',
                        customizeText: function(data) {
                            return 'Разом: ' + data.value;
                        }
                    }, {
                        column: 'Podilsky',
                        summaryType: 'sum',
                        customizeText: function(data) {
                            return 'Разом: ' + data.value;
                        }
                    }, {
                        column: 'Svyatoshinsky',
                        summaryType: 'sum',
                        customizeText: function(data) {
                            return 'Разом: ' + data.value;
                        }
                    }, {
                        column: 'Solomiansky',
                        summaryType: 'sum',
                        customizeText: function(data) {
                            return 'Разом: ' + data.value;
                        }
                    }, {
                        column: 'Shevchenkovsky',
                        summaryType: 'sum',
                        customizeText: function(data) {
                            return 'Разом: ' + data.value;
                        }
                    }, {
                        column: 'allQuestionsQty',
                        summaryType: 'sum',
                        customizeText: function(data) {
                            return 'Разом: ' + data.value;
                        }
                    }
                ]
            },
            sorting: {
                mode: 'none'
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
            groupingAutoExpandAll: null
        },
        init: function() {
            this.sub1 = this.messageService.subscribe('GlobalFilterChanged', this.getFiltersParams, this);
            this.sub2 = this.messageService.subscribe('ApplyGlobalFilters', this.applyChanges, this);
            this.arrayColor = [
                '63be7b',
                '85c87d',
                'a8d27f',
                'cbdc81',
                'ede683',
                'ffdd82',
                'fdc07c',
                'fca377',
                'fa8671',
                'f8696b'
            ];
            this.config.onContentReady = this.afterRenderTable.bind(this);
            this.config.onToolbarPreparing = this.createTableButton.bind(this);
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
                    onClick: function(e) {
                        e.event.stopImmediatePropagation();
                        let exportQuery = {
                            queryCode: this.config.query.code,
                            limit: -1,
                            parameterValues: this.config.query.parameterValues
                        };
                        this.queryExecutor(exportQuery, this.myCreateExcel, this);
                    }.bind(this)
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
                    pageSetup: { orientation: 'landscape', fitToPage: false, fitToWidth: true }
                });
                /*TITLE*/
                let cellInfoCaption = worksheet.getCell('A1');
                cellInfoCaption.value = 'ТОП-10 найпроблемніших питань в розрізі районів';
                let cellPeriod = worksheet.getCell('A2');
                cellPeriod.value = 'Період вводу з (включно) : дата з ' + this.changeDateTimeValues(this.dateFrom) +
                    ' дата по ' + this.changeDateTimeValues(this.dateTo);
                worksheet.mergeCells('A1:M1');
                worksheet.mergeCells('A2:M2');
                worksheet.getRow(1).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true, italic: false };
                worksheet.getRow(1).alignment = { vertical: 'middle', horizontal: 'center' };
                worksheet.getRow(2).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true, italic: false };
                worksheet.getRow(2).alignment = { vertical: 'middle', horizontal: 'center' };
                worksheet.getRow(4).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true, italic: false };
                worksheet.getRow(4).alignment = { vertical: 'middle', horizontal: 'center' };
                let indexArr = this.indexArr;
                let rows = [];
                let rowNumber = '№ з/п';
                let captions = [];
                captions.push(rowNumber);
                let columnsHeader = [];
                let columnNumber = {
                    key: 'number',
                    width: 5
                }
                columnsHeader.push(columnNumber);
                indexArr.forEach(el => {
                    if (el.name === 'questionType') {
                        let obj = {
                            key: el.name,
                            width: 28
                        };
                        columnsHeader.push(obj);
                        captions.push('Тип питання');
                    } else if (el.name === 'Golosiivsky') {
                        let obj = {
                            key: el.name,
                            width: 8
                        };
                        columnsHeader.push(obj);
                        captions.push('Голосіївський');
                    } else if (el.name === 'Darnitsky') {
                        let obj = {
                            key: el.name,
                            width: 8
                        };
                        columnsHeader.push(obj);
                        captions.push('Дарницький');
                    } else if (el.name === 'Desnyansky') {
                        let obj = {
                            key: el.name,
                            width: 8
                        };
                        columnsHeader.push(obj);
                        captions.push('Деснянський');
                    } else if (el.name === 'Dnirovsky') {
                        let obj = {
                            key: el.name,
                            width: 8
                        };
                        columnsHeader.push(obj);
                        captions.push('Дніпровський');
                    } else if (el.name === 'Obolonsky') {
                        let obj = {
                            key: el.name,
                            width: 8
                        };
                        columnsHeader.push(obj);
                        captions.push('Оболонський');
                    } else if (el.name === 'Pechersky') {
                        let obj = {
                            key: el.name,
                            width: 8
                        };
                        columnsHeader.push(obj);
                        captions.push('Печерський');
                    } else if (el.name === 'Podilsky') {
                        let obj = {
                            key: el.name,
                            width: 8
                        };
                        columnsHeader.push(obj);
                        captions.push('Подільський');
                    } else if (el.name === 'Svyatoshinsky') {
                        let obj = {
                            key: el.name,
                            width: 8
                        };
                        columnsHeader.push(obj);
                        captions.push('Святошинський');
                    } else if (el.name === 'Solomiansky') {
                        let obj = {
                            key: el.name,
                            width: 8
                        };
                        columnsHeader.push(obj);
                        captions.push('Солом`янський');
                    } else if (el.name === 'Shevchenkovsky') {
                        let obj = {
                            key: el.name,
                            width: 8
                        };
                        columnsHeader.push(obj);
                        captions.push('Шевченківський');
                    } else if (el.name === 'allQuestionsQty') {
                        let obj = {
                            key: el.name,
                            width: 8
                        };
                        columnsHeader.push(obj);
                        captions.push('Всього по питанням');
                    }
                });
                worksheet.getRow(4).values = captions;
                worksheet.columns = columnsHeader;
                this.addetedIndexes = [];
                let indexQuestionType = data.columns.findIndex(el => el.code.toLowerCase() === 'questiontype');
                let indexGolosiivsky = data.columns.findIndex(el => el.code.toLowerCase() === 'golosiivsky');
                let indexDarnitsky = data.columns.findIndex(el => el.code.toLowerCase() === 'darnitsky');
                let indexDesnyansky = data.columns.findIndex(el => el.code.toLowerCase() === 'desnyansky');
                let indexDnirovsky = data.columns.findIndex(el => el.code.toLowerCase() === 'dnirovsky');
                let indexObolonsky = data.columns.findIndex(el => el.code.toLowerCase() === 'obolonsky');
                let indexPechersky = data.columns.findIndex(el => el.code.toLowerCase() === 'pechersky');
                let indexPodilsky = data.columns.findIndex(el => el.code.toLowerCase() === 'podilsky');
                let indexSvyatoshinsky = data.columns.findIndex(el => el.code.toLowerCase() === 'svyatoshinsky');
                let indexSolomiansky = data.columns.findIndex(el => el.code.toLowerCase() === 'solomiansky');
                let indexShevchenkovsky = data.columns.findIndex(el => el.code.toLowerCase() === 'shevchenkovsky');
                let indexAllQuestionsQty = data.columns.findIndex(el => el.code.toLowerCase() === 'allquestionsqty');
                for (let j = 0; j < data.rows.length; j++) {
                    let row = data.rows[j];
                    let rowItem = { number: j + 1 };
                    for (let i = 0; i < indexArr.length; i++) {
                        let el = indexArr[i];
                        if (el.name === 'questionType') {
                            rowItem.questionType = row.values[indexQuestionType];
                        } else if (el.name === 'Golosiivsky') {
                            rowItem.Golosiivsky = row.values[indexGolosiivsky];
                        } else if (el.name === 'Darnitsky') {
                            rowItem.Darnitsky = row.values[indexDarnitsky];
                        } else if (el.name === 'Desnyansky') {
                            rowItem.Desnyansky = row.values[indexDesnyansky];
                        } else if (el.name === 'Dnirovsky') {
                            rowItem.Dnirovsky = row.values[indexDnirovsky];
                        } else if (el.name === 'Obolonsky') {
                            rowItem.Obolonsky = row.values[indexObolonsky];
                        } else if (el.name === 'Pechersky') {
                            rowItem.Pechersky = row.values[indexPechersky];
                        } else if (el.name === 'Podilsky') {
                            rowItem.Podilsky = row.values[indexPodilsky];
                        } else if (el.name === 'Svyatoshinsky') {
                            rowItem.Svyatoshinsky = row.values[indexSvyatoshinsky];
                        } else if (el.name === 'Solomiansky') {
                            rowItem.Solomiansky = row.values[indexSolomiansky];
                        } else if (el.name === 'Shevchenkovsky') {
                            rowItem.Shevchenkovsky = row.values[indexShevchenkovsky];
                        } else if (el.name === 'allQuestionsQty') {
                            rowItem.allQuestionsQty = row.values[indexAllQuestionsQty];
                        }
                    }
                    rows.push(rowItem);
                }
                rows.forEach(el => {
                    let number = el.number + '.'
                    let row = {
                        number: number,
                        questionType: el.questionType,
                        Golosiivsky: el.Golosiivsky,
                        Darnitsky: el.Darnitsky,
                        Desnyansky: el.Desnyansky,
                        Dnirovsky: el.Dnirovsky,
                        Obolonsky: el.Obolonsky,
                        Pechersky: el.Pechersky,
                        Podilsky: el.Podilsky,
                        Svyatoshinsky: el.Svyatoshinsky,
                        Solomiansky: el.Solomiansky,
                        Shevchenkovsky: el.Shevchenkovsky,
                        allQuestionsQty: el.allQuestionsQty
                    }
                    worksheet.addRow(row);
                });
                worksheet.pageSetup.margins = {
                    left: 0.4, right: 0.3,
                    top: 0.4, bottom: 0.4,
                    header: 0.0, footer: 0.0
                };
                for (let i = 0; i < rows.length + 1; i++) {
                    let number = i + 4;
                    let row = worksheet.getRow(number);
                    row.height = number === 4 ? 100 : 50;
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
                worksheet.getRow(3).border = {
                    bottom: { style: 'thin' }
                };
                worksheet.getRow(4).font = {
                    vertAlign: 'subscript', name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true, italic: false
                };
                worksheet.getRow(4).alignment = { textRotation: +90, vertical: 'middle', horizontal: 'center', wrapText: true };
                let numberTitle = worksheet.getCell('A4');
                let qustTitle = worksheet.getCell('B4');
                numberTitle.alignment = { textRotation: 0, vertical: 'middle', horizontal: 'center', wrapText: true };
                qustTitle.alignment = { textRotation: 0, vertical: 'middle', horizontal: 'center', wrapText: true };
                this.helperFunctions.excel.save(workbook, 'Заявки', this.hidePagePreloader);
            }
        },
        changeDateTimeValues: function(value) {
            if (value !== null) {
                let date = new Date(value);
                let dd = date.getDate().toString();
                let mm = (date.getMonth() + 1).toString();
                let yyyy = date.getFullYear();
                dd = dd.length === 1 ? '0' + dd : dd;
                mm = mm.length === 1 ? '0' + mm : mm;
                return dd + '.' + mm + '.' + yyyy;
            }
            return ' ';
        },
        compareNumeric: function(a, b) {
            if (a > b) {
                return 1;
            }
            return -1;
        },
        getAllIndexes: function(arr, val) {
            let indexes = [];
            for (let i = 0; i < arr.length; i++) {
                let cellValue = arr[i].textContent;
                if (Number(cellValue) === val) {
                    indexes.push(i);
                }
            }
            return indexes;
        },
        afterRenderTable: function() {
            if (this.data.length > 0) {
                const data = this.data;
                this.sortArray = [];
                let rows = document.querySelectorAll('.dx-row');
                let rowsAll = Array.from(rows);
                rowsAll.shift();
                rowsAll.pop();
                data.forEach(row => {
                    let arrRow = [];
                    for (let i = 2; i < row.length; i++) {
                        let value = row[i];
                        arrRow.push(value)
                    }
                    arrRow.sort(this.compareNumeric);
                    this.sortArray.push(arrRow);
                });
                for (let k = 0; k < this.sortArray.length; k++) {
                    let row = this.sortArray[k];
                    for (let j = 0; j < row.length; j++) {
                        let value = row[j];
                        let color = this.arrayColor[j];
                        if (rowsAll[k]) {
                            if (rowsAll[k].children) {
                                let array = Array.prototype.slice.call(rowsAll[k].children);
                                array.pop();
                                let indexes = this.getAllIndexes(array, value);
                                for (let i = 0; i < indexes.length; i++) {
                                    let index = indexes[i];
                                    let cell = array[index];
                                    cell.style.backgroundColor = '#' + color;
                                }
                            }
                        }
                    }
                }
            }
        },
        getFiltersParams: function(message) {
            let period = message.package.value.values.find(f => f.name === 'period').value;
            let questionGroup = message.package.value.values.find(f => f.name === 'questionGroup').value;
            let questionType = message.package.value.values.find(f => f.name === 'questionType').value;
            let organization = message.package.value.values.find(f => f.name === 'organization').value;
            let organizationGroup = message.package.value.values.find(f => f.name === 'organizationGroup').value;
            let sources = message.package.value.values.find(f => f.name === 'sources').value;
            if (period !== null) {
                if (period.dateFrom !== '' && period.dateTo !== '') {
                    this.sources = this.extractValues(sources);
                    this.dateFrom = period.dateFrom;
                    this.dateTo = period.dateTo;
                    this.questionGroup = questionGroup === null ? 0 : questionGroup === '' ? 0 : questionGroup.value;
                    this.questionType = questionType === null ? 0 : questionType === '' ? 0 : questionType.value;
                    this.organization = organization === null ? 0 : organization === '' ? 0 : organization.value;
                    this.organizationGroup = organizationGroup === null ? 0 : organizationGroup === '' ? 0 : organizationGroup.value;
                    this.sources = sources.toString() === '' ? '0' : this.sources.toString();
                    if (this.questionType !== 0) {
                        this.config.query.parameterValues = [
                            { key: '@dateFrom', value: this.dateFrom },
                            { key: '@dateTo', value: this.dateTo },
                            { key: '@questionGroup', value: this.questionGroup },
                            { key: '@questionType', value: this.questionType },
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
        afterLoadDataHandler: function(data) {
            this.data = data;
            this.render();
        },
        destroy: function() {
            this.sub1.unsubscribe();
            this.sub2.unsubscribe();
        }
    };
}());
