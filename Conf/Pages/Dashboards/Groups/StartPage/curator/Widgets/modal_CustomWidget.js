(function() {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig:
                    `
                    <style>
                    </style>
                    <div id='container'></div>
                    `
        ,
        init: function() {
            this.sub = this.messageService.subscribe('showModalWindow', this.showModalWindow, this);
        },
        showModalWindow: function(message) {
            if (message.length > 50) {
                let CONTAINER = document.getElementById('container');
                const modalBtnFalse = this.createElement('button', {
                    id:'modalBtnFalse',
                    className: 'btn',
                    innerText: 'Нi'
                });
                const modalBtnTrue = this.createElement('button', {
                    id:'modalBtnTrue',
                    className: 'btn',
                    innerText: 'Так'
                });
                const modalBtnWrapper = this.createElement('div', {
                    id:'modalBtnWrapper',
                    className: 'modalBtnWrapper'
                }, modalBtnTrue, modalBtnFalse);
                const modalTitleCounter = this.createElement('div', {
                    className:'modalTitle',
                    innerText: 'Кількість обраних доручень: ' + message.length
                });
                const modalTitleChecked = this.createElement('div', {
                    className:'modalTitle',
                    innerText: 'Ви дійсно бажаєте їх закрити?'
                });
                const modalWindow = this.createElement('div', {
                    id:'modalWindow',
                    className: 'modalWindow'
                }, modalTitleCounter, modalTitleChecked, modalBtnWrapper);
                const modalWindowWrapper = this.createElement('div', {
                    id:'modalWindowWrapper',
                    className: 'modalWindowWrapper'
                }, modalWindow);
                CONTAINER.appendChild(modalWindowWrapper);
                modalBtnTrue.addEventListener('click', () => {
                    this.executeQuery(message);
                    CONTAINER.removeChild(CONTAINER.lastElementChild);
                });
                modalBtnFalse.addEventListener('click', () => {
                    CONTAINER.removeChild(CONTAINER.lastElementChild);
                });
            } else {
                this.executeQuery(message);
            }
        },
        executeQuery: function(message) {
            const query = {
                queryCode: message.query,
                parameterValues: [ {key: '@Ids', value: message.sendRows} ],
                limit: -1
            };
            this.queryExecutor(query);
            this.showPreloader = false;
            this.messageService.publish({ name: 'renderAfterCloseModal' });
            this.sendMessageToReloadMainTable(message);
        },
        sendMessageToReloadMainTable: function(message) {
            const name = 'reloadMainTable';
            const navigation = message.self.navigation;
            const column = message.self.column;
            const targetId = message.self.targetId;
            this.messageService.publish({ name, navigation, column, targetId });
        },
        createElement: function(tag, props, ...children) {
            const element = document.createElement(tag);
            Object.keys(props).forEach(key => element[key] = props[key]);
            if(children.length > 0) {
                children.forEach(child =>{
                    element.appendChild(child);
                });
            } return element;
        },
        destroy: function() {
            this.sub.unsubscribe();
        }
    };
}());
