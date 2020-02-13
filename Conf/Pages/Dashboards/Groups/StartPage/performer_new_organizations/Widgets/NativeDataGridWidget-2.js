(function() {
    return {
        config: {
            query: {
                code: 'NeVKompetentcii',
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
                    caption: 'Тип питання',
                    sortOrder: 'asc',
                    allowSorting: true
                }, {
                    dataField: 'zayavnyk',
                    caption: 'Заявник'
                }, {
                    dataField: 'adress_place',
                    caption: 'Місце проблеми'
                }, {
                    dataField: 'pidlegliy',
                    caption: 'Виконавець'
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
            masterDetail: {
                enabled: true
            },
            filterRow: {
                visible: true,
                applyFilter: 'auto'
            },
            export: {
                enabled: true,
                fileName: 'Excel'
            },
            searchPanel: {
                visible: false,
                highlightCaseSensitive: true
            },
            pager: {
                showPageSizeSelector: false,
                allowedPageSizes: [10, 15, 30],
                showInfo: false,
                pageSize: 10
            },
            editing: {
                mode: 'row',
                allowUpdating: true,
                useIcons: true
            },
            scrolling: {
                mode: 'standart',
                rowRenderingMode: null,
                columnRenderingMode: null,
                showScrollbar: null
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
        childs: [],
        OrganizationId: [],
        elements: [],
        init: function() {
            this.dataGridInstance.height = window.innerHeight - 300;
            this.changedRows = [];
            document.getElementById('table5__NeVKompetentcii').style.display = 'none';
            this.sub = this.messageService.subscribe('clickOnTable2', this.changeOnTable, this);
            this.sub1 = this.messageService.subscribe('messageWithOrganizationId', this.takeOrganizationId, this);
            this.config.masterDetail.template = this.createMasterDetail.bind(this);
            this.dataGridInstance.onCellClick.subscribe(e => {
                if(e.column) {
                    if(e.column.dataField === 'registration_number' && e.row !== undefined) {
                        window.open(String(location.origin + localStorage.getItem('VirtualPath') + '/sections/Assignments/edit/' + e.key));
                    }
                }
            });
            this.config.onToolbarPreparing = this.createTableButton.bind(this);
        },
        changeOnTable: function(message) {
            this.column = message.column;
            this.navigator = message.navigation;
            this.targetId = message.targetId;
            if(message.column !== 'Не в компетенції') {
                document.getElementById('table5__NeVKompetentcii').style.display = 'none';
            }else{
                document.getElementById('table5__NeVKompetentcii').style.display = 'block';
                this.config.query.queryCode = 'NeVKompetentsii';
                this.config.query.parameterValues = [{ key: '@organization_id', value: message.orgId},
                    { key: '@organizationName', value: message.orgName},
                    { key: '@navigation', value: message.navigation}];
                let executeQuery = {
                    queryCode: 'Lookup_NeVKompetencii_PidOrganization',
                    parameterValues: [ {key: '@organization_id', value: this.OrganizationId} ],
                    limit: -1
                };
                this.queryExecutor(executeQuery, this.lookupFoo, this);
            }
        },
        findAllRowsNeVKompetentсii: function() {
            let rows = this.dataGridInstance.instance.getSelectedRowsData();
            if(rows.length > 0) {
                rows.map(el => {
                    let executeQuery = {
                        queryCode: 'Button_NeVKompetentcii',
                        parameterValues: [ {key: '@executor_organization_id', value: el.transfer_to_organization_id},
                            {key: '@Id', value: el.Id} ],
                        limit: -1
                    };
                    this.queryExecutor(executeQuery);
                });
                this.loadData(this.afterLoadDataHandler);
                this.messageService.publish({
                    name: 'reloadMainTable',
                    column: this.column,
                    navigator: this.navigator,
                    targetId: this.targetI
                });
            }
        },
        createTableButton: function(e) {
            let toolbarItems = e.toolbarOptions.items;
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
        createElement: function(tag, props, ...children) {
            const element = document.createElement(tag);
            Object.keys(props).forEach(key => element[key] = props[key]);
            if(children.length > 0) {
                children.forEach(child =>{
                    element.appendChild(child);
                });
            } return element;
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
            this.config.columns[5].lookup.dataSource.store = this.elements;
            this.loadData(this.afterLoadDataHandler);
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
        createMasterDetail: function(container, options) {
            let currentEmployeeData = options.data;
            if(currentEmployeeData.comment === null || currentEmployeeData.comment === undefined) {
                currentEmployeeData.comment = '';
            }
            if(currentEmployeeData.zayavnyk_zmist === null || currentEmployeeData.zayavnyk_zmist === undefined) {
                currentEmployeeData.zayavnyk_zmist = '';
            }
            if(currentEmployeeData.zayavnyk_adress === null || currentEmployeeData.zayavnyk_adress === undefined) {
                currentEmployeeData.zayavnyk_adress = '';
            }
            if(currentEmployeeData.balans_name === null || currentEmployeeData.balans_name === undefined) {
                currentEmployeeData.balans_name = '';
            }
            let elementAdress__content = this.createElement('div',
                {
                    className: 'elementAdress__content content', innerText: String(String(currentEmployeeData.zayavnyk_adress))}
            );
            let elementAdress__caption = this.createElement('div',
                {
                    className: 'elementAdress__caption caption', innerText: 'Адреса заявника'}
            );
            let elementAdress = this.createElement('div',
                {
                    className: 'elementAdress element'
                },
                elementAdress__caption, elementAdress__content
            );
            let elementСontent__content = this.createElement('div',
                {
                    className: 'elementСontent__content content', innerText: String(String(currentEmployeeData.zayavnyk_zmist))}
            );
            let elementСontent__caption = this.createElement('div',
                {
                    className: 'elementСontent__caption caption', innerText: 'Зміст'}
            );
            let elementСontent = this.createElement('div',
                {
                    className: 'elementСontent element'
                },
                elementСontent__caption, elementСontent__content
            );
            let elementBalance__content = this.createElement('div',
                {
                    className: 'elementBalance__content content', innerText: String(String(currentEmployeeData.balans_name))}
            );
            let elementBalance__caption = this.createElement('div',
                {
                    className: 'elementBalance__caption caption', innerText: 'Балансоутримувач'
                }
            );
            let elementBalance = this.createElement('div',
                {
                    className: 'elementСontent element'
                },
                elementBalance__caption, elementBalance__content
            );
            let elementsWrapper = this.createElement('div',
                {
                    className: 'elementsWrapper'}, elementAdress, elementСontent, elementBalance
            );
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
        takeOrganizationId: function(message) {
            this.OrganizationId = message.value;
        },
        destroy: function() {
            this.sub.unsubscribe();
            this.sub1.unsubscribe();
        }
    };
}());
