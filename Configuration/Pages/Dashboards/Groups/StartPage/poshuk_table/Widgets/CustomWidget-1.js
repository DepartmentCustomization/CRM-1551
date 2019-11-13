(function () {
  return {
    title: ' ',
    hint: '',
    formatTitle: function() {},
    customConfig:
                
                `
                <style>
                #notificationContainer{
                    height: 100%;
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    justify-content: center;                    
                }
                .captionWarning{
                    font-size: 40px;
                    text-transform: uppercase;
                    font-weight: 600;                    
                }
                </style>
                
                <div id='notificationContainer' ></div>
                `
    ,
    init: function() {
        this.isSelected = false;
        this.sub = this.messageService.subscribe( 'GlobalFilterChanged', this.setFiltersValue, this );
        this.sub1 = this.messageService.subscribe( 'ApplyGlobalFilters', this.findAllCheckedFilter, this );
        this.sub2 = this.messageService.subscribe( 'findFilterColumns', this.reloadTable, this );
    },
    setFiltersValue: function(message){
        var elem = message.package.value.values;
        this.filtersLength = elem.length;
        this.filtersWithOutValues = 0;
        elem.forEach( elem => {
            if(elem.active === false){
                this.filtersWithOutValues = this.filtersWithOutValues  + 1 ;
            }
        });
        this.filtersWithOutValues === this.filtersLength ?  this.isSelected = false : this.isSelected = true; 
    },
    findAllCheckedFilter: function(){
        this.isSelected === true ? document.getElementById('notification').style.display = 'none' : document.getElementById('notification').style.display = 'block' ;
    },
	createElement: function(tag, props, ...children) {
        const element = document.createElement(tag);
        Object.keys(props).forEach( key => element[key] = props[key] );
        if(children.length > 0){
            children.forEach( child =>{
                element.appendChild(child);
            });
        } return element;
    },      
    afterViewInit: function() {
        const container = document.getElementById('notificationContainer');
        const captionWarning =  this.createElement( 'div',{ className: 'captionWarning', innerText: 'Оберiть фiльтри!' });
        container.appendChild(captionWarning);
    }
};
}());
