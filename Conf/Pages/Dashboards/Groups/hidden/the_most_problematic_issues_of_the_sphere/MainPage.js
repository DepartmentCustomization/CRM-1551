(function() {
    return {
        init: function() {
            if (!document.getElementById('hightChart3D')) {
                let head = document.getElementsByTagName('head')[0];
                let script = document.createElement('script');
                script.id = 'mainHightChart';
                script.type = 'text/javascript';
                script.src = 'https://code.highcharts.com/highcharts.js';
                head.appendChild(script);
                script.onload = function() {
                    let script2 = document.createElement('script');
                    script2.id = 'hightChart3D';
                    script2.type = 'text/javascript';
                    script2.src = 'https://code.highcharts.com/highcharts-3d.js';
                    head.appendChild(script2);
                    script2.onload = function() {
                        this.messageService.publish({ name: 'LoadLib' });
                    }.bind(this);
                }.bind(this);
            }
            this.showPreloader = false;
        }
    }
    ;
}());
