(function() {
    return {
        config: {
            query: {
                code: 'db_ReestrRating2',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [],
            keyExpr: ''
        },
        init: function() {
            this.dataGridInstance.height = window.innerHeight - 100;
            const getUrlParams = window
                .location
                .search
                .replace('?', '')
                .split('&')
                .reduce(function(p, e) {
                    let a = e.split('=');
                    p[decodeURIComponent(a[0])] = decodeURIComponent(a[1]);
                    return p;
                }, {}
                );
            const columnCode = getUrlParams.columncode;
            const date = getUrlParams.date;
            const ratingId = Number(getUrlParams.ratingid);
            const rdaId = Number(getUrlParams.rdaid);
            this.config.query.parameterValues = [
                {key: '@CalcDate' , value: date },
                {key: '@RDAId', value: rdaId },
                {key: '@RatingId', value: ratingId },
                {key: '@ColumnCode', value: columnCode }
            ];
            let exportQuery = {
                queryCode: this.config.query.code,
                limit: -1,
                parameterValues: [
                    {key: '@CalcDate' , value:  date },
                    {key: '@RDAId', value: rdaId },
                    {key: '@RatingId', value: ratingId },
                    {key: '@ColumnCode', value: columnCode }
                ]
            };
            this.queryExecutor(exportQuery, this.setColumns, this);
        },
        setColumns: function(data) {
            for (let i = 0; i < data.columns.length; i++) {
                const element = data.columns[i];
                if(this.config.key === '') {
                    this.config.key = element.dataType;
                }
                let dataField = element.code;
                let caption = element.name;
                let obj = { dataField, caption }
                this.config.columns.push(obj);
            }
            this.loadData(this.afterLoadDataHandler);
        },
        afterLoadDataHandler: function() {
            this.render();
        }
    };
}());
