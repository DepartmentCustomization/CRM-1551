(function() {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig:
                    `
                    <style>
                        #container{
                            height: 100%;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 16px;
                            font-weight: 600;
                        }
                    </style>
                    
                    <div id='container'></div>
                    `
        ,
        init: function() {
            const query = {
                'queryCode': 'ak_CSI_yesterday_indicator',
                'limit': -1,
                'parameterValues': []
            };
            this.queryExecutor(query, this.load, this);
            this.showPreloader = false;
        },
        load: function(data) {
            const CONTAINER = document.getElementById('container');
            if (data.rows.length) {
                CONTAINER.innerText = data.rows[0].values[0];
            }
        }
    };
}());
