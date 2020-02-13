(function() {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig:
                `
                <style>
                    .reportListItem{
                        background-color: #fff;
                        padding: .75em .25em .75em 1em;
                        margin-bottom: .7em;
                        border-left: 5px solid #36c6d3;
                        box-shadow: 0 2px 3px 2px rgba(0,0,0,.03);
                        cursor: pointer;
                        transition: .3s linear background-color;                    
                    }
                </style>
                <div id='reportListContainer'></div>
                `
        ,
        init: function() {
            let executeQuery = {
                queryCode: 'ys_report_list',
                limit: -1,
                parameterValues: []
            };
            this.queryExecutor(executeQuery, this.load, this);
        },
        load: function(data) {
            const reportListContainer = document.getElementById('reportListContainer');
            let reportListWrap = this.createElement('div', { id: 'reportListWrap'});
            reportListContainer.appendChild(reportListWrap);
            data.rows.forEach(el => {
                let reportTitle = el.values[2];
                let linkToReport = el.values[1];
                let reportListItem = this.createElement('div', { className: 'reportListItem', link: linkToReport, innerText: reportTitle });
                reportListWrap.appendChild(reportListItem);
                reportListItem.addEventListener('click', event => {
                    let target = event.currentTarget;
                    window.open(location.origin + localStorage.getItem('VirtualPath') + '/dashboard/page/' + target.link);
                });
            });
        },
        createElement: function(tag, props, ...children) {
            const element = document.createElement(tag);
            Object.keys(props).forEach(key => element[key] = props[key]);
            if(children.length > 0) {
                children.forEach(child =>{
                    element.appendChild(child);
                });
            } return element;
        }
    };
}());
