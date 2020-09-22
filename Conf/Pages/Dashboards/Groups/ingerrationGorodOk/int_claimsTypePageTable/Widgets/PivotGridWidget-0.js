(function() {
    return {
        config: {
            query: {
                code: 'int_claims_typePageTable',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns:[
                {
                    dataField: 'operation',
                    caption: 'Операція',
                    width: 100
                },{
                    caption: 'ГородОк',
                    alignment: 'center',
                    columns: [
                        {
                            dataField: 'become',
                            caption: 'Було',
                            alignment: 'left'
                        },{
                            dataField: 'it_was',
                            caption: 'Стало',
                            alignment: 'left'
                        }
                    ]
                },
                {
                    dataField: 'is_done',
                    caption: 'Стан',
                    width: 80
                },{
                    dataField: 'comment',
                    caption: 'Коментар'
                }
            ],
            searchPanel: {
                visible: true,
                highlightCaseSensitive: false
            },
            pager: {
                showPageSizeSelector:  false,
                allowedPageSizes: [10, 15, 30],
                showInfo: true,
                pageSize: 10
            },
            export: {
                fileName: 'File_name'
            },
            editing: {
                mode: 'batch',
                allowUpdating: true,
                useIcons: true
            },
            filterRow: {
                visible: false,
                applyFilter: 'auto'
            },
            keyExpr: 'Id',
            showBorders: true,
            showColumnLines: true,
            showRowLines: true,
            remoteOperations: null,
            allowColumnReordering: null,
            rowAlternationEnabled: null,
            columnAutoWidth: null,
            hoverStateEnabled: true,
            columnWidth: null,
            wordWrapEnabled: true,
            allowColumnResizing: true,
            showFilterRow: false,
            showHeaderFilter: false,
            showColumnChooser: true,
            showColumnFixing: true,
            groupingAutoExpandAll: null
        },
        elements: [],
        init: function() {
            this.dataGridInstance.height = window.innerHeight - 100;
            this.loadData(this.afterLoadDataHandler);
            this.dataGridInstance.onRowUpdating.subscribe(function(e) {
                let is_done = e.newData.is_done;
                let key = e.key;
                let comment = e.newData.comment;
                let cat_id = e.oldData.cat_id;
                let saveChange = {
                    queryCode: 'int_btnSaveChange_claims_typeGorodok',
                    limit: -1,
                    parameterValues: [
                        {
                            key: '@key',
                            value: key
                        },{
                            key: '@is_done',
                            value: is_done
                        },{
                            key: '@comment',
                            value: comment
                        },{
                            key: '@cat_id',
                            value: cat_id
                        }
                    ]
                };
                this.queryExecutor(saveChange);
            }.bind(this));
            this.config.onToolbarPreparing = this.createTableButton.bind(this);
        },
        afterLoadDataHandler: function() {
            this.render();
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
        createCustomStyle:function() {
            let element = document.querySelector('.dx-datagrid-save-button');
            element.style.marginRight = '9px';
            element.style.backgroundColor = '#5cb85c';
            element.firstElementChild.firstElementChild.style.color = '#fff';
            element.firstElementChild.lastElementChild.style.color = '#fff';
            element.parentElement.parentElement.classList.remove('dx-toolbar-text-auto-hide');
        },
        createTableButton: function(e) {
            let toolbarItems = e.toolbarOptions.items;
            toolbarItems.push({
                widget: 'dxButton',
                options: {
                    icon: 'exportxlsx',
                    type: 'default',
                    text: 'Excel',
                    onClick: function() {
                        this.dataGridInstance.instance.exportToExcel();
                    }.bind(this)
                },
                location: 'after'
            });
        }
    };
}());
