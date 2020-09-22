(function() {
    return {
        customConfig:
                `
                <div id='container'></div>
                `
        ,
        dashboards: [
            {
                description: 'Довідник Вулиці',
                url: 'int_streetsPageTable',
                location: 'page',
                icon: 'location_city',
                color: '#ff7961'
            },
            {
                description: 'Довідник Будинки',
                url: 'int_housesPageTable',
                location: 'page',
                icon: 'home',
                color: '#2196F3'
            },
            {
                description: 'Довідник організацій',
                url: 'int_organizationPageTable',
                location: 'page',
                icon: 'person_pin_circle',
                color: '#2196F3'
            },
            {
                description: 'Довідник типов заявок',
                url: 'int_claimsTypePageTable',
                location: 'page',
                icon: 'event_note',
                color: '#FBC02D'
            },
            {
                description: 'Київпастранс',
                url: 'CityPublicTransport',
                location: 'home',
                icon: 'directions_bus',
                color: '#FFB300'
            }
        ],
        afterViewInit: function() {
            const CONTAINER = document.getElementById('container');
            let groupsWrapper = this.createElement('div',
                {
                    className: 'group-btns'
                }
            );
            this.dashboards.forEach(dashboard => {
                let groupLetter__icon = this.createElement('i',
                    {
                        className: 'icon letterIcon material-icons', innerText: dashboard.icon
                    }
                );
                groupLetter__icon.style.color = dashboard.color;
                let groupLetter__description = this.createElement('div',
                    {
                        className: 'description',
                        innerText: dashboard.description
                    }
                );
                let groupBorderBottom = this.createElement('div', { className: 'border-bottom' });
                let groupBorderRight = this.createElement('div', { className: 'border-right'});
                let group = this.createElement('div',
                    {
                        className: 'group',
                        tabindex: '0'
                    },
                    groupLetter__icon, groupLetter__description, groupBorderBottom, groupBorderRight
                );
                group.addEventListener('click', () => {
                    window.open(
                        String(
                            location.origin
                            + localStorage.getItem('VirtualPath')
                            + '/dashboard/'
                            + `${dashboard.location}`
                            + '/'
                            + `${dashboard.url}`
                        )
                    );
                });
                groupsWrapper.appendChild(group);
            });
            CONTAINER.appendChild(groupsWrapper);
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
