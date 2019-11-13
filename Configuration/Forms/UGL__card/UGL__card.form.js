(function () {
    return {
      RecordId: 0,
      StateServerId: 0,
  
      onLoadModalPhone: function() {
          
          debugger;
          this.modal_phone_NEW = null; 
          const queryForGetValue22 = {
              queryCode: 'GetApplicantPhonesForApplicantId',
              parameterValues: [{ key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')}]
          };
              
          this.queryExecutor.getValues(queryForGetValue22).subscribe(function (data){
              
              this.kolvoPhonesForApplicant =  data.rows.length-1;
              
              if (data.rows.length > 0){
                  const fieldsForm = {
                      title: 'Телефони заявника',
                      acceptBtnText: 'save',
                      cancelBtnText: 'exit',
                      singleButton: false, 
                      fieldGroups: []
                  };
                              
                  for (let j = 0; j < data.rows.length; j++ ){
                      if(data.rows[j].values[5] == 1) {
                          
                          var p = {
                              code: 'GroupPhone'+j,
                              name: 'Створення телефону',
                              expand: true,
                              position: data.rows[j].values[0],
                              fields: []
                          };
                                  
                          fieldsForm.fieldGroups.push(p);
                          
                          var c = fieldsForm.fieldGroups.length-1;
                          var t = {
                              code: data.rows[j].values[1],
                              fullScreen: true,
                              hidden: false,
                              placeholder: data.rows[j].values[2],
                              position: 1,
                              required: false,
                              value: data.rows[j].values[3],
                              disabled: true,
                              type: "text",
                              icon: 'phone_forwarded',
                              iconHint: 'Скопіювати з вхідного номера телефону',
                              maxlength: 14,
                              width: '50%'
                          };
                          fieldsForm.fieldGroups[c].fields.push(t);
                          
                          var t0_0 = {
                              code: data.rows[j].values[1]+'_phoneType',
                              fullScreen: true,
                              hidden: false,
                              placeholder: 'Тип',
                              position: 2,
                              required: false,
                              value: "Мобільний",
                              keyValue: 1,
                              listKeyColumn: "Id",
                              listDisplayColumn: "name",
                              type: "select",
                              queryListCode: "dir_PhoneTypes_SelectRows",
                              width: '50%'
                          };
                          fieldsForm.fieldGroups[c].fields.push(t0_0);
                          
                          var t0_2 = {
                              code: data.rows[j].values[1]+'_phoneIsMain',
                              fullScreen: true,
                              hidden: false,
                              placeholder: 'Основний?',
                              position: 3,
                              required: false,
                              value: false,
                              type: "checkbox",
                              width: '50%'
                          };
                          
                          fieldsForm.fieldGroups[c].fields.push(t0_2);
                          
                          
                          var t0_1 = {
                              code: data.rows[j].values[1]+'_phoneDelete',
                              fullScreen: true,
                              hidden: false,
                              placeholder: 'Додати',
                              position: 4,
                              icon: 'add',
                              required: false,
                              type: "button",
                              width: '50%'
                          };
                          
                          fieldsForm.fieldGroups[c].fields.push(t0_1);
                          
                      } else {
                          var p1 = {
                              code: 'GroupPhone'+j,
                              name: data.rows[j].values[2],
                              expand: true,
                              position: data.rows[j].values[0],
                              fields: []
                          };
                                  
                          fieldsForm.fieldGroups.push(p1);
                          
                          var c1 = fieldsForm.fieldGroups.length-1;
                          var t1_0 = {
                              code: data.rows[j].values[1]+'_phoneNumber',
                              fullScreen: true,
                              hidden: false,
                              placeholder: 'Номер телефону',
                              position: 1,
                              required: false,
                              value: data.rows[j].values[3],
                              type: "text",
                              maxlength: 14,
                              width: '50%'
                          };
                          fieldsForm.fieldGroups[c1].fields.push(t1_0);
                          
                          var t1_1 = {
                              code: data.rows[j].values[1]+'_phoneType',
                              fullScreen: true,
                              hidden: false,
                              placeholder: 'Тип',
                              position: 2,
                              required: false,
                              value: data.rows[j].values[7],
                              keyValue: data.rows[j].values[6],
                              listKeyColumn: "Id",
                              listDisplayColumn: "name",
                              type: "select",
                              queryListCode: "dir_PhoneTypes_SelectRows",
                              width: '50%'
                          };
                          fieldsForm.fieldGroups[c1].fields.push(t1_1);
                          
                          var t1_2 = {
                              code: data.rows[j].values[1]+'_phoneIsMain',
                              fullScreen: true,
                              hidden: false,
                              placeholder: 'Основний?',
                              position: 3,
                              required: false,
                              value: data.rows[j].values[4],
                              type: "checkbox",
                              width: '50%'
                          };
                          
                          fieldsForm.fieldGroups[c1].fields.push(t1_2);
                          
                          if (data.rows[j].values[4]) {
                              var t1_3_0 = {
                                  code: 'phoneDelete_Disabled',
                                  fullScreen: true,
                                  hidden: false,
                                  placeholder: 'Видалити',
                                  position: 4,
                                  required: false,
                                  icon: 'delete',
                                  type: "button",
                                  width: '50%'
                              };
                              
                              fieldsForm.fieldGroups[c1].fields.push(t1_3_0);
                          } else {
                              var t1_3_1 = {
                                  code: data.rows[j].values[1]+'_phoneDelete',
                                  fullScreen: true,
                                  hidden: false,
                                  placeholder: 'Видалити',
                                  position: 4,
                                  required: false,
                                  icon: 'delete',
                                  type: "button",
                                  width: '50%'
                              };
                              
                              fieldsForm.fieldGroups[c1].fields.push(t1_3_1);
                          }
                          
                          var t1_4 = {
                              code: data.rows[j].values[1]+'_phoneId',
                              fullScreen: true,
                              hidden: true,
                              placeholder: 'Id',
                              position: 5,
                              value: data.rows[j].values[8],
                              required: false,
                              type: "text",
                              width: '100%'
                          };
                          
                          fieldsForm.fieldGroups[c1].fields.push(t1_4);
                      };
                  };
                  this.openModalForm(fieldsForm, this.onModal_Phone.bind(this), this.afterModal_Phone_FormOpen.bind(this));
              };
              
          }.bind(this));
      },
      onChangeCardPhone: function(value) {
          for (let u = 0; u < this.kolvoPhonesForApplicant; u++ ){
              this.formModalConfig.setControlValue('modal_phone'+(u+1)+'_phoneIsMain', false);
          };
          // var t = event.currentTarget.id;   
          // var t2 = t.substr(0, (t.length-6));
          // this.formModalConfig.setControlValue(t2, true);
      }, 
       extractStartDate:function() {
                         
          function addDays(theDate, days) {
              return new Date(theDate.getTime() + days*24*60*60*1000);
          }
          var newDate = addDays(new Date(), 14);            
          var inMonth = newDate;
          inMonth.setMonth(newDate.getMonth()+1);
          var dd = inMonth.getDate();
          var mm = inMonth.getMonth(); //January is 0!
          var yyyy = inMonth.getFullYear();
          var hh = inMonth.getHours();
          var mi = inMonth.getMinutes();
          var ss = inMonth.getSeconds();
  
          if(dd<10) { dd='0'+dd }
          if(mm<10) { mm='0'+mm }
          if(hh<10) { hh='0'+hh}
          if(mi<10) { mi='0'+mi }
          if(ss<10) { ss='0'+ss }           
          return yyyy+'-'+mm+'-'+dd+' 23:59:59';
      },
      convertDateNull:function(value){
          if (!value) {return this.extractStartDate();} else {return value;};
      },
      mask: function(event) {
           
          function setCursorPosition(pos, elem) {
              elem.focus();
              if (elem.setSelectionRange) {
                  elem.setSelectionRange(pos, pos);
              } else if (elem.createTextRange) {
                  var range = elem.createTextRange();
                  range.collapse(true);
                  range.moveEnd("character", pos);
                  range.moveStart("character", pos);
                  range.select()
              }
          }
          
          var matrix = "(___)___-__-__",
          i = 0,
          def = matrix.replace(/\D/g, ""),
          val = this.value.replace(/\D/g, "");
          if (def.length >= val.length) val = def;
          this.value = matrix.replace(/./g, function(a) {
              return /[_\d]/.test(a) && i < val.length ? val.charAt(i++) : i >= val.length ? "" : a
          });
      
          if (event.type == "blur") {
              if (this.value.length == 2) this.value = ""
          } else {
              setCursorPosition(this.value.length, this)
          }
      },
      onModalPhonesChanged: function(phone) {
          if (!phone) {
              document.getElementById('modal_phone_NEW_phoneDelete').disabled = true;
          } else {
              if (phone.replace('(','').replace(')','').replace(/-/g,'').replace(/\D/g,'').length == 10) {
                  document.getElementById('modal_phone_NEW_phoneDelete').disabled = false;
              } else {
                  document.getElementById('modal_phone_NEW_phoneDelete').disabled = true;
              };
          };
      },
      onRecalcCardPhone: function() {
          const queryForGetValue_RecalcPhone = {
              queryCode: 'ApplicantPhonesRecalcCardPhone',
              parameterValues: [{ key: '@Applicant_id', value: this.form.getControlValue('Applicant_Id')}]
          };
          
          this.queryExecutor.getValues(queryForGetValue_RecalcPhone).subscribe(function (data){
              this.form.setControlValue('CardPhone' ,data.rows[0].values[0]);
          }.bind(this));
          
          const queryForGetValue_GetIsMainPhone = {
              queryCode: 'GetApplicantPhonesIsMain',
              parameterValues: [{ key: '@Applicant_id', value: this.form.getControlValue('Applicant_Id')}]
          };
          
          this.queryExecutor.getValues(queryForGetValue_GetIsMainPhone).subscribe(function (data){
              this.form.setControlValue('Applicant_Phone_Hide' ,data.rows[0].values[0]);
          }.bind(this));
      },
      onDeleteCardPhone: function(phone) {
          const queryForGetValue_DeletePhone = {
              queryCode: 'ApplicantPhonesDelete',
              parameterValues: [{ key: '@PhoneId', value: this.formModalConfig.getControlValue('modal_phone'+phone+'_phoneId')}]
          };
                      
          this.queryExecutor.getValues(queryForGetValue_DeletePhone).subscribe(function (data){
              var event = new Event("click");
              document.querySelector('smart-bi-modal-form > div.btn-center-control > button.smart-btn.btn-back.ng-star-inserted').dispatchEvent(event);
          
              this.onLoadModalPhone();
              this.onRecalcCardPhone();
              
              //LoadDetail Detail_Aplicant
              const parameters_01 = [
                  { key: '@phone_number', value: this.form.getControlValue('Phone') }
              ];
              this.details.loadData('Detail_Aplicant', parameters_01/*, filters, sorting*/);       
          }.bind(this));
                      
          // this.formModalConfig.getControlValue('modal_phone'+phone+'_phoneId');
      },
      afterModal_Phone_FormOpen: function(form) {
          // console.log('Open ', form);
          form.formConfig = this;
          this.formModalConfig = form;
          
          if (this.kolvoPhonesForApplicant > 0) {
              for (let u = 0; u < this.kolvoPhonesForApplicant; u++ ){
                  document.getElementById('modal_phone'+(u+1)+'_phoneIsMain').addEventListener("click", function(event) {
                      this.formConfig.onChangeCardPhone(true);
                  }.bind(form)); 
                  if (document.getElementById('modal_phone'+(u+1)+'_phoneDelete')) {
                      document.getElementById('modal_phone'+(u+1)+'_phoneDelete').addEventListener("click", function(event) {
                          this.formConfig.onDeleteCardPhone(u+1);
                      }.bind(form)); 
                  };
                      
                  var input = document.getElementById("modal_phone"+(u+1)+"_phoneNumber");
                  input.addEventListener("input", this.mask, false);
                  input.addEventListener("focus", this.mask, false);
                  input.addEventListener("blur", this.mask, false);
                  input.addEventListener("change", this.mask, false);
              };
              document.getElementById('phoneDelete_Disabled').disabled = true;
              
              for (let u2 = 0; u2 < this.kolvoPhonesForApplicant; u2++ ){
                  document.getElementById("modal_phone"+(u2+1)+"_phoneNumber").focus();
              };
          };
  
          form.onControlValueChanged('modal_phone_NEW', this.onModalPhonesChanged);
          document.getElementById('modal_phone_NEW_phoneDelete').disabled = true;
          
                
                
          if (this.form.getControlValue('Applicant_Id')) {
              document.getElementById('modal_phone_NEW_phoneDelete').addEventListener("click", function(event) {
                  const queryForGetValue_AddNewPhone = {
                      queryCode: 'ApplicantPhonesAdd',
                      parameterValues: [{ key: '@Applicant_id', value: this.formConfig.form.getControlValue('Applicant_Id')}, { key: '@TypePhone', value: this.getControlValue('modal_phone_NEW_phoneType')}, { key: '@Phone', value: this.getControlValue('modal_phone_NEW')}, { key: '@IsMain', value: this.getControlValue('modal_phone_NEW_phoneIsMain')}]
                  };
  
                  this.formConfig.queryExecutor.getValues(queryForGetValue_AddNewPhone).subscribe(function (data){
                      if (data.rows[0].values[0] == "OK") {
                          this.setControlValue('modal_phone_NEW', null);
                          
                          var event = new Event("click");
                          document.querySelector('smart-bi-modal-form > div.btn-center-control > button.smart-btn.btn-back.ng-star-inserted').dispatchEvent(event);
                          
                          this.formConfig.onLoadModalPhone();
                          this.formConfig.onRecalcCardPhone();
                          //LoadDetail Detail_Aplicant
                          const parameters_02 = [
                                              { key: '@phone_number', value: this.formConfig.form.getControlValue('Phone') }
                                          ];
                          this.formConfig.details.loadData('Detail_Aplicant', parameters_02/*, filters, sorting*/);
                      } else {
                          this.setControlValue('modal_phone_NEW', null);
                          this.formConfig.openPopUpInfoDialog('Помилка. Такий номер вже існує!');
                      };
                  }.bind(this));
              }.bind(form));  
         
              // document.getElementById('modal_phone_NEW_phoneDelete').style.backgroundColor = "#56ce70 !important";
              var input3 = document.getElementById("modal_phone_NEW");
                    input3.addEventListener("input", this.mask, false);
                    input3.addEventListener("focus", this.mask, false);
                    input3.addEventListener("blur", this.mask, false);
                    input3.addEventListener("change", this.mask, false);
                    document.getElementById('modal_phone_NEW').focus();
                    document.getElementById('modal_phone_NEW_phoneDelete').focus();
                    
              document.getElementById('modal_phone_NEWIcon').addEventListener("click", function(event) {
                  this.setControlValue('modal_phone_NEW',this.formConfig.form.getControlValue('Phone'));
                  document.getElementById('modal_phone_NEW').focus();
                    document.getElementById('modal_phone_NEW_phoneDelete').focus();
              }.bind(form));    
          };
      },
      onModal_Phone: function(value) {
       
      //  if 
      //  value.find(f => f.key === '@modal_phone1_phoneNumber').value
      
          if (value) {
              if (this.kolvoPhonesForApplicant > 0) {
                  for (let u = 0; u < this.kolvoPhonesForApplicant; u++ ){
                  
                      const queryForGetValue_UpdatePhone = {
                          queryCode: 'ApplicantPhonesUpdate',
                          parameterValues: [{ key: '@Applicant_id', value: this.form.getControlValue('Applicant_Id')}, 
                                              { key: '@TypePhone', value: value.find(f => f.key === '@modal_phone'+(u+1)+'_phoneType').value}, 
                                              { key: '@Phone', value: value.find(f => f.key === '@modal_phone'+(u+1)+'_phoneNumber').value}, 
                                              { key: '@IsMain', value: value.find(f => f.key === '@modal_phone'+(u+1)+'_phoneIsMain').value}, 
                                              { key: '@IdPhone', value: value.find(f => f.key === '@modal_phone'+(u+1)+'_phoneId').value}]
                      };
                      
                      this.queryExecutor.getValues(queryForGetValue_UpdatePhone).subscribe(function (data){
                          // debugger;
                          // var event = new Event("click");
                          // document.querySelector('smart-bi-modal-form > div.btn-center-control > button.smart-btn.btn-back.ng-star-inserted').dispatchEvent(event);
                      
                          //  this.onLoadModalPhone();
                                  
                      }.bind(this));
                      
                  
                      //  console.log(value.find(f => f.key === '@modal_phone'+(u+1)+'_phoneNumber').value);
                      //  console.log(value.find(f => f.key === '@modal_phone'+(u+1)+'_phoneId').value);
                      //  console.log(value.find(f => f.key === '@modal_phone'+(u+1)+'_phoneIsMain').value);
                      //  console.log(value.find(f => f.key === '@modal_phone'+(u+1)+'_phoneType').value);
                  };
                  const parameters_03 = [
                                      { key: '@phone_number', value: this.form.getControlValue('Phone') }
                                  ];
                  this.details.loadData('Detail_Aplicant', parameters_03/*, filters, sorting*/);
                  this.onRecalcCardPhone();
              };
          };
      }, 
      TypeFormId: 0,
      init: function() {
          
          this.form.disableControl('Question_OrganizationId');
          this.form.setControlVisibility('Question_Building', false);
          this.form.setControlVisibility('Question_Organization', false);
          this.form.setControlVisibility('entrance', false);
          this.form.setControlVisibility('flat', false);
          this.form.setControlVisibility('Event_Prew_Name', false);
                                  
          //скрываем кнопку "Назад" и "Сохранить" в верхнем правом углу
          document.getElementsByClassName('float_r')[0].style.display = 'none';
          // document.querySelectorAll('div.card-title > div > button')[1].style.display = 'none'
          
          // this.form.disableControl('Applicant_District');
          
          //mask for phone
          function setCursorPosition(pos, elem) {
              elem.focus();
              if (elem.setSelectionRange) {
                  elem.setSelectionRange(pos, pos);
              } else if (elem.createTextRange) {
                  var range = elem.createTextRange();
                  range.collapse(true);
                  range.moveEnd("character", pos);
                  range.moveStart("character", pos);
                  range.select()
              }
          }
          
          function mask(event) {
              debugger;
              var matrix = "(___)___-__-__",
                  i = 0,
                  def = matrix.replace(/\D/g, ""),
                  val = this.value.replace(/\D/g, "");
              if (def.length >= val.length) val = def;
              this.value = matrix.replace(/./g, function(a) {
                  return /[_\d]/.test(a) && i < val.length ? val.charAt(i++) : i >= val.length ? "" : a
              });
          
              if (event.type == "blur") {
                  if (this.value.length == 2) this.value = ""
              } else setCursorPosition(this.value.length, this)
          };
              
  
  
  
          if (this.state == "create") {
              var getDataFromLink = window
                  .location
                      .search
                          .replace('?', '')
                              .split('&')
                                  .reduce(
                                      function(p, e) {
                                          var a = e.split('=');
                                          p[decodeURIComponent(a[0])] = decodeURIComponent(a[1]);
                                          return p;
                                      }, {}
                                  );
  
              this.TypeFormId = Number(getDataFromLink["type"]);
  
              if (Number(getDataFromLink["type"]) >= 1 && Number(getDataFromLink["type"]) <= 8) {
                  // Submit Appeal
                  var val_phone = '';
                  if (getDataFromLink["phone"] == undefined) {
                      val_phone = '«не визначений»';
                  } else {
                      val_phone = getDataFromLink["phone"]
                  };
                  
                  const queryForGetValue = {
                      queryCode: 'Appeals_Insert',
                      parameterValues: [
                          {
                              key: '@receipt_source_id',
                              value: Number(getDataFromLink["type"])
                          },
                          {
                              key: '@phone_number',
                              value: val_phone
                          }
                      ]
                  };
                  this.queryExecutor.getValue(queryForGetValue).subscribe(data => {
                      this.navigateTo('sections/CreateAppeal/edit/'+data)
                  //   this.logger(data);
                  });
              }
          }else{
              document.getElementById('CardPhone').addEventListener("click", function(event) {
                  this.onLoadModalPhone();
              }.bind(this));  
              
              const queryForGetValue_enter_number = {
                  queryCode: 'GetAppeal_receipt_source_id',
                  parameterValues: [
                      {
                          key: '@AppealId',
                          value: this.id
                      }
                  ]
              }; 
                      
                      
              this.queryExecutor.getValues(queryForGetValue_enter_number).subscribe(data => {
                  if (data) {
                      if (data.rows.length > 0) {
                          if (data.rows[0].values[0] == "UGL" || data.rows[0].values[0] == "Mail" || data.rows[0].values[0] == "Letter") {
                              this.form.setControlVisibility('Appeal_enter_number', true);
                          } else {
                              this.form.setControlVisibility('Appeal_enter_number', false);
                          }
                      } else {
                          this.form.setControlVisibility('Appeal_enter_number', false);
                      }
                  } else {
                      this.form.setControlVisibility('Appeal_enter_number', false);
                  }
              });      
              document.getElementById('Appeal_enter_numberIcon').addEventListener("click", function(event) {   
                  const queryForGetValueSet_enter_number = {
                      queryCode: 'GetAppeal_Set_enter_number',
                      parameterValues: [
                          {
                              key: '@AppealId',
                              value: this.form.getControlValue('AppealId')
                          },
                          {
                              key: '@Enter_number',
                              value: this.form.getControlValue('Appeal_enter_number')
                          }
                      ]
                  };
                  this.queryExecutor.getValues(queryForGetValueSet_enter_number).subscribe(data => {});
              }.bind(this));  
              this.form.disableControl('Question_Prew_ApplicantPIB');
              this.form.disableControl('Question_Prew_ApplicantAdress');
              
              this.form.disableControl('AppealId');
              this.form.disableControl('ReceiptSources');
              this.form.disableControl('AppealNumber');
              this.form.disableControl('Phone');
              this.form.disableControl('DateStart');
              this.form.disableControl('DateEnd');
              this.form.disableControl('Applicant_Age');
              this.form.disableControl('Question_ControlDate');
              this.form.disableControl('CardPhone');
                  
              this.form.onControlValueChanged('Question_AnswerType', this.onChangedQuestion_AnswerType.bind(this));
              document.getElementById('Question_Btn_Add').disabled = true;
              document.getElementById('Work_with_a_question_Btn_save').disabled = true;
              
              this.form.onControlValueChanged('Applicant_Id', this.onChangedApplicant_Id.bind(this));
              
              var getDataFromLink = window
                  .location
                      .pathname
                          .split('/')
                              this.RecordId = Number(getDataFromLink[4]);
          
              const queryForGetValueStateServer = {
                  queryCode: 'LoadServer_SelectRow',
                  parameterValues: []
              };
                      
              this.queryExecutor.getValues(queryForGetValueStateServer).subscribe(data => {
                  if (data.rows[0].values[3] == "Simple load") {this.StateServerId = 1;}
                  else if (data.rows[0].values[3] == "Standart load") {this.StateServerId = 2;}
                  else if (data.rows[0].values[3] == "Hard load") {this.StateServerId = 3;
                                                                      this.form.setGroupVisibility('Group_WIKI', false);};
                      
                  //  console.log('LoadServerCode =', data.rows[0].values[3], '; StateServerId = ', this.StateServerId);   
                      
                  if (this.StateServerId == 1) {
                          this.form.setControlVisibility('Question_OrganizationId', true);
                  } else {
                          this.form.setControlVisibility('Question_OrganizationId', false);
                  }; 
              });
              const queryForGetValue = {
                  queryCode: 'Appeals_SelectRow',
                  parameterValues: [
                      {
                          key: '@Id',
                          value: this.id
                      }
                  ]
              };
                      
              this.queryExecutor.getValues(queryForGetValue).subscribe(data => {
                  this.form.setControlValue('AppealId', data.rows[0].values[0]);
                  this.form.setControlValue('ReceiptSources', { key: data.rows[0].values[4], value: data.rows[0].values[19] });
                  this.form.setControlValue('AppealNumber', data.rows[0].values[3]);
                  this.form.setControlValue('Phone', data.rows[0].values[5]);
                  // this.form.setControlValue('DateStart', new Date(data.rows[0].values[10]));
                  this.form.setControlValue('DateStart', new Date());
                  this.form.setControlValue('CardPhone', this.form.getControlValue('Phone'));
                  //LoadDetail Detail_Aplicant
                  const parameters = [
                      { key: '@phone_number', value: data.rows[0].values[5] }
                  ];
                  this.details.loadData('Detail_Aplicant', parameters/*, filters, sorting*/);
                      //Detail_QuestionReestration
                  const parameters2 = [
                      { key: '@AppealId', value: data.rows[0].values[0] }
                  ];
                  this.details.loadData('Detail_QuestionReestration', parameters2/*, filters, sorting*/); 
              });
              
              //Счетчик времени в группе "Загальна інформація" по полю "Дата та час закінчення розмови"
              
              this.interval = setInterval(function() {
                  var d = new Date();
                  this.form.setControlValue('DateEnd', d);
              }.bind(this), 1000);
  
  
              this.form.disableControl("ExecutorInRoleForObject");
              this.form.disableControl("Applicant_District");
          
              //Кнопка "WIKI_Btn_Search" в группе "Консультація за БЗ"
              document.getElementById('WIKI_Btn_Search').addEventListener("click", function(event) {
                  const queryForGetValue3 = {
                      queryCode: 'WIKI_Btn_Search_InsertRow',
                      parameterValues: [
                          {
                              key: '@Applicant_Phone',
                              value: this.form.getControlValue('Applicant_Phone_Hide')
                          },
                          {
                              key: '@AppealId',
                              value: this.form.getControlValue('AppealId')
                          },
                          {
                              key: '@Applicant_Building',
                              value: this.form.getControlValue('Applicant_Building')
                          }
                              ]
                  };
                  
                  this.queryExecutor.getValues(queryForGetValue3).subscribe(data => {
                              window.open('http://wiki.1551.gov.ua/', '_blank');
                          //ReLoadDetail Detail_Consultation
                          const parameters1 = [
                                              { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                                              { key: '@appeal_id',  value: this.form.getControlValue('AppealId')},
                                              { key: '@phone_number', value: this.form.getControlValue('Applicant_Phone_Hide')}
                                          ];
                          this.details.loadData('Detail_Consultation', parameters1/*, filters, sorting*/);        
                  });
  
              }.bind(this));  
              
              document.getElementById('WIKI_Btn_Consultation').addEventListener("click", function(event) {
                  const queryForGetValue3 = {
                      queryCode: 'WIKI_Btn_Search_InsertRow',
                      parameterValues: [
                          {
                              key: '@Applicant_Phone',
                              value: this.form.getControlValue('Applicant_Phone_Hide')
                          },
                          {
                              key: '@AppealId',
                              value: this.form.getControlValue('AppealId')
                          },
                          {
                              key: '@Applicant_Building',
                              value: this.form.getControlValue('Applicant_Building')
                          },
                          { //add Artem
                              key: '@applicant_id',
                              value: this.form.getControlValue('Applicant_Id')
                          }
                                  ]
                  };
                      
                  this.queryExecutor.getValues(queryForGetValue3).subscribe(data => {
                              //ReLoadDetail Detail_Consultation
                      const parameters1 = [
                          { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                          { key: '@appeal_id',  value: this.form.getControlValue('AppealId')},
                          { key: '@phone_number', value: this.form.getControlValue('Applicant_Phone_Hide')}
                      ];
                      this.details.loadData('Detail_Consultation', parameters1/*, filters, sorting*/);
                  });
              }.bind(this));  
              
              
              document.getElementById('Question_Prew_Btn_Consultation').addEventListener("click", function(event) {
                  const queryForGetValue3 = {
                      queryCode: 'Question_Prew_Btn_Consultation_InsertRow',
                      parameterValues: [
                          {
                              key: '@Applicant_Phone',
                              value: this.form.getControlValue('Applicant_Phone_Hide')
                          },
                          {
                              key: '@AppealId',
                              value: this.form.getControlValue('AppealId')
                          },
                          {
                              key: '@Applicant_Building',
                              value: this.form.getControlValue('Applicant_Building')
                          },
                          {
                              key: '@Question_Prew_Id',
                              value: this.form.getControlValue('Question_Prew_Id')
                          },
                          {
                              key: '@Question_Prew_TypeId',
                              value: this.form.getControlValue('Question_Prew_TypeId')
                          }
                      ]
                  };
                      
                  this.queryExecutor.getValues(queryForGetValue3).subscribe(data => {
                      //ReLoadDetail Detail_Consultation
                      const parameters1 = [
                          { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                          { key: '@appeal_id',  value: this.form.getControlValue('AppealId')},
                          { key: '@phone_number', value: this.form.getControlValue('Applicant_Phone_Hide')}
                      ];
                      this.details.loadData('Detail_Consultation', parameters1/*, filters, sorting*/);
                  });
  
              }.bind(this)); 
              
              
          
              document.getElementById('GorodokClaim_Prew_Btn_Consultation').addEventListener("click", function(event) {
                  const queryForGetValue3 = {
                      queryCode: 'GorodokClaim_Prew_Btn_Consultation_InsertRow',
                      parameterValues: [
                          {
                              key: '@Applicant_Phone',
                              value: this.form.getControlValue('Applicant_Phone_Hide')
                          },
                          {
                              key: '@AppealId',
                              value: this.form.getControlValue('AppealId')
                          },
                          {
                              key: '@Applicant_Building',
                              value: this.form.getControlValue('Applicant_Building')
                          },
                          {
                              key: '@GorodokClaim_RowId',
                              value: this.form.getControlValue('GorodokClaim_RowId')
                          }
                      ]
                  };
                      
                  this.queryExecutor.getValues(queryForGetValue3).subscribe(data => {
                      //ReLoadDetail Detail_Consultation
                      const parameters1 = [
                          { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                          { key: '@appeal_id',  value: this.form.getControlValue('AppealId')},
                          { key: '@phone_number', value: this.form.getControlValue('Applicant_Phone_Hide')}
                      ];
                      this.details.loadData('Detail_Consultation', parameters1/*, filters, sorting*/);
                  });
  
              }.bind(this));
  
              document.getElementById('Event_Prew_Btn_Consultation').addEventListener("click", function(event) {
                  const queryForGetValue3 = {
                      queryCode: 'Event_Prew_Btn_Consultation_InsertRow',
                      parameterValues: [
                          {
                              key: '@Applicant_Phone',
                              value: this.form.getControlValue('Applicant_Phone_Hide')
                          },
                          {
                              key: '@AppealId',
                              value: this.form.getControlValue('AppealId')
                          },
                          {
                              key: '@Applicant_Building',
                              value: this.form.getControlValue('Applicant_Building')
                          },
                          {
                              key: '@Event_Prew_Id',
                              value: this.form.getControlValue('Event_Prew_Id')
                          }
                      ]
                  };
                      
                  this.queryExecutor.getValues(queryForGetValue3).subscribe(data => {
                      //ReLoadDetail Detail_Consultation
                      const parameters1 = [
                          { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                          { key: '@appeal_id',  value: this.form.getControlValue('AppealId')},
                          { key: '@phone_number', value: this.form.getControlValue('Applicant_Phone_Hide')}
                      ];
                      this.details.loadData('Detail_Consultation', parameters1/*, filters, sorting*/);
                  });
              }.bind(this));  
              
          //Кнопка "Зберегти" в группе "Реєстрація питання"
              document.getElementById('Question_Btn_Add').addEventListener("click", function(event) {
                  const queryForGetValue3 = {
                      queryCode: 'Question_Btn_Add_InsertRow',
                      parameterValues: [
                          {
                              key: '@AppealId',
                              value: this.form.getControlValue('AppealId')
                          },
                          {
                              key: '@AppealNumber',
                              value: this.form.getControlValue('AppealNumber')
                          },
                          {
                              key: '@Question_TypeId',
                              value: this.form.getControlValue('Question_TypeId')
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
                              key: '@Question_EventId',
                              value: this.form.getControlValue('Question_EventId')
                          },
                          {
                              key: '@Question_Content',
                              value: this.form.getControlValue('Question_Content')
                          },
                          {
                              key: '@Question_AnswerType',
                              value: this.form.getControlValue('Question_AnswerType')
                          },
                          {
                              key: '@Applicant_Phone',
                              value: this.form.getControlValue('Phone')
                          },
                          {
                              key: '@Applicant_Email',
                              value: this.form.getControlValue('Applicant_Email')
                          },
                          {
                              key: '@Applicant_Building',
                              // value: this.form.getControlValue('Adress')
                              value: this.form.getControlValue('Adress_for_answer')
                          },
                          {
                              key: '@Question_OrganizationId',
                              value: this.form.getControlValue('Question_OrganizationId')
                          },
                          {
                              key: '@applicant_id',
                              value: this.form.getControlValue('Applicant_Id')
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
                              key: '@Question_ControlDate',
                              value: new Date(this.convertDateNull(this.form.getControlValue('Question_ControlDate')))
                          }
                              ]
                  };
                      
                  this.queryExecutor.getValues(queryForGetValue3).subscribe(data => {
                      const queryForGetValue4 = {
                          queryCode: 'Appeals_SelectRow',
                          parameterValues: [
                              {
                                  key: '@Id',
                                  value: this.id
                              }
                          ]
                      };
                      this.queryExecutor.getValues(queryForGetValue4).subscribe(data => {
                          this.form.setControlValue('AppealId', data.rows[0].values[0]);
                          this.form.setControlValue('ReceiptSources', { key: data.rows[0].values[4], value: data.rows[0].values[19] });
                          this.form.setControlValue('AppealNumber', data.rows[0].values[3]);
                          this.form.setControlValue('Phone', data.rows[0].values[5]);
                          // this.form.setControlValue('DateStart', new Date(data.rows[0].values[10]));
                          this.form.setControlValue('DateStart', new Date());
                          
                          
                          //LoadDetail Detail_Aplicant
                          const parameters = [
                                              { key: '@phone_number', value: data.rows[0].values[5] }
                                          ];
                          this.details.loadData('Detail_Aplicant', parameters/*, filters, sorting*/);
                          
                          //Detail_QuestionReestration
                          const parameters2 = [
                                              { key: '@AppealId', value: data.rows[0].values[0] }
                                          ];
                          this.details.loadData('Detail_QuestionReestration', parameters2/*, filters, sorting*/);
                      });
                  });
                  this.form.setControlValue('Question_Organization', {}); 
                  this.form.setControlValue('Question_Content', ""); 
                  this.form.setControlValue('Question_TypeId', {}); 
                  this.form.setControlValue('Question_OrganizationId', {}); 
                  this.form.setControlValue('Question_ControlDate', ""); 
                  // this.form.setControlValue('Question_AnswerType', {}); 
                  // this.form.setControlValue('Question_AnswerPhoneOrPost', ""); 
                  this.form.setControlValue('Question_EventId', null); 
              }.bind(this));  
              this.details.onCellClick('Detail_Aplicant', this.Detail_Aplicant.bind(this)); 
              this.details.onCellClick('Detail_QuestionReestration', this.Detail_QuestionReestration.bind(this)); 
              this.details.onCellClick('Detail_Consultation', this.OnCellClikc_Detail_Consultation.bind(this)); 
              
              this.form.onGroupCloseClick('Group_Preview_Question', this.Group_Preview_Question_Close.bind(this));
              
              this.form.setGroupVisibility('Group_Preview_Question', false);
              this.form.setGroupVisibility('Group_Events', false);
              this.form.setGroupVisibility('Group_GorodokClaims', false);
              // this.form.setGroupVisibility('Group_WIKI', false);
              
              //Кнопка "Зберегти" в группе "Заявник"
              document.getElementById('Applicant_Btn_Add').addEventListener("click", function(event) {
                  const queryForGetValue2 = {
                      queryCode: 'Applicant_Btn_Add_InsertRow',
                      parameterValues: [
                          {
                              key: '@Applicant_Id',
                              value: this.form.getControlValue('Applicant_Id')
                          },
                          {
                              key: '@Applicant_PIB',
                              value: this.form.getControlValue('Applicant_PIB')
                          },
                          {
                              key: '@Applicant_Privilege',
                              value: this.form.getControlValue('Applicant_Privilege')
                          },
                          {
                              key: '@Applicant_SocialStates',
                              value: this.form.getControlValue('Applicant_SocialStates')
                          },
                          {
                              key: '@Applicant_CategoryType',
                              value: this.form.getControlValue('Applicant_CategoryType')
                          },
                          {
                              key: '@Applicant_Type',
                              value: this.form.getControlValue('Applicant_Type')
                          },
                          {
                              key: '@Applicant_Sex',
                              value: this.form.getControlValue('Applicant_Sex')
                          },
                          {
                              key: '@Application_BirthDate',
                              value: this.form.getControlValue('Application_BirthDate')
                          },
                          {
                              key: '@Applicant_Age',
                              value: this.form.getControlValue('Applicant_Age')
                          },
                          {
                              key: '@Applicant_Comment',
                              value: this.form.getControlValue('Applicant_Comment')
                          },
                          {
                              key: '@Applicant_Building',
                              value: this.form.getControlValue('Applicant_Building')
                          },
                          {
                              key: '@Applicant_HouseBlock',
                              value: this.form.getControlValue('Applicant_HouseBlock')
                          },
                          {
                              key: '@Applicant_Entrance',
                              value: this.form.getControlValue('Applicant_Entrance')
                          },
                          {
                              key: '@Applicant_Flat',
                              value: this.form.getControlValue('Applicant_Flat')
                          },
                          {
                              key: '@AppealId',
                              value: this.form.getControlValue('AppealId')
                          },
                          {
                              key: '@Applicant_Phone',
                              value: this.form.getControlValue('Phone')
                          },
                          {
                              key: '@Applicant_Email',
                              value: this.form.getControlValue('Applicant_Email')
                          },
                          {
                              key: '@Applicant_TypePhone',
                              value: 1
                          }
                          
                          
                      ]
                  };
                      
                  this.queryExecutor.getValues(queryForGetValue2).subscribe(data => {
                          
                      this.form.setControlValue('Applicant_Id', data.rows[0].values[0]); 
                      const queryForGetValue3 = {
                          queryCode: 'Appeals_SelectRow',
                          parameterValues: [
                              {
                                  key: '@Id',
                                  value: this.id
                              }
                          ]
                      };
                              
                      this.queryExecutor.getValues(queryForGetValue3).subscribe(data => {
                          this.form.setControlValue('AppealId', data.rows[0].values[0]);
                          this.form.setControlValue('ReceiptSources', { key: data.rows[0].values[4], value: data.rows[0].values[19] });
                          this.form.setControlValue('AppealNumber', data.rows[0].values[3]);
                          this.form.setControlValue('Phone', data.rows[0].values[5]);
                          this.form.setControlValue('DateStart', new Date());
                                  
                                  //LoadDetail Detail_Aplicant
                          const parameters = [
                                              { key: '@phone_number', value: this.form.getControlValue('Phone') }
                                          ];
                          this.details.loadData('Detail_Aplicant', parameters/*, filters, sorting*/);
                          
                          //Detail_QuestionReestration
                          const parameters2 = [
                                              { key: '@AppealId', value: data.rows[0].values[0] }
                                          ];
                          this.details.loadData('Detail_QuestionReestration', parameters2/*, filters, sorting*/);
                          
                          this.onRecalcCardPhone();
                      });
                              
                      this.onChanged_Question_Aplicant_Btn_Add_Input();
                  });
  
                  document.getElementById('Applicant_Btn_Add').disabled = true;
                  this.details.setVisibility('Detail_Consultation', true);
                  
              }.bind(this));  
              
              //Кнопка "Очистити" в группе "Заявник"
              document.getElementById('Applicant_Btn_Clear').addEventListener("click", function(event) {
                  // event.stopPropagation();
                  this.form.setGroupVisibility('Group_CreateQuestion', false);
                  
                  this.form.setControlValue('Applicant_Id', null);
                  this.form.setControlValue('Applicant_PIB', '');
                  this.form.setControlValue('Applicant_District', {});
                  this.form.setControlValue('Applicant_Building', {});
                  this.form.setControlValue('Applicant_HouseBlock', '');
                  this.form.setControlValue('Applicant_Entrance', '');
                  this.form.setControlValue('Applicant_Flat', '');
                  this.form.setControlValue('Applicant_Privilege', {});
                  this.form.setControlValue('Applicant_SocialStates', {});
                  this.form.setControlValue('Applicant_CategoryType', {});
                  this.form.setControlValue('Applicant_Type', {});
                  this.form.setControlValue('Applicant_Sex',  '');
                  this.form.setControlValue('Application_BirthDate', '');
                  this.form.setControlValue('Applicant_Age', '');
                  this.form.setControlValue('Applicant_Email', '');
                  this.form.setControlValue('Applicant_Comment', '');
                  this.details.setVisibility('Detail_Consultation', false);
                  this.form.setControlValue('Applicant_Phone_Hide', null);
                  this.form.setControlValue('CardPhone', null);
                  
                  this.form.setControlValue('CardPhone', this.form.getControlValue('Phone'));
              
              }.bind(this)); 
              
              this.form.setGroupVisibility('Group_CreateQuestion', false);
              document.getElementById('Question_Aplicant_Btn_Add').addEventListener("click", function(event) {
                  const objNameQuestion_AnswerType = {
                      queryCode: 'dir_AnswerTypes_SelectRow',
                      parameterValues: [
                          {
                              key: '@Id',
                              // value: 2 /*За телефоном*/
                              value: this.form.getControlValue('ReceiptSources')
                          }
                      ]
                  };
                  this.queryExecutor.getValues(objNameQuestion_AnswerType).subscribe(data => {
                      this.form.setControlValue('Question_AnswerType',  { key: data.rows[0].values[0], value: data.rows[0].values[1]} ); 
                  });
                  this.form.setControlValue('Question_AnswerPhoneOrPost', this.form.getControlValue('Applicant_Phone_Hide'));
                  this.form.setGroupVisibility('Group_CreateQuestion', true);
                  
                  this.form.setGroupVisibility('Group_Preview_Question', false)
                  this.form.setGroupVisibility('Group_Events', false);
                  this.form.setGroupVisibility('Group_GorodokClaims', false);
                  
                  this.form.setControlValue('Question_EventId', null); 
                  // this.form.setGroupVisibility('Group_WIKI', false);
  
                  this.scrollTopMainForm();
                  
              }.bind(this));
              
  
              document.getElementById('GorodokClaim_Prew_Btn_Add').addEventListener("click", function(event) {
                  this.form.setGroupVisibility('Group_CreateQuestion', true);
                  
                  this.form.setGroupVisibility('Group_Preview_Question', false)
                  this.form.setGroupVisibility('Group_Events', false);
                  this.form.setGroupVisibility('Group_GorodokClaims', false);
                  
                  this.form.setControlValue('Question_EventId', null); 
                  // this.form.setGroupVisibility('Group_WIKI', false);
              }.bind(this));
              
              document.getElementById('Question_Prew_Btn_Add').addEventListener("click", function(event) {
                  this.form.setGroupVisibility('Group_CreateQuestion', true);
                  
                  this.form.setGroupVisibility('Group_Preview_Question', false)
                  this.form.setGroupVisibility('Group_Events', false);
                  this.form.setGroupVisibility('Group_GorodokClaims', false);
                  
                  this.form.setControlValue('Question_EventId', null); 
                  // this.form.setGroupVisibility('Group_WIKI', false);
              }.bind(this));
              
              document.getElementById('Question_Btn_work_with').addEventListener("click", function(event) {
                  this.form.setGroupVisibility('Group_Work_with_a_question', true);
              }.bind(this));
              
  
              document.getElementById('Event_Prew_Btn_Add').addEventListener("click", function(event) {
                  this.form.setGroupVisibility('Group_CreateQuestion', true);
                  
                  this.form.setGroupVisibility('Group_Preview_Question', false)
                  this.form.setGroupVisibility('Group_Events', false);
                  this.form.setGroupVisibility('Group_GorodokClaims', false);
                  
                  this.form.setControlValue('Question_EventId', this.form.getControlValue('Event_Prew_Id'));
                  // this.form.setGroupVisibility('Group_WIKI', false);
                  
              }.bind(this));
              
              
              const objNameApplicantPrivilege = {
                  queryCode: 'ak_SelectApplicantPrivilegeRow',
                  parameterValues: [
                  {
                      key: '@Id',
                      value: 60 /*Пільги відсутні*/
                  }
              ]
              };
              this.queryExecutor.getValues(objNameApplicantPrivilege).subscribe(data => {
                  this.form.setControlValue('Applicant_Privilege',  { key: data.rows[0].values[0], value: data.rows[0].values[1]} ); 
              });
                      
              const objNameApplicantGetApplicantTypes = {
                  queryCode: 'GetApplicantTypes',
                  parameterValues: [
                  {
                      key: '@Id',
                      value: 1 /*Звичайний*/
                  }
              ]
              };
              this.queryExecutor.getValues(objNameApplicantGetApplicantTypes).subscribe(data => {
                  this.form.setControlValue('Applicant_Type',  { key: data.rows[0].values[0], value: data.rows[0].values[1]} ); 
              });
                      
                      
              const objNameSocialState = {
                  queryCode: 'dir_SocialState_SelectRow',
                  parameterValues: [
                  {
                      key: '@Id',
                      value: 2 /*Робітник*/
                  }
              ]
              };
              this.queryExecutor.getValues(objNameSocialState).subscribe(data => {
                  this.form.setControlValue('Applicant_SocialStates',  { key: data.rows[0].values[0], value: data.rows[0].values[1]} ); 
              });
                      
          
              //  this.form.onControlValueChanged('Applicant_PIB', this.onChanged_Question_Aplicant_Btn_Add_Input.bind(this));
  
              this.form.onControlValueChanged('Applicant_Id', this.onChanged_Applicant_Id.bind(this));
  
              this.form.onControlValueChanged('Applicant_HouseBlock', this.onChanged_Applicant_HouseBlock_Input.bind(this));
              this.form.onControlValueChanged('Applicant_Flat', this.onChanged_Applicant_Flat_Input.bind(this));
              this.form.onControlValueChanged('Applicant_Type', this.onChanged_Applicant_Type_Input.bind(this));
              this.form.onControlValueChanged('Applicant_Sex', this.onChanged_Applicant_Sex_Input.bind(this));
              this.form.onControlValueChanged('Application_BirthDate', this.onChanged_Application_BirthDate_Input.bind(this));
              this.form.onControlValueChanged('Applicant_Email', this.onChanged_Applicant_Email_Input.bind(this));
              this.form.onControlValueChanged('Applicant_Comment', this.onChanged_Applicant_Comment_Input.bind(this));
  
  
              this.form.onControlValueChanged('Applicant_PIB', this.onChanged_Applicant_PIB_Input.bind(this));
              this.form.onControlValueChanged('CardPhone', this.onChanged_Applicant_Phone_Input.bind(this));
  
              this.form.onControlValueChanged('Applicant_Building', this.onChanged_Applicant_Building_Input.bind(this));
              this.form.onControlValueChanged('Applicant_Entrance', this.onChanged_Applicant_Entrance_Input.bind(this));
  
              this.form.onControlValueChanged('Applicant_Privilege', this.onChanged_Applicant_Privilege_Input.bind(this));
              this.form.onControlValueChanged('Applicant_SocialStates', this.onChanged_Applicant_SocialStates_Input.bind(this));
              this.form.onControlValueChanged('Applicant_CategoryType', this.onChanged_Applicant_CategoryType_Input.bind(this));
  
              this.form.onControlValueChanged('Question_TypeId', this.onChanged_Question_TypeId_Input.bind(this));
              this.form.onControlValueChanged('Question_Building', this.onChanged_Question_Building_Input.bind(this));
              this.form.onControlValueChanged('Question_Organization', this.onChanged_Question_Organization_Input.bind(this));
  
              this.form.onControlValueChanged('Question_Content', this.onChanged_Question_Content_Input.bind(this));
              this.form.onControlValueChanged('Question_AnswerType', this.onChanged_Question_AnswerType_Input.bind(this));
              
              //Кнопка "Пошук" (за № Звернення) в группе "Загальна інформація"
              this.form.onControlValueChanged('Search_Appeals_Input', this.onChanged_Search_Appeals_Input.bind(this));
              document.getElementById('Search_Appeals_Search').disabled = true;
              document.getElementById('Search_Appeals_Search').addEventListener("click", function(event) {
                  this.details.setVisibility('Detail_ConsultationAplicant', false);
                  this.details.setVisibility('Detail_QuestionApplicant', false);
                  this.details.setVisibility('Detail_QuestionObjectAplicant', false);
                  this.details.setVisibility('Detail_QuestionPhone', false);
                  this.details.setVisibility('Detail_QuestionBuildingAplicant', false);
                  this.details.setVisibility('Detail_GorodokClaim', false);
                  this.details.setVisibility('Detail_QuestionNumberAppeal', false);
                  
                  
                  //Detail_QuestionNumberAppeal
                  const parameters = [
                      { key: '@AppealRegistrationNumber', value: this.form.getControlValue('Search_Appeals_Input') }
                  ];
                  this.details.loadData('Detail_QuestionNumberAppeal', parameters/*, filters, sorting*/);
                  this.details.setVisibility('Detail_QuestionNumberAppeal', true);
              }.bind(this));
              
              //Кнопка "Закрити питання" в группе "Перегляд питання"
              document.getElementById('Question_Prew_Btn_Close').addEventListener("click", function(event) {
                  // event.stopPropagation();
                  const Question_Close_callback = (response) => {
                      
                      if (response) {
                          const objName = {
                              queryCode: 'CloseAssignments_UpdateRow',
                              parameterValues: [
                              {
                                  key: '@question_id',
                                  value: response[3].value
                              },
                              {
                                  key: '@AssignmentResultsId',
                                  value: response[0].value
                              },
                              {
                                  key: '@Question_Prew_Rating',
                                  value: response[1].value
                              },
                              {
                                  key: '@Question_Prew_Comment',
                                  value: response[2].value
                              }
                          ]
                          };
                          
                          this.queryExecutor.getValues(objName).subscribe(data => {
                              //ReLoadDetail Detail_Consultation
                              const parameters1 = [
                                  { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                                  { key: '@appeal_id',  value: this.form.getControlValue('AppealId')},
                                  { key: '@phone_number', value: this.form.getControlValue('Applicant_Phone_Hide')}
                              ];
                              this.details.loadData('Detail_Consultation', parameters1/*, filters, sorting*/);
                                  
                                  
                              this.details.setVisibility('Detail_ConsultationAplicant', false);
                              this.details.setVisibility('Detail_QuestionApplicant', false);
                              this.details.setVisibility('Detail_QuestionObjectAplicant', false);
                              this.details.setVisibility('Detail_QuestionPhone', false);
                              this.details.setVisibility('Detail_QuestionBuildingAplicant', false);
                              this.details.setVisibility('Detail_GorodokClaim', false);
                              this.form.setGroupVisibility('Group_Preview_Question', false);
                                  
                          });
                      };
                  };
          
                  const fieldsForm = {
                      title: ' ',
                      // singleButton: 1,
                      acceptBtnText: 'save',
                      cancelBtnText: 'exit',
                      fieldGroups: [
                          {
                              code: 'Question_Close',
                              name: 'Закриття питання',
                              expand: true,
                              position: 1,
                              fields: [
                                  {
                                      code: "Question_Prew_AssignmentResults",
                                      fullScreen: true,
                                      hidden: false,
                                      listKeyColumn: "Id",
                                      listDisplayColumn: "Name",
                                      placeholder: "Результат питання",
                                      position: 1,
                                      queryListCode: "List_AssignmentResults_InClosed_SelectRows",
                                      filterList: [{ parameterCode: '@QuestionId', parameterValue: this.form.getControlValue('Question_Prew_Id') }],
                                      required: true,
                                      type: "select"
                                  },
                                  {
                                      code: "Question_Prew_Rating",
                                      fullScreen: true,
                                      hidden: false,
                                      placeholder: "Оцінка результату виконаних робіт",
                                      position: 3,
                                      required: true,
                                      type: "radio",
                                      radioItems: [{ value: 1, viewValue: 1 },
                                                      { value: 2, viewValue: 2 },
                                                      { value: 3, viewValue: 3 },
                                                      { value: 4, viewValue: 4 },
                                                      { value: 5, viewValue: 5 }]
                                  },
                                  {
                                      code: "Question_Prew_Comment",
                                      fullScreen: true,
                                      hidden: false,
                                      placeholder: "Коментар оператора",
                                      position: 4,
                                      required: true,
                                      type: "text"
                                  },
                                  {
                                      code: "Question_Close_QuestionId",
                                      fullScreen: true,
                                      hidden: true,
                                      placeholder: "Question_Close_QuestionId",
                                      position: 5,
                                      required: false,
                                      type: "number",
                                      value: this.form.getControlValue('Question_Prew_Id')
                                  }
                              ]
                          }
                      ]
                  };
                  this.openModalForm(fieldsForm, Question_Close_callback.bind(this));
              }.bind(this)); 
              
              //Hide Export Excel for Detail
              for (var i=0;i<document.querySelectorAll('div.card-title > div > button').length;i++){
                  document.querySelectorAll('div.card-title > div > button')[i].style.display = 'none';
              };
              
              //Hide Detail or Group - FirstLoad
              this.details.setVisibility('Detail_QuestionApplicant', false);
              this.details.setVisibility('Detail_ConsultationAplicant', false);
              this.details.setVisibility('Detail_QuestionObjectAplicant', false);
              this.details.setVisibility('Detail_QuestionPhone', false);
              this.details.setVisibility('Detail_QuestionBuildingAplicant', false);
              this.details.setVisibility('Detail_GorodokClaim', false);
              this.details.setVisibility('Detail_QuestionNumberAppeal', false);
              this.details.setVisibility('Detail_Consultation', false);
              this.details.setVisibility('Detail_Event', false);
              
              this.details.onCellClick('Detail_QuestionApplicant', this.Detail_Question_Prev.bind(this)); 
              this.details.onCellClick('Detail_QuestionObjectAplicant', this.Detail_Question_Prev.bind(this)); 
              this.details.onCellClick('Detail_QuestionPhone', this.Detail_Question_Prev.bind(this)); 
              this.details.onCellClick('Detail_QuestionBuildingAplicant', this.Detail_Question_Prev.bind(this)); 
              this.details.onCellClick('Detail_QuestionNumberAppeal', this.Detail_Question_Prev.bind(this)); 
              
              this.details.onCellClick('Detail_GorodokClaim', this.onCellClick_Detail_GorodokClaim.bind(this)); 
              this.details.onCellClick('Detail_Event', this.onCellClick_Detail_Event.bind(this)); 
          };
              
          this.form.onControlValueChanged('Applicant_District', this.onDistricChanged);
          
          this.form.onControlValueChanged('Application_BirthDate', this.validateDate);
          this.form.onControlValueChanged('Question_TypeId', this.onQuestionControlDate); //Question_ControlDate
              
          this.form.disableControl('Event_Prew_Id');
          this.form.disableControl('Event_Prew_Type');
          this.form.disableControl('Event_Prew_Name');
          this.form.disableControl('Event_Prew_EventOrganizers');
          this.form.disableControl('Event_Prew_Comment');
          this.form.disableControl('Event_Prew_StartDate');
          this.form.disableControl('Event_Prew_PlanEndDate');
          
          this.form.disableControl('Question_Prew_Building');
          this.form.disableControl('Question_Prew_Organization');
          this.form.disableControl('Question_Prew_OrganizationId');
          this.form.disableControl('Question_Prew_Content');
          this.form.disableControl('Question_Prew_TypeId');
          this.form.disableControl('Question_Prew_ControlDate');
          this.form.disableControl('Question_Prew_States');
          this.form.disableControl('Question_Prew_AssignmentResolution');
          this.form.disableControl('Question_Prew_ResultText');
          this.form.disableControl('Question_Prew_CommentExecutor');
          this.form.disableControl('Question_Prew_Id');
      
          this.form.setGroupVisibility('Group_Work_with_a_question', false);
          
          this.form.onControlValueChanged('Work_with_a_question_organization', this.onPhoneWorkOrganization.bind(this));
          this.form.onControlValueChanged('Work_with_a_question_notes', this.onChanged_Work_with_a_question_notes.bind(this));
  
          document.getElementById('Work_with_a_question_Btn_save').addEventListener("click", function(event) {
  
              const work_notes  = {
                  queryCode: 'WorkWithaQuestionNotesSave',
                  parameterValues: [
                      {
                          key: '@notes',
                          value: this.form.getControlValue('Work_with_a_question_notes')
                      },
                      {
                          key: '@que_id',
                          value: this.form.getControlValue('Work_with_a_question_ID')
                      }
                  ]
              };
                      
              this.queryExecutor.getValues(work_notes).subscribe(data => {});
              this.form.setControlValue('Work_with_a_question_notes', null);
              this.form.setControlValue('Work_with_a_question_organization', null);
              this.form.setControlValue('Work_with_a_question_phone_org', null);
              this.form.setControlValue('Work_with_a_question_ID', null);
              
              this.form.setGroupVisibility('Group_Work_with_a_question', false);  
          }.bind(this));
              
      }, //END INIT
      onPhoneWorkOrganization:function(id_org){
          if (id_org) {
              if (typeof id_org === "string") {
                   return
              } else {
                  if (id_org) {
                      const org = {
                          queryCode: 'onPhoneOrganization',
                          parameterValues: [{key: '@org_id', value: id_org}]
                      };
                       this.queryExecutor.getValue(org).subscribe(data =>{
                          this.form.setControlValue('Work_with_a_question_phone_org', data);
                       });
                  }
              }
          }
          
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
                  const d = data.rows[0].values[0];
                  const dat = d.replace('T',' ').slice(0,16);
                  this.form.setControlValue('Question_ControlDate',dat )
              });
          }
          
      },
      validateDate:function(valid_date){
          
          const getAge = birthDate => Math.floor((new Date() - new Date(birthDate).getTime()) / 31556925994);
          let val_data = getAge(valid_date);
   
          if (val_data < 16 && val_data >= 0){
              const formValidDate = {
                  title: 'Дата народження введена некоректно',
                  text: 'Заявнику не може бути менше 16 років',
                  singleButton : true
              }
              const callbackValidDate = (res) =>{
                  this.form.setControlValue('Application_BirthDate', null);
                  this.form.setControlValue('Applicant_Age', null);
              }
              this.openModalForm(formValidDate, callbackValidDate);
          }else if(val_data < 0){
              const formValidDate = {
                  title: 'Дата народження введена некоректно',
                  text: ' Ви обрали майбутню дату',
                  singleButton : true
              }
              const callbackValidDate = (res) =>{
                  this.form.setControlValue('Application_BirthDate', null);
                  this.form.setControlValue('Applicant_Age', null);
              }
              this.openModalForm(formValidDate, callbackValidDate);
          }
          this.form.setControlValue('Applicant_Age', getAge(valid_date));
      },
      onDistricChanged:function(st_id){
          // this.form.setControlValue('Applicant_Building', {});
          // let dependParams = [{ parameterCode: '@street', parameterValue: st_id }];
          // this.form.setControlParameterValues('Applicant_Building', dependParams);
      },
      onCellClick_Detail_GorodokClaim: function(column, row, value, event, indexOfColumnId) {
          this.details.setVisibility('Detail_ConsultationAplicant', false);
          this.details.setVisibility('Detail_QuestionApplicant', false);
          this.details.setVisibility('Detail_QuestionObjectAplicant', false);
          this.details.setVisibility('Detail_QuestionPhone', false);
          this.details.setVisibility('Detail_QuestionBuildingAplicant', false);
          this.details.setVisibility('Detail_QuestionNumberAppeal', false);
            
            
          const queryForGetValues = {
              queryCode: 'PrevGorodokClaimForId_selectRow',
              parameterValues: [{
                  key: '@ClaimId',
                  value: row.values[5]
              }]
          };
          
          this.queryExecutor.getValues(queryForGetValues).subscribe(data => {
              this.form.setGroupVisibility('Group_Preview_Question', false);
              // this.form.setGroupVisibility('Group_WIKI', false);
              this.form.setGroupVisibility('Group_Events', false);
              this.form.setGroupVisibility('Group_CreateQuestion', false);
              
              this.form.setGroupVisibility('Group_GorodokClaims', true);
              
              this.form.setControlValue('GorodokClaim_RowId', data.rows[0].values[0]); //ID заявки
              this.form.setControlValue('GorodokClaim_Prew_Id', data.rows[0].values[1]); //Номер заявки
              this.form.setControlValue('GorodokClaim_Prew_State', data.rows[0].values[2]); //Стан заявки
              this.form.setControlValue('GorodokClaim_Prew_Type', data.rows[0].values[3]); //Тип заявки
              this.form.setControlValue('GorodokClaim_Prew_Content', data.rows[0].values[4]); //Зміст
              this.form.setControlValue('GorodokClaim_Prew_Executor', data.rows[0].values[6]); //Виконавець
              this.form.setControlValue('GorodokClaim_Prew_MainObject', data.rows[0].values[5]); //Місце проблеми
              this.form.setControlValue('GorodokClaim_Prew_StartDate', new Date(data.rows[0].values[7])); //Дата та час створення заявки
              this.form.setControlValue('GorodokClaim_Prew_PlanEndDate', new Date(data.rows[0].values[8])); //Plan Дата та час виконання
              this.form.setControlValue('GorodokClaim_Prew_CommentExecutor', data.rows[0].values[10]); //Коментар виконавця
  
          });
          this.scrollTopMainForm();   
      },
      onCellClick_Detail_Event: function(column, row, value, event, indexOfColumnId) {
          this.form.setGroupVisibility('Group_Events', true);
          this.form.setControlValue('Event_Prew_Id', row.values[0]); 
          this.form.setControlValue('Event_Prew_Type', { key: row.values[7], value: row.values[2] });
          this.form.setControlValue('Event_Prew_Name', row.values[0]);
          this.form.setControlValue('Event_Prew_EventOrganizers', row.values[3]); 
          this.form.setControlValue('Event_Prew_Comment', row.values[4]); 
          this.form.setControlValue('Event_Prew_StartDate', new Date(row.values[5])); 
          this.form.setControlValue('Event_Prew_PlanEndDate', new Date(row.values[6])); 
          this.scrollTopMainForm();
      },
      onChangedApplicant_Id: function(value) {
          
          if (!value || value  == "") {
              this.form.disableControl('CardPhone');
              this.form.setControlValue('CardPhone', this.form.getControlValue('Phone')); 
          } else {
             this.form.enableControl('CardPhone'); 
          //   this.form.setControlValue('CardPhone', this.form.getControlValue('Phone')); 
          };
      },
      
      onChangedQuestion_AnswerType: function(value) {
          this.form.setControlValue('Question_AnswerPhoneOrPost', null);
          if(value == 2) {
              this.form.setControlValue('Question_AnswerPhoneOrPost', this.form.getControlValue('Applicant_Phone_Hide'));
          };
          
          if(value == 4 || value == 5) {
              //   this.form.setControlValue('Question_AnswerPhoneOrPost', this.form.getControlValue('Adress'));
              this.form.setControlValue('Question_AnswerPhoneOrPost', this.form.getControlValue('Adress_for_answer'));
          };
          
          if(value == 3) {
              this.form.setControlValue('Question_AnswerPhoneOrPost', this.form.getControlValue('Applicant_Email'));
          };
      },
      
      onChanged_Search_Appeals_Input: function(value) {
          if(value == "") {
              //   this.form.disableControl('Search_Appeals_Search');
              document.getElementById('Search_Appeals_Search').disabled = true;
          } else { 
              //   this.form.enableControl('Search_Appeals_Search');
              document.getElementById('Search_Appeals_Search').disabled = false;
          };
      },
      Question_Building_Input: undefined,
      Question_Organization_Input: undefined,
      Question_TypeId: undefined,
      Question_Content_Input: "",
      Question_AnswerType_Input: undefined,
      getOrgExecut: function() {
          if (this.StateServerId == 1) {
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
                  this.form.setControlValue('Question_OrganizationId', { key: data.rows[0].values[0], value: data.rows[0].values[1] });
              });
          };
      },
      Question_Organization_IsVisible: 0,
      Question_Building_IsVisible: 0,
      Question_Organization_ResultState: 'Error',
      Question_Building_ResultState: 'Error',
      
      onChanged_Question_TypeId_Input: function(value) {
          this.Question_TypeId_Input = value;
          this.onChanged_Question_Btn_Add_Input();
          this.getOrgExecut(); 
      },
      onChanged_VisibleOrgAndBuild: function() {
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
                      this.Question_Organization_IsVisible = 1;
                  } else {
                      this.form.setControlVisibility('Question_Organization', false);
                      this.Question_Organization_IsVisible = 0;
                  };
                  
                      //"Object_is"
                  if (data.rows[0].values[1]) {
                      this.Question_Building_IsVisible = 1;
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
                      this.Question_Building_IsVisible = 0;
                      this.form.setControlVisibility('Question_Building', false);
                      this.form.setControlVisibility('entrance', false);
                      this.form.setControlVisibility('flat', false);
                  };
              } else {
                  this.Question_Building_IsVisible = 0;
                  this.Question_Organization_IsVisible = 0;
                  this.form.setControlVisibility('Question_Building', false);
                  this.form.setControlVisibility('Question_Organization', false);
                  this.form.setControlVisibility('entrance', false);
                  this.form.setControlVisibility('flat', false);
                  
              };
  
              if (this.Question_Building_IsVisible == 1) {
                  if (this.Question_Building_Input == undefined || this.Question_Building_Input == null) {
                      this.Question_Building_ResultState = 'Error';
                  } else { 
                      this.Question_Building_ResultState = 'OK';
                  };
              } else {
                  this.Question_Building_ResultState = 'OK';
              };
  
              if (this.Question_Organization_IsVisible == 1) {
                  if (this.Question_Organization_Input == undefined || this.Question_Organization_Input == null) {
                      this.Question_Organization_ResultState = 'Error';
                  } else { 
                      this.Question_Organization_ResultState = 'OK';
                  };
              } else {
                  this.Question_Organization_ResultState = 'OK';
              };
  
  
  
              if( this.form.getControlValue('Applicant_Id') == "" || this.form.getControlValue('Applicant_Id') == null  || this.Question_Content_Input == "" || this.Question_AnswerType_Input == null  || this.Question_AnswerType_Input == undefined || this.Question_TypeId_Input == null || this.Question_TypeId_Input == undefined
                  || ((this.Question_Building_ResultState == 'OK') && (this.Question_Organization_ResultState == 'OK')) != true 
              ) {
                  document.getElementById('Question_Btn_Add').disabled = true;
              } else { 
                  document.getElementById('Question_Btn_Add').disabled = false;
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
          this.Question_Building_Input = null;
          this.onChanged_Question_Btn_Add_Input();  
        };
             
      },
      onChanged_Question_Organization_Input: function(value) {
          this.Question_Organization_Input = value;
          this.onChanged_Question_Btn_Add_Input();
          this.getOrgExecut();
      },
      
      
      onChanged_Question_Content_Input: function(value) {
          this.Question_Content_Input = value;
          this.onChanged_Question_Btn_Add_Input();
      },
      onChanged_Question_AnswerType_Input: function(value) {
          this.Question_AnswerType_Input = value;
          this.onChanged_Question_Btn_Add_Input();
      },
      
       onChanged_Question_Btn_Add_Input: function() {
          this.onChanged_VisibleOrgAndBuild();
      },
      
      onChanged_Work_with_a_question_notes: function(value) {
          this.Work_with_a_question_notes = value;
          this.onChanged_Work_with_a_question_Btn_save_Input();
      },
      
      onChanged_Work_with_a_question_Btn_save_Input: function() {
          if( this.Work_with_a_question_notes == "" ||  this.Work_with_a_question_notes == undefined) {
              document.getElementById('Work_with_a_question_Btn_save').disabled = true;
          } else { 
              document.getElementById('Work_with_a_question_Btn_save').disabled = false;
          };
         
      },
      Applicant_PIB_Input: "",
      Applicant_Phone_Input: "",
      Applicant_Building_Input: undefined,
      Applicant_Entrance_Input: "",
      
      onChanged_Applicant_CategoryType_Input: function(value) {
           if(this.InitialState_Applicant_CategoryType == this.onChanged_Input(this.form.getControlValue('Applicant_CategoryType'))) {this.CheckParamForApplicant_CategoryType = 0} else {this.CheckParamForApplicant_CategoryType = 1};
            this.onChanged_Question_Aplicant_Btn_Add_Input();
      },
      onChanged_Applicant_PIB_Input: function(value) {
          this.Applicant_PIB_Input = value;
          if(this.InitialState_Applicant_PIB == this.onChanged_Input(this.form.getControlValue('Applicant_PIB'))) {
              this.CheckParamForApplicant_PIB = 0
          } else {
              this.CheckParamForApplicant_PIB = 1
          };
          this.onChanged_Question_Aplicant_Btn_Add_Input();
      },
      onChanged_Applicant_Phone_Input: function(value) {
       
          
          this.Applicant_Phone_Input = value;
          if(this.InitialState_Applicant_Phone == this.onChanged_Input(this.form.getControlValue('CardPhone'))) {
              this.CheckParamForApplicant_Phone = 0
          } else {
              this.CheckParamForApplicant_Phone = 1
          };
          this.onChanged_Question_Aplicant_Btn_Add_Input();
          
          //ReLoadDetail Detail_Consultation
          const parameters1 = [
              { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
              { key: '@appeal_id',  value: this.form.getControlValue('AppealId')},
              { key: '@phone_number', value: this.form.getControlValue('Applicant_Phone_Hide')}
          ];
          this.details.loadData('Detail_Consultation', parameters1/*, filters, sorting*/);
          
          this.details.setVisibility('Detail_ConsultationAplicant', false);
          this.details.setVisibility('Detail_QuestionApplicant', false);
          this.details.setVisibility('Detail_QuestionObjectAplicant', false);
          this.details.setVisibility('Detail_QuestionPhone', false);
          this.details.setVisibility('Detail_QuestionBuildingAplicant', false);
          this.details.setVisibility('Detail_GorodokClaim', false);
          
          
          if (value) {
              if (value.length >= 3) {
  
              }
          };
            
      },
  
      onChanged_Applicant_Entrance_Input: function(value) {
           this.Applicant_Entrance_Input = value;
           if(this.InitialState_Applicant_Entrance == this.onChanged_Input(this.form.getControlValue('Applicant_Entrance'))) {
              this.CheckParamForApplicant_Entrance = 0
          } else {
              this.CheckParamForApplicant_Entrance = 1
          }; 
          this.onChanged_Question_Aplicant_Btn_Add_Input();
      },
      
  
      onChanged_Applicant_SocialStates_Input: function(value) {
          if (value == null || value == undefined) {
              const objNameSocialState_Select = {
                  queryCode: 'dir_SocialState_SelectRow',
                  parameterValues: [
                      {
                          key: '@Id',
                          value: 2 /*Робітник*/
                      }
                  ]
              };
              this.queryExecutor.getValues(objNameSocialState_Select).subscribe(data => {
                  this.form.setControlValue('Applicant_SocialStates',  { key: data.rows[0].values[0], value: data.rows[0].values[1]} ); 
              });
          };
          
          
           if(this.InitialState_Applicant_SocialStates == this.onChanged_Input(this.form.getControlValue('Applicant_SocialStates'))) {
              this.CheckParamForApplicant_SocialStates = 0
          } else {
              this.CheckParamForApplicant_SocialStates = 1
          }; 
          this.onChanged_Question_Aplicant_Btn_Add_Input();
      },
      onChanged_Applicant_Privilege_Input: function(value) {
          if (value == null || value == undefined) {
              const objNameApplicantPrivilegeRow = {
                  queryCode: 'ak_SelectApplicantPrivilegeRow',
                  parameterValues: [
                      {
                          key: '@Id',
                          value: 60 /*Пільги відсутні*/
                      }
                  ]
              };
              this.queryExecutor.getValues(objNameApplicantPrivilegeRow).subscribe(data => {
                  this.form.setControlValue('Applicant_Privilege',  { key: data.rows[0].values[0], value: data.rows[0].values[1]} ); 
              });
          };
          if(this.InitialState_Applicant_Privilege == this.onChanged_Input(this.form.getControlValue('Applicant_Privilege'))) {
              this.CheckParamForApplicant_Privilege = 0
          } else {
              this.CheckParamForApplicant_Privilege = 1
          }; 
          this.onChanged_Question_Aplicant_Btn_Add_Input();
      },
      
      onChanged_Applicant_Building_Input: function(value) {
          if (value) {   
              if (typeof value === "string") {
                  return
              } else {
                  if (value) {
                      const objName = {
                          queryCode: 'list_filter_fullName_Object',
                          parameterValues: [
                              {
                                  key: '@buil_id',
                                  value: value
                              }
                          ]
                      };
                  
                      
                      this.queryExecutor.getValues(objName).subscribe(data => {
                          this.form.setControlValue('Question_Building',  { key: data.rows[0].values[0], value: data.rows[0].values[1]} ); 
                          this.form.setControlValue('entrance',this.form.getControlValue('Applicant_Entrance') ); 
                          this.form.setControlValue('flat',  this.form.getControlValue('Applicant_Flat') ); 
                      });
                  
                      const executName = {
                          queryCode: 'GetExecutorInRoleForObject_SelectRow',
                          parameterValues: [
                          {
                              key: '@building_id',
                              value: value
                          }
                      ]
                      };
                      this.queryExecutor.getValues(executName).subscribe(data => {
                          if (data.rows.length > 0) {
                              this.form.setControlValue('ExecutorInRoleForObject', data.rows[0].values[0]);
                          } else {
                              this.form.setControlValue('ExecutorInRoleForObject',  ''); 
                          };
                      }); 
               
               
                      const DistrName = {
                          queryCode: 'GetDistrictForBuilding',
                          parameterValues: [
                          {
                              key: '@building_id',
                              value: value
                          }
                      ]
                      };
                      this.queryExecutor.getValues(DistrName).subscribe(data => {
                          if (data.rows.length > 0) {
                              this.form.setControlValue('Applicant_District', data.rows[0].values[0]);
                          } else {
                              this.form.setControlValue('Applicant_District',  ''); 
                          };
                      });  
  
                  } else {
                      this.form.setControlValue('ExecutorInRoleForObject',  ''); 
                      this.form.setControlValue('Applicant_District',  ''); 
                  };
          
              // this.form.setControlValue('Question_Building', { key: this.form.getControlValue('Applicant_Building'), value: this.form.getControlDisplayValue('Applicant_Building') });
         
  
              this.form.setControlValue('Adress', this.form.getControlDisplayValue('Applicant_Building'));
          
              this.Applicant_Building_Input = value;
              if(this.InitialState_Applicant_Building == this.onChanged_Input(this.form.getControlValue('Applicant_Building'))) {this.CheckParamForApplicant_Building = 0} else {this.CheckParamForApplicant_Building = 1}; 
              this.onChanged_Question_Aplicant_Btn_Add_Input();
            
              if (value == null || value == undefined) {
                  this.details.setVisibility('Detail_Event', false);
              } else {
                  const parameters1 = [
                      { key: '@object_id', value: value}
                  ];
                  this.details.loadData('Detail_Event', parameters1/*, filters, sorting*/);
                  if (this.StateServerId == 1 || this.StateServerId == 2) {
                      this.details.setVisibility('Detail_Event', true);
                  };
              };
          };
          
          } else {
              this.form.setControlValue('ExecutorInRoleForObject',  ''); 
              this.form.setControlValue('Applicant_District',  ''); 
          };
          
      },
      
      onChanged_Question_Aplicant_Btn_Add_Input: function() {
          if(this.Applicant_Entrance_Input == "" || this.Applicant_PIB_Input == "" || this.Applicant_Phone_Input  == "" ||   this.Applicant_Building_Input == null ||  this.Applicant_Building_Input == undefined ) {
              if (this.form.getControlValue('Applicant_Id') != null || this.form.getControlValue('Applicant_Id') != '') {
                  document.getElementById('Question_Aplicant_Btn_Add').disabled = true;
              };
          } else { 
              //   document.getElementById('Question_Aplicant_Btn_Add').disabled = false;
              if (this.form.getControlValue('Applicant_Id') == null || this.form.getControlValue('Applicant_Id') == '') {
                  document.getElementById('Question_Aplicant_Btn_Add').disabled = true;
              } else {
                  document.getElementById('Question_Aplicant_Btn_Add').disabled = false;
              }
          };
          
          
          if(this.Applicant_PIB_Input == "") {
                  document.getElementById('Applicant_Btn_Add').disabled = true;
          } else { 
              if( this.CheckParamForApplicant_PIB == 0 && 
                  this.CheckParamForApplicant_Phone == 0 && 
                  this.CheckParamForApplicant_Building == 0 &&
                  this.CheckParamForApplicant_HouseBlock == 0 && 
                  this.CheckParamForApplicant_Entrance == 0 && 
                  this.CheckParamForApplicant_Flat == 0 &&
                  this.CheckParamForApplicant_Privilege == 0 && 
                  this.CheckParamForApplicant_SocialStates == 0 && 
                  this.CheckParamForApplicant_CategoryType == 0 &&
                  this.CheckParamForApplicant_Type == 0 && 
                  this.CheckParamForApplicant_Sex == 0 && 
                  this.CheckParamForApplication_BirthDate == 0 &&
                  this.CheckParamForApplicant_Email == 0 &&
                  this.CheckParamForApplicant_Comment == 0
              ) {
                  document.getElementById('Applicant_Btn_Add').disabled = true;
              } else {
                  document.getElementById('Applicant_Btn_Add').disabled = false;
              };
                  
          };
      },
      
  
      TargetElement_Detail_Consultation_Prev: "",
      OnCellClikc_Detail_Consultation: function(column, row, value, event, indexOfColumnId) {
          if (this.StateServerId == 1 || this.StateServerId == 2) {
          
              if (this.TargetElement_Detail_Consultation_Prev != "") {
                  this.TargetElement_Detail_Consultation_Prev.style.removeProperty('color');
                  this.TargetElement_Detail_Consultation_Prev.style.removeProperty('background');
              }; 
              event.target.style.background = '#627ca0';
              event.target.style.color = 'white';
              this.TargetElement_Detail_Consultation_Prev = event.target;
              
              this.details.setVisibility('Detail_ConsultationAplicant', false);
              this.details.setVisibility('Detail_QuestionApplicant', false);
              this.details.setVisibility('Detail_QuestionObjectAplicant', false);
              this.details.setVisibility('Detail_QuestionPhone', false);
              this.details.setVisibility('Detail_QuestionBuildingAplicant', false);
              this.details.setVisibility('Detail_GorodokClaim', false);
              this.details.setVisibility('Detail_QuestionNumberAppeal', false);
              
              this.form.setGroupVisibility('Group_Preview_Question', false);
          
              //"питання заявника"
              if (value == "питання заявника") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Усі"}
                  ];
                  this.details.loadData('Detail_QuestionApplicant', parameters/*, filters, sorting*/);
                  this.details.setVisibility('Detail_QuestionApplicant', true);
              };
              if (row.values[1] == "питання заявника" && column.code == "Зареєстровано") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Зареєстровано"}
                  ];
                  this.details.loadData('Detail_QuestionApplicant', parameters/*, filters, sorting*/);
                  this.details.setVisibility('Detail_QuestionApplicant', true);
              };
              if (row.values[1] == "питання заявника" && column.code == "В роботі") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "В роботі"}
                  ];
                  this.details.loadData('Detail_QuestionApplicant', parameters/*, filters, sorting*/);  
                  this.details.setVisibility('Detail_QuestionApplicant', true);
              };
              if (row.values[1] == "питання заявника" && column.code == "Просрочено") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Просрочено"}
                  ];
                  this.details.loadData('Detail_QuestionApplicant', parameters/*, filters, sorting*/);  
                  this.details.setVisibility('Detail_QuestionApplicant', true);
              };
              if (row.values[1] == "питання заявника" && column.code == "Виконано") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Виконано"}
                  ];
                  this.details.loadData('Detail_QuestionApplicant', parameters/*, filters, sorting*/); 
                  this.details.setVisibility('Detail_QuestionApplicant', true);
              };
              if (row.values[1] == "питання заявника" && column.code == "Доопрацювання") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Доопрацювання"}
                  ];
                  this.details.loadData('Detail_QuestionApplicant', parameters/*, filters, sorting*/);
                  this.details.setVisibility('Detail_QuestionApplicant', true);
              };
              
              
              //"питання заявника (old)"
              if (value == "питання заявника (old)") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Усі (old)"}
                  ];
                  this.details.loadData('Detail_QuestionApplicant', parameters/*, filters, sorting*/);    
                  this.details.setVisibility('Detail_QuestionApplicant', true);
              };
              if (row.values[1] == "питання заявника (old)" && column.code == "Зареєстровано") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Зареєстровано (old)"}
                  ];
                  this.details.loadData('Detail_QuestionApplicant', parameters/*, filters, sorting*/); 
                  this.details.setVisibility('Detail_QuestionApplicant', true);
              };
              if (row.values[1] == "питання заявника (old)" && column.code == "В роботі") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "В роботі (old)"}
                  ];
                  this.details.loadData('Detail_QuestionApplicant', parameters/*, filters, sorting*/);
                  this.details.setVisibility('Detail_QuestionApplicant', true);
              };
              if (row.values[1] == "питання заявника (old)" && column.code == "Просрочено") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Просрочено (old)"}
                  ];
                  this.details.loadData('Detail_QuestionApplicant', parameters/*, filters, sorting*/);
                  this.details.setVisibility('Detail_QuestionApplicant', true);
              };
              if (row.values[1] == "питання заявника (old)" && column.code == "Виконано") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Виконано (old)"}
                  ];
                  this.details.loadData('Detail_QuestionApplicant', parameters/*, filters, sorting*/);    
                  this.details.setVisibility('Detail_QuestionApplicant', true);
              };
              if (row.values[1] == "питання заявника (old)" && column.code == "Доопрацювання") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Доопрацювання (old)"}
                  ];
                  this.details.loadData('Detail_QuestionApplicant', parameters/*, filters, sorting*/);
                          
                  this.details.setVisibility('Detail_QuestionApplicant', true);
              };
              
              
              //"Консультації заявника"
              if (value == "консультації заявника") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Усі"},
                      { key: '@appeal_id', value: this.form.getControlValue('AppealId')},
                      { key: '@phone_number', value: this.form.getControlValue('Applicant_Phone_Hide')}
                  ];
                  this.details.loadData('Detail_ConsultationAplicant', parameters/*, filters, sorting*/);
                          
                  this.details.setVisibility('Detail_ConsultationAplicant', true);
              };
              if (row.values[1] == "консультації заявника" && column.code == "Зареєстровано") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Зареєстровано"},
                      { key: '@appeal_id', value: this.form.getControlValue('AppealId')},
                      { key: '@phone_number', value: this.form.getControlValue('Applicant_Phone_Hide')}
                  ];
                  this.details.loadData('Detail_ConsultationAplicant', parameters/*, filters, sorting*/);
                  this.details.setVisibility('Detail_ConsultationAplicant', true);
              };
              if (row.values[1] == "консультації заявника" && column.code == "В роботі") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "В роботі"},
                      { key: '@appeal_id', value: this.form.getControlValue('AppealId')},
                      { key: '@phone_number', value: this.form.getControlValue('Applicant_Phone_Hide')}
                  ];
                  this.details.loadData('Detail_ConsultationAplicant', parameters/*, filters, sorting*/);
                          
                  this.details.setVisibility('Detail_ConsultationAplicant', true);
              };
              if (row.values[1] == "консультації заявника" && column.code == "Просрочено") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Просрочено"},
                      { key: '@appeal_id', value: this.form.getControlValue('AppealId')},
                      { key: '@phone_number', value: this.form.getControlValue('Applicant_Phone_Hide')}
                  ];
                  this.details.loadData('Detail_ConsultationAplicant', parameters/*, filters, sorting*/);
                  this.details.setVisibility('Detail_ConsultationAplicant', true);
              };
              if (row.values[1] == "консультації заявника" && column.code == "Виконано") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Виконано"},
                      { key: '@appeal_id', value: this.form.getControlValue('AppealId')},
                      { key: '@phone_number', value: this.form.getControlValue('Applicant_Phone_Hide')}
                  ];
                  this.details.loadData('Detail_ConsultationAplicant', parameters/*, filters, sorting*/);
                  this.details.setVisibility('Detail_ConsultationAplicant', true);
              };
              if (row.values[1] == "консультації заявника" && column.code == "Доопрацювання") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Доопрацювання"},
                      { key: '@appeal_id', value: this.form.getControlValue('AppealId')},
                      { key: '@phone_number', value: this.form.getControlValue('Applicant_Phone_Hide')}
                  ];
                  this.details.loadData('Detail_ConsultationAplicant', parameters/*, filters, sorting*/);
                  this.details.setVisibility('Detail_ConsultationAplicant', true);
              };
              
              
              //"питання за помешканням заявника"
              if (value == "питання за помешканням заявника") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Усі"}
                  ];
                  this.details.loadData('Detail_QuestionObjectAplicant', parameters/*, filters, sorting*/);
                          
                  this.details.setVisibility('Detail_QuestionObjectAplicant', true);
              };
              if (row.values[1] == "питання за помешканням заявника" && column.code == "Зареєстровано") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Зареєстровано"}
                  ];
                  this.details.loadData('Detail_QuestionObjectAplicant', parameters/*, filters, sorting*/);
                          
                  this.details.setVisibility('Detail_QuestionObjectAplicant', true);
              };
              if (row.values[1] == "питання за помешканням заявника" && column.code == "В роботі") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "В роботі"}
                  ];
                  this.details.loadData('Detail_QuestionObjectAplicant', parameters/*, filters, sorting*/);
                          
                  this.details.setVisibility('Detail_QuestionObjectAplicant', true);
              };
              if (row.values[1] == "питання за помешканням заявника" && column.code == "Просрочено") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Просрочено"}
                  ];
                  this.details.loadData('Detail_QuestionObjectAplicant', parameters/*, filters, sorting*/);
                          
                  this.details.setVisibility('Detail_QuestionObjectAplicant', true);
              };
              if (row.values[1] == "питання за помешканням заявника" && column.code == "Виконано") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Виконано"}
                  ];
                  this.details.loadData('Detail_QuestionObjectAplicant', parameters/*, filters, sorting*/);
                          
                  this.details.setVisibility('Detail_QuestionObjectAplicant', true);
              };
              if (row.values[1] == "питання за помешканням заявника" && column.code == "Доопрацювання") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Доопрацювання"}
                  ];
                  this.details.loadData('Detail_QuestionObjectAplicant', parameters/*, filters, sorting*/); 
                  this.details.setVisibility('Detail_QuestionObjectAplicant', true);
              };
              
              //"питання з номеру телефону заявника"
              if (value == "питання з номеру телефону заявника") {
                  const parameters = [
                      { key: '@phone_number', value: this.form.getControlValue('Applicant_Phone_Hide')},
                      { key: '@type', value: "Усі"}
                  ];
                  this.details.loadData('Detail_QuestionPhone', parameters/*, filters, sorting*/);
                  this.details.setVisibility('Detail_QuestionPhone', true);
              };
              if (row.values[1] == "питання з номеру телефону заявника" && column.code == "Зареєстровано") {
                  const parameters = [
                      { key: '@phone_number', value: this.form.getControlValue('Applicant_Phone_Hide')},
                      { key: '@type', value: "Зареєстровано"}
                  ];
                  this.details.loadData('Detail_QuestionPhone', parameters/*, filters, sorting*/);
                  this.details.setVisibility('Detail_QuestionPhone', true);
              };
              if (row.values[1] == "питання з номеру телефону заявника" && column.code == "В роботі") {
                  const parameters = [
                      { key: '@phone_number', value: this.form.getControlValue('Applicant_Phone_Hide')},
                      { key: '@type', value: "В роботі"}
                  ];
                  this.details.loadData('Detail_QuestionPhone', parameters/*, filters, sorting*/);
                  this.details.setVisibility('Detail_QuestionPhone', true);
              };
              if (row.values[1] == "питання з номеру телефону заявника" && column.code == "Просрочено") {
                  const parameters = [
                      { key: '@phone_number', value: this.form.getControlValue('Applicant_Phone_Hide')},
                      { key: '@type', value: "Просрочено"}
                  ];
                  this.details.loadData('Detail_QuestionPhone', parameters/*, filters, sorting*/);   
                  this.details.setVisibility('Detail_QuestionPhone', true);
              };
              if (row.values[1] == "питання з номеру телефону заявника" && column.code == "Виконано") {
                  const parameters = [
                      { key: '@phone_number', value: this.form.getControlValue('Applicant_Phone_Hide')},
                      { key: '@type', value: "Виконано"}
                  ];
                  this.details.loadData('Detail_QuestionPhone', parameters/*, filters, sorting*/);
                  this.details.setVisibility('Detail_QuestionPhone', true);
              };
              if (row.values[1] == "питання з номеру телефону заявника" && column.code == "Доопрацювання") {
                  const parameters = [
                      { key: '@phone_number', value: this.form.getControlValue('Applicant_Phone_Hide')},
                      { key: '@type', value: "Доопрацювання"}
                  ];
                  this.details.loadData('Detail_QuestionPhone', parameters/*, filters, sorting*/);
                  this.details.setVisibility('Detail_QuestionPhone', true);
              };
              
              
              
              //"питання по будинку"
              if (value == "питання по будинку") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Усі"}
                  ];
                  this.details.loadData('Detail_QuestionBuildingAplicant', parameters/*, filters, sorting*/);
                  this.details.setVisibility('Detail_QuestionBuildingAplicant', true);
              };
              if (row.values[1] == "питання по будинку" && column.code == "Зареєстровано") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Зареєстровано"}
                  ];
                  this.details.loadData('Detail_QuestionBuildingAplicant', parameters/*, filters, sorting*/);
                  this.details.setVisibility('Detail_QuestionBuildingAplicant', true);
              };
              if (row.values[1] == "питання по будинку" && column.code == "В роботі") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "В роботі"}
                  ];
                  this.details.loadData('Detail_QuestionBuildingAplicant', parameters/*, filters, sorting*/);     
                  this.details.setVisibility('Detail_QuestionBuildingAplicant', true);
              };
              if (row.values[1] == "питання по будинку" && column.code == "Просрочено") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Просрочено"}
                  ];
                  this.details.loadData('Detail_QuestionBuildingAplicant', parameters/*, filters, sorting*/);   
                  this.details.setVisibility('Detail_QuestionBuildingAplicant', true);
              };
              if (row.values[1] == "питання по будинку" && column.code == "Виконано") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Виконано"}
                  ];
                  this.details.loadData('Detail_QuestionBuildingAplicant', parameters/*, filters, sorting*/);   
                  this.details.setVisibility('Detail_QuestionBuildingAplicant', true);
              };
              if (row.values[1] == "питання по будинку" && column.code == "Доопрацювання") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Доопрацювання"}
                  ];
                  this.details.loadData('Detail_QuestionBuildingAplicant', parameters/*, filters, sorting*/);
                          
                  this.details.setVisibility('Detail_QuestionBuildingAplicant', true);
              };
              
              
              //"заявки за Городком"
              if (value == "заявки за Городком") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Усі"}
                  ];
                  this.details.loadData('Detail_GorodokClaim', parameters/*, filters, sorting*/);
                  this.details.setVisibility('Detail_GorodokClaim', true);
              };
              if (row.values[1] == "заявки за Городком" && column.code == "Зареєстровано") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Зареєстровано"}
                  ];
                  this.details.loadData('Detail_GorodokClaim', parameters/*, filters, sorting*/);         
                  this.details.setVisibility('Detail_GorodokClaim', true);
              };
              if (row.values[1] == "заявки за Городком" && column.code == "В роботі") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "В роботі"}
                  ];
                  this.details.loadData('Detail_GorodokClaim', parameters/*, filters, sorting*/);
                  this.details.setVisibility('Detail_GorodokClaim', true);
              };
              if (row.values[1] == "заявки за Городком" && column.code == "Просрочено") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Просрочено"}
                  ];
                  this.details.loadData('Detail_GorodokClaim', parameters/*, filters, sorting*/);
                  this.details.setVisibility('Detail_GorodokClaim', true);
              };
              if (row.values[1] == "заявки за Городком" && column.code == "Виконано") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Виконано"}
                  ];
                  this.details.loadData('Detail_GorodokClaim', parameters/*, filters, sorting*/);
                  this.details.setVisibility('Detail_GorodokClaim', true);
              };
              if (row.values[1] == "заявки за Городком" && column.code == "Доопрацювання") {
                  const parameters = [
                      { key: '@applicant_id', value: this.form.getControlValue('Applicant_Id')},
                      { key: '@type', value: "Доопрацювання"}
                  ];
                  this.details.loadData('Detail_GorodokClaim', parameters/*, filters, sorting*/);
                          
                  this.details.setVisibility('Detail_GorodokClaim', true);
              };
          };
          this.scrollTopMainForm();  
      },
      
      Detail_Aplicant: function(column, row, value, event, indexOfColumnId) {
          this.details.setExpanding('Detail_Aplicant',false);
      
          var sex = null;
          if(row.values[19] == null) {
              sex = null;
          } else {
              sex = (row.values[19]).toString();
          };
  
          var BirthDate = null;
          if(row.values[20] == null) {
              BirthDate = null;
          } else {
              BirthDate = new Date(row.values[20]);
          };
          
  
          this.form.setControlValue('Applicant_Id', row.values[0]);
          this.form.setControlValue('Applicant_PIB', row.values[1]);
          
          this.form.setControlValue('Applicant_District', { key: row.values[10], value: row.values[11] });
          
          this.form.setControlValue('Applicant_Building', { key: row.values[2], value: row.values[13]+' '+row.values[3] });
          this.form.setControlValue('Applicant_HouseBlock', row.values[16]);
          this.form.setControlValue('Applicant_Entrance', row.values[17]);
          this.form.setControlValue('Applicant_Flat', row.values[18]);
          this.form.setControlValue('Applicant_Privilege', { key: row.values[7], value: row.values[8] });
          this.form.setControlValue('Applicant_SocialStates', { key: row.values[5], value: row.values[6] });
          this.form.setControlValue('Applicant_CategoryType', { key: row.values[14], value: row.values[15] });
           this.form.setControlValue('Applicant_Type', { key: row.values[24], value: row.values[25] });
          this.form.setControlValue('Applicant_Sex',  sex);
          this.form.setControlValue('Application_BirthDate', BirthDate);
          this.form.setControlValue('Applicant_Age', row.values[21]);
          this.form.setControlValue('Applicant_Email', row.values[22]);
          this.form.setControlValue('Applicant_Comment', row.values[23]);
          
          this.form.setControlValue('CardPhone', row.values[31]);
          this.form.setControlValue('Applicant_Phone_Hide', row.values[32]);
           
          //Adress
          this.form.setControlValue('Adress', row.values[4]);
          this.form.setControlValue('Adress_for_answer', row.values[4]);
   
  
  
          
           //LoadDetail Detail_Consultation
          if (this.StateServerId == 1 || this.StateServerId == 2) {
  
              const parameters1 = [
                  { key: '@applicant_id', value: row.values[0]},
                  { key: '@appeal_id', value: this.form.getControlValue('AppealId')},
                  { key: '@phone_number', value: this.form.getControlValue('Applicant_Phone_Hide')}
              ];
              this.details.loadData('Detail_Consultation', parameters1/*, filters, sorting*/);
                  
          this.details.setVisibility('Detail_Consultation', true);
          };
          
          this.details.setVisibility('Detail_ConsultationAplicant', false);
          this.details.setVisibility('Detail_QuestionApplicant', false);
          this.details.setVisibility('Detail_QuestionObjectAplicant', false);
          this.details.setVisibility('Detail_QuestionPhone', false);
          this.details.setVisibility('Detail_QuestionBuildingAplicant', false);
          this.details.setVisibility('Detail_GorodokClaim', false);    
          
          document.getElementById('Applicant_Btn_Add').disabled = true;
          
          this.CheckParamForApplicant_PIB = 0;
          this.CheckParamForApplicant_Phone = 0;
          this.CheckParamForApplicant_Building = 0;
          this.CheckParamForApplicant_HouseBlock = 0;
          this.CheckParamForApplicant_Entrance = 0;
          this.CheckParamForApplicant_Flat = 0;
          this.CheckParamForApplicant_Privilege = 0;
          this.CheckParamForApplicant_SocialStates = 0;
          this.CheckParamForApplicant_CategoryType = 0;
          this.CheckParamForApplicant_Type = 0;
          this.CheckParamForApplicant_Sex = 0;
          this.CheckParamForApplication_BirthDate = 0;
          this.CheckParamForApplicant_Email = 0;
          this.CheckParamForApplicant_Comment = 0;
          
          
          this.InitialState_Applicant_PIB = null;
          this.InitialState_Applicant_Phone = null;
          this.InitialState_Applicant_Building = null;
          this.InitialState_Applicant_HouseBlock = null;
          this.InitialState_Applicant_Entrance = null;
          this.InitialState_Applicant_Flat = null;
          this.InitialState_Applicant_Privilege = null;
          this.InitialState_Applicant_SocialStates = null;
          this.InitialState_Applicant_CategoryType = null;
          this.InitialState_Applicant_Type = null;
          this.InitialState_Applicant_Sex = null;
          this.InitialState_Application_BirthDate = null;
          this.InitialState_Applicant_Email = null;
          this.InitialState_Applicant_Comment = null;
  
          this.InitialState_Applicant_PIB = this.form.getControlValue('Applicant_PIB');
          this.InitialState_Applicant_Phone = this.form.getControlValue('CardPhone');  
          this.InitialState_Applicant_Building = this.form.getControlValue('Applicant_Building');
          this.InitialState_Applicant_HouseBlock = this.form.getControlValue('Applicant_HouseBlock');
          this.InitialState_Applicant_Entrance = this.form.getControlValue('Applicant_Entrance');
          this.InitialState_Applicant_Flat = this.form.getControlValue('Applicant_Flat');
          this.InitialState_Applicant_Privilege = this.form.getControlValue('Applicant_Privilege');
          this.InitialState_Applicant_SocialStates = this.form.getControlValue('Applicant_SocialStates');
          this.InitialState_Applicant_CategoryType = this.form.getControlValue('Applicant_CategoryType');
          this.InitialState_Applicant_Type = this.form.getControlValue('Applicant_Type');
          this.InitialState_Applicant_Sex = this.form.getControlValue('Applicant_Sex');
          this.InitialState_Application_BirthDate = this.form.getControlValue('Application_BirthDate');
          this.InitialState_Applicant_Email = this.form.getControlValue('Applicant_Email');
          this.InitialState_Applicant_Comment = this.form.getControlValue('Applicant_Comment');
      },
      
      InitialState_Applicant_PIB: null,
      InitialState_Applicant_Phone: null,
      InitialState_Applicant_Building: null,
      InitialState_Applicant_HouseBlock: null,
      InitialState_Applicant_Entrance: null,
      InitialState_Applicant_Flat: null,
      InitialState_Applicant_Privilege: null,
      InitialState_Applicant_SocialStates: null,
      InitialState_Applicant_CategoryType: null,
      InitialState_Applicant_Type: null,
      InitialState_Applicant_Sex: null,
      InitialState_Application_BirthDate: null,
      InitialState_Applicant_Email: null,
      InitialState_Applicant_Comment: null,
      
      onChanged_Input: function(value) {
          if(value == '') {return null} else {return value};
      },
      onChanged_Applicant_Id: function(value) {
          this.onChanged_Question_Btn_Add_Input();
      },
      onChanged_Applicant_HouseBlock_Input: function(value) {
          if(this.InitialState_Applicant_HouseBlock == this.onChanged_Input(this.form.getControlValue('Applicant_HouseBlock'))) {this.CheckParamForApplicant_HouseBlock = 0} else {this.CheckParamForApplicant_HouseBlock = 1};
          this.onChanged_Question_Aplicant_Btn_Add_Input();
      },
      onChanged_Applicant_Flat_Input: function(value) {
          if(this.InitialState_Applicant_Flat == this.onChanged_Input(this.form.getControlValue('Applicant_Flat'))) {this.CheckParamForApplicant_Flat = 0} else {this.CheckParamForApplicant_Flat = 1};
          this.onChanged_Question_Aplicant_Btn_Add_Input();
      },
      onChanged_Applicant_Type_Input: function(value) {
          if (value == null || value == undefined) {
              const objNameApplicantGetApplicantTypes = {
                  queryCode: 'GetApplicantTypes',
                  parameterValues: [
                      {
                          key: '@Id',
                          value: 1 /*Звичайний*/
                      }
                  ]
              };
              this.queryExecutor.getValues(objNameApplicantGetApplicantTypes).subscribe(data => {
                  this.form.setControlValue('Applicant_Type',  { key: data.rows[0].values[0], value: data.rows[0].values[1]} ); 
              });
          };
          
          if(this.InitialState_Applicant_Type == this.onChanged_Input(this.form.getControlValue('Applicant_Type'))) {
              this.CheckParamForApplicant_Type = 0
          } else {
              this.CheckParamForApplicant_Type = 1
          };
          this.onChanged_Question_Aplicant_Btn_Add_Input();
      },
      onChanged_Applicant_Sex_Input: function(value) {
            if(this.InitialState_Applicant_Sex == this.onChanged_Input(this.form.getControlValue('Applicant_Sex'))) {this.CheckParamForApplicant_Sex = 0} else {this.CheckParamForApplicant_Sex = 1};
            this.onChanged_Question_Aplicant_Btn_Add_Input();
      },
      onChanged_Application_BirthDate_Input: function(value) {
            if(this.InitialState_Application_BirthDate == this.onChanged_Input(this.form.getControlValue('Application_BirthDate'))) {this.CheckParamForApplication_BirthDate = 0} else {this.CheckParamForApplication_BirthDate = 1};
            this.onChanged_Question_Aplicant_Btn_Add_Input();
      },
      onChanged_Applicant_Email_Input: function(value) {
            if(this.InitialState_Applicant_Email == this.onChanged_Input(this.form.getControlValue('Applicant_Email'))) {this.CheckParamForApplicant_Email = 0} else {this.CheckParamForApplicant_Email = 1};
            this.onChanged_Question_Aplicant_Btn_Add_Input();
      },
      onChanged_Applicant_Comment_Input: function(value) {
           if(this.InitialState_Applicant_Comment == this.onChanged_Input(this.form.getControlValue('Applicant_Comment'))) {this.CheckParamForApplicant_Comment = 0} else {this.CheckParamForApplicant_Comment = 1};
           this.onChanged_Question_Aplicant_Btn_Add_Input();
      },
      
      Group_Preview_Question_Close: function(event) {        
          if(this.Applicant_PIB_Input == "" || this.Applicant_Phone_Input  == "" ||  this.Applicant_Building_Input == null ||  this.Applicant_Building_Input == undefined) {
             this.form.setGroupVisibility('Group_CreateQuestion', false);
          } else { 
             this.form.setGroupVisibility('Group_CreateQuestion', false);
          };    
          
      },
      
      Detail_Question_Prev: function(column, row, value, event, indexOfColumnId) {
          
          this.form.setGroupVisibility('Group_CreateQuestion', false);
          this.form.setGroupVisibility('Group_Preview_Question', true)
          this.form.setGroupVisibility('Group_Events', false);
          this.form.setGroupVisibility('Group_GorodokClaims', false);
          this.form.setGroupVisibility('Group_Work_with_a_question', false);
          // this.form.setGroupVisibility('Group_WIKI', false);
          
          this.PrevQuestionForId_selectRow(row.values[0]);
          this.form.setGroupExpanding('Group_Aplicant', false);
          this.scrollTopMainForm();
          this.form.setControlValue('Work_with_a_question_ID', row.values[0]);
      },
      
      
      PrevQuestionForId_selectRow: function(questionId) {
          
          const queryForGetValues = {
              queryCode: 'PrevQuestionForId_selectRow',
              parameterValues: [{
                  key: '@QuestionId',
                  value: questionId
              }]
          };
          
          this.queryExecutor.getValues(queryForGetValues).subscribe(data => {
              this.form.setControlValue('Question_Prew_Building', { key: data.rows[0].values[7], value: data.rows[0].values[8] });
              this.form.setControlValue('Question_Prew_Organization', { key: data.rows[0].values[9], value: data.rows[0].values[10] });
              this.form.setControlValue('Question_Prew_OrganizationId', data.rows[0].values[4]);
              this.form.setControlValue('Question_Prew_Content', data.rows[0].values[11]);
              this.form.setControlValue('Question_Prew_TypeId', { key: data.rows[0].values[12], value: data.rows[0].values[3] });
              this.form.setControlValue('Question_Prew_ControlDate',  new Date(data.rows[0].values[5]));
              this.form.setControlValue('Question_Prew_States', { key: data.rows[0].values[15], value: data.rows[0].values[16] });
              this.form.setControlValue('Question_Prew_ResultText', data.rows[0].values[17]);
              this.form.setControlValue('Question_Prew_CommentExecutor', data.rows[0].values[18]);
              this.form.setControlValue('Question_Prew_Id', data.rows[0].values[0]);
              this.form.setControlValue('AssignmentId', data.rows[0].values[13]);
              this.form.setControlValue('Question_Prew_AssignmentResolution', data.rows[0].values[19]);
              this.form.setControlValue('Question_Prew_ApplicantPIB', data.rows[0].values[20]);
              this.form.setControlValue('Question_Prew_ApplicantAdress', data.rows[0].values[21]);
  
                  // если статус вопроса закрыто блокируем кнопку "Закрыть питання"
              // if(this.form.getControlValue == 5){
              if(data.rows[0].values[15] == 5){
                  document.getElementById('Question_Prew_Btn_Close').disabled = true;
              }else{
                  document.getElementById('Question_Prew_Btn_Close').disabled = false;
              }
          });
      },
    
      CheckParamForApplicant_Btn_Add: 0,
      CheckParamForApplicant_PIB: 0,
      CheckParamForApplicant_Building: 0,
      CheckParamForApplicant_HouseBlock: 0,
      CheckParamForApplicant_Entrance: 0,
      CheckParamForApplicant_Flat: 0,
      CheckParamForApplicant_Privilege: 0,
      CheckParamForApplicant_SocialStates: 0,
      CheckParamForApplicant_CategoryType: 0,
      CheckParamForApplicant_Type: 0,
      CheckParamForApplicant_Sex: 0,
      CheckParamForApplication_BirthDate: 0,
      CheckParamForApplicant_Email: 0,
      CheckParamForApplicant_Comment: 0,
      
      Detail_QuestionReestration: function(column, row, value, event, indexOfColumnId) {
  
         this.form.setControlValue('Question_Prew_Building', { key: row.values[7], value: row.values[8] });
         this.form.setControlValue('Question_Prew_Organization', { key: row.values[9], value: row.values[10] });
         this.form.setControlValue('Question_Prew_OrganizationId',  row.values[4]);
         this.form.setControlValue('Question_Prew_Content', row.values[11]);
         this.form.setControlValue('Question_Prew_TypeId', { key: row.values[12], value: row.values[3] });
      //   this.form.setControlValue('Question_Prew_OrganizationId',  { key: row.values[4], value: row.values[4] })); 
         this.form.setControlValue('Question_Prew_ControlDate',  new Date(row.values[5]));
         this.form.setControlValue('Question_Prew_States', { key: row.values[15], value: row.values[16] });
         this.form.setControlValue('Question_Prew_ResultText', row.values[17]);
         this.form.setControlValue('Question_Prew_CommentExecutor', row.values[18]);
         this.form.setControlValue('Question_Prew_Id', row.values[0]);
         this.form.setControlValue('Work_with_a_question_ID', row.values[0]);
         
          this.form.setControlValue('Question_Prew_AssignmentResolution', row.values[19]);
          this.form.setGroupVisibility('Group_CreateQuestion', false);
          this.form.setGroupVisibility('Group_Preview_Question', true);
          this.form.setGroupVisibility('Group_Work_with_a_question', false);
          this.form.setGroupVisibility('Group_Events', false);
          this.form.setGroupVisibility('Group_GorodokClaims', false);
          // this.form.setGroupVisibility('Group_WIKI', false);
          this.scrollTopMainForm(); 
      },
      scrollTopMainForm: function() {
          this.interval4 = setInterval(function() {
                  // console.log('START scrollTop: '+document.querySelector('#Appeals > section.groups.hasDetails').scrollTop+' '+'offsetWidth: '+document.querySelector('#Appeals > section.groups.hasDetails').offsetWidth);
                  // if (document.querySelector('#Appeals > section.groups.hasDetails').scrollTop != document.querySelector('#Appeals > section.groups.hasDetails').offsetWidth) {
              document.querySelector('#Appeals > section.groups.hasDetails').scrollTop = document.querySelector('#Appeals > section.groups.hasDetails').offsetWidth;
              document.querySelector('#Appeals > section.groups.hasDetails').scrollTop = 1000;
                          //  console.log('END scrollTop: '+document.querySelector('#Appeals > section.groups.hasDetails').scrollTop+' '+'offsetWidth: '+document.querySelector('#Appeals > section.groups.hasDetails').offsetWidth);
              clearInterval(this.interval4);
                  // };
          }.bind(this), 100);
      },
      destroy: function() {
          clearInterval(this.interval);
      }
  };
  }());
  