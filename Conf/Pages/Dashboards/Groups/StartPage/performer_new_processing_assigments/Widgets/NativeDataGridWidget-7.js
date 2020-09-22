(function() {
    return {
        config: {
            query: {
                code: 'Poshuk',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [
                {
                    dataField: 'navigation',
                    caption: 'Джерело надходження'
                }, {
                    dataField: 'registration_number',
                    caption: 'Номер питання',
                    sortOrder: 'asc',
                    width: 150
                }, {
                    dataField: 'states',
                    caption: 'Стан'
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
                    dataField: 'vykonavets',
                    caption: 'Виконавець'
                }, {
                    dataField: 'control_date',
                    caption: 'Дата контролю'
                }
            ],
            filterRow: {
                visible: true,
                applyFilter: 'auto'
            },
            masterDetail: {
                enabled: true
            },
            searchPanel: {
                visible: false,
                highlightCaseSensitive: true
            },
            pager: {
                showPageSizeSelector:  true,
                allowedPageSizes: [10, 15, 30],
                showInfo: true,
                pageSize: 10
            },
            paging: {
                pageSize: 10
            },
            editing: {
                enabled: false
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
        init: function() {
            const context = this;
            this.messageService.publish({ name: 'checkDisplayWidth', context});
            document.getElementById('searchTable').style.display = 'none';
            this.sub = this.messageService.subscribe('resultSearch', this.changeOnTable, this);
            this.sub1 = this.messageService.subscribe('clearInput', this.hideAllTable, this);
            this.sub2 = this.messageService.subscribe('clickOnСoordinator_table', this.hideSearchTable, this);
            this.config.masterDetail.template = this.createMasterDetail.bind(this);
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
        createElement: function(tag, props, ...children) {
            const element = document.createElement(tag);
            Object.keys(props).forEach(key => element[key] = props[key]);
            if(children.length > 0) {
                children.forEach(child =>{
                    element.appendChild(child);
                });
            } return element;
        },
        changeOnTable: function(message) {
            if(message.value !== '') {
                document.getElementById('searchTable').style.display = 'block';
                this.config.query.parameterValues = [
                    { key: '@appealNum', value: message.value},
                    { key: '@organization_id', value: message.orgId}
                ];
                this.loadData(this.afterLoadDataHandler);
                this.dataGridInstance.onCellClick.subscribe(e => {
                    if(e.column.dataField === 'registration_number' && e.row !== undefined) {
                        window.open(String(location.origin + localStorage.getItem('VirtualPath') + '/sections/Assignments/edit/' + e.key));
                    }
                });
            }
        },
        hideAllTable: function() {
            document.getElementById('searchTable').style.display = 'none';
        },
        hideSearchTable: function() {
            document.getElementById('searchTable').style.display = 'none';
            document.getElementById('searchContainer__input').value = '';
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
