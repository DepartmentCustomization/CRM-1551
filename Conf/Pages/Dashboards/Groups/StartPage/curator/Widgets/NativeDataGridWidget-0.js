(function() {
    return {
        config: {
            query: {
                code: 'CoordinatorController_NeVKompetentsii',
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
                    fixed: true
                }, {
                    dataField: 'QuestionType',
                    caption: 'Тип питання',
                    fixed: true
                }, {
                    dataField: 'zayavnikName',
                    caption: 'Заявник',
                    fixed: true
                }, {
                    dataField: 'adress',
                    caption: 'Місце проблеми',
                    fixed: true
                }, {
                    dataField: 'vykonavets',
                    caption: 'Виконавець',
                    fixed: true,
                    sortOrder: 'asc'
                }, {
                    dataField: 'control_date',
                    caption: 'Дата контролю',
                    dataType: 'datetime',
                    format: 'dd.MM.yyyy HH:mm'
                }, {
                    dataField: 'transfer_to_organization_id',
                    caption: 'Можливий виконавець',
                    lookup: {
                        dataSource: {
                            paginate: true,
                            store: this.elements
                        },
                        valueExpr: 'ID',
                        displayExpr: 'Name'
                    }
                }
            ],
            loadPanel: {
                enabled: true
            },
            scrolling: {
                mode: 'standart',
                rowRenderingMode: null,
                columnRenderingMode: null,
                showScrollbar: null
            },
            masterDetail: {
                enabled: true
            },
            filterRow: {
                visible: true,
                applyFilter: 'auto'
            },
            export: {
                enabled: false,
                fileName: 'Excel'
            },
            pager: {
                showPageSizeSelector:  true,
                allowedPageSizes: [10, 50, 100, 500],
                showInfo: true
            },
            paging: {
                pageSize: 500
            },
            searchPanel: {
                visible: false,
                highlightCaseSensitive: true
            },
            editing: {
                mode: 'cell',
                allowUpdating: true,
                useIcons: true
            },
            sorting: {
                mode: 'multiple'
            },
            selection: {
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
            this.dataGridInstance.height = window.innerHeight - 305;
            this.showPreloader = false;
            document.getElementById('table5__NeVKompetentsii').style.display = 'none';
            this.sub = this.messageService.subscribe('clickOnСoordinator_table', this.changeOnTable, this);
            this.config.masterDetail.template = this.createMasterDetail.bind(this);
            this.config.onToolbarPreparing = this.createTableButton.bind(this);
            this.config.onContentReady = this.afterRenderTable.bind(this);
            this.config.onCellPrepared = this.onCellPrepared.bind(this);
            this.dataGridInstance.onCellClick.subscribe(e => {
                if(e.column) {
                    if(e.column.dataField === 'registration_number' && e.row !== undefined) {
                        window.open(String(
                            location.origin +
                            localStorage.getItem('VirtualPath') +
                            '/sections/Assignments/edit/' +
                            e.key
                        ));
                    }
                }
            });
        },
        onCellPrepared: function(options) {
            if(options.rowType === 'data') {
                if(options.column.dataField === 'control_date') {
                    const cellDate = options.data.control_date;
                    const date = new Date ();
                    if(cellDate <= date) {
                        options.cellElement.classList.add('expiredControlDate');
                    }
                }
            }
        },
        afterRenderTable: function() {
            this.messageService.publish({ name: 'afterRenderTable', code: this.config.query.code });
        },
        changeOnTable: function(message) {
            if(message.column !== 'Не в компетенції') {
                document.getElementById('table5__NeVKompetentsii').style.display = 'none';
            }else{
                this.navigation = message.value;
                this.column = message.column;
                this.targetId = message.targetId;
                document.getElementById('table5__NeVKompetentsii').style.display = 'block';
                this.config.query.parameterValues = [ { key: '@navigation', value: message.value} ];
                let executeQuery = {
                    queryCode: 'CoordinatorController_PodOrganization',
                    parameterValues: [],
                    limit: -1
                };
                this.queryExecutor(executeQuery, this.lookupFoo, this);
            }
        },
        findAllRowsNeVKompetentсii: function() {
            let rows = this.dataGridInstance.instance.getSelectedRowsData();
            if(rows.length > 0) {
                rows.forEach(function(el) {
                    let executeQuery = {
                        queryCode: 'Button_NeVKompetentcii',
                        parameterValues: [ {key: '@executor_organization_id', value: el.transfer_to_organization_id},
                            {key: '@Id', value: el.Id } ],
                        limit: -1
                    };
                    this.queryExecutor(executeQuery);
                }.bind(this));
            }
            rows = [];
            this.loadData(this.afterLoadDataHandler);
            this.messageService.publish({
                name: 'reloadMainTable',
                navigation: this.navigation,
                column: this.column,
                targetId: this.targetId
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
        createMasterDetail: function(container, options) {
            let currentEmployeeData = options.data;
            if(currentEmployeeData.short_answer === null) {
                currentEmployeeData.short_answer = '';
            }
            if(currentEmployeeData.adressZ === null) {
                currentEmployeeData.adressZ = '';
            }
            if(currentEmployeeData.question_content === null) {
                currentEmployeeData.question_content = '';
            }
            let elementAdress__content = this.createElement('div', {
                className: 'elementAdress__content content',
                innerText: String(String(currentEmployeeData.adressZ))
            });
            let elementAdress__caption = this.createElement('div', {
                className: 'elementAdress__caption caption',
                innerText: 'Адреса заявника'
            });
            let elementAdress = this.createElement('div', {
                className: 'elementAdress element'
            }, elementAdress__caption, elementAdress__content);
            let elementСontent__content = this.createElement('div', {
                className: 'elementСontent__content content',
                innerText: String(String(currentEmployeeData.question_content))
            });
            let elementСontent__caption = this.createElement('div', {
                className: 'elementСontent__caption caption',
                innerText: 'Зміст'
            });
            let elementСontent = this.createElement('div', {
                className: 'elementСontent element'
            }, elementСontent__caption, elementСontent__content);
            let elementComment__content = this.createElement('div', {
                className: 'elementComment__content content',
                innerText: String(String(currentEmployeeData.short_answer))
            });
            let elementComment__caption = this.createElement('div', {
                className: 'elementComment__caption caption',
                innerText: 'Коментар виконавця'
            });
            let elementComment = this.createElement('div', {
                className: 'elementСontent element'
            }, elementComment__caption, elementComment__content);
            let elementsWrapper = this.createElement('div', {
                className: 'elementsWrapper'
            }, elementAdress, elementСontent, elementComment);
            container.appendChild(elementsWrapper);
            let elementsAll = document.querySelectorAll('.element');
            elementsAll = Array.from(elementsAll);
            elementsAll.forEach(el => {
                el.style.display = 'flex';
                el.style.margin = '15px 10px';
            });
            let elementsCaptionAll = document.querySelectorAll('.caption');
            elementsCaptionAll = Array.from(elementsCaptionAll);
            elementsCaptionAll.forEach(el => {
                el.style.minWidth = '200px';
            });
        },
        lookupFoo: function(data) {
            this.elements = [];
            for(let i = 0; i < data.rows.length; i++) {
                let el = data.rows[i];
                let obj = {
                    'ID': el.values[0],
                    'Name': el.values[1]
                }
                this.elements.push(obj);
            }
            this.config.columns[6].lookup.dataSource.store = this.elements;
            this.loadData(this.afterLoadDataHandler);
        },
        afterLoadDataHandler: function() {
            this.render();
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
                        this.exportToExcel();
                    }.bind(this)
                },
                location: 'after'
            });
            toolbarItems.push({
                widget: 'dxButton',
                options: {
                    icon: 'upload',
                    type: 'default',
                    text: 'Передати',
                    onClick: function(e) {
                        e.event.stopImmediatePropagation();
                        this.findAllRowsNeVKompetentсii();
                    }.bind(this)
                },
                location: 'after'
            });
        },
        exportToExcel: function() {
            let exportQuery = {
                queryCode: 'CoordinatorController_NeVKompetentsii',
                limit: -1,
                parameterValues: [
                    { key: '@navigation', value: this.navigation }
                ]
            };
            this.queryExecutor(exportQuery, this.myCreateExcel, this);
        },
        myCreateExcel: function(data) {
            let indexRegistrationNumber = data.columns.findIndex(el => el.code.toLowerCase() === 'registration_number');
            let indexQuestionType = data.columns.findIndex(el => el.code.toLowerCase() === 'questiontype');
            let indexZayavnikName = data.columns.findIndex(el => el.code.toLowerCase() === 'zayavnikname');
            let indexAdress = data.columns.findIndex(el => el.code.toLowerCase() === 'adress');
            let indexVykonavets = data.columns.findIndex(el => el.code.toLowerCase() === 'vykonavets');
            let indexQuestionContent = data.columns.findIndex(el => el.code.toLowerCase() === 'question_content');
            let indexAdressZ = data.columns.findIndex(el => el.code.toLowerCase() === 'adressz');
            this.showPagePreloader('Зачекайте, формується документ');
            this.indexArr = [];
            let column_registration_number = { name: 'registration_number', index: 0 };
            let column_zayavnyk = { name: 'zayavnikName', index: 1 };
            let column_QuestionType = { name: 'QuestionType', index: 2 };
            let column_vykonavets = { name: 'vykonavets', index: 3 };
            let column_adress = { name: 'adress', index: 4 };
            this.indexArr = [
                column_registration_number,
                column_zayavnyk,
                column_QuestionType,
                column_vykonavets,
                column_adress
            ];
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
                'про звернення громадян, ' +
                'що надійшли до Контактного центру ' +
                'міста Києва. Термін виконання …';
            let cellPeriod = worksheet.getCell('A3');
            cellPeriod.value = 'Період вводу з (включно) : дата з … дата по … (Розширений пошук).';
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
                if (el.name === 'registration_number') {
                    let obj = {
                        key: 'registration_number',
                        width: 10,
                        height: 20
                    };
                    columnsHeader.push(obj);
                    captions.push('Номер питання');
                } else if(el.name === 'zayavnikName') {
                    let obj = {
                        key: 'zayavnikName',
                        width: 25
                    };
                    columnsHeader.push(obj);
                    captions.push('Заявник');
                } else if(el.name === 'QuestionType') {
                    let obj = {
                        key: 'QuestionType',
                        width: 52
                    };
                    columnsHeader.push(obj);
                    captions.push('Суть питання');
                } else if(el.name === 'vykonavets') {
                    let obj = {
                        key: 'vykonavets',
                        width: 16
                    };
                    columnsHeader.push(obj);
                    captions.push('Виконавець');
                } else if(el.name === 'adress') {
                    let obj = {
                        key: 'adress',
                        width: 16
                    };
                    columnsHeader.push(obj);
                    captions.push('Місце проблеми (Об\'єкт)');
                }
            });
            worksheet.getRow(5).values = captions;
            worksheet.columns = columnsHeader;
            this.addetedIndexes = [];
            for(let j = 0; j < data.rows.length; j++) {
                let row = data.rows[j];
                let rowItem = { number: j + 1 };
                for(let i = 0; i < indexArr.length; i++) {
                    let el = indexArr[i];
                    if (el.name === 'registration_number') {
                        rowItem.registration_number = row.values[indexRegistrationNumber];
                    } else if(el.name === 'zayavnikName') {
                        rowItem.zayavnikName = row.values[indexZayavnikName] + ' ' + row.values[indexAdressZ];
                    } else if(el.name === 'QuestionType') {
                        rowItem.QuestionType =
                            'Тип питання: ' + row.values[indexQuestionType] +
                            '. Зміст: ' + row.values[indexQuestionContent];
                    } else if(el.name === 'vykonavets') {
                        rowItem.vykonavets = row.values[indexVykonavets]
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
                    zayavnikName: el.zayavnikName,
                    QuestionType: el.QuestionType,
                    vykonavets: el.vykonavets,
                    adress: el.adress
                }
                worksheet.addRow(row);
            });
            for(let i = 0; i < rows.length + 1; i++) {
                let number = i + 5;
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
        destroy: function() {
            this.sub.unsubscribe();
        }
    };
}());
