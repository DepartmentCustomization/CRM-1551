(function() {
    return {
        title: 'Goole Maps',
        hint: '',
        mapOptions: {
            zoom: 18,
            maxZoom: 19
        },
        formatTitle: function() {},
        init: function() {
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
            this.mapOptions.latitude = this.latitude;
            this.mapOptions.longitude = this.longitude;
            let executeQuery = {
                queryCode: 'int_list_district_1551',
                limit: -1,
                parameterValues: []
            };
            this.queryExecutor(executeQuery, this.load, this);
        },
        load: function() {
            let marker = L.marker([this.latitude, this.longitude]);
            marker.addTo(this.map);
        }
    };
}());