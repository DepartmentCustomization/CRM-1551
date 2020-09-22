(function() {
    return {
        config: {
            query: {
                code: 'h_Coordinator_Poshuk',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [
                {
                    dataField: 'registration_number',
                    caption: 'Номер питання'
                }, {
                    dataField: 'registration_date',
                    caption: 'Дата реєстрації',
                    sortOrder: 'asc'
                }, {
                    dataField: 'QuestionType',
                    caption: 'Тип питання'
                }, {
                    dataField: 'place_problem',
                    caption: 'Місце проблеми'
                }, {
                    dataField: 'control_date',
                    caption: 'Дата контролю'
                }, {
                    dataField: 'vykonavets',
                    caption: 'Виконавець'
                }, {
                    dataField: 'comment',
                    caption: 'Коментар'
                }
            ],
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
            masterDetail: {
                enabled: true
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
            this.dataGridInstance.height = window.innerHeight - 405;
            this.showPreloader = false;
            document.getElementById('finder').style.display = 'none';
            this.subscribers.push(this.messageService.subscribe('resultSearch', this.resultSearch, this));
            this.subscribers.push(this.messageService.subscribe('hideSearchTable', this.hideSearchTable, this));
            this.config.masterDetail.template = this.createMasterDetail.bind(this);
            this.config.onContentReady = this.afterRenderTable.bind(this);
            this.dataGridInstance.onCellClick.subscribe(e => {
                if(e.column.dataField === 'registration_number' && e.row !== undefined) {
                    window.open(`
                        ${location.origin}
                        ${localStorage.getItem('VirtualPath')}
                        /sections/Assignments/edit/
                        ${e.key}
                    `)
                }
            });
        },
        createMasterDetail: function(container, options) {
            const currentEmployeeData = options.data;
            const name = 'createMasterDetail';
            const fields = {
                zayavnyk: 'Заявник',
                ZayavnykAdress: 'Адреса заявника',
                content: 'Зміст'
            };
            this.messageService.publish({
                name, currentEmployeeData, fields, container
            });
        },
        afterRenderTable: function() {
            this.messageService.publish({ name: 'afterRenderTable', code: this.config.query.code });
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
        resultSearch: function(message) {
            document.getElementById('finder').style.display = 'block';
            this.config.query.parameterValues = [{ key: '@appealNum', value: message.appealNum}];
            this.loadData(this.afterLoadDataHandler);
        },
        hideSearchTable: function() {
            document.getElementById('finder').style.display = 'none';
        },
        afterLoadDataHandler: function() {
            this.render();
        }
    };
}());
