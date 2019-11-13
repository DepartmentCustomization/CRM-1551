(function () {
  return {
    // title: '',
    // hint: '',
    // formatTitle: function() {},
    customConfig:
                `
                    <style>
                        .header-label {
                            text-align: center;
                            color: #131313;
                            margin: 32.5px;
                            font-size: 30px;
                            line-height: 18px;
                        }
                        .group-btns {
                            margin-top: 3em;
                            display: -webkit-box;
                            display: -ms-flexbox;
                            display: flex;
                            justify-content: space-around; /* просто не хватило этого */
                            -ms-flex-wrap: wrap;
                            flex-wrap: wrap;
                        }
                        
                        .group-btns .group {
                            width: 20.00%;
                            height: 200px;
                            cursor: pointer;
                            position: relative;
                            background-color: #F8F8F8;
                            border-radius: 15px;
                            display: flex;
                            flex-direction: column;
                            justify-content: space-around;
                            margin: 2% 5%;
                        }
                        .group-btns .group .icon {
                            text-align: center;
                        }
                        .group-btns .group .icon i {
                            font-size: 70px;
                        }
                        .group-btns .group .description {
                            text-align: center;
                            color: #131313;
                            font-size: 20px;
                            line-height: 18px;
                        }
                        .group-btns .group .border-bottom {
                            position: absolute;
                            width: calc(100% - 40px);
                            bottom: 0;
                            left: 20px;
                            box-shadow: 0 0 1px 1px rgba(0,0,0,.1);
                        }
                        .group-btns .group .border-right {
                            position: absolute;
                            height: calc(100% - 40px);
                            top: 20px;
                            right: 0;
                            box-shadow: 0 0 1px 1px rgba(0,0,0,.1);
                        }
                        .elementIcon{
                            padding-top: 25px;
                        }
                    
                    </style>
                

                    <section class="group-btns">
                      <!-- -->
                      
                      <div class="group" tabindex="0" onclick="javascript:window.location='`+location.origin + localStorage.getItem('VirtualPath')+ `/admin/users'">
                        <div class="icon">
                          <i class="material-icons elementIcon" style="color:#f44336;"> settings </i>
                        </div>
                        <div class="description">Налаштування</div>
                        <div class="border-bottom"></div>
                        <div class="border-right"></div>
                      </div>
                      
                      <div class="group" tabindex="0" onclick="javascript:window.location='`+location.origin + localStorage.getItem('VirtualPath')+ `/dashboard/page/admin__workCalendar'">
                        <div class="icon">
                          <i class="material-icons elementIcon" style="color:#f44336;"> view_module </i>
                        </div>
                        <div class="description">Календар</div>
                        <div class="border-bottom"></div>
                        <div class="border-right"></div>
                      </div>
                      
                      <div class="group" tabindex="0" onclick="javascript:window.location='`+location.origin + localStorage.getItem('VirtualPath')+ `/sections'">
                        <div class="icon">
                          <i class="material-icons elementIcon" style="color:#ff7961;"> view_list </i>
                        </div>
                        <div class="description">Секції</div>
                        <div class="border-bottom"></div>
                        <div class="border-right"></div>
                      </div>
                      
                       <div class="group" tabindex="0" onclick="javascript:window.location='`+location.origin + localStorage.getItem('VirtualPath')+ `/dashboard/page/reports_list'">
                        <div class="icon">
                          <i class="material-icons elementIcon" style="color:#ff7961;"> list </i>
                        </div>
                        <div class="description">Стандартні звіти</div>
                        <div class="border-bottom"></div>
                        <div class="border-right"></div>
                      </div>
                      
                      <div class="group" tabindex="0" onclick="javascript:window.location='`+location.origin + localStorage.getItem('VirtualPath')+ `/dashboard/page/constructor'">
                        <div class="icon">
                          <i class="material-icons elementIcon" style="color:#ff7961;"> build </i>
                        </div>
                        <div class="description">Конструктор звітів</div>
                        <div class="border-bottom"></div>
                        <div class="border-right"></div>
                      </div>                      
                      
                      <!--
                      <div class="group" tabindex="0" onclick="javascript:window.location='`+location.origin + localStorage.getItem('VirtualPath')+ `/sections/CreateAppeal/add?phone=0000000000&type=2'">
                        <div class="icon">
                          <i class="material-icons elementIcon" style="color: #2196F3;"> desktop_windows </i>
                        </div>
                        <div class="description"> Реєстрація Звернень з сайту </div>
                        <div class="border-bottom"></div>
                        <div class="border-right"></div>
                      </div>
                      
                      <div class="group" tabindex="0"  onclick="javascript:window.location='`+location.origin + localStorage.getItem('VirtualPath')+ `/sections/CreateAppeal/add?phone=0000000000&type=5'">
                        <div class="icon">
                          <i class="material-icons elementIcon" style="color: #6ec6ff;"> mail </i>
                        </div>
                        <div class="description"> Реєстрація Звернення згідно листа </div>
                        <div class="border-bottom"></div>
                        <div class="border-right"></div>
                      </div>
                      
                        <div class="group" tabindex="0"  onclick="javascript:window.location='`+location.origin + localStorage.getItem('VirtualPath')+ `/sections/Polls/add'">
                        <div class="icon">
                          <i class="material-icons elementIcon" style="color:#FBC02D;"> event_note </i>
                        </div>
                        <div class="description"> Проведення опитування </div>
                        <div class="border-bottom"></div>
                        <div class="border-right"></div>
                      </div>
                      
                  <div class="group" tabindex="0" onclick="javascript:window.location='`+location.origin + localStorage.getItem('VirtualPath')+ `/dashboard/home/CityPublicTransport'">
                        <div class="icon">
                          <i class="material-icons elementIcon" style="color: #FFB300;">directions_bus </i>
                        </div>
                        <div class="description"> Київпастранс </div>
                        <div class="border-bottom"></div>
                        <div class="border-right"></div>
                      </div>-->
                    
                    </section>
                
                `
    ,
    // onclick="javascript:window.location='`+location.origin + localStorage.getItem('VirtualPath')+ `/sections/CreateAppeal/add'"
    init: function() {
    },
    initValue: function(){
        
    },
    load: function(data) {
    },
    afterViewInit:function(){
      // let btn = document.getElementById('btn1');
      // let number = () => {
      //       // let r = [{ code: "Phone", value: document.getElementById('phone_value2').value}];
      //     let r = document.getElementById('phone_value2').value;
      //         let r1 = JSON.stringify(r);
      //         let r2 = encodeURI(r1);
      //         // console.log(r);
      //         // console.log(r1);
      //         // console.log(r2);
      //     // window.open(location.origin + localStorage.getItem('VirtualPath') + "/sections/CreateAppeal/add?phone="+r"+"&type=1");
      //     window.open(location.origin + localStorage.getItem('VirtualPath') + "/data/dataSource")
      // };
      // btn.addEventListener( "click", number )
    }
}

;
}());
