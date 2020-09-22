(function() {
    return {
        config: {
            query: {
                code: 'DynamicsRDARatin_table',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columnChooser: {
                enabled: true
            },
            columns: [
                {
                    dataField: 'OrganizationName',
                    caption: 'Назва установи',
                    width:200
                },
                {
                    caption: '% вчасно закритих',
                    alignment: 'center',
                    cssClass: 'column-violet column',
                    columns: [
                        {
                            dataField: 'avg_PercentClosedOnTime_with_1',
                            caption: `${this.firstColumnValue}`,
                            cssClass: 'column-violet column',
                            alignment: 'center'
                        },
                        {
                            dataField: 'avg_PercentClosedOnTime_with_filter',
                            caption: this.secondColumnValue,
                            cssClass: 'column-violet column',
                            alignment: 'center'
                        },
                        {
                            dataField: 'avg_PercentClosedOnTime_dyn',
                            caption: 'Динаміка',
                            cssClass: 'column-violet column',
                            alignment: 'center'
                        }]
                },
                {
                    caption: '% виконання',
                    alignment: 'center',
                    cssClass: 'column-green column',
                    columns: [
                        {
                            dataField: 'avg_PercentOfExecution_with_1',
                            caption: '01.08-06.08',
                            cssClass: 'column-green column',
                            alignment: 'center'
                        },
                        {
                            dataField: 'avg_PercentOfExecution_with_filter',
                            caption: '05.08-06.08',
                            cssClass: 'column-green column',
                            alignment: 'center'
                        },
                        {
                            dataField: 'avg_PercentOfExecution_dyn',
                            caption: 'Динаміка',
                            cssClass: 'column-green column',
                            alignment: 'center'
                        }]
                }
                ,
                {
                    caption: '% достовірності',
                    alignment: 'center',
                    cssClass: 'column-red column',
                    columns: [
                        {
                            dataField: 'avg_PercentOnVeracity_with_1',
                            caption: '01.08-06.08',
                            cssClass: 'column-red column',
                            alignment: 'center'
                        },
                        {
                            dataField: 'avg_PercentOnVeracity_with_filter',
                            caption: '05.08-06.08',
                            cssClass: 'column-red column',
                            alignment: 'center'
                        },
                        {
                            dataField: 'avg_PercentOnVeracity_dyn',
                            caption: 'Динаміка',
                            cssClass: 'column-red column',
                            alignment: 'center'
                        }]
                }
                ,
                {
                    caption: 'Індекс швидкості виконання',
                    alignment: 'center',
                    cssClass: 'column-olive column',
                    columns: [
                        {
                            dataField: 'avg_IndexOfSpeedToExecution_with_1',
                            caption: '01.08-06.08',
                            cssClass: 'column-olive column',
                            alignment: 'center'
                        },
                        {
                            dataField: 'avg_IndexOfSpeedToExecution_with_filter',
                            caption: '05.08-06.08',
                            cssClass: 'column-olive column',
                            alignment: 'center'
                        },
                        {
                            dataField: 'avg_IndexOfSpeedToExecution_dyn',
                            caption: 'Динаміка',
                            cssClass: 'column-olive column',
                            alignment: 'center'
                        }]
                }
                ,
                {
                    caption: 'Індекс швидкості розяснення',
                    alignment: 'center',
                    cssClass: 'column-orange column',
                    columns: [
                        {
                            dataField: 'avg_IndexOfSpeedToExplain_with_1',
                            caption: '01.08-06.08',
                            cssClass: 'column-orange column',
                            alignment: 'center'
                        },
                        {
                            dataField: 'avg_IndexOfSpeedToExplain_with_filter',
                            caption: '05.08-06.08',
                            cssClass: 'column-orange column',
                            alignment: 'center'
                        },
                        {
                            dataField: 'avg_IndexOfSpeedToExplain_dyn',
                            caption: 'Динаміка',
                            cssClass: 'column-orange column',
                            alignment: 'center'
                        }]
                }
                ,
                {
                    caption: 'Фактичне виконання',
                    alignment: 'center',
                    cssClass: 'column-blue column',
                    columns: [
                        {
                            dataField: 'avg_IndexOfFactToExecution_with_1',
                            caption: '01.08-06.08',
                            cssClass: 'column-blue column',
                            alignment: 'center'
                        },
                        {
                            dataField: 'avg_IndexOfFactToExecution_with_filter',
                            caption: '05.08-06.08',
                            cssClass: 'column-blue column',
                            alignment: 'center'
                        },
                        {
                            dataField: 'avg_IndexOfFactToExecution_dyn',
                            caption: 'Динаміка',
                            cssClass: 'column-blue column',
                            alignment: 'center'
                        }]
                },
                {
                    caption: '% задоволеність виконанням',
                    alignment: 'center',
                    cssClass: 'column-grey column',
                    columns: [
                        {
                            dataField: 'avg_PercentPleasureOfExecution_with_1',
                            caption: '01.08-06.08',
                            cssClass: 'column-grey column',
                            alignment: 'center'
                        },
                        {
                            dataField: 'avg_PercentPleasureOfExecution_with_filter',
                            caption: '05.08-06.08',
                            cssClass: 'column-grey column',
                            alignment: 'center'
                        },
                        {
                            dataField: 'avg_PercentPleasureOfExecution_dyn',
                            caption: 'Динаміка',
                            cssClass: 'column-grey column',
                            alignment: 'center'
                        }]
                }
            ],
            export: {
                enabled: true,
                fileName: 'Динаміка показників рейтингу РДА по організаціях РДА'
            },
            focusedRowEnabled: true,
            showRowLines: true,
            wordWrapEnabled: true,
            showBorders: false,
            showColumnLines: true,
            remoteOperations: null,
            allowColumnReordering: null,
            rowAlternationEnabled: null,
            columnAutoWidth: null,
            columnWidth: null,
            allowColumnResizing: true,
            showFilterRow: true,
            showHeaderFilter: false,
            showColumnChooser: false,
            showColumnFixing: true,
            groupingAutoExpandAll: null,
            keyExpr: 'Id'
        },
        init: function() {
            this.sub = this.messageService.subscribe('GlobalFilterChanged', this.getFiltersParams, this);
            this.sub = this.messageService.subscribe('ApplyGlobalFilters',this.renderTable , this);
            this.config.onCellPrepared = this.onCellPrepared.bind(this)
            this.applyChanges(true)
            this.config.onToolbarPreparing = this.createTableButton.bind(this);
        },
        onCellPrepared(e) {
            e.cellElement.style.verticalAlign = 'middle'
            if(e.rowType === 'data' && e.column.caption === 'Динаміка') {
                if(e.cellElement.textContent.includes('+')) {
                    e.cellElement.style.backgroundColor = 'green'
                } else if(e.cellElement.textContent.includes('-')) {
                    e.cellElement.style.backgroundColor = 'red'
                }
            }
        },
        applyChanges: function(state) {
            const msg = {
                name: 'SetFilterPanelState',
                package: {
                    value: state
                }
            };
            this.messageService.publish(msg);
        },
        destroy: function() {
            this.sub.unsubscribe();
        },
        getFiltersParams: function(message) {
            const period = message.package.value.values.find(f => f.name === 'period').value;
            const rdaDepts = message.package.value.values.find(f => f.name === 'rda-depts').value;
            const rating = message.package.value.values.find(f => f.name === 'rating').value;
            if(period !== null) {
                if(period.dateFrom !== '' && period.dateTo !== '') {
                    if(rdaDepts) {
                        this.deptsValue = rdaDepts.value
                    }
                    if(rating) {
                        this.rating = rating.value
                    }
                    this.dateFrom = period.dateFrom;
                    this.dateTo = period.dateTo;
                    this.config.query.parameterValues = [
                        {key: '@date_from' , value: this.dateFrom },
                        {key: '@date_to' , value: this.dateTo },
                        {key: '@rda_id', value: this.deptsValue},
                        {key: '@rating_id', value: this.rating}
                    ];
                }
            }
            this.setDate(this.dateFrom, this.dateTo)
        },
        convertDateTime: function(dateTime) {
            const date = new Date(dateTime);
            const mm = ('0' + (date.getMonth() + 1)).slice(-2);
            const dd = ('0' + date.getDate()).slice(-2);
            return dd + '.' + mm;
        },
        setDate(dateFrom,dateTo) {
            const dateNowFrom = this.convertDateTime(dateFrom)
            const dateNowTo = this.convertDateTime(dateTo)
            const dateFromBefore = dateFrom - 1
            const dateFromBeforeValue = this.convertDateTime(dateFromBefore)
            const dateNow = new Date(dateFrom);
            const dateMonth = dateNow.getMonth();
            const dateYear = dateNow.getFullYear();
            const firstColumnFrom = new Date(dateYear,`${dateNowFrom.slice(0,2) === '01' ? dateMonth - 1 : dateMonth}`, '01', '00', '00');
            const convertFirstColumnDate = this.convertDateTime(firstColumnFrom)

            const firstColumnValue = `${convertFirstColumnDate}-${dateFromBeforeValue}`;
            const secondColumnValue = `${dateNowFrom}-${dateNowTo}`;
            this.config.columns.forEach(elem=>{
                if(elem.columns) {
                    elem.columns[0].caption = firstColumnValue;
                    elem.columns[1].caption = secondColumnValue;
                }
            })
            this.setColors()
        },
        setColors() {
            this.config.columns.forEach(elem=>{
                elem.BackColor = 'red'
            })
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
                    onClick: function() {
                        this.dataGridInstance.instance.exportToExcel();
                    }.bind(this)
                }
            });
        },
        renderTable() {
            this.loadData(this.afterLoadDataHandler)
            this.applyChanges(false)
        },
        afterLoadDataHandler: function() {
            this.render()
        }
    };
}());
