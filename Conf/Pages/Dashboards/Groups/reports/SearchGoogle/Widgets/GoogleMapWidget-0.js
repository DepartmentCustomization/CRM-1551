(function () {
  return {
    title: 'Goole Maps',
    hint: '',
    formatTitle: function() {},
    googleMapConfig: {
        latitude: 50.431782,
        longitude: 30.516382,
        zoom: 20,
        type: 'roadmap',
        disableDefaultUI: true,
        zoomControl: false,
        mapTypeControl: false,
        scaleControl: false,
        streetViewControl: false,
        rotateControl: false,
        fullscreenControl: false
    },
    init: function() {
        var getDataFromLink = window
        .location
            .search
                .replace('?', '')
                    .split('&')
                        .reduce(
                            function(p, e) {
                                var a = e.split('=');
                                p[decodeURIComponent(a[0])] = decodeURIComponent(a[1]);
                                return p;
                            }, {}
                        );

                     this.googleMapConfig.latitude = getDataFromLink["lat"];
                     this.googleMapConfig.longitude = getDataFromLink["lon"];
 
     },
    afterViewInit: function() {
        var getDataFromLink = window
        .location
            .search
                .replace('?', '')
                    .split('&')
                        .reduce(
                            function(p, e) {
                                var a = e.split('=');
                                p[decodeURIComponent(a[0])] = decodeURIComponent(a[1]);
                                return p;
                            }, {}
                        );

        new google.maps.Marker({
            position: new google.maps.LatLng(getDataFromLink["lat"], getDataFromLink["lon"]),
            map: this.map,
            title: '',
            label: ''
        });


    },
    load: function() {

    },
};
}());
