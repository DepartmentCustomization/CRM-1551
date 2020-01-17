(function () {
  return {
    title: ' ',
    hint: '',
    formatTitle: function() {},
    customConfig:
                `
                <style>
                    #toChildOrganization{
                        text-align: right;
                        display: flex;
                        justify-content: center;
                    }
                    .btnToParOrg, .btnToReturn{
                        padding: 5px 10px;
                        cursor: pointer;
                        background-color: #5cb85c;
                        border-color: transparent;
                        color: #fff;
                        border-radius: 4px;
                        border-width: 1px;
                        border-style: solid;
                        font-weight: 400;
                        font-size: 14px;
                        padding: 7px 18px 8px ;
                        font-family: 'Helvetica Neue','Segoe UI',Helvetica,Verdana,sans-serif; 
                    }
                </style>
                <div id="toChildOrganization">
                </div>    
                `
    ,
    init: function() {
    },
    afterViewInit: function(data) {
        const toChildOrganization = document.getElementById('toChildOrganization');
        const btnToParOrg = document.createElement('button');
        btnToParOrg.innerText = 'Перейти до органiзацiй';
        btnToParOrg.classList.add('btnToParOrg');  
        
        
        const btnToReturn = document.createElement('button');
        btnToReturn.innerText = 'Повернутися';
        btnToReturn.style.display = 'none';
        btnToReturn.classList.add('btnToReturn');
        
        toChildOrganization.appendChild(btnToParOrg);
        toChildOrganization.appendChild(btnToReturn);
        
        btnToParOrg.addEventListener('click', event =>{
            const organizationName = document.getElementById('organizationName').innerText;
            const organizationId = document.getElementById('organizationName').value;
            btnToParOrg.style.display = 'none';
            btnToReturn.style.display = 'block';
            this.messageService.publish({name: 'reloadMainTable', orgName: organizationName, orgId: organizationId });
        }); 
        btnToReturn.addEventListener('click', event =>{
            document.getElementById('table3__organization').style.display = 'none';
            document.getElementById('table2__mainTable').style.display = 'block';
            btnToReturn.style.display = 'none';
            btnToParOrg.style.display = 'block';
            
        });
    },

};
}());
