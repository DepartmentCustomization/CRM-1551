(function () {
  return {
    config: {
        query: {
            code: 'table2',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                dataField: 'navigation',
                caption: '',
                width: 200,
                fixed: true,
                sortOrder: 'asc',
            },{
                dataField: 'nadiyshlo',
                caption: 'Надійшло', 
                width: 50,
                fixed: true,
            },{
                dataField: 'neVKompetentsii',
                caption: 'Не в компетенції',
                width: 50,
                fixed: true,
            },{
                dataField: 'prostrocheni',
                caption: 'Прострочені',
                width: 50,
                fixed: true,
            },{
                dataField: 'uvaga',
                caption: 'Увага',
                width: 50,
                fixed: true,
            },{
                dataField: 'vroboti',
                caption: 'В роботі',
                width: 50,
                fixed: true,
            },{
                dataField: 'dovidoma',
                caption: 'До відома',
                width: 50,
                fixed: true,
            },
            {
                dataField: 'naDoopratsiyvanni',
                caption: 'На доопрацюванні',
                width: 50,
                fixed: true,
            },{
                dataField: 'neVykonNeMozhl',
                caption: 'План/Програма',
                width: 50,
                fixed: true,
            }
        ],
        summary: {
            totalItems: [
                {
                    column: "nadiyshlo",
                    summaryType: "sum",
                    alignByColumn: true,
                    customizeText: function(data) {
                        return "Всього: " + (data.value);
                    }
                }, {
                    column: "neVKompetentsii",
                    summaryType: "sum",
                    alignByColumn: true,
                    customizeText: function(data) {
                        return "Всього: " + (data.value);
                    }
                }, {
                    column: "prostrocheni",
                    summaryType: "sum",
                    alignByColumn: true,
                    customizeText: function(data) {
                        return "Всього: " + (data.value);
                    }
                }, {
                    column: "uvaga",
                    summaryType: "sum",
                    alignByColumn: true,
                    customizeText: function(data) {
                        return "Всього: " + (data.value);
                    }
                }, {
                    column: "vroboti",
                    summaryType: "sum",
                    alignByColumn: true,
                    customizeText: function(data) {
                        return "Всього: " + (data.value);
                    }
                }, {
                    column: "dovidoma",
                    summaryType: "sum",
                    alignByColumn: true,
                    customizeText: function(data) {
                        return "Всього: " + (data.value);
                    }
                }, {
                    column: "naDoopratsiyvanni",
                    summaryType: "sum",
                    alignByColumn: true,
                    customizeText: function(data) {
                        return "Всього: " + (data.value);
                    }
                }, {
                    column: "neVykonNeMozhl",
                    summaryType: "sum",
                    alignByColumn: true,
                    customizeText: function(data) {
                        return "Всього: " + (data.value);
                    }
                }
            ]
        },
        export: {
            enabled: false,
            fileName: 'File_name'
        },
        scrolling: {
            mode: 'virtual',
            rowRenderingMode: 'virtual',
            columnRenderingMode: 'virtual',
            showScrollbar:true
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
        showColumnChooser: false,
        showColumnFixing: true,
        groupingAutoExpandAll: null,
        onRowUpdating: function(data) {},
        onRowExpanding: function(data) {},
        onRowInserting: function(data) {},
        onRowRemoving: function(data) {},
        onCellClick: function(data) {},
        onRowClick: function(data) {},
        selectionChanged: function(data) {}
    },
    organizationId: 0,
    sub: [],
    sub1: [],
    sub2: [],
    
    containerCell: [],
    init: function() {
        // 1. подписываешься ена сообщение и вызываешь коллбекфанк init2
        this.sub = this.messageService.subscribe('GlobalFilterChanged', this.init2, this);
        this.sub1 = this.messageService.subscribe('clickOnTable3', this.queryForTable2, this);
        this.sub2 = this.messageService.subscribe('reloadAssignmentsTable', this.reloadAfterSend, this);
       
       
       
        if(window.location.search == ''){
            let executeQuery = {
                queryCode: 'organization_name',
                parameterValues: [],
                limit: -1
            };
            this.queryExecutor(executeQuery, this.userOrganization, this);
            // 2.1. если нет то дергаешь запрос (получаешь знач в коллбекфанк "ОрганизацияТекущегоЮзера") и заприсываешь её в глоьб переменную + создвешь параметр урл
            
        }else{
            // 2.2 если есть значе заприсываешь её в глоб переменную ГлобПекременнаяОрганизации 
            var getUrlParams = window
                            .location
                                .search
                                    .replace('?', '')
                                        .split('&')
                                            .reduce(function(p, e) {
                                                      var a = e.split('=');
                                                      p[decodeURIComponent(a[0])] = decodeURIComponent(a[1]);
                                                      return p;
                                                    }, {}
                                                        );
            let tabInd = Number(getUrlParams.id);
            this.organizationId = [];
            this.organizationId = (tabInd);
            // this.sendOrgId('sendOrgId', this.organizationId);

            console.log(this.organizationId);
            this.config.query.queryCode = 'table2';
            this.config.query.parameterValues = [ { key: '@organization_id',  value: this.organizationId} ];
            this.loadData(this.afterLoadDataHandler);
            
            this.sendMessOrganizationId('organizationId', this.organizationId);
            
            let executeQuery = {
                queryCode: 'organization_name',
                parameterValues: [{ key: '@organizationId',  value: this.organizationId}],
                limit: -1
            };
            this.queryExecutor(executeQuery, this.userOrganization, this);
        }
    },
    userOrganization: function(data){
        let indexOfTypeName = data.columns.findIndex(el => el.code.toLowerCase() === 'organizationname' );
        let indexOfTypeId = data.columns.findIndex(el => el.code.toLowerCase() === 'organizationid' );
        let indexOfTypeDistribute = data.columns.findIndex(el => el.code.toLowerCase() === 'distribute' );
        this.organizationId = [];
        this.organizationId = (data.rows[0].values[indexOfTypeId]);
        this.distribute = (data.rows[0].values[indexOfTypeDistribute]);
        console.log(this.distribute)
        
        this.messageService.publish({name: 'messageWithOrganizationId', value: this.organizationId, distribute:  this.distribute});
        // this.sendOrgId('sendOrgId', this.organizationId);
        document.getElementById('organizationName').value = (data.rows[0].values[indexOfTypeId]);
        document.getElementById('organizationName').innerText = (data.rows[0].values[indexOfTypeName]);
        if( window.location.search != '?id='+data.rows[0].values[indexOfTypeId]+''){
            window.location.search = 'id='+data.rows[0].values[indexOfTypeId]+'';
        }
    },
    sendOrgId: function(message, id){
        this.messageService.publish({name: message, value: id });
    },
    // ОрганизацияТекущегоЮзера: function(ДАТА) {
    //   сОЗДАЕШЬ урл парамето оргИД (проставляешь знач ДАТА) + записываешь знач в переменную ГлобПекременнаяОрганизации
    //   отправляешь месседж для инит2
    // },
    init2: function() {
        this.dataGridInstance.onCellClick.subscribe(e => {
            if(this.containerCell[0]){
                this.containerCell[0].style.removeProperty("background-color");
                this.containerCell[0].style.removeProperty("color");
            }
            this.containerCell = [];
            this.containerCell.push(e.cellElement);
            this.containerCell[0].style.backgroundColor = '#5cb85c';
            this.containerCell[0].style.color = '#fff';
            if(e.row != undefined && e.column.dataField != 'navigation'){
                const orgName = document.getElementById('organizationName').innerText;
                this.sendMesOnBtnClick('clickOnTable2', e.column.caption, e.row.data.navigation, orgName, this.organizationId);
            }
            if( e.row == undefined ){
                const all = 'Усі';
                const orgName = document.getElementById('organizationName').innerText;
                this.sendMesOnBtnClick('clickOnTable2', e.column.caption, all, orgName, this.organizationId);                
            }
        });
        this.loadData(this.afterLoadDataHandler);
    },
    queryForTable2: function(message){
        this.config.query.parameterValues = [{ key: '@organization_id',  value: message.value} ];
        this.loadData(this.afterLoadDataHandler);
        
        document.getElementById('table2__mainTable').style.display = 'block';
        document.getElementById('table3__organization').style.display = 'none';
        
        let executeQuery = {
            queryCode: 'organization_name',
            parameterValues: [ { key: '@organizationId',  value: message.value} ],
            limit: -1
        };
        this.queryExecutor(executeQuery, this.userOrganization, this);
    },
    sendMesOnBtnClick: function(message, columnIndex, rowName, orgName, orgId){
        this.messageService.publish({name: message, column: columnIndex, row: rowName, orgName, orgId: orgId });
    },
    sendMessReloadTable: function(message, orgName, orgId){
        this.messageService.publish({name: message, orgName: orgName, orgId: orgId });
    },
    sendMessOrganizationId: function(message, orgId){
        this.messageService.publish({name: message, value: orgId });
    },
    reloadAfterSend: function(){
        this.config.query.parameterValues = [ {key: '@organization_id',  value: this.organizationId} ];
        this.loadData(this.afterLoadDataHandler);
    },
	afterLoadDataHandler: function(data) {
		this.render();
	},    
    destroy: function() {
        this.sub.unsubscribe();
        this.sub1.unsubscribe();
        this.sub2.unsubscribe();
    } 
};
}());
