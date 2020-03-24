(function() {
    return {
        title: ' ',
        hint: '',
        customConfig:
                    `
                    <style>
                    #algorithmWrapper{

                    }
                    </style>

                    <div id="containerEventAlgorithm"></div>
                    `
        ,
        createElement: function(tag, props, ...children) {
            const element = document.createElement(tag);
            Object.keys(props).forEach(key => element[key] = props[key]);
            if(children.length) {
                children.forEach(child =>{
                    element.appendChild(child);
                });
            }
            return element;
        },
        init: function() {
            this.eventAlgorithmContainer = document.getElementById('eventAlgorithmContainer');
            this.eventAlgorithmContainer.style.display = 'none';
            this.messageService.subscribe('sendCategoryId', this.executeAlgorithmQuery, this);
        },
        afterViewInit: function() {
            const container = document.getElementById('containerEventAlgorithm');
            this.container = container;
            const algorithmWrapper = this.createAlgorithmWrapper();
            this.algorithmWrapper = algorithmWrapper;
            this.container.appendChild(algorithmWrapper);
        },
        createAlgorithmWrapper: function() {
            const algorithmWrapper = this.createElement(
                'div',
                {
                    id: 'algorithmWrapper'
                }
            );
            return algorithmWrapper;
        },
        executeAlgorithmQuery: function(message) {
            const id = message.id;
            const queryAlgorithm = {
                queryCode: 'ak_EventAlgorithm112',
                parameterValues: [
                    { key: '@event_category_id', value: id}
                ],
                filterColumns: [],
                limit: -1
            };
            this.queryExecutor(queryAlgorithm, this.createCategoryAlgorithm, this);
        },
        createCategoryAlgorithm: function(data) {
            const text = data.rows[0].values[1];
            if(data.rows.length) {
                const categoryAlgorithm = this.createElement(
                    'div',
                    {
                        className: 'categoryAlgorithm',
                        innerText: text,
                        id: data.rows[0].values[0]
                    }
                );
                this.algorithmWrapper.appendChild(categoryAlgorithm);
            }
        }
    };
}());
