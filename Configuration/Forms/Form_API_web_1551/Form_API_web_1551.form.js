(function () {
  return {
    init: function() {
        const filters = [];
                            
        const sorting = [{ key: 'ObjectName', value: 0}];
                            
        const parameters = [
                                { key: '@ApplicantId', value: 9}
                            ];
                this.details.loadData('api_Detail_Events', parameters, filters, sorting);
    }
};
}());
