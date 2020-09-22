(function() {
    return {
        init:function() {
            this.showModal();
            document.getElementById('showModalWrapper').addEventListener('click', () => {
                this.showModal();
            });
        },
        showModal: function() {
            const formAddComplain = {
                title: 'Створити скаргу',
                acceptBtnText: 'save',
                cancelBtnText: 'cancel',
                fieldGroups: [
                    {
                        code: 'compl',
                        expand: true,
                        position: 1,
                        fields:[
                            {
                                code:'text',
                                placeholder:'Коментар',
                                hidden: false,
                                required: false,
                                position: 4,
                                fullScreen: true,
                                value: '12312312',
                                type: 'textarea'
                            }
                        ]
                    }
                ]
            };
            this.openCreateUserForm(formAddComplain);
        }
    };
}());
