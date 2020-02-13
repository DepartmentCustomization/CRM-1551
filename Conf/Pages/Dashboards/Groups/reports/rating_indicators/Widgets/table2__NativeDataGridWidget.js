(function() {
    return {
        formatTitle: function() {
            return '<h3 class=\'table2__title\'>Зведені показання за переліком питань: Житлове господарство</h3>'
        },
        config: {
            query: {
                code: 'db_ReestrRating_Table',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [],
            sorting: {
                mode: 'multiple'
            },
            showBorders: false,
            showColumnLines: true,
            showRowLines: true,
            columnAutoWidth: true,
            hoverStateEnabled: true,
            wordWrapEnabled: true,
            allowColumnResizing: true,
            showFilterRow: true,
            showHeaderFilter: false,
            showColumnChooser: true,
            showColumnFixing: true,
            key: 'RDAId'
        },
        init: function() {
            this.config.title =
            document.getElementById('infoContainer').style.display = 'none';
            this.sub = this.messageService.subscribe('FiltersParams', this.setFiltersParams, this);
            this.sub1 = this.messageService.subscribe('showInfo', this.showInfo, this);
        },
        showInfo: function() {
            document.getElementById('infoContainer').style.display = 'block';
            let createTableQuery = {
                queryCode: this.config.query.code,
                limit: -1,
                parameterValues: this.config.query.parameterValues
            };
            this.queryExecutor(createTableQuery, this.setColumns, this);
            this.showPreloader = false;
        },
        setFiltersParams: function(message) {
            this.date = message.date;
            this.rating = message.rating;
            this.config.query.parameterValues = [
                {key: '@CalcDate' , value: this.date },
                {key: '@RatingId', value: this.rating }
            ];
        },
        setColumns: function(data) {
            for (let i = 0; i < data.columns.length; i++) {
                const element = data.columns[i];
                const dataField = element.code;
                const alignment = 'center';
                const verticalAlignment = 'Bottom';
                let caption = '';
                if(dataField !== 'RDAId') {
                    if(dataField === 'RDAName') {
                        caption = 'Назва установи';
                    }else if(dataField === 'IndicatorAVG') {
                        caption = 'Підсумок';
                    }else if(dataField === 'rnk') {
                        caption = 'Місце';
                    } else {
                        caption = element.name;
                    }
                    let obj = { dataField, caption, alignment, verticalAlignment}
                    this.config.columns.push(obj);
                }
            }
            this.config.columns[0].fixed = true;
            this.config.columns[0].width = 200;
            this.hidePagePreloader();
            this.loadData(this.afterLoadDataHandler);
        },
        afterLoadDataHandler: function() {
            this.render();
        },
        destroy: function() {
            this.sub.unsubscribe();
            this.sub1.unsubscribe();
        }
    };
}());
