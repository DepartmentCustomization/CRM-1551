(function () {
  return {
    init: function() {
        let select2LibraryJS = 'select2LibraryJS'; 
        let jQueryLibraryJS = 'jQueryLibraryJS'; 
        let select2LibraryCSS = 'select2LibraryCSS'; 
        if (!document.getElementById(select2LibraryJS)) {
            let head  = document.getElementsByTagName('head')[0];
            let script  = document.createElement('script');
            script.id   = 'jQueryLibraryJS';
            script.type = 'text/javascript';
            script.src = 'https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.min.js';
            head.appendChild(script);
            script.onload = function () {
                    let script2  = document.createElement('script');
                    script2.id   = 'select2LibraryJS';
                    script2.type = 'text/javascript';
                     script2.src = 'https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.9/js/select2.min.js';
                    head.appendChild(script2);
                                  
                    script2.onload = function () {
                    let style  = document.createElement('style');
                    let styleDefault  = document.createElement('style');
                    let styleSelect = document.createElement('link');
                        styleSelect.rel = 'stylesheet';
                        styleSelect.href =  'https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css';
                        styleSelect.type = 'text/css';
                        
                    let tag_head = document.getElementsByTagName('head');
                        tag_head[0].appendChild(styleSelect);
                        style.onload = function () {
                                    
                                let messageSelect = {
                                    name: 'LoadLib',
                                    package: {
                                        value: 1
                                    }
                                }
                                self.messageService.publish(messageSelect);    
                            
                        }.bind(self);
                  }.bind(self); 
              console.clear();
            }.bind(self);  
        }
        this.showPreloader = false;
        this.sub  = this.messageService.subscribe( 'showPagePreloader', this.showMyPreloader, this);
        this.sub1 = this.messageService.subscribe( 'hidePagePreloader', this.hideMyPreloader, this);
    },
    showMyPreloader: function(){
        this.showPagePreloader();
    },
    hideMyPreloader: function(){
        this.hidePagePreloader();
    },
    destroy: function(){
        this.sub.unsubscribe;
        this.sub1.unsubscribe;
    }
};
}());
