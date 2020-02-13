(function() {
    return {
        title: [],
        hint: '',
        formatTitle: function() {},
        customConfig:
                `
                 
                 <p style="font-size: 1em; font-weight: bold; width: 100%;">Останні зміни стану:</p>
                 <p id="LastChangeDate" style="font-size: 2em; font-weight: bold; width: 100%; height: 100px;"></p>
                 <div class="wrapper">
            		<div class="switch_box box_3">
            			<div class="toggle_switch">
            				<input type="checkbox" class="switch_3" id="input_btn_1">
            				<svg class="checkbox" xmlns="http://www.w3.org/2000/svg" style="isolation:isolate" viewBox="0 0 168 80">
            				   <path class="outer-ring" d="M41.534 9h88.932c17.51 0 31.724 13.658 31.724 30.482 0 16.823-14.215 30.48-31.724 30.48H41.534c-17.51 0-31.724-13.657-31.724-30.48C9.81 22.658 24.025 9 41.534 9z" fill="none" stroke="#233043" stroke-width="3" stroke-linecap="square" stroke-miterlimit="3"/>
            				   <path class="is_checked" d="M17 39.482c0-12.694 10.306-23 23-23s23 10.306 23 23-10.306 23-23 23-23-10.306-23-23z"/>
            					<path class="is_unchecked" d="M132.77 22.348c7.705 10.695 5.286 25.617-5.417 33.327-2.567 1.85-5.38 3.116-8.288 3.812 7.977 5.03 18.54 5.024 26.668-.83 10.695-7.706 13.122-22.634 5.418-33.33-5.855-8.127-15.88-11.474-25.04-9.23 2.538 1.582 4.806 3.676 6.66 6.25z"/>
            				</svg>
            			  </div>
            			  Simple load	
            		</div>
            		
            			<div class="switch_box box_3">
            			<div class="toggle_switch">
            				<input type="checkbox" class="switch_3" id="input_btn_2">
            				<svg class="checkbox" xmlns="http://www.w3.org/2000/svg" style="isolation:isolate" viewBox="0 0 168 80">
            				   <path class="outer-ring" d="M41.534 9h88.932c17.51 0 31.724 13.658 31.724 30.482 0 16.823-14.215 30.48-31.724 30.48H41.534c-17.51 0-31.724-13.657-31.724-30.48C9.81 22.658 24.025 9 41.534 9z" fill="none" stroke="#233043" stroke-width="3" stroke-linecap="square" stroke-miterlimit="3"/>
            				   <path class="is_checked" d="M17 39.482c0-12.694 10.306-23 23-23s23 10.306 23 23-10.306 23-23 23-23-10.306-23-23z"/>
            					<path class="is_unchecked" d="M132.77 22.348c7.705 10.695 5.286 25.617-5.417 33.327-2.567 1.85-5.38 3.116-8.288 3.812 7.977 5.03 18.54 5.024 26.668-.83 10.695-7.706 13.122-22.634 5.418-33.33-5.855-8.127-15.88-11.474-25.04-9.23 2.538 1.582 4.806 3.676 6.66 6.25z"/>
            				</svg>
            			  </div>
            			  Standart load
            		</div>
            		
            		
            			<div class="switch_box box_3">
            			<div class="toggle_switch">
            				<input type="checkbox" class="switch_3" id="input_btn_3">
            				<svg class="checkbox" xmlns="http://www.w3.org/2000/svg" style="isolation:isolate" viewBox="0 0 168 80">
            				   <path class="outer-ring" d="M41.534 9h88.932c17.51 0 31.724 13.658 31.724 30.482 0 16.823-14.215 30.48-31.724 30.48H41.534c-17.51 0-31.724-13.657-31.724-30.48C9.81 22.658 24.025 9 41.534 9z" fill="none" stroke="#233043" stroke-width="3" stroke-linecap="square" stroke-miterlimit="3"/>
            				   <path class="is_checked" d="M17 39.482c0-12.694 10.306-23 23-23s23 10.306 23 23-10.306 23-23 23-23-10.306-23-23z"/>
            					<path class="is_unchecked" d="M132.77 22.348c7.705 10.695 5.286 25.617-5.417 33.327-2.567 1.85-5.38 3.116-8.288 3.812 7.977 5.03 18.54 5.024 26.668-.83 10.695-7.706 13.122-22.634 5.418-33.33-5.855-8.127-15.88-11.474-25.04-9.23 2.538 1.582 4.806 3.676 6.66 6.25z"/>
            				</svg>
            			  </div>
            			  Hard load
            		</div>
            		
            	</div>
            	
                            `
        ,
        StateCode1: 'Simple load',
        StateCode2: 'Standart load',
        StateCode3: 'Hard load',
        afterViewInit: function() {
            let BtnCreateContent1 = document.getElementById('input_btn_1');
            BtnCreateContent1.addEventListener('click', function() {
                this.activeElement(BtnCreateContent1);
                this.changeState(1);
            }.bind(this), true);
            let BtnCreateContent2 = document.getElementById('input_btn_2');
            BtnCreateContent2.addEventListener('click', function() {
                this.activeElement(BtnCreateContent2);
                this.changeState(2);
            }.bind(this), true);
            let BtnCreateContent3 = document.getElementById('input_btn_3');
            BtnCreateContent3.addEventListener('click', function() {
                this.activeElement(BtnCreateContent3);
                this.changeState(3);
            }.bind(this), true);
            BtnCreateContent1.checked = false;
            BtnCreateContent2.checked = false;
            BtnCreateContent3.checked = false;
            this.reloadState();
        },
        changeState: function(StateId) {
            let executeQuery = {
                queryCode: 'LoadServer_InsertRow',
                limit: -1,
                parameterValues: [{key: '@StateId', value: StateId}]
            };
            this.queryExecutor(executeQuery, this.reloadState, this);
        },
        reloadState: function() {
            let executeQuery = {
                queryCode: 'LoadServer_SelectRow',
                limit: -1,
                parameterValues: []
            };
            this.queryExecutor(executeQuery, this.load, this);
        },
        activeElement: function(element) {
            let BtnCreateContent1 = document.getElementById('input_btn_1');
            let BtnCreateContent2 = document.getElementById('input_btn_2');
            let BtnCreateContent3 = document.getElementById('input_btn_3');
            BtnCreateContent1.checked = false;
            BtnCreateContent2.checked = false;
            BtnCreateContent3.checked = false;
            BtnCreateContent1.disabled = false;
            BtnCreateContent2.disabled = false;
            BtnCreateContent3.disabled = false;
            element.checked = true;
            element.disabled = true;
        },
        extractDate: function(val) {
            let inMonth = new Date(this.getLocalizedValue(val, 'Datetime'));
            let dd = inMonth.getDate();
            let mm = inMonth.getMonth() + 1;
            let yyyy = inMonth.getFullYear();
            let hh = inMonth.getHours();
            let mi = inMonth.getMinutes();
            let ss = inMonth.getSeconds();
            if(dd < 10) {
                dd = '0' + dd
            }
            if(mm < 10) {
                mm = '0' + mm
            }
            if(hh < 10) {
                hh = '0' + hh
            }
            if(mi < 10) {
                mi = '0' + mi
            }
            if(ss < 10) {
                ss = '0' + ss
            }
            return yyyy + '-' + mm + '-' + dd + ' ' + hh + ':' + mi + ':' + ss;
        },
        load: function(data) {
            let BtnCreateContent1 = document.getElementById('input_btn_1');
            let BtnCreateContent2 = document.getElementById('input_btn_2');
            let BtnCreateContent3 = document.getElementById('input_btn_3');
            document.getElementById('LastChangeDate').innerText = this.extractDate(data.rows[0].values[4]);
            if (data.rows[0].values[3] == 'Simple load') {
                this.activeElement(BtnCreateContent1);
            } else if (data.rows[0].values[3] == 'Standart load') {
                this.activeElement(BtnCreateContent2);
            } else if (data.rows[0].values[3] == 'Hard load') {
                this.activeElement(BtnCreateContent3);
            }
        }
    };
}());
