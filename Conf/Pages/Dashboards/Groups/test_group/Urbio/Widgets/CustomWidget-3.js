(function() {
    return {
        title: [],
        hint: '',
        formatTitle: function() {},
        customConfig:
                `
                <button type="button" id="btn_GetDistrictsByLocality">GetDistrictsByLocality</button>
                `
        ,
        Data: [],
        btn_load: function() {
            let data = JSON.stringify({'query':'{\n  query: districtsByLocality(match: "", ofLocality: "538d7492-371b-11e7-b112-000c29ff5864", locale: "UA") {\n    id\n    name {\n      fullName\n      shortName\n      fullToponym\n      shortToponym\n      isToponymBeforeName\n    }\n    koatuu\n    history {\n      fullName\n      shortName\n      fullToponym\n      shortToponym\n      isToponymBeforeName\n    }\n    incorrect {\n      fullName\n      shortName\n      fullToponym\n      shortToponym\n      isToponymBeforeName\n    }\n    ofLocality {\n      id\n      name {\n        fullName\n        shortName\n        fullToponym\n        shortToponym\n        isToponymBeforeName       \n      }\n    }\n    asString\n    locale\n  }\n}','variables':{},'operationName':null});
            let xhr = new XMLHttpRequest();
            xhr.withCredentials = true;
            let token_text = document.getElementById('input_token').value;
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if(xhr.status == 200) {
                        this.Data.push(JSON.parse(xhr.responseText));
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
            document.getElementById('btn_GetDistrictsByLocality').addEventListener('click', function() {
                this.btn_load();
            }.bind(this));
        },
        load: function() {
        }
    };
}());
