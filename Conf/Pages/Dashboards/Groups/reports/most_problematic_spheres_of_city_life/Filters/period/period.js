(function () {
    return {

        placeholder: 'Період',
        type: "Date",
        onItemSelect: function (date) {
        },

        init: function () {
        },

        initValue: function () {
            let currentDate = new Date();
            let year = currentDate.getFullYear();
            let monthFrom = currentDate.getMonth();
            let dayTo = currentDate.getDate();
            let defaultValue = {
                dateFrom: new Date(year, '00', '01'),
                dateTo: new Date(year, monthFrom, dayTo)
            }
            this.setDefaultValue(defaultValue);
        }
    };
}());
