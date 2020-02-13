(function() {
    return {
        title: [],
        hint: '',
        formatTitle: function() {},
        customConfig:
                  `
                  <button type="button" id="btn_GetAllAoByStreet">GetAllAoByStreet</button>
                  `
        ,
        Data: [],
        btn_load: function() {
            let data = JSON.stringify({'query':'{\n  query: allAoByStreet(match: "*", ofStreet: "323926b2-370f-11e7-9a5c-000c29ff5864", locale: "UA") { \n      id\nname {\n  ofFirstLevel {\n    fullName\n    shortName\n    fullToponym\n    shortToponym\n    isToponymBeforeName\n  }\n  ofSecondLevel {\n    fullName\n    shortName\n    fullToponym\n    shortToponym\n    isToponymBeforeName\n  }\n  \n  ofThirdLevel {\n    fullName\n    shortName\n    fullToponym\n    shortToponym\n    isToponymBeforeName\n  }\n}\n    geolocation {\n      lat\n      lon\n      \n    }\n    asString\n    locale\n\n  }\n}','variables':{},'operationName':null});
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
            document.getElementById('btn_GetAllAoByStreet').addEventListener('click', function() {
                this.btn_load();
            }.bind(this));
        },
        load: function() {
        }
    };
}());
