(function() {
    return {
        title: [],
        hint: '',
        formatTitle: function() {},
        customConfig:
                    `
                    <button type="button" id="btn_GetData">GetData</button>
                    
                    `
        ,
        sub1: {},
        sub2: {},
        sub3: {},
        sub4: {},
        sub5: {},
        sub6: {},
        Result_Data_Country: [],
        Result_Data_LocalitiesByCountry: [],
        Result_Data_DistrictsByLocality: [],
        Result_Data_StreetsByDistrict: [],
        Result_Data_Data_AllAoByStreet: [],
        Result_Data_PremisesByAO: [],
        init: function() {
            this.sub1 = this.messageService.subscribe('Data_Country', this.Data_Country, this);
            this.sub2 = this.messageService.subscribe('Data_LocalitiesByCountry', this.Data_LocalitiesByCountry, this);
            this.sub3 = this.messageService.subscribe('Data_DistrictsByLocality', this.Data_DistrictsByLocality, this);
            this.sub4 = this.messageService.subscribe('Data_StreetsByDistrict', this.Data_StreetsByDistrict, this);
            this.sub5 = this.messageService.subscribe('Data_AllAoByStreet', this.Data_AllAoByStreet, this);
            this.sub6 = this.messageService.subscribe('Data_PremisesByAO', this.Data_PremisesByAO, this);
        },
        afterViewInit: function() {
            document.getElementById('btn_GetData').addEventListener('click', function() {
            }.bind(this));
        },
        load: function() {
        },
        Data_Country: function(message) {
            this.Result_Data_Country = message.value;
        },
        Data_LocalitiesByCountry: function(message) {
            this.Result_Data_Country = message.value;
        },
        Data_DistrictsByLocality: function() {
        },
        Data_StreetsByDistrict: function() {
        },
        Data_AllAoByStreet: function() {
        },
        Data_PremisesByAO: function() {
        },
        destroy: function() {
            this.sub1.unsubscribe();
            this.sub2.unsubscribe();
            this.sub3.unsubscribe();
            this.sub4.unsubscribe();
            this.sub5.unsubscribe();
            this.sub6.unsubscribe();
        }
    };
}());
