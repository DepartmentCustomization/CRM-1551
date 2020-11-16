(function() {
    return {
        title: ' ',
        hint: '',
        formatTitle: function() {},
        customConfig: `
                <div id='modalContainer'></div>
                `,
        init: function() {
            let initTime = new Date();
            this.sessionTime = 'Session_' + initTime;
            this.closingResult = [];
            this.resultsValues = [];
            this.templateSelectValues = [];
            this.rowsId = '';
            this.resolutionId = '';
            this.resultId = '';
            this.comment = '';
            this.checkBoxChecked = '';
            this.sub = this.messageService.subscribe('openModalForm', this.openModalForm, this);
            this.sub1 = this.messageService.subscribe('sortingArr', this.showSortingArr, this);
            this.executeSelectResultQuery('Prozvon_ResultSelect_v2', this.resultsValues);
            this.executeSelectResultQuery('Prozvon_ControlComments_SRows', this.templateSelectValues);
        },
        executeSelectResultQuery: function(code, array) {
            let executeQuery = {
                queryCode: code,
                limit: -1,
                parameterValues: [
                    { key: '@pageOffsetRows', value: 1 },
                    { key: '@pageLimitRows', value: 10 }
                ]
            };
            this.queryExecutor(executeQuery, this.setResultsId.bind(this, array), this);
            this.showPreloader = false;
        },
        setResultsId: function(array, data) {
            data.rows.forEach(el => {
                array.push({
                    innerText: el.values[1],
                    value: el.values[0]
                });
            });
        },
        openModalForm: function(message) {
            const modalContainer = document.getElementById('modalContainer');
            if (modalContainer.childNodes.length === 0) {
                this.resolutionId = '';
                this.resultId = '';
                this.comment = '';
                this.checkBoxChecked = '';
                this.selectedRows = [];
                message.value.forEach(el => this.selectedRows.push(el));
                const button_close = this.createElement('button', { id: 'button_close', className: 'modalBtn', innerText: 'Закрити' });
                const button_save = this.createElement('button',
                    { id: 'button_save', className: 'modalBtn', innerText: 'Зберегти', disabled: true }
                );
                const buttonWrapper = this.createElement('div', { id: 'buttonWrapper' }, button_close, button_save);
                const resultSelectOption = this.createElement('option', { innerText: '', value: 0 });
                const resultSelect = this.createElement('select',
                    { id: 'resultSelect', className: 'resultSelect selectItem js-example-basic-single' },
                    resultSelectOption
                );
                const assigmResult = this.createElement('div', { id: 'assigmResult', className: 'modalItem' }, resultSelect);
                const assigmResultTitle = this.createElement('span', { className: 'assigmResultTitle caption', innerText: 'Результат' });
                const assigmResultWrapper = this.createElement('div', { className: 'assigmResultWrapper' },
                    assigmResultTitle, assigmResult
                );
                const rating5__title = this.createElement('span', { className: 'rating__title', innerText: '5' });
                const rating5__checkBox = this.createElement('input',
                    { type: 'radio', name: 'radio', checked: 'checked', className: 'radio', mark: 5 }
                );
                const rating5 = this.createElement('div', { id: 'rating1', className: 'container' }, rating5__checkBox, rating5__title);
                const rating4__title = this.createElement('span', { className: 'rating__title', innerText: '4' });
                const rating4__checkBox = this.createElement('input', { type: 'radio', name: 'radio', className: 'radio', mark: 4 });
                const rating4 = this.createElement('div', { id: 'rating1', className: 'container' }, rating4__checkBox, rating4__title);
                const rating3__title = this.createElement('span', { className: 'rating__title', innerText: '3' });
                const rating3__checkBox = this.createElement('input', { type: 'radio', name: 'radio', className: 'radio', mark: 3 });
                const rating3 = this.createElement('div', { id: 'rating1', className: 'container' }, rating3__checkBox, rating3__title);
                const rating2__title = this.createElement('span', { className: 'rating__title', innerText: '2' });
                const rating2__checkBox = this.createElement('input', { type: 'radio', name: 'radio', className: 'radio', mark: 2 });
                const rating2 = this.createElement('div', { id: 'rating1', className: 'container' }, rating2__checkBox, rating2__title);
                const rating1__title = this.createElement('span', { className: 'rating__title', innerText: '1' });
                const rating1__checkBox = this.createElement('input', { type: 'radio', name: 'radio', className: 'radio', mark: 1 });
                const rating1 = this.createElement('div', { id: 'rating1', className: 'container' }, rating1__checkBox, rating1__title);
                const ratingElements = this.createElement('div', { id: 'ratingElements', className: '' },
                    rating1, rating2, rating3, rating4, rating5
                );
                const ratingTitle = this.createElement('div',
                    { className: 'assigmRating__title caption', innerText: 'Оцінка результату виконаних робіт' }
                );
                const assigmRating = this.createElement('div', { id: 'assigmRating', className: 'displayNone' },
                    ratingTitle, ratingElements
                );
                const resolution__value = this.createElement('span', { id: 'resolution__value', innerText: '', resolutionId: 0 });
                const assigmResolution = this.createElement('div', { id: 'assigmResolutionValue', className: 'modalItem' },
                    resolution__value
                );
                const assigmResolutionTitle = this.createElement('span',
                    { className: 'assigmResultTitle caption', innerText: 'Резолюцiя' }
                );
                const assigmResolutionWrapper = this.createElement('div',
                    { id: 'assigmResolution', className: 'displayNone assigmResultWrapper' },
                    assigmResolutionTitle, assigmResolution
                );
                const templateSelectOption = this.createElement('option', { innerText: '', value: 0 });
                const templateSelect = this.createElement('select',
                    { id: 'templateSelect', className: 'resultSelect selectItem js-example-basic-single' },
                    templateSelectOption
                );
                const templateResult = this.createElement('div',
                    { id: 'templateResult', className: 'modalItem' },
                    templateSelect
                );
                const templateResultTitle = this.createElement('span', { className: 'caption', innerText: 'Шаблон' });
                const templateResultWrapper = this.createElement('div',
                    { id: 'templateResultWrapper', className: 'displayNone assigmResultWrapper' },
                    templateResultTitle, templateResult
                );
                const assigmComment = this.createElement('input',
                    { type: 'text', id: 'assigmComment', className: 'displayNone modalItem', placeholder: 'Коментар перевіряючого' }
                );
                const modalWindow = this.createElement('div', { id: 'modalWindow' },
                    assigmResultWrapper, assigmResolutionWrapper, assigmRating, templateResultWrapper, assigmComment, buttonWrapper
                );
                const modalWrapper = this.createElement('div', { id: 'modalWrapper' }, modalWindow);
                modalContainer.appendChild(modalWrapper);
                button_close.addEventListener('click', event => {
                    event.stopImmediatePropagation();
                    modalContainer.removeChild(modalContainer.firstElementChild);
                });
                button_save.addEventListener('click', event => {
                    event.stopImmediatePropagation();
                    let target = event.currentTarget;
                    target.disabled = true;
                    target.style.backgroundColor = '#cfcbcb';
                    this.sendResult(modalContainer);
                });
                this.setOptions(resultSelect, this.resultsValues, this);
                this.setOptions(templateSelect, this.templateSelectValues, this);
                $('#resultSelect').on('select2:select', e => {
                    e.stopImmediatePropagation();
                    this.resultId = Number(e.params.data.id);
                    this.showHiddenElements(this.resultId, button_save);
                });
                $('#templateSelect').on('select2:select', e => {
                    e.stopImmediatePropagation();
                    assigmComment.value = e.params.data.text;
                });
            }
        },
        setOptions: function(select, data) {
            data.forEach(el => {
                let option = this.createElement('option', { innerText: el.innerText, value: el.value, className: 'option' });
                select.appendChild(option);
            });
            this.createOptions();
        },
        showHiddenElements: function(resultId, button_save) {
            button_save.disabled = false;
            this.showHideModalElements(resultId);
            document.getElementById('resolution__value').innerText = this.getResolutionId(resultId);
            document.getElementById('resolution__value').resolutionId = this.resolutionId;
        },
        getResolutionId: function(resultId) {
            switch (resultId) {
                case 4:
                    this.resolutionId = 9;
                    return 'Підтверджено заявником';
                case 5:
                case 10:
                case 12:
                    this.resolutionId = 8;
                    return 'Виконання не підтверджено заявником ';
                case 7:
                    this.resolutionId = 6;
                    return 'Перевірено куратором';
                case 11:
                    this.resolutionId = 10;
                    return 'Заявник усунув проблему власними силами';
                default:
                    return undefined
            }
        },
        showHideModalElements: function(resultId) {
            switch (resultId) {
                case 4:
                    this.showElement('templateResultWrapper');
                    this.showElement('assigmComment');
                    this.showElement('assigmResolution');
                    this.showElement('assigmRating');
                    break;
                case 5:
                case 7:
                case 10:
                case 11:
                case 12:
                    this.showElement('templateResultWrapper');
                    this.showElement('assigmComment');
                    this.showElement('assigmResolution');
                    this.hideElement('assigmRating');
                    break;
                case 13:
                    this.showElement('templateResultWrapper');
                    this.showElement('assigmComment');
                    this.hideElement('assigmResolution');
                    this.hideElement('assigmRating');
                    break;
                default:
                    this.hideElement('templateResultWrapper');
                    this.hideElement('assigmComment');
                    this.hideElement('assigmResolution');
                    this.hideElement('assigmRating');
                    break;
            }
        },
        hideElement: function(id) {
            document.getElementById(id).classList.add('displayNone');
        },
        showElement: function(id) {
            document.getElementById(id).classList.remove('displayNone');
        },
        showSortingArr: function(message) {
            this.sortingArr = message.arr;
        },
        sendResult: function(modalContainer) {
            if (this.sortingArr) {
                const a = [];
                this.sortingArr.forEach(el => a.push(`${el.fullName} ${el.value}`));
                this.sendSortValue = a.join(', ');
            } else {
                this.sendSortValue = '1=1';
            }
            this.rowsCounter = 0;
            this.selectedRowsLength = this.selectedRows.length;
            this.selectedRows.forEach(row => {
                let executeQuerySessionTime = {
                    queryCode: 'ak_CallLogging_v2',
                    limit: -1,
                    parameterValues: [
                        { key: '@Session', value: this.sessionTime },
                        { key: '@AssigmentId', value: row.id }
                    ]
                };
                this.queryExecutor(executeQuerySessionTime);
                this.showPreloader = false;
                let checkBoxes = document.querySelectorAll('.radio');
                checkBoxes = Array.from(checkBoxes);
                checkBoxes.forEach(el => {
                    if (el.checked === true) {
                        this.checkBoxChecked = el.mark;
                    }
                });
                this.comment = document.getElementById('assigmComment').value;
                switch (this.resultId) {
                    case 4:
                    case 5:
                    case 7:
                    case 10:
                    case 11:
                    case 12:
                        if (this.resolutionId !== '' && this.resolutionId !== undefined) {
                            this.executeProzvonClose(row.id, row.organization_id, this.resolutionId, modalContainer);
                        }
                        break
                    case '':
                        break
                    case 13:
                    default:
                        if (this.resultId !== '' && this.resultId !== undefined) {
                            this.executeProzvonClose(row.id, null, null, modalContainer);
                        }
                        break
                }
            });
        },
        executeProzvonClose: function(id, organization_id, assignment_resolution_id, modalContainer) {
            let executeQuery = {
                queryCode: 'Prozvon_Close_Filter_v2',
                limit: -1,
                parameterValues: [
                    { key: '@Id', value: id },
                    { key: '@organization_id', value: organization_id },
                    { key: '@assignment_resolution_id', value: assignment_resolution_id },
                    { key: '@control_result_id', value: this.resultId },
                    { key: '@control_comment', value: this.comment },
                    { key: '@grade', value: this.checkBoxChecked }
                ]
            };
            this.queryExecutor(executeQuery, this.changeRowsCounter.bind(this, modalContainer), this);
            this.showPreloader = false;
        },
        changeRowsCounter: function(modalContainer) {
            this.rowsCounter++;
            if (this.rowsCounter === this.selectedRowsLength) {
                modalContainer.removeChild(modalContainer.firstElementChild);
                this.messageService.publish({ name: 'reloadMainTable', sortingString: this.sendSortValue });
            }
        },
        createOptions: function() {
            $(document).ready(function() {
                $('.js-example-basic-single').select2();
                $('.js-example-placeholder-district').select2({
                    placeholder: 'Обрати район',
                    allowClear: true
                });
                $('.js-example-placeholder-categorie').select2({
                    placeholder: 'Обрати напрямок робiт',
                    allowClear: true
                });
            });
            this.messageService.publish({ name: 'hidePagePreloader' });
        },
        createElement: function(tag, props, ...children) {
            const element = document.createElement(tag);
            Object.keys(props).forEach(key => element[key] = props[key]);
            if (children.length > 0) {
                children.forEach(child => {
                    element.appendChild(child);
                });
            }
            return element;
        },
        destroy: function() {
            this.sub.unsubscribe();
            this.sub1.unsubscribe();
        }
    };
}());
