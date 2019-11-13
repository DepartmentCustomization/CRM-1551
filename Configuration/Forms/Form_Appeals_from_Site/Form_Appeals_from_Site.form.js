(function () {
  return {   
    IsCreateApplicant: 0,
    IsFormReturnModerated: function(){
        this.form.setControlVisibility('btn_searchPerson', false);
        this.form.setControlVisibility('additional', false);
        
        this.form.setGroupVisibility('Group_App_site', true); 
        this.form.setGroupVisibility('Appeal', true); 
        
    },
    queryFor_Applicant1551: function(ApplicantId){
                const queryFor_Applicant1551_IsFormOnlyRead = {
                    queryCode: 'Get_Applicant1551_ForSite',
                    parameterValues: [
                        {
                            key: '@ApplicantId',
                            value: ApplicantId
                        }
                             ]
                };

                this.queryExecutor.getValues(queryFor_Applicant1551_IsFormOnlyRead).subscribe(data => {
                      this.form.setControlValue('1551_Applicant_PIB', data.rows[0].values[0]);
                      this.form.setControlValue('1551_Applicant_Phone', data.rows[0].values[1]);
                      this.form.setControlValue('1551_Applicant_Address', data.rows[0].values[2]);
                      this.form.setControlValue('Applicant_INFO', 'Вибрано існуючого заявника в системі "'+data.rows[0].values[0]+'"');
                });
                
        this.form.setControlValue('Applicant_Id', ApplicantId);
    },    
    IsFormOnlyRead: function(){
        this.form.setGroupVisibility('Group_App_site', false);
        this.form.setGroupVisibility('Group2', false);
        this.details.setVisibility('Site_Applicant', false);
        this.form.setGroupVisibility('Appeal_Question', false);
        this.form.setGroupVisibility('bad_Appeal', false);
        this.form.setControlVisibility('btn_person1551_question', false);
        this.form.setControlVisibility('additional', false);
        this.form.setGroupVisibility('Group_PreviewApplicant', true); 
        this.form.setGroupVisibility('Appeal', true); 
        
        this.queryFor_Applicant1551(this.form.getControlValue('Applicant_Id'));    
    },
    init: function(){
        
        //скрываем кнопку "Сохранить" в верхнем правом углу
        document.getElementsByClassName('float_r')[0].children[1].style.display = 'none';

        
        this.form.onControlValueChanged('Question_TypeId', this.onChanged_Question_TypeId_Input.bind(this));
        this.form.onControlValueChanged('Question_Building', this.onChanged_Question_Building_Input.bind(this));
        this.form.onControlValueChanged('Question_Organization', this.onChanged_Question_Organization_Input.bind(this));
        this.form.onControlValueChanged('Applicant_Id', this.onChangedApplicant_Id.bind(this));
        // this.form.disableControl('Question_OrganizationId');
        this.form.disableControl('Question_ControlDate');
        this.details.setVisibility('Site_Applicant', false);
        this.form.setGroupVisibility('bad_Appeal', false);
        this.form.setGroupVisibility('Appeal_Question', false);
        this.form.setGroupVisibility('Group2', false);
        this.form.setGroupVisibility('Group_PreviewApplicant', false);
        this.form.setControlVisibility('btn_CreateApplicant1551', false);
         this.form.disableControl('Applicant_INFO');
            this.form.disableControl('1551_Applicant_PIB');
            this.form.disableControl('1551_Applicant_Phone');
            this.form.disableControl('1551_Applicant_Address');
            this.form.disableControl('ApplicantFromSite_PIB');
            this.form.disableControl('ApplicantFromSite_Mail');
            this.form.disableControl('ApplicantFromSite_Phone');
            this.form.disableControl('ApplicantFromSite_Address');
            this.form.disableControl('ApplicantFromSite_Sex');
            this.form.disableControl('ApplicantFromSite_Birthdate');
            this.form.disableControl('ApplicantFromSite_Age');
            this.form.disableControl('ApplicantFromSite_SocialState');
            this.form.disableControl('Applicant_Privilege');
            this.form.disableControl('AppealFromSite_Id');
            this.form.disableControl('AppealFromSite_WorkDirectionType');
            this.form.disableControl('AppealFromSite_Content');
            this.form.disableControl('AppealFromSite_Object');
            this.form.disableControl('AppealFromSite_SiteAppealsResult');
            this.form.disableControl('AppealFromSite_ReceiptDate');
            
            this.form.disableControl('1551_ApplicantFromSite_PIB');
            this.form.disableControl('1551_ApplicantFromSite_Phone');
            this.form.setControlValue('1551_ApplicantFromSite_PIB',this.form.getControlValue('ApplicantFromSite_PIB'));
            this.form.setControlValue('1551_ApplicantFromSite_Phone',this.form.getControlValue('ApplicantFromSite_Phone'));
            
        document.getElementById('additional').addEventListener("click", function(event) {
            this.form.setGroupVisibility('bad_Appeal', true);
            this.IsFormReturnModerated();
        }.bind(this));
        
        document.getElementById('btn_CreateApplicant1551').addEventListener("click", function(event) {
            this.CreateApplicant1551();
            this.details.setVisibility('Site_Applicant', false);
            
            this.form.setControlValue('Applicant_INFO', 'Буде створено новий заявник в системі "'+this.form.getControlValue('ApplicantFromSite_PIB')+'"');
        }.bind(this));   
        
        document.getElementById('btn_person1551_question').addEventListener("click", function(event) {
            this.CreateApplicant1551();
            this.details.setVisibility('Site_Applicant', false);
        }.bind(this)); 
        
        
        
        document.getElementById('btn_searchPerson').addEventListener("click", function(event) {
            this.form.setGroupVisibility('Group2', true);
            this.form.setControlVisibility('btn_CreateApplicant1551', false);
            // this.form.setGroupExpanding('Group_App_site', false);
        }.bind(this)); 
        
        
        document.getElementById('Question_BuildingIcon').style.fontSize = '30px';
        document.getElementById('Question_BuildingIcon').addEventListener("click", function(event) {
            event.stopImmediatePropagation();
            this.form.setControlValue('Question_Building',{ key: this.form.getControlValue('AppealFromSite_Object'), value: this.form.getControlDisplayValue('AppealFromSite_Object')});
            // debugger;
        }.bind(this)); 
        
        document.getElementById('btn_SearchApplicant1551').addEventListener("click", function(event) {
            this.form.setControlVisibility('btn_CreateApplicant1551', true);
            this.SerchApplicant1551();
        }.bind(this));  
        
        document.getElementById('return_appeal').addEventListener("click", function(event) {
            this.ReturnAppealToApplicant();
        }.bind(this));  
        
        
        this.form.onGroupCloseClick('Group2',this.GroupClose_Group2.bind(this));
        this.form.onGroupCloseClick('Group_PreviewApplicant',this.GroupClose_Group_PreviewApplicant.bind(this));
        this.form.onGroupCloseClick('Appeal_Question',this.GroupClose_Appeal_Question.bind(this));
        
        this.details.onCellClick('Site_Applicant', this.OnCellClikc_Detail_Site_Applicant.bind(this));
        
        //Кнопка "Зберегти" в группе "Реєстрація питання"
         document.getElementById('Question_Btn_Add').addEventListener("click", function(event) {
            //  debugger
             const queryForGetValue3 = {
                    queryCode: 'ForSite_Question_Btn_Add_InsertRow',
                    parameterValues: [
                        {
                            key: '@Applicant_Id',
                            value: this.form.getControlValue('Applicant_Id')
                        },
                        {
                            key: '@1551_ApplicantFromSite_PIB',
                            value: this.form.getControlValue('1551_ApplicantFromSite_PIB')
                        },
                        {
                            key: '@ApplicantFromSite_Birthdate',
                            value: this.form.getControlValue('ApplicantFromSite_Birthdate')
                        },
                        {
                            key: '@ApplicantFromSite_SocialState',
                            value: this.form.getControlValue('ApplicantFromSite_SocialState')
                        },
                        {
                            key: '@Applicant_Privilege',
                            value: this.form.getControlValue('Applicant_Privilege')
                        },
                        {
                            key: '@ApplicantFromSite_Sex',
                            value: this.form.getControlValue('ApplicantFromSite_Sex')
                        },
                        {
                            key: '@ApplicantFromSite_Age',
                            value: this.form.getControlValue('ApplicantFromSite_Age')
                        },
                        {
                            key: '@AppealsFromSite_Id',
                            value: this.id
                        },
                        {
                            key: '@Question_ControlDate',
                            value: this.form.getControlValue('Question_ControlDate')
                        },
                        {
                            key: '@Question_Building',
                            value: this.form.getControlValue('Question_Building')
                        },
                        {
                            key: '@Question_Organization',
                            value: this.form.getControlValue('Question_Organization')
                        },
                        {
                            key: '@Question_TypeId',
                            value: this.form.getControlValue('Question_TypeId')
                        },
                        {
                            key: '@Question_Content',
                            value: this.form.getControlValue('AppealFromSite_Content')
                        },
                        {
                            key: '@entrance',
                            value: this.form.getControlValue('entrance')
                        },
                        {
                            key: '@flat',
                            value: this.form.getControlValue('flat')
                        },
                        {
                            key: '@1551_ApplicantFromSite_Address_Building',
                            value: this.form.getControlValue('1551_ApplicantFromSite_Address_Building')
                        },
                        {
                            key: '@1551_ApplicantFromSite_Address_Entrance',
                            value: this.form.getControlValue('1551_ApplicantFromSite_Address_Entrance')
                        },
                        {
                            key: '@1551_ApplicantFromSite_Address_Flat',
                            value: this.form.getControlValue('1551_ApplicantFromSite_Address_Flat')
                        }
                            ]
                };
                 
                this.queryExecutor.getValues(queryForGetValue3).subscribe(data => {
                    
                            const parameters2 = [
                                                { key: '@AppealId', value: data.rows[0].values[3] }
                                            ];
                            this.details.loadData('Detail_QuestionReestration_Site', parameters2/*, filters, sorting*/);
                            this.form.setControlValue('AppealFromSite_SiteAppealsResult', { key: data.rows[0].values[0], value: data.rows[0].values[1] });
                            this.form.setControlValue('Applicant_Id', data.rows[0].values[2]);
                            
                            
                            this.IsFormOnlyRead();
                            
                    
                        //      const queryForGetValue4 = {
                        //     queryCode: 'Appeals_SelectRow',
                        //     parameterValues: [
                        //         {
                        //             key: '@Id',
                        //             value: this.id
                        //         }
                        //     ]
                        // };
                        
                        // this.queryExecutor.getValues(queryForGetValue4).subscribe(data => {
                        //     debugger;
                        //     // this.form.setControlValue('AppealId', data.rows[0].values[0]);
                        //     // this.form.setControlValue('ReceiptSources', { key: data.rows[0].values[4], value: data.rows[0].values[19] });
                        //     // this.form.setControlValue('AppealNumber', data.rows[0].values[3]);
                        //     // this.form.setControlValue('Phone', data.rows[0].values[5]);
                        //     // // this.form.setControlValue('DateStart', new Date(data.rows[0].values[10]));
                        //     // this.form.setControlValue('DateStart', new Date());
                            
                        //     // //Detail_QuestionReestration
                        //     // const parameters2 = [
                        //     //                     { key: '@AppealId', value: data.rows[0].values[0] }
                        //     //                 ];
                        //     // this.details.loadData('Detail_QuestionReestration', parameters2/*, filters, sorting*/);
                        // });
                });

         }.bind(this));   
         
         
         if (this.form.getControlValue('AppealFromSite_SiteAppealsResult') == 3) {
           this.IsFormOnlyRead();  
         };
         
         if (this.form.getControlValue('AppealFromSite_SiteAppealsResult') == 2) {
           this.IsFormReturnModerated();  
         };
         
    
    },
    onQuestionControlDate:function(ques_type_id){
        if (ques_type_id == null){
            this.form.setControlValue('Question_ControlDate',null )
        }else{
        const execute = {
            queryCode: 'list_onExecuteTerm',
            parameterValues: [{
                            key: '@q_type_id',
                            value:ques_type_id
                        }]
        };
        
        this.queryExecutor.getValues(execute).subscribe(data => {
            // debugger;
            const d = data.rows[0].values[0];
            const dat = d.replace('T',' ').slice(0,16);
            this.form.setControlValue('Question_ControlDate',dat )
        });
        }
        
    },
    
    onChanged_Question_TypeId_Input: function(value) {
        this.onQuestionControlDate(value);
        
         this.Question_TypeId_Input = value;
          this.onChanged_Question_Btn_Add_Input();
          this.getOrgExecut();
          
            const objAndOrg = {
                            queryCode: 'QuestionTypes_HideColumns',
                            parameterValues: [
                            {
                                key: '@question_type_id',
                                value: this.form.getControlValue('Question_TypeId')
                            }
                        ]
                        };
                        
                        this.queryExecutor.getValues(objAndOrg).subscribe(data => {
                                
                            if (data.rows.length > 0) {
                                
                                //"Organization_is"
                                if (data.rows[0].values[0]) {
                                    this.form.setControlVisibility('Question_Organization', true);
                                } else {
                                    this.form.setControlVisibility('Question_Organization', false);
                                };
                                
                                 //"Object_is"
                                if (data.rows[0].values[1]) {
                                    
                                    this.form.setControlVisibility('Question_Building', true);
                                    // this.form.setControlVisibility('entrance', true);
                                    // this.form.setControlVisibility('flat', true);
                                            const objAndFlat = {
                                                queryCode: 'QuestionFlat_HideColumns',
                                                parameterValues: [
                                                {
                                                    key: '@Question_BuildingId',
                                                    value: this.form.getControlValue('Question_Building')
                                                }
                                            ]
                                            };
                                            
                                            this.queryExecutor.getValues(objAndFlat).subscribe(data => {
                                                
                                                if (data.rows.length > 0) {
                                                    
                                                    
                                                         if (this.form.getControlValue('Question_TypeId') == null) {
                                                                this.form.setControlVisibility('entrance', false);
                                                                this.form.setControlVisibility('flat', false);
                                                                     
                                                            
                                                         }else {
                                                             if (data.rows.length > 0) {
                                                                 
                                                                         if (data.rows[0].values == 1 || data.rows[0].values == 112) {/*Житлові будинки*/
                                                                             this.form.setControlVisibility('entrance', true);
                                                                             this.form.setControlVisibility('flat', true);
                                                                         } else {
                                                                             this.form.setControlVisibility('entrance', false);
                                                                             this.form.setControlVisibility('flat', false);
                                                                         };
                                                                      } else {
                                                                          this.form.setControlVisibility('entrance', false);
                                                                          this.form.setControlVisibility('flat', false);
                                                                     };
                                                         };
                                            
                                                    
                                                 } else {
                                                     this.form.setControlVisibility('entrance', false);
                                                     this.form.setControlVisibility('flat', false);
                                                };
                                                    
                                            });
                                    
                                } else {
                                    this.form.setControlVisibility('Question_Building', false);
                                    this.form.setControlVisibility('entrance', false);
                                    this.form.setControlVisibility('flat', false);
                                };
                            } else {
                                this.form.setControlVisibility('Question_Building', false);
                                this.form.setControlVisibility('Question_Organization', false);
                                this.form.setControlVisibility('entrance', false);
                                this.form.setControlVisibility('flat', false);
                                
                            };
                                
                        });
    },
     onChanged_Question_Building_Input: function(value) {
        
        if (value) {   
        if (typeof value === "string") {
            
             return
        } else {
        
         this.Question_Building_Input = value;
          this.onChanged_Question_Btn_Add_Input();
           this.getOrgExecut();
        //   debugger;
          if (this.form.getControlValue('Question_TypeId') == null) {
              this.form.setControlVisibility('entrance', false);
              this.form.setControlVisibility('flat', false);
              
          } else {
                 const objAndFlat = {
                                      queryCode: 'QuestionFlat_HideColumns',
                                      parameterValues: [
                                      {
                                          key: '@Question_BuildingId',
                                          value: this.form.getControlValue('Question_Building')
                                      }
                                  ]
                                  };
                                  // 
                                  this.queryExecutor.getValues(objAndFlat).subscribe(data => {
                                      if (data.rows.length > 0) {
                                          if (data.rows[0].values == 1 || data.rows[0].values == 112) {/*Житлові будинки*/
                                              this.form.setControlVisibility('entrance', true);
                                              this.form.setControlVisibility('flat', true);
                                          } else {
                                              this.form.setControlVisibility('entrance', false);
                                              this.form.setControlVisibility('flat', false);
                                          };
                                       } else {
                                           this.form.setControlVisibility('entrance', false);
                                           this.form.setControlVisibility('flat', false);
                                      };
                                  });   
          };
        };
      } else {
            this.form.setControlVisibility('entrance', false);
            this.form.setControlVisibility('flat', false);
      };
           
    },
    onChangedApplicant_Id: function(value) {
        this.onChanged_Question_Btn_Add_Input();
    },
    onChanged_Question_Organization_Input: function(value) {
          this.Question_Organization_Input = value;
          this.onChanged_Question_Btn_Add_Input();
           this.getOrgExecut();
    },
    getOrgExecut: function() {
         const objAndOrg = {
                            queryCode: 'getOrganizationExecutor',
                            parameterValues: [
                            {
                                key: '@question_type_id',
                                value: this.form.getControlValue('Question_TypeId')
                            },
                            {
                                key: '@object_id',
                                value: this.form.getControlValue('Question_Building')
                            },
                            {
                                key: '@organization_id',
                                value: this.form.getControlValue('Question_Organization')
                            }
                        ]
                        };
                        
                        this.queryExecutor.getValues(objAndOrg).subscribe(data => {
                            // debugger
                                this.form.setControlValue('Question_OrganizationId', { key: data.rows[0].values[0], value: data.rows[0].values[1] });
                        });
    },
    Question_Building_Input: undefined,
    Question_Organization_Input: undefined,
    Question_TypeId_Input: undefined,
    
    onChanged_Question_Btn_Add_Input: function() {
       if( this.Question_TypeId_Input == null || this.Question_TypeId_Input == undefined
          || ((this.Question_Building_Input == undefined || this.Question_Building_Input == null) && (this.Question_Organization_Input  == undefined || this.Question_Organization_Input  == null)) == true 
         ) {
           document.getElementById('Question_Btn_Add').disabled = true;
       } else { 
           document.getElementById('Question_Btn_Add').disabled = false;
       };
    },
    CreateApplicant1551: function (){
         this.form.setGroupVisibility('Group_App_site', false);
         this.form.setGroupVisibility('Group2', false);
         this.form.setGroupVisibility('Appeal_Question', true);
    },
    OnCellClikc_Detail_Site_Applicant: function(column, row, value, event, indexOfColumnId) {
        this.form.setGroupVisibility('Group_PreviewApplicant', true);
        
        this.queryFor_Applicant1551(row.values[0]); 
                
        this.form.setGroupVisibility('Group2', false);        
        this.IsCreateApplicant = 0;
        
    },
    SerchApplicant1551:function(){
        const parameters = [
            { key: '@AppealFromSite_Id', value: this.id },
            { key: '@BuildingId', value: this.form.getControlValue('1551_ApplicantFromSite_Address_Building') },
            { key: '@Flat', value: this.form.getControlValue('1551_ApplicantFromSite_Address_Flat') }
        ];
        
        const filters = [

        ];
        
        const sorting = [
            { key: "PIB", value: 0 }
        ];
        
        this.details.loadData('Site_Applicant', parameters, filters, sorting);
        
        this.details.setVisibility('Site_Applicant', true);
       
    },
    GroupClose_Appeal_Question:function(){
       this.form.setGroupVisibility('Group2', false);
       this.details.setVisibility('Site_Applicant', false);
       this.form.setGroupVisibility('Group_App_site', true); 
       this.form.setGroupExpanding('Group_App_site', true); 
    },
    GroupClose_Group_PreviewApplicant:function(){
        
        if (this.form.getControlValue('AppealFromSite_SiteAppealsResult') == 1) {
            this.form.setGroupVisibility('Group2', false);
            this.form.setControlValue('Applicant_Id', null);
            this.form.setControlValue('Applicant_INFO', null);
            this.form.setGroupVisibility('Appeal_Question', false); 
            this.details.setVisibility('Site_Applicant', false);
            this.form.setGroupVisibility('Group_App_site', true); 
            this.form.setGroupExpanding('Group_App_site', true);  
         } else {
             event.stopImmediatePropagation();
         };
            
    },
    
    GroupClose_Group2:function(){
       this.form.setGroupExpanding('Group_App_site', true);
       this.details.setVisibility('Site_Applicant', false);
    },
    ReturnAppealToApplicant:function(){
     const queryForReturnAppealToApplicant = {
                    queryCode: 'ReturnAppealFromSiteToApplicant',
                    parameterValues: [
                        {
                            key: '@Id',
                            value: this.id
                        },
                        {
                            key: '@AppealFromSite_CommentModerator',
                            value: this.form.getControlValue('AppealFromSite_CommentModerator')
                        }
                             ]
                };

                this.queryExecutor.getValues(queryForReturnAppealToApplicant).subscribe(data => {
                       this.form.setGroupVisibility('bad_Appeal', false);
                       this.form.setControlValue('AppealFromSite_SiteAppealsResult', {key: 2, value: 'Повернуто заявнику'});     
                });

    }
};
}());
