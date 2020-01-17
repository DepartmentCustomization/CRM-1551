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
                            justify-content: space-around;
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
                            
                        }
                        .group-btns .group .icon {
                            height: 75%;
                            text-align: center;
                        }
                        .group-btns .group .icon i {
                            font-size: 70px;
                            margin-top: 40px;
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
                    
                    </style>
                
                
                        <div ="" class="header-label"> Інтергація з систємою "ГородОк" </div>
                    <section ="" class="group-btns">
                      <!-- -->
                      
                      
                      <div ="" class="group" tabindex="0" onclick="javascript:window.location='`+location.origin + localStorage.getItem('VirtualPath')+ `/dashboard/page/int_streetsPageTable'">
                        <div ="" class="icon">
                          <i ="" class="material-icons" style="color:#ff7961;"> location_city </i>
                        </div>
                        <div ="" class="description"> Довідник Вулиці </div>
                        <div ="" class="border-bottom"></div>
                        <div ="" class="border-right"></div>
                      </div>
                      
                      <div ="" class="group" tabindex="0" onclick="javascript:window.location='`+location.origin + localStorage.getItem('VirtualPath')+ `/dashboard/page/int_housesPageTable'">
                        <div ="" class="icon">
                          <i ="" class="material-icons" style="color: #2196F3;"> home </i>
                        </div>
                        <div ="" class="description"> Довідник Будинки </div>
                        <div ="" class="border-bottom"></div>
                        <div ="" class="border-right"></div>
                      </div>
                      
                       <div ="" class="group" tabindex="0" onclick="javascript:window.location='`+location.origin + localStorage.getItem('VirtualPath')+ `/dashboard/page/int_organizationPageTable'">
                        <div ="" class="icon">
                          <i ="" class="material-icons" style="color: #2196F3;"> person_pin_circle </i>
                        </div>
                        <div ="" class="description"> Довідник організацій </div>
                        <div ="" class="border-bottom"></div>
                        <div ="" class="border-right"></div>
                      </div>
                      
                     <div ="" class="group" tabindex="0"  onclick="javascript:window.location='`+location.origin + localStorage.getItem('VirtualPath')+ `/dashboard/page/int_claimsTypePageTable'">
                        <div ="" class="icon">
                          <i ="" class="material-icons" style="color:#FBC02D;"> event_note </i>
                        </div>
                        <div ="" class="description"> Довідник типов заявок </div>
                        <div ="" class="border-bottom"></div>
                        <div ="" class="border-right"></div>
                      </div>
                      
                     <!--<div ="" class="group" tabindex="0" onclick="javascript:window.location='`+location.origin + localStorage.getItem('VirtualPath')+ `/dashboard/home/CityPublicTransport'">
                        <div ="" class="icon">
                          <i ="" class="material-icons" style="color: #FFB300;">directions_bus </i>
                        </div>
                        <div ="" class="description"> Київпастранс </div>
                        <div ="" class="border-bottom"></div>
                        <div ="" class="border-right"></div>
                      </div>-->
                    
                    </section>
                
                `
    ,
    init: function() {
        // let executeQuery = {
        //     queryCode: '<Название источника>',
        //     limit: -1,
        //     parameterValues: []
        // };
        // this.queryExecutor(executeQuery, this.load);
    },
    load: function(data) {
    }
};
}());
