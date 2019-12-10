(function () {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig:
                    `
                    <style>
                    </style>
                    <div id='reportListContainer'></div>
                    `
        ,
        init: function() {
            this.reports = [
                { title: 'Показники рейтингів', url: 'rating_indicators'},
                { title: 'Конструктор', url: 'constructor'},
                { title: 'Звіт для метрополітену', url: 'kyiv_metropoliten'},
                { title: 'Топ питань', url: 'top_questions'},
                { title: 'ТОП-10 найпроблемніших питань в розрізі районів', url: 'top_10_problem_question'},
                { title: 'Моніторинг та реагування на звернення громадян', url: 'monitoring_and_responding'},
                { title: 'Щотижневий дайджест', url: 'weekly_digest'},
                { title: 'Звіт щодо кількості відключених будинків по комунальним послугам', url: 'report_on_the_number_of_detached_houses'},
                { title: 'ТОП-10 найпроблемніших сфер життєдіяльності міста', url: 'most_problematic_spheres_of_city_life'},
                { title: 'Статистичний звіт за рік чи півріччя', url: 'statistical_report_for_the_year_or_half_year'}
            ];
        },
        afterViewInit: function() {
            const reportListContainer = document.getElementById('reportListContainer');
            let reportListWrap = this.createElement('div', { id: 'reportListWrap'});
            reportListContainer.appendChild(reportListWrap);
            this.reports.forEach( report => {
                const reportTitle = report.title;
                const url = report.url;
                
                const reportListItem = this.createElement('div', { className: 'reportListItem', url: url, innerText: reportTitle });
                reportListWrap.appendChild(reportListItem);
                
                reportListItem.addEventListener( 'click', event => {
                    const target = event.currentTarget;
                    window.open(location.origin + localStorage.getItem('VirtualPath') + "/dashboard/page/"+target.url);
                });
            });
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
    };
}());
  