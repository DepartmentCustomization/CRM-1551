(function() {
    return {
        config: {
            query: {
                code: '',
                parameterValues: [],
                filterColumns: [],
                sortColumns: [],
                skipNotVisibleColumns: true,
                chunkSize: 1000
            },
            columns: [
                {
                    dataField: 'Appeal_number',
                    caption: 'Номер звернення'
                },
                {
                    dataField: 'Question_number',
                    caption: 'Номер питання'
                },
                {
                    dataField: 'QuestionType',
                    caption: 'Тип питання'
                },
                {
                    dataField: 'AssignmentExecutorOrganization',
                    caption: 'Виконавець'
                },
                {
                    dataField: 'AssignmentRegistrationDate',
                    caption: 'Дата реєстрації доручення'
                },
                {
                    dataField: 'AssignmentState',
                    caption: 'Стан доручення'
                },
                {
                    dataField: 'AssignmentResult',
                    caption: 'Результат розгляду доручення'
                },
                {
                    dataField: 'AssignmentResolution',
                    caption: 'Резолюція доручення'
                },
                {
                    dataField: 'AssigmentExecutionDate',
                    caption: 'Дата контролю доручення '
                },
                {
                    dataField: 'Department',
                    caption: 'Назва департаменту'
                }
            ],
            keyExpr: 'Id'
        },
        init: function() {
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
            const orgId = Number(getUrlParams.orgId);
            const date = new Date(getUrlParams.date);
            const query = getUrlParams.query;
            const queryCode = 'ak_RD_' + query;
            this.config.query.code = queryCode;
            this.config.query.parameterValues = [
                {key: '@Date' , value: date },
                {key: '@Organization_Id', value: orgId }
            ];
            this.loadData(this.afterLoadDataHandler);
        },
        afterLoadDataHandler: function() {
            this.render();
        }
    };
}());
