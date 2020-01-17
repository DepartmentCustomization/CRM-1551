(function () {
  return {
    init: function() {
        this.showMyPreloader();
        this.sub  = this.messageService.subscribe( 'showPagePreloader', this.showMyPreloader, this);
        this.sub1 = this.messageService.subscribe( 'hidePagePreloader', this.hideMyPreloader, this);
    },
    showMyPreloader: function(){
        this.showPagePreloader('Зачекайте, сторінка завантажується');
    },
    hideMyPreloader: function(){
        this.hidePagePreloader('Зачекайте, сторінка завантажується');
    }
};
}());
