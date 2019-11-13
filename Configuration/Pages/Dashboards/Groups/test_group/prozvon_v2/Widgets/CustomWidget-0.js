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
            this.rowsId = '';
            this.resolutionId = '';
            this.resultId = '';
            this.comment = '';
            this.checkBoxChacked = '';
            this.sub = this.messageService.subscribe('openModalForm', this.openModalForm, this);
            this.sub1 = this.messageService.subscribe('sortingArr', this.showSortingArr, this);

            let executeQueryAssigmResult = {
                queryCode: 'Prozvon_ResultSelect_Pr_v2',
                limit: -1,
                parameterValues: [
                    { key: '@pageOffsetRows', value: 1 },
                    { key: '@pageLimitRows', value: 10 }
                ]
            };
            this.queryExecutor(executeQueryAssigmResult, this.setResultsId, this);
            this.showPreloader = false;
        },
        setResultsId: function(data) {
            data.rows.forEach(el => {
                let obj = {
                    innerText: el.values[1],
                    value: el.values[0]
                }
                this.resultsValues.push(obj);
            });
        },
        openModalForm: function(message) {
            const modalContainer = document.getElementById('modalContainer');
            if (modalContainer.childNodes.length === 0) {
                this.resolutionId = '';
                this.resultId = '';
                this.comment = '';
                this.checkBoxChacked = '';
                this.selectedRows = [];
                message.value.forEach(el => {
                    this.selectedRows.push(el);
                });

                const button_close = this.createElement('button', { id: 'button_close', className: 'modalBtn', innerText: 'Закрити' });
                const button_save = this.createElement('button', { id: 'button_save', className: 'modalBtn', innerText: 'Зберегти' });
                const buttonWrapper = this.createElement('div', { id: 'buttonWrapper' }, button_close, button_save);
                button_save.disabled = true;
                const resultSelectOption = this.createElement('option', { innerText: '', value: 0 });
                const resultSelect = this.createElement('select', { id: 'resultSelect', className: "resultSelect selectItem js-example-basic-single" }, resultSelectOption);
                const assigmResult = this.createElement('div', { id: 'assigmResult', className: 'modalItem' }, resultSelect);
                const assigmResultTitle = this.createElement('span', { className: 'assigmResultTitle caption', innerText: 'Результат' });
                const assigmResultWrapper = this.createElement('div', { className: 'assigmResultWrapper' }, assigmResultTitle, assigmResult);

                const rating5__title = this.createElement('span', { className: 'rating__title', innerText: '5' });
                const rating5__checkBox = this.createElement('input', { type: "radio", name: "radio", checked: "checked", className: 'radio', mark: 5 });
                const rating5 = this.createElement('div', { id: 'rating1', className: 'container' }, rating5__checkBox, rating5__title);

                const rating4__title = this.createElement('span', { className: 'rating__title', innerText: '4' });
                const rating4__checkBox = this.createElement('input', { type: "radio", name: "radio", className: 'radio', mark: 4 });
                const rating4 = this.createElement('div', { id: 'rating1', className: 'container' }, rating4__checkBox, rating4__title);

                const rating3__title = this.createElement('span', { className: 'rating__title', innerText: '3' });
                const rating3__checkBox = this.createElement('input', { type: "radio", name: "radio", className: 'radio', mark: 3 });
                const rating3 = this.createElement('div', { id: 'rating1', className: 'container' }, rating3__checkBox, rating3__title);

                const rating2__title = this.createElement('span', { className: 'rating__title', innerText: '2' });
                const rating2__checkBox = this.createElement('input', { type: "radio", name: "radio", className: 'radio', mark: 2 });
                const rating2 = this.createElement('div', { id: 'rating1', className: 'container' }, rating2__checkBox, rating2__title);

                const rating1__title = this.createElement('span', { className: 'rating__title', innerText: '1' });
                const rating1__checkBox = this.createElement('input', { type: "radio", name: "radio", className: 'radio', mark: 1 });
                const rating1 = this.createElement('div', { id: 'rating1', className: 'container' }, rating1__checkBox, rating1__title);

                const ratingElements = this.createElement('div', { id: 'ratingElements', className: '' }, rating1, rating2, rating3, rating4, rating5);
                const ratingTitle = this.createElement('div', { className: 'assigmRating__title caption', innerText: 'Оцінка результату виконаних робіт' });
                const assigmRating = this.createElement('div', { id: 'assigmRating', className: 'displayNone' }, ratingTitle, ratingElements);

                const resolution__value = this.createElement('span', { id: 'resolution__value', innerText: '', resolutionId: 0 });

                const assigmResolution = this.createElement('div', { id: 'assigmResolutionValue', className: 'modalItem' }, resolution__value);
                const assigmResolutionTitle = this.createElement('span', { className: 'assigmResultTitle caption', innerText: 'Резолюцiя' });
                const assigmResolutionWrapper = this.createElement('div', { id: 'assigmResolution', className: 'displayNone assigmResultWrapper' }, assigmResolutionTitle, assigmResolution);

                const assigmComment = this.createElement('input', { type: "text", id: 'assigmComment', className: 'displayNone modalItem', placeholder: 'Коментар перевіряючого' });
                const modalWindow = this.createElement('div', { id: 'modalWindow' }, assigmResultWrapper, assigmResolutionWrapper, assigmRating, assigmComment, buttonWrapper);
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
                    this.sendResult();
                });
                this.showAssigmResult(resultSelect, this.resultsValues, this);
                this.showPreloader = false;
            }
        },
        showAssigmResult: function(select, data) {
            data.forEach(el => {
                let option = this.createElement('option', { innerText: el.innerText, value: el.value, className: "option" });
                select.appendChild(option);
            });
            this.createOptions();

            $('#resultSelect').on('select2:select', function(e) {
                e.stopImmediatePropagation();
                let resultId = Number(e.params.data.id);
                this.resultId = resultId;
                this.showHiddenElements(resultId);
            }.bind(this));
        },
        showHiddenElements: function(resultId) {
            let resolutionInnerText;
            let resolutionId;

            button_save.disabled = false;
            switch (resultId) {
                case 4:
                    resolutionId = 9;
                    resolutionInnerText = 'Підтверджено заявником';
                    break;
                case 5:
                case 10:
                case 12:
                    resolutionId = 8;
                    resolutionInnerText = 'Виконання не підтверджено заявником ';
                    break;
                case 7:
                    resolutionId = 6;
                    resolutionInnerText = 'Перевірено куратором';
                    break;
                case 11:
                    resolutionId = 10;
                    resolutionInnerText = 'Заявник усунув проблему власними силами';
                    break;
            }
            this.resolutionId = resolutionId;
            document.getElementById('resolution__value').innerText = resolutionInnerText;
            document.getElementById('resolution__value').resolutionId = resolutionId;
            switch (resultId) {
                case 4:
                    document.getElementById('assigmComment').classList.remove('displayNone');
                    document.getElementById('assigmResolution').classList.remove('displayNone');
                    document.getElementById('assigmRating').classList.remove('displayNone');
                    break;
                case 5:
                case 7:
                case 10:
                case 11:
                case 12:
                    document.getElementById('assigmComment').classList.remove('displayNone');
                    document.getElementById('assigmResolution').classList.remove('displayNone');
                    document.getElementById('assigmRating').classList.add('displayNone');
                    break;
                case 13:
                    document.getElementById('assigmComment').classList.remove('displayNone');
                    document.getElementById('assigmResolution').classList.add('displayNone');
                    document.getElementById('assigmRating').classList.add('displayNone');
                    break;
                default:
                    document.getElementById('assigmComment').classList.add('displayNone');
                    document.getElementById('assigmResolution').classList.add('displayNone');
                    document.getElementById('assigmRating').classList.add('displayNone');
                    break;
            }
        },
        showSortingArr: function(message) {
            this.sortingArr = message.arr;
        },
        sendResult: function() {
            let sortArr = this.sortingArr;
            let sendString;
            if (sortArr) {
                let sortingString = '';
                sortArr.forEach(el => {
                    let string = el.name + ' ' + el.value + ', ';
                    sortingString = sortingString + string;
                });
                sendString = sortingString.slice(0, -2);
            } else {
                sendString = '1=1';
            }
            this.sendString = sendString;

            let selectedRows = this.selectedRows;
            this.selectedRowsLength = selectedRows.length;
            this.rowsCounter = 0;
            selectedRows.forEach(row => {
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
                        this.checkBoxChacked = el.mark;
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
                        if (this.resolutionId != '' && this.resolutionId != undefined) {
                            let executeQuery = {
                                queryCode: 'Prozvon_Close_v2',
                                limit: -1,
                                parameterValues: [
                                    { key: '@Id', value: row.id },
                                    { key: '@organization_id', value: row.organization_id },
                                    { key: '@assignment_resolution_id', value: this.resolutionId },
                                    { key: '@control_result_id', value: this.resultId },
                                    { key: '@control_comment', value: this.comment },
                                    { key: '@grade', value: this.checkBoxChacked },
                                ]
                            };
                            this.queryExecutor(executeQuery, this.changeRowsCounter, this);
                            this.showPreloader = false;
                        }
                        break
                    case '':
                        break
                    case 13:
                    default:
                        if (this.resultId != '' && this.resultId != undefined) {
                            let executeQuery = {
                                queryCode: 'Prozvon_Close_v2',
                                limit: -1,
                                parameterValues: [
                                    { key: '@Id', value: row.id },
                                    { key: '@organization_id', value: null },
                                    { key: '@assignment_resolution_id', value: null },
                                    { key: '@control_result_id', value: this.resultId },
                                    { key: '@control_comment', value: this.comment },
                                    { key: '@grade', value: this.checkBoxChacked },
                                ]
                            };
                            this.queryExecutor(executeQuery, this.changeRowsCounter, this);
                            this.showPreloader = false;
                        }
                        break
                }
            });
        },
        changeRowsCounter: function(result) {
            let obj = {
                number: result.rows[0].values[0],
                result: result.rows[0].values[1],
            }
            this.closingResult.push(obj);
            this.rowsCounter++;
            if (this.rowsCounter === this.selectedRowsLength) {
                modalContainer.removeChild(modalContainer.firstElementChild);
                if (this.resultId === 12 || this.resultId === 5) {
                    this.showResultWrapper(this.closingResult, modalContainer);
                } else {
                    this.closingResult = [];
                    this.messageService.publish({ name: 'reloadMainTable', sortingString: this.sendString });
                }
            }
        },
        showResultWrapper: function(closingResult, modalContainer) {

            let closingResultHeader__number = this.createElement('div', { id: 'closingResultHeader__number', innerText: 'Номер доручення', className: 'closingResultItemChild closingResultItemHeader' });
            let closingResultHeader__result = this.createElement('div', { id: 'closingResultHeader__result', innerText: 'Результат', className: 'closingResultItemChild closingResultItemHeader' });
            let closingResultHeader = this.createElement('div', { id: 'closingResultHeader' }, closingResultHeader__number, closingResultHeader__result);

            let closingResultBody = this.createElement('div', { id: 'closingResultBody' });
            let closingResultBtn = this.createElement('button', { id: 'closingResultBtn', className: 'modalBtn', innerText: 'Закрити' });
            let closingResultBtnWrapper = this.createElement('div', { id: 'closingResultBtnWrapper' }, closingResultBtn);

            let modalWindow = this.createElement('div', { id: 'modalWindow' }, closingResultHeader, closingResultBody, closingResultBtnWrapper);

            closingResult.forEach(el => {
                let closingResultItem__number = this.createElement('div', { className: 'closingResultItemChild', innerText: el.number });
                let closingResultItem__result = this.createElement('div', { className: 'closingResultItemChild', innerText: el.result });
                let closingResultItem = this.createElement('div', { className: 'closingResultItem' }, closingResultItem__number, closingResultItem__result);
                closingResultBody.appendChild(closingResultItem);
            });

            let closingResultWrapper = this.createElement('div', { id: 'closingResultWrapper' }, modalWindow);
            modalContainer.appendChild(closingResultWrapper)

            closingResultBtn.addEventListener('click', event => {
                event.stopImmediatePropagation();
                this.closingResult = [];
                modalContainer.removeChild(modalContainer.firstElementChild);
                this.messageService.publish({ name: 'reloadMainTable', sortingString: this.sendString });
            });
        },
        createOptions: function(selectId, event) {
            $(document).ready(function() {
                $('.js-example-basic-single').select2();
                $(".js-example-placeholder-district").select2({
                    placeholder: "Обрати район",
                    allowClear: true
                });
                $(".js-example-placeholder-categorie").select2({
                    placeholder: "Обрати напрямок робiт",
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
        },
    };
}());