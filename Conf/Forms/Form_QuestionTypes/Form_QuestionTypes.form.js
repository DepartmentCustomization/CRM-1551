(function () {
  return {
    init: function(){
        this.form.disableControl('Id');
        //this.form.disableControl('rule_id');
        this.form.disableControl('edit_date');
        this.form.disableControl('user_edit_id');
        this.form.disableControl('qwerty');
        
       // document.getElementById("qwerty").style.cssText = "none";
        document.getElementById("qwerty").style.backgroundColor="white";
        //style="background-color: red; width: 900px; height: 100px">; backgroundColor = 'red'


        
        //
        let btn_changeRule = document.getElementById('btn_changeRule');
        let that = this;
        
        btn_changeRule.addEventListener('click', function(){
            const FormRules = {
                title: 'Правило вибору',
                // title: 'FormR',
                acceptBtnText: 'ok',
                cancelBtnText: 'cancel',
                fieldGroups:[
                        {
                            code: 'GroupField_Rule',
                            expand: true,
                            position: 1,
                            fields:[
                                {
                                 code: 'executor_role_level',
                                 fullScreen: false,
                                 hidden: false,
                                 placeholder: 'Рівень ролі',
                                 position: 1,
                                 required: false,
                                 type: 'select',
                                 queryListCode: 'list_ExecutorRoleLevel',
                                 listDisplayColumn: "name",
                                 listKeyColumn: "Id"
                                },
                                {
                                 code: 'executor_role',
                                 fullScreen: false,
                                 hidden: false,
                                 placeholder: 'Роль виконавця',
                                 position: 2,
                                 required: false,
                                 type: 'text'
                                },
                                {
                                 code: 'RuleOfChoice',
                                 fullScreen: false,
                                 hidden: false,
                                 placeholder: 'Правило вибору',
                                 position: 3,
                                 required: false,
                                 type: 'text'
                                },
                                {
                                 code: 'priority',
                                 fullScreen: false,
                                 hidden: false,
                                 placeholder: 'Пріоритет',
                                 position: 4,
                                 required: false,
                                 type: 'number'
                                },
                                {
                                 code: 'main',
                                 fullScreen: false,
                                 hidden: false,
                                 placeholder: 'Головний',
                                 position: 7,
                                 required: false,
                                 type: 'checkbox'
                                },
                                {
                                 code: 'priocessing_kind',
                                 fullScreen: true,
                                 hidden: false,
                                 placeholder: 'Тип обробки',
                                 position: 6,
                                 required: false,
                                 type: 'select',
                                 queryListCode: 'list_ProcessingKind',
                                 listDisplayColumn: "name",
                                 listKeyColumn: "Id"
                                }
                            ]
                        }]
            };
            
            const changeRules = (date) =>{
                console.log(date);
            }
            
            
           that.openModalForm(FormRules, changeRules);
        });
        
        
    }
};
}());
