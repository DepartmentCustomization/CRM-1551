(function () {
  return {
    init: function(){
        this.form.disableControl('registration_number');
        this.form.disableControl('receipt_source_id');
        this.form.disableControl('phone_number');
        
        var num = this.form.getControlValue('phone_number');
        if(num !== null){
            this.form.setControlValue('receipt_source_id', {key:1 , value:'Дзвінок в 1551'});
        };
        let appl = [{ parameterCode: '@phone_number', parameterValue: num }];
        this.form.setControlParameterValues('applicant_id', appl);
        
        this.form.setControlValue('answer_type_id', {key:1 , value:'Без відповіді'});
        this.form.setControlVisibility('answer_phone',false);
        this.form.setControlVisibility('answer_post', false);
        this.form.setControlVisibility('answer_mail', false);
        this.form.onControlValueChanged('answer_type_id', this.visibilityTypeResponse);
        
        var phone = document.getElementById('phone_number');
        phone.style.color = 'black';
        phone.style.fontWeight = 'bold';
        
        // this.form.onControlValueChanged('phone_number', this.onAppealsChanged);
        // this.onAppealsChanged(num);

        this.form.onControlValueChanged('applicant_id', this.ondataApplicant);

                                            //Modal new Applicant//
        const formNewApplicant = {
            title: 'Новий заявник',
            acceptBtnText: "save",
            cancelBtnText: "cancel",
            fieldGroups:[
                    {
                        code: 'ModalNewApp',
                        expand: true,
                        position: 1,
                        fields: [
                            {
                              code:'n_phone_number',
                              placeholder:'Номер телефону',
                              hidden: false,
                              required: false,
                              position: 1,
                              fullScreen: false,
                              value: this.form.getControlValue('phone_number'),
                              type: 'text'  
                            },
                            {
                              code:'n_full_name',
                              placeholder:'Призвіще, ім`я та по батькові',
                              hidden: false,
                              required: true,
                              position: 2,
                              fullScreen: true,
                              value: '',
                              type: 'text'  
                            },
                            {
                              code:'n_applicant_type_id',
                              placeholder:'Тип заявника',
                              hidden: false,
                              required: true,
                              position: 3,
                              fullScreen: false,
                              queryListCode: "dir_ApplicantTypes_SelectRows",
                              listDisplayColumn: "name",
                              listKeyColumn: "Id",
                              type: 'select'  
                            },
                            {
                              code:'n_social_state_id',
                              placeholder:'Соціальний стан',
                              hidden: false,
                              required: true,
                              position: 4,
                              fullScreen: false,
                              queryListCode: "dir_SocialState_SelectRows",
                              listDisplayColumn: "name",
                              listKeyColumn: "Id",
                              type: 'select'  
                            },
                            {
                              code:'n_applicant_category_id',
                              placeholder:'Категорія заявника',
                              hidden: false,
                              required: true,
                              position: 5,
                              fullScreen: true,
                              queryListCode: "dir_ApplicantCategories_SelectRows",
                              listDisplayColumn: "name",
                              listKeyColumn: "Id",
                              type: 'select'  
                            },
                            {
                              code:'n_sex',
                              placeholder: 'Стать',
                              hidden: false,
                              required: true,
                              position: 6,
                              fullScreen: true,
                              queryListCode: "dir_ApplicantCategories_SelectRows",
                              listDisplayColumn: "name",
                              listKeyColumn: "Id",
                              radioItems: [{ value: 1, viewValue: 'Жінка' },{ value: 2, viewValue: 'Чоловік' }],
                              type: 'radio'
                              
                            }
                        ]
                    }
                ]
        };
        
        const addApplicantCallBack = (param) => {
            if (param === false){
                console.log('It`s a cancel');
            }else{
                console.log('It`s a good');
                const body = {
                    queryCode: 'cx_modal_Applicants_Insert',
                    parameterValues: param
                }
                this.queryExecutor.submitValues(body).subscribe();
            }
        }
        
        var icon = document.getElementById('applicant_idIcon');
        icon.addEventListener("click", () =>  {
            this.openModalForm(formNewApplicant, addApplicantCallBack);;
        });
    },
    ondataApplicant: function(app_info){
        const parameters = [{key : '@app_info', value : app_info}]
        this.details.loadData('Detail_other_phone', parameters);
    },
    
    visibilityTypeResponse: function(id){
         if (id == 1 || id == 5){
            this.form.setControlVisibility('answer_post',false);
            this.form.setControlVisibility('answer_phone',false);
            this.form.setControlVisibility('answer_mail', false);
        }
        if (id == 2){
            this.form.setControlVisibility('answer_phone',true);
            this.form.setControlVisibility('answer_post', false);
            this.form.setControlVisibility('answer_mail', false);
        }
         if (id == 3){
            this.form.setControlVisibility('answer_mail',true);
            this.form.setControlVisibility('answer_phone',false);
            this.form.setControlVisibility('answer_post', false);
        }
         if (id == 4){
            this.form.setControlVisibility('answer_post',true);
            this.form.setControlVisibility('answer_phone',false);
            this.form.setControlVisibility('answer_mail', false);
        }
    }
    //   onAppealsChanged: function(app_Id) {
    //     let appl = [{ parameterCode: '@phone_number', parameterValue: app_Id }];
    //     this.form.setControlParameterValues('applicant_id', appl);
    // }
};
}());
