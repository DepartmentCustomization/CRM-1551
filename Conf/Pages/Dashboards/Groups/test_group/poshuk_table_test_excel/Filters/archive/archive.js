(function () {
  return {
    placeholder: 'Архiвнi',
    onItemSelect: function(value) {
        this.yourFunctionName(value);
    },
    yourFunctionName: function(value) {
        let message = {
            name: '',
            package: {
                value: value
            }
        }
        this.messageService.publish(message);
    }
};
}());
