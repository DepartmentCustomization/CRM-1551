(function () {
  return {
    title: ' ',
    hint: '',
    formatTitle: function() {},
    customConfig:
                `
                <style>
                  #container{}
                  #tabsWrapper{
                    display: flex;
                    justify-content: space-around;
                    display: flex;
                    justify-content: space-between;
                    margin-right: 10px;
                    max-width: 900px;
                    margin: 10px auto;
                    border-bottom: 1px solid rgba(204 204 204);
                  }
                  .tab{
                    text-transform: uppercase;
                    color: #15BDF4;
                    font-weight: 400;
                    font-style: normal;
                    font-size: 14px;
                    cursor: pointer;
                    padding: 0 20px 6px;
                  }
                  .tabHover {
                    border-bottom: 3px solid #15BDF4;
                  }  
                </style>
                <div id='container'></div> 
                `
    ,
    afterViewInit: function(){
      const CONTAINER = document.getElementById('container');
      const tabSpeedDone = this.createElement('div', { id: 'tabSpeedDone', className: 'tab tabHover', innerText: 'Швидкість виконання'});
      const tabSpeedExplained = this.createElement('div', { id: 'tabSpeedExplained', className: 'tab', innerText: 'Швидкість роз\'яснення'});
      const tabsWrapper = this.createElement('div', { id: 'tabsWrapper'}, tabSpeedDone, tabSpeedExplained);
      CONTAINER.appendChild(tabsWrapper);

      const tabs = document.querySelectorAll('.tab');
      tabs.forEach( tab => {
        tab.addEventListener( 'click', e => {
          tabs.forEach( tab => tab.classList.remove('tabHover'));
          let target = e.currentTarget;
          target.classList.add('tabHover');
          this.messageService.publish( {name: 'showTable', tabName: target.id});
        });
      });
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
};
}());
