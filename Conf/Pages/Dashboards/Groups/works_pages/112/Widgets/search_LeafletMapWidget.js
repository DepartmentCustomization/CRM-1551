(function() {
    return {
        title: ' ',
        hint: '',
        mapOptions: {
            zoom: 11,
            latitude: 50.450418,
            longitude: 30.523541,
            maxZoom: 19
        },
        dataForMap: {
            search: []
        },
        init: function() {
            this.messageService.subscribe('setSearchMarker', this.setSearchMarker, this);
            const queryCategoryList = {
                queryCode: 'list_filter_districts',
                parameterValues: [],
                filterColumns: [],
                limit: -1
            };
            this.queryExecutor(queryCategoryList, this.load, this);
            this.showPreloader = false;
        },
        initMap: function(zoomLevel = 5, viewOne = 50.433841, viewTwo = 30.453244) {
            this.map.setView([Number(viewOne), Number(viewTwo)], zoomLevel);
        },
        setSearchMarker: function(message) {
            const data = message.data;
            if(data.rows.length) {
                let indexId = data.columns.findIndex(el => el.code.toLowerCase() === 'id');
                let indexAddress = data.columns.findIndex(el => el.code.toLowerCase() === 'addresssearch');
                let indexOfLatitude = data.columns.findIndex(el => el.code.toLowerCase() === 'geolocation_lat');
                let indexOfLongitude = data.columns.findIndex(el => el.code.toLowerCase() === 'geolocation_lon');
                this.indexId = indexId;
                const address = data.rows[0].values[indexAddress];
                const addressId = data.rows[0].values[indexId];
                const name = 'sendSearchAddress'
                const latitude = data.rows[0].values[indexOfLatitude];
                const longitude = data.rows[0].values[indexOfLongitude];
                this.messageService.publish({name, address, addressId, latitude, longitude});
                this.indexAddress = indexAddress;
                let LeafIcon = L.Icon.extend({
                    options: {
                        shadowUrl: '',
                        iconSize: [28, 28],
                        shadowSize: [50, 64]
                    }
                });
                let yellowIcon = new LeafIcon({
                    iconUrl: 'assets/img/marker-icon.png'
                });
                const search = L.layerGroup(this.dataForMap.search);
                search.addTo(this.map);
                search.clearLayers();
                L.icon = function(options) {
                    return new L.Icon(options);
                };
                if(data.rows.length) {
                    let marker = L.marker(
                        [data.rows[0].values[indexOfLatitude], data.rows[0].values[indexOfLongitude]],
                        {icon: yellowIcon}
                    ).addTo(this.map);
                    this.dataForMap.search.push(marker);
                    this.initMap(13, data.rows[0].values[indexOfLatitude], data.rows[0].values[indexOfLongitude]);
                }
            }
        }
    };
}());
