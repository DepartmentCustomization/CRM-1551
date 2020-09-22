(function() {
    return {
        title: ' ',
        hint: '',
        customConfig:
                    `
                    <style>
                    #tabsWrapper{
                        display: flex;
                        justify-content: space-around;

                        margin: 0;
                        color: white;
                        font-size: 100%;
                        font-weight: normal;
                        text-transform: uppercase;
                        line-height: 1.5em;
                        border: 1px solid #2d9cdb;
                        background: #2d9cdb;
                        display: flex;
                        align-items: center;
                        height: 46px;
                    }
                    .tab{
                        height: 100%;
                        width: 100%;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        cursor: pointer;
                    }
                    .tabsBorderBottom{
                        border-bottom: 4px solid #fff;
                        box-shadow: 1px 1px 3px rgba(0, 0, 0, 0.3);
                    }
                    </style>
                    <div id="containerCardAlgorithm"></div>
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
        },
        afterViewInit: function() {
            const container = document.getElementById('containerCardAlgorithm');
            this.container = container;
            const tabsWrapper = this.createTabsWrapper();
            this.addContainerChild(
                tabsWrapper
            );
            this.addActiveTabBorder('tabCards');
        },
        addContainerChild: function(...params) {
            params.forEach(item => this.container.appendChild(item));
        },
        createTabsWrapper: function() {
            const tabCards = this.createTab('tabCards', true, 'Останні картки');
            const tabAlgorithm = this.createTab('tabAlgorithm', false, 'Алгоритми');
            const tabsWrapper = this.createElement(
                'div',
                {
                    className: '',
                    id: 'tabsWrapper'
                },
                tabCards, tabAlgorithm
            );
            return tabsWrapper;
        },
        createTab: function(id, active, text) {
            const span = this.createElement('span', { className: 'tabSpan',innerText: text});
            const tab = this.createElement(
                'div',
                {
                    className: 'tab',
                    id: id,
                    active: active
                },
                span
            );
            tab.addEventListener('click', e => {
                e.stopImmediatePropagation();
                const target = e.currentTarget;
                if(target.id === 'tabCards') {
                    this.showHideTabs('eventCardsContainer', 'eventAlgorithmContainer');
                    this.removeActiveTabBorder('tabAlgorithm');
                    this.addActiveTabBorder('tabCards');
                } else if(target.id === 'tabAlgorithm') {
                    this.showHideTabs('eventAlgorithmContainer', 'eventCardsContainer');
                    this.removeActiveTabBorder('tabCards');
                    this.addActiveTabBorder('tabAlgorithm');
                }
            });
            return tab;
        },
        showHideTabs: function(show, hide) {
            document.getElementById(show).style.display = 'block';
            document.getElementById(hide).style.display = 'none';
        },
        addActiveTabBorder: function(id) {
            document.getElementById(id).classList.add('tabsBorderBottom');
        },
        removeActiveTabBorder: function(id) {
            document.getElementById(id).classList.remove('tabsBorderBottom');
        },
        changeTab: function(tab) {
            switch (tab.id) {
                case 'tabCards':
                    this.addActiveTabBorder('tabAlgorithm');
                    this.removeActiveTabBorder(tab.id);
                    break;
                case 'tabAlgorithm':
                    this.addActiveTabBorder('tabCards');
                    this.removeActiveTabBorder(tab.id);
                    break;
                default:
                    break;
            }
        }
    };
}());
