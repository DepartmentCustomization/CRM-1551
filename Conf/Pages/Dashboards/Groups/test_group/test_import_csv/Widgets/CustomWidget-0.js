(function () {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig:
                    `
                        <div id='container'></div>
                    `
        ,
        init: function() {
        },
        afterViewInit: function(data) {
            const CONTAINER = document.getElementById('container');
            
            let input  =  this.createElement('input', { type: 'file', id: 'fileInput', accept: ".csv"  });
            let btn  =  this.createElement('button', { id:'importBtn', innerText: 'Import csv files' } );
            let form = this.createElement('form', { method:'post', enctype: 'multipart/form-data'}, input);
            let wrapper = this.createElement('div', { id: 'wrapper' },form, btn );

            CONTAINER.appendChild(wrapper);
            btn.addEventListener( 'click', event => {
                this.showPagePreloader("Зачекайте, файл завантажується");
                let target = event.currentTarget;
                let fileInput = document.getElementById('fileInput');
                let files = fileInput.files;
                let file  = files[0];
                let data = new FormData();
                data.append("file", file);
                data.append("configuration", "{\n   \"HasHeaderRecord\":true,\n   \"EncodingName\":\"windows-1251\",\n   \"Delimiter\":\";\",\n   \"Quote\":\"\\\"\",\n   \"MaxAllowedErrors\":0\n}");
                let xhr = new XMLHttpRequest();
                
                xhr.addEventListener("readystatechange", event => {
                    if (xhr.readyState === 4) {
                        let json = xhr.responseText;
                        let response = JSON.parse(json);
                        let responseNotification = {};
                        if(response.errors.length === 0 ){
                            responseNotification = {
                                title: 'Завантаження пройшло успiшно!',
                                success: 'Завантажено строк: ' + response.success
                            }
                        }else{
                            responseNotification = {
                                title: 'Помилка завантаження!',
                                errorRow: 'Строка: ' + response.errors[0].row,
                                errorColumn: 'Колонка: ' + response.errors[0].column,
                                errorInfo: 'Помилка: ' + response.errors[0].text
                            }
                        }
                        let responseModal =  this.createElement('div', { id: 'responseModal'});
                        this.showModalWindow(responseModal, responseNotification, CONTAINER);                        
                    }
                });
                let url = window.location.origin + '/api/section/demo/import/csv';
                xhr.open("POST", url );
                let token = localStorage.getItem('X-Auth-Token');
                xhr.setRequestHeader("Authorization", 'Bearer ' + token );
                xhr.send(data);
            });
        },
        showModalWindow: function (responseModal, responseNotification, CONTAINER) {
            const modalBtnTrue =  this.createElement('button', { id:'modalBtnTrue', className: 'btn', innerText: 'Сховати'});
            const modalBtnWrapper =  this.createElement('div', { id:'modalBtnWrapper', className: 'modalBtnWrapper'}, modalBtnTrue);
            const contentWrapper =  this.createElement('div', { id:'contentWrapper'}, responseModal);
            const modalTitle =  this.createElement('div', { id:'modalTitle', innerText: 'Результат завантаження:'});
            const modalWindow = this.createElement('div', { id:'modalWindow', className: 'modalWindow'}, modalTitle, contentWrapper ,modalBtnWrapper); 
            const modalWindowWrapper = this.createElement('div', { id:'modalWindowWrapper', className: 'modalWindowWrapper'}, modalWindow); 

            modalBtnTrue.addEventListener( 'click', event => {
                CONTAINER.removeChild(container.lastElementChild);
            });
            for (key in responseNotification) {
                if( key === 'title'){ 
                    let responseTitle =  this.createElement('div', { id: 'responseTitle', className: 'responseTest', innerText: responseNotification[key] });
                    responseModal.appendChild(responseTitle); 
                }else if(key === 'errorInfo'){
                    let responseErrorInfo =  this.createElement('div', { id: 'responseErrorInfo', className: 'responseTest', innerText:responseNotification[key] });
                    responseModal.appendChild(responseErrorInfo);
                }else if(key === 'errorRow'){
                    let responseErrorRow =  this.createElement('div', { id: 'responseErrorRow', className: 'responseError responseTest', innerText: responseNotification[key] });
                    responseModal.appendChild(responseErrorRow);
                }else if(key === 'errorColumn'){
                    let responseErrorColumn =  this.createElement('div', { id: 'responseErrorColumn', className: 'responseError responseTest', innerText: responseNotification[key] });
                    responseModal.appendChild(responseErrorColumn);
                }
            }
            this.hidePagePreloader();
            CONTAINER.appendChild(modalWindowWrapper);
        },
        createElement: function(tag, props, ...children) {
            const element = document.createElement(tag);
            Object.keys(props).forEach( key => element[key] = props[key] );
            if(children.length > 0){
                children.forEach( child =>{
                    element.appendChild(child);
                });
            } return element;
        },
        destroy: function () {
            
        } 
    };
}());