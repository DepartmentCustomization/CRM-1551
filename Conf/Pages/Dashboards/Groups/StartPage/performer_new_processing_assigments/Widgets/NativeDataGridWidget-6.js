(function() {
    return {
        config: {
            query: {
                code: 'NaDooprNemaMozhlVyk_686',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [
                {
                    dataField: 'registration_number',
                    caption: 'Номер питання',
                    width: 150
                }, {
                    dataField: 'QuestionType',
                    caption: 'Тип питання'
                }, {
                    dataField: 'zayavnyk',
                    caption: 'Заявник'
                }, {
                    dataField: 'adress',
                    caption: 'Місце проблеми'
                }, {
                    dataField: 'control_date',
                    caption: 'Дата контролю',
                    dataType: 'datetime',
                    format: 'dd.MM.yyyy HH:mm'
                }
            ],
            filterRow: {
                visible: true,
                applyFilter: 'auto'
            },
            searchPanel: {
                visible: false,
                highlightCaseSensitive: true
            },
            masterDetail: {
                enabled: true
            },
            pager: {
                showPageSizeSelector: false,
                allowedPageSizes: [10, 15, 30],
                showInfo: false,
                pageSize: 10
            },
            editing: {
                enabled: false,
                allowAdding: false
            },
            scrolling: {
                mode: 'standart',
                rowRenderingMode: null,
                columnRenderingMode: null,
                showScrollbar: null
            },
            selection: {
                mode: 'multiple'
            },
            sorting: {
                mode: 'multiple'
            },
            keyExpr: 'Id',
            focusedRowEnabled: true,
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
            const context = this;
            this.messageService.publish({ name: 'checkDisplayWidth', context});
            document.getElementById('table10_Plan_Programs').style.display = 'none';
            this.sub = this.messageService.subscribe('clickOnTable2', this.changeOnTable, this);
            this.config.masterDetail.template = this.createMasterDetail.bind(this);
            this.config.onToolbarPreparing = this.createTableButton.bind(this);
            this.dataGridInstance.onCellClick.subscribe(e => {
                if(e.column) {
                    if(e.column.dataField === 'registration_number' && e.row !== undefined) {
                        window.open(String(location.origin + localStorage.getItem('VirtualPath') + '/sections/Assignments/edit/' + e.key));
                    }
                }
            });
        },
        createTableButton: function(e) {
            let toolbarItems = e.toolbarOptions.items;
            toolbarItems.push({
                widget: 'dxButton',
                options: {
                    icon: 'exportxlsx',
                    type: 'default',
                    text: 'Excel',
                    onClick: function(e) {
                        e.event.stopImmediatePropagation();
                        this.executeQueryExecutor();
                    }.bind(this)
                },
                location: 'after'
            });
        },
        executeQueryExecutor: function() {
            let exportQuery = {
                queryCode: this.config.query.code,
                limit: -1,
                parameterValues: this.config.query.parameterValues
            };
            this.queryExecutor(exportQuery, this.myCreateExcel, this);
        },
        myCreateExcel: function(data) {
            this.showPagePreloader('Зачекайте, формується документ');
            this.indexArr = [];
            let column_registration_number = { name: 'registration_number', index: 0 };
            let column_zayavnyk = { name: 'zayavnyk', index: 1 };
            let column_ZayavnykZmist = { name: 'zayavnyk_zmist', index: 2 };
            let column_controlDate = { name: 'controlDate', index: 3 };
            let column_address = { name: 'adress', index: 4 };
            this.indexArr = [ column_registration_number, column_zayavnyk, column_ZayavnykZmist, column_controlDate, column_address];
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
            let cellInfoCaption = worksheet.getCell('A1');
            cellInfoCaption.value = 'Інформація';
            let cellInfo = worksheet.getCell('A2');
            cellInfo.value =
                'про звернення громадян, що надійшли до Контактного центру  міста Києва. Термін виконання …';
            let cellPeriod = worksheet.getCell('A3');
            cellPeriod.value = 'Період вводу з (включно) : дата з … дата по … .';
            let cellNumber = worksheet.getCell('A4');
            cellNumber.value = 'Реєстраційний № РДА …';
            worksheet.mergeCells('A1:F1');
            worksheet.mergeCells('A2:F2');
            worksheet.mergeCells('A3:F3');
            worksheet.getRow(1).font = {
                name: 'Times New Roman',
                family: 4,
                size: 10,
                underline: false,
                bold: true,
                italic: false
            };
            worksheet.getRow(1).alignment = { vertical: 'middle', horizontal: 'center' };
            worksheet.getRow(2).font = {
                name: 'Times New Roman',
                family: 4,
                size: 10,
                underline: false,
                bold: true,
                italic: false
            };
            worksheet.getRow(2).alignment = { vertical: 'middle', horizontal: 'center' };
            worksheet.getRow(3).font = {
                name: 'Times New Roman',
                family: 4,
                size: 10,
                underline: false,
                bold: true,
                italic: false
            };
            worksheet.getRow(3).alignment = { vertical: 'middle', horizontal: 'left' };
            worksheet.getRow(4).font = {
                name: 'Times New Roman',
                family: 4,
                size: 10,
                underline: false,
                bold: true,
                italic: false
            };
            worksheet.getRow(5).alignment = { vertical: 'middle', horizontal: 'left' };
            let indexArr = this.indexArr;
            let rows = [];
            let captions = [];
            let columnsHeader = [];
            let columnNumber = { key: 'number', width: 5 }
            columnsHeader.push(columnNumber);
            let rowNumber = '№ з/п';
            captions.push(rowNumber);
            indexArr.forEach(el => {
                let obj = {}
                if(el.name === 'registration_number') {
                    obj.key = 'registration_number';
                    obj.width = 10;
                    obj.height = 20;
                    captions.push('Номер питання');
                }else if(el.name === 'zayavnyk_zmist') {
                    obj.key = 'zayavnyk_zmist';
                    obj.width = 44;
                    captions.push('Суть питання');
                }else if(el.name === 'zayavnyk') {
                    obj.key = 'zayavnyk';
                    obj.width = 30;
                    captions.push('Заявник');
                }else if(el.name === 'controlDate') {
                    obj.key = 'controlDate';
                    obj.width = 16;
                    captions.push('Дата контролю');
                }else if(el.name === 'adress') {
                    obj.key = 'adress';
                    obj.width = 21;
                    captions.push('Місце проблеми (Об\'єкт)');
                }
                columnsHeader.push(obj);
            });
            worksheet.getRow(5).values = captions;
            worksheet.columns = columnsHeader;
            this.addetedIndexes = [];
            let indexRegistrationNumber = data.columns.findIndex(el => el.code.toLowerCase() === 'registration_number');
            let indexZayavnikName = data.columns.findIndex(el => el.code.toLowerCase() === 'zayavnyk');
            let indexAdress = data.columns.findIndex(el => el.code.toLowerCase() === 'adress');
            let indexControlDate = data.columns.findIndex(el => el.code.toLowerCase() === 'control_date');
            let indexQuestionContent = data.columns.findIndex(el => el.code.toLowerCase() === 'zayavnyk_zmist');
            let indexAdressZ = data.columns.findIndex(el => el.code.toLowerCase() === 'zayavnyk_adress');
            for(let j = 0; j < data.rows.length; j++) {
                const row = data.rows[j];
                let rowItem = { number: j + 1 };
                for(let i = 0; i < indexArr.length; i++) {
                    let el = indexArr[i];
                    if (el.name === 'registration_number') {
                        rowItem.registration_number = row.values[indexRegistrationNumber];
                    } else if(el.name === 'zayavnyk') {
                        rowItem.zayavnyk = row.values[indexZayavnikName] + ', ' + row.values[indexAdressZ];
                    } else if(el.name === 'zayavnyk_zmist') {
                        rowItem.zayavnyk_zmist = 'Зміст: ' + row.values[indexQuestionContent];
                    } else if(el.name === 'controlDate') {
                        rowItem.controlDate = 'Дата контролю: ' + this.changeDateTimeValues(row.values[indexControlDate]);
                    } else if(el.name === 'adress') {
                        rowItem.adress = row.values[indexAdress];
                    }
                }
                rows.push(rowItem);
            }
            rows.forEach(el => {
                let number = el.number + '.'
                let row = {
                    number: number,
                    registration_number: el.registration_number,
                    zayavnyk: el.zayavnyk,
                    zayavnyk_zmist: el.zayavnyk_zmist,
                    controlDate: el.controlDate,
                    adress: el.adress
                }
                worksheet.addRow(row);
            });
            for(let i = 0; i < rows.length + 1; i++) {
                let number = i + 5;
                const row = worksheet.getRow(number);
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
            }
            worksheet.getRow(2).border = {
                bottom: {style:'thin'}
            };
            worksheet.getRow(5).font = {
                name: 'Times New Roman',
                family: 4,
                size: 10,
                underline: false,
                bold: true,
                italic: false
            };
            worksheet.getRow(5).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };
            this.helperFunctions.excel.save(workbook, 'Заявки', this.hidePagePreloader);
        },
        changeDateTimeValues: function(value) {
            let date = new Date(value);
            let dd = date.getDate().toString();
            let mm = (date.getMonth() + 1).toString();
            let yyyy = date.getFullYear().toString();
            dd = dd.length === 1 ? '0' + dd : dd;
            mm = mm.length === 1 ? '0' + mm : mm;
            return dd + '.' + mm + '.' + yyyy;
        },
        createMasterDetail: function(container, options) {
            const currentEmployeeData = options.data;
            const name = 'createMasterDetail';
            const fields = {
                zayavnyk_adress: 'Адреса заявника',
                zayavnyk_zmist: 'Зміст',
                balans_name: 'Балансоутримувач'
            };
            this.messageService.publish({
                name, currentEmployeeData, fields, container
            });
        },
        changeOnTable: function(message) {
            if(message.column !== 'План/Програма') {
                document.getElementById('table10_Plan_Programs').style.display = 'none';
            }else{
                document.getElementById('table10_Plan_Programs').style.display = 'block';
                this.config.query.parameterValues = [
                    { key: '@organization_id', value: message.orgId},
                    { key: '@column', value: message.column},
                    { key: '@navigation', value: message.navigation}
                ];
                this.loadData(this.afterLoadDataHandler);
            }
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
        afterLoadDataHandler: function() {
            this.render();
            this.createCustomStyle();
        },
        createCustomStyle: function() {
            let elements = document.querySelectorAll('.dx-datagrid-export-button');
            elements = Array.from(elements);
            elements.forEach(function(element) {
                let spanElement = this.createElement('span', { className: 'dx-button-text', innerText: 'Excel'});
                element.firstElementChild.appendChild(spanElement);
            }.bind(this));
        },
        destroy: function() {
            this.sub.unsubscribe();
        }
    };
}());
