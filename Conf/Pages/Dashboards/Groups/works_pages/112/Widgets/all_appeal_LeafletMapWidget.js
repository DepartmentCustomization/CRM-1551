(function() {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig:
                    `
                    <style>
                    #map {
                        margin: 0;
                        overflow: hidden;
                        position: fixed;
                        width: 100%;
                        height: 100%;
                    }
                    </style>
                    <div id="map"></div>
                    `
        ,
        subscriptions: [],
        sub1: {},
        sub2: {},
        init: function() {
            let ss = document.createElement('link');
            ss.type = 'text/css';
            ss.rel = 'stylesheet';
            ss.href = 'https://unpkg.com/leaflet@1.4.0/dist/leaflet.css';
            document.getElementsByTagName('head')[0].appendChild(ss);
            this.allAppealLeafLetMap = document.getElementById('allAppealLeafLetMap');
            this.sub1 = this.messageService.subscribe('showAllAppealLeafLetMap', this.showAllAppealLeafLetMap, this);
            this.sub2 = this.messageService.subscribe('hideAllAppealLeafLetMap', this.hideAllAppealLeafLetMap, this);
            this.subscriptions.push(this.sub1);
            this.subscriptions.push(this.sub2);
            ss.onload = function() {
                let s = document.createElement('script');
                s.type = 'text/javascript';
                s.src = 'https://unpkg.com/leaflet@1.4.0/dist/leaflet.js';
                document.getElementsByTagName('head')[0].appendChild(s);
                s.onload = function() {
                    const queryEventCardsList = {
                        queryCode: 'ak_LastCard112',
                        parameterValues: [
                            { key: '@pageOffsetRows', value: 0},
                            { key: '@pageLimitRows', value: 10}
                        ],
                        filterColumns: [],
                        limit: -1
                    };
                    this.queryExecutor(queryEventCardsList, this.load, this);
                    this.showPreloader = false;
                }.bind(this)
            }.bind(this)
        },
        dataForMap: {
            claims: []
        },
        convertDateTime: function(datetime) {
            let d = new Date(datetime),
                yyyy = d.getFullYear(),
                mm = ('0' + (d.getMonth() + 1)).slice(-2),
                dd = ('0' + d.getDate()).slice(-2),
                hh = d.getHours(),
                h = hh,
                min = ('0' + d.getMinutes()).slice(-2),
                time;
            time = yyyy + '-' + mm + '-' + dd + ' ' + h + ':' + min;
            return time;
        },
        load: function(data) {
            this.map = new L.Map('map', {
                center: new L.LatLng(50.450347, 30.932071),
                zoom: 11,
                layers: [new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png')]
            });
            let indexOfLatitude = 3;
            let indexOfLongitude = 2;
            let indexReceipt_date = 1;
            let indexPerson_phone = 4;
            let indexContent = 5;
            let indexFIO = 6;
            let indexIdRow = 0;
            let LeafIcon = L.Icon.extend({
                options: {
                    shadowUrl: '',
                    iconSize: [28, 28],
                    shadowSize: [50, 64]
                }
            });
            let yellowIcon = new LeafIcon({
                iconUrl: 'assets/img/yellow-point.png'
            });
            L.icon = function(options) {
                return new L.Icon(options);
            };
            const claims = L.layerGroup(this.dataForMap.claims);
            claims.addTo(this.map);
            claims.clearLayers();
            if (data.rows.length > 0) {
                for (let i = 0; i < data.rows.length; i++) {
                    let marker = L.marker([data.rows[i].values[indexOfLatitude], data.rows[i].values[indexOfLongitude]], {
                        icon: yellowIcon
                    }).addTo(this.map).bindPopup(
                        '<div id="infowindow_marker01' + i.toString() + '" style="display: flex; height: 173px;">' +
                         '<div style="display: inline-block; height: 100%; padding-left: 15px;">' +
                         '<p style="font-weight: bold; color: black; font-size: 16px; margin-bottom: 0px;">Подія: <b>'
                         + data.rows[i].values[indexIdRow] + '</b></p>' +
                         '<p style="margin: 5px 0;">Дата реєстрації: <b>' +
                         this.convertDateTime(data.rows[i].values[indexReceipt_date]) + '</b></p>' +
                         '<p style="margin: 5px 0;">Заявник: <b>' + data.rows[i].values[indexFIO] + '</b></p>' +
                         '<p style="margin: 5px 0;">Телефон заявника: <b>' + data.rows[i].values[indexPerson_phone] + '</b></p>' +
                         '<p style="margin: 5px 0;">Опис: <b>' + data.rows[i].values[indexContent] + '</b></p>' +
                         '</div></div>', {maxWidth: 800, maxHeight: 500});
                    this.dataForMap.claims.push(marker);
                    marker.IdRow = data.rows[i].values[indexIdRow];
                    marker.addEventListener('click', function(e) {
                        let message = {
                            name: 'LeafletMap_SelectRow',
                            id:  e.sourceTarget.IdRow
                        }
                        this.messageService.publish(message);
                    }.bind(this));
                }
            }
        },
        initMap(zoomLevel = 10, viewOne = 50.452353, viewTwo = 30.567467) {
            this.map.setView([Number(viewOne), Number(viewTwo)], zoomLevel);
        },
        showAllAppealLeafLetMap: function() {
            this.allAppealLeafLetMap.style.display = 'block';
        },
        hideAllAppealLeafLetMap: function() {
            this.allAppealLeafLetMap.style.display = 'none';
        },
        unsubscribeFromMessages() {
            for(let i = 0; i < this.subscriptions.length; i++) {
                this.subscriptions[i].unsubscribe();
            }
        },
        destroy() {
            this.unsubscribeFromMessages();
        }
    };
}());
