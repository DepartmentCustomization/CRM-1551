(function () {
  return {  
        customConfig:
                `
                <div id='container'></div>  
                `
        ,
        init: function() {
            this.reports = [
                { title: 'Показники рейтингів', url: 'rating_indicators', icon: 'trending_up'},
                { title: 'Конструктор', url: 'constructor', icon: 'extension'},
                { title: 'Звіт для метрополітену', url: 'kyiv_metropoliten', icon: 'subway'},
                { title: 'Топ питань', url: 'top_questions', icon: 'format_list_numbered'},
                { title: 'ТОП-10 найпроблемніших питань в розрізі районів', url: 'top_10_problem_question', icon: 'publish'},
                { title: 'Моніторинг та реагування на звернення громадян', url: 'monitoring_and_responding', icon: 'done_all'},
                { title: 'Щотижневий дайджест', url: 'weekly_digest', icon: 'assessment'},
                { title: 'Звіт щодо кількості відключених будинків по комунальним послугам', url: 'report_on_the_number_of_detached_houses', icon: 'home'},
                { title: 'ТОП-10 найпроблемніших сфер життєдіяльності міста', url: 'most_problematic_spheres_of_city_life', icon: 'pie_chart'},
                { title: 'Статистичний звіт за рік чи півріччя', url: 'statistical_report_for_the_year_or_half_year', icon: 'calendar_view_day'}
            ];
        },
    afterViewInit: function(){
        const container = document.getElementById('container');
        const filtersContainerDepart =  this.createElement('div', { id: 'filtersContainerDepart', className: "filtersContainer"});
        const filtersContainerDistrict =  this.createElement('div', { id: 'filtersContainerDistrict', className: "filtersContainer"});

        const tabsWrapper = this.createElement('div', { id: 'tabsWrapper', className: 'tabsWrapper'});
        const tableContainer = this.createElement('div', { id: 'tableContainer', className: 'tableContainer'});

        container.appendChild(tabsWrapper);
        this.createTabs();
        this.createReports();
    },
    createReports: function() {
        let reportListWrap = this.createElement('div', { id: 'reportListWrap'});
        container.appendChild(reportListWrap);
        this.reports.forEach( report => {
            const reportTitle = report.title;
            const url = report.url;
            const icon = report.icon;
            const reportListItem__icon = this.createElement('div', { classList: 'reportListItem__icon material-icons', innerText: icon });
            const reportListItem__text = this.createElement('div', { className: 'reportListItem__text',  innerText: reportTitle });
            const reportListItem = this.createElement('div', { className: 'reportListItem', url: url, }, reportListItem__icon, reportListItem__text);
            reportListWrap.appendChild(reportListItem);
            
            reportListItem.addEventListener( 'click', event => {
                const target = event.currentTarget;
                window.open(location.origin + localStorage.getItem('VirtualPath') + "/dashboard/page/"+target.url);
            });
        });
    },
    createTabs: function(){

        let tabPhone__title  = this.createElement('div', { className: 'tabPhone tabTitle', innerText: 'ВХІДНИЙ ДЗВІНОК'});
        let tabReportList__title  = this.createElement('div', { className: 'tabProzvon tabTitle', innerText: 'Звіти'});
        let tabFinder__title  = this.createElement('div', { className: ' tabTitle', innerText: 'Розширений пошук'});

        const tabReportList = this.createElement('div', { id: 'tabReportList', location: 'dashboard', url: 'StartPage_operator', className: 'tabPhone tab  tabHover'}, tabReportList__title);
        const tabPhone = this.createElement('div', { id: 'tabPhone', location: 'dashboard', url: 'StartPage_operator', className: 'tabPhone tab tabTo'},tabPhone__title);
        const tabFinder = this.createElement('div', { id: 'tabFinder', location: 'dashboard', url: 'poshuk_table', className: 'tabFinder tab tabTo'}, tabFinder__title);

        const tabsContainer = this.createElement('div', { id: 'tabsContainer', className: 'tabsContainer'}, tabReportList, tabPhone, tabFinder);
        tabsWrapper.appendChild(tabsContainer);

        let tabs = document.querySelectorAll('.tabTo');
        tabs = Array.from(tabs);
        tabs.forEach( function (el){
            el.addEventListener( 'click', event => {
                let target =  event.currentTarget;
                if( target.location == 'section'){
                    document.getElementById('container').style.display = 'none';
                    this.goToSection(target.url);
                }else if( target.location == 'dashboard'){
                    document.getElementById('container').style.display = 'none';
                    this.goToDashboard(target.url);
                }
            });   
        }.bind(this));
    },
    createElement: function(tag, props, ...children) {
        const element = document.createElement(tag);
        Object.keys(props).forEach( key => element[key] = props[key] );
        if(children.length > 0){
            children.forEach( child =>{
                element.appendChild(child);
            });
        }
        return element;
        },
    };
}());
