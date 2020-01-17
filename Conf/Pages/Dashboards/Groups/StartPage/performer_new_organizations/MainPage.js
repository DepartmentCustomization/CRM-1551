(function () {
  return {
    init: function() {
        this.showMyPreloader();
        this.sub  = this.messageService.subscribe( 'showPagePreloader', this.showMyPreloader, this);
        this.sub1 = this.messageService.subscribe( 'hidePagePreloader', this.hideMyPreloader, this);
        this.sub2 = this.messageService.subscribe( 'emptyPage', this.emptyPage, this);
    },
    emptyPage: function(){
        this.showPagePreloader('Доручень немає');
    }, 
    showMyPreloader: function(){
        this.showPagePreloader('Зачекайте, сторінка завантажується');
    },
    hideMyPreloader: function(){
        this.hidePagePreloader('Зачекайте, сторінка завантажується');
    },
    destroy: function(){
        this.sub.unsubscribe();
        this.sub1.unsubscribe();
        this.sub2.unsubscribe();
    }
};
}());
