(function () {
    return {
        config: {
            query: {
                code: 'IndexOfSpeedToExplain',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [],
            summary: {
            totalItems: [],
            },
            scrolling: {
                mode: 'virtual'
            },
            filterRow: {
                visible: true,
                applyFilter: "auto"
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
            groupingAutoExpandAll: null,
        },

        init: function() {
            this.results = [];
            this.dataGridInstance.height = window.innerHeight - 200;
            this.active = false;
            document.getElementById('containerSpeedExplained').style.display = 'none';
            
            this.sub = this.messageService.subscribe('showTable', this.showTable, this);
            this.sub1 = this.messageService.subscribe('FilterParameters', this.executeQuery, this);
            this.sub2 = this.messageService.subscribe( 'ApplyGlobalFilters', this.renderTable, this );
            this.sub3 = this.messageService.subscribe( 'setConfig2', this.setConfig, this);
        },

        showTable: function(message) {
            let tabName = message.tabName;
            if(tabName !== 'tabSpeedExplained'){
                this.active = false;
                document.getElementById('containerSpeedExplained').style.display = 'none';
            } else {
                this.active = true;
                document.getElementById('containerSpeedExplained').style.display = 'block';
                this.renderTable();
            }
        },

        setConfig: function (message) {
            this.config = message.config;
        },

        executeQuery: function (message) {
            this.config.query.parameterValues = [];
            this.period = message.period;
            this.rating = message.rating;
            this.executor = message.executor;
            const parameters = message.parameters;
            const codeResult = 'IndexOfSpeedToExplain_Percent';
            const config = this.config;
            const name = 'getConfig';
            const tab = 2;
            this.messageService.publish({ name, parameters, codeResult, config, tab });
        },

        renderTable: function () {
            if (this.period) {
                if (this.active) {
                    let msg = {
                        name: "SetFilterPanelState",
                        package: {
                            value: false
                        }
                    };
                    this.messageService.publish(msg);
                    this.loadData(this.afterLoadDataHandler);  
                }
            }
        },

        afterLoadDataHandler: function(data) {
            this.render();
        },
        
        destroy: function () {
            this.sub.unsubscribe();
            this.sub1.unsubscribe();
            this.sub2.unsubscribe();
            this.sub3.unsubscribe();
        }
    };
}());
