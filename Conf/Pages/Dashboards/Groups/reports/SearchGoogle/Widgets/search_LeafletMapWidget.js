(function() {
    return {
        title: [],
    hint: '',
    formatTitle: function() {},
    customConfig:
                `
                <div id="map">
                  <div id="map-content">
                    <div id="map-nav"></div>
                  </div>
                </div>
                `
        ,
        formatTitle: function() {},
        init: function() {
            let ss = document.createElement('link');
            ss.type = 'text/css';
            ss.rel = 'stylesheet';
            ss.href = 'https://unpkg.com/leaflet@1.4.0/dist/leaflet.css';
            document.getElementsByTagName('head')[0].appendChild(ss);

            ss.onload = function() {
              let s = document.createElement('script');
              s.type = 'text/javascript';
              s.src = 'https://unpkg.com/leaflet@1.4.0/dist/leaflet.js';
              document.getElementsByTagName('head')[0].appendChild(s);
              s.onload = function() {
                    const getUrlParams = window
                        .location
                        .search
                        .replace('?', '')
                        .split('&')
                        .reduce(
                            function(p, e) {
                                let a = e.split('=');
                                p[decodeURIComponent(a[0])] = decodeURIComponent(a[1]);
                                return p;
                            }, {}
                        );
                    this.latitude = Number(getUrlParams.lat);
                    this.longitude = Number(getUrlParams.lon);
                    
                    this.load();
              }.bind(this)
          }.bind(this)

            
        },
        load: function() {

            var	streets  =  new L.TileLayer('https://tms{s}.visicom.ua/2.0.0/planet3/base/{z}/{x}/{y}.png?key=a85a6cf0ba5fba83eb2fafd7530a1e57', {
                        attribution: 'Картографічні дані © АТ «<a href="https://api.visicom.ua/">Візіком</a>»',
                        maxZoom: 19,
                        subdomains: '123',
                        tms: true
                    })

            var defaultStyleMap = streets;     

            this.map = new L.Map('map', {
                center: new L.LatLng(this.latitude, this.longitude),
                zoom: 18,
                zoomSnap: 0.5,
                maxZoom: 19,
                minZoom: 10,
                preferCanvas: true,
                layers: defaultStyleMap
              });

            let marker = L.marker([this.latitude, this.longitude]);
            marker.addTo(this.map);
        }
    };
}());