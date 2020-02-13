(function() {
    return {
        title: [],
        hint: '',
        formatTitle: function() {},
        customConfig:
                `
                <button type="button" id="btn_GetCountry">GetCountry</button>
                `
        ,
        Data: [],
        btn_load: function() {
            let data = JSON.stringify({
                'query': '{\n  query: countries(match: "Укра", locale: "UK") {\n          id,\n    name {\n      fullName\n    \tshortName\n    \tfullToponym\n    \tshortToponym\n    \tisToponymBeforeName\n    }\n    codeIsoAlpha2\n    codeIsoAlpha3\n    codeIsoNumeric\n    history {\n      fullName\n    \tshortName\n    \tfullToponym\n    \tshortToponym\n    \tisToponymBeforeName\n    }\n    incorrect {\n      fullName\n    \tshortName\n    \tfullToponym\n    \tshortToponym\n    \tisToponymBeforeName\n    }\n    locale\n\n  }\n}',
                'variables': {},
                'operationName': null
            });
            let xhr = new XMLHttpRequest();
            xhr.withCredentials = true;
            let token_text = document.getElementById('input_token').value;
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if(xhr.status == 200) {
                        this.Data.push(JSON.parse(xhr.responseText));
                        let message = {
                            name: 'Data_Country',
                            value: JSON.parse(xhr.responseText)
                        };
                        this.messageService.publish(message);
                    }
                }
            }.bind(this);
            xhr.open('POST', 'https://address-stage.kyivcity.gov.ua/address');
            xhr.setRequestHeader('Accept', 'application/json');
            xhr.setRequestHeader('Content-Type', 'application/json');
            xhr.setRequestHeader('Authorization', 'Bearer ' + token_text);
            xhr.setRequestHeader('Cache-Control', 'no-cache');
            xhr.send(data);
        },
        init: function() {
        },
        afterViewInit: function() {
            document.getElementById('btn_GetCountry').addEventListener('click', function() {
                this.btn_load();
            }.bind(this));
        },
        load: function() {
        }
    };
}());
