import { SelectFilter } from '/Modules/Models/Filters/SelectFilter.js';

export class MultiSelectFilter extends SelectFilter {
    constructor(name, placeholder, type, values) {
        super(name, placeholder, type);
        this.value = this.setMultipleValues(values, 'value');
        this.viewValue = this.setMultipleValues(values, 'viewValue');
    }

    setMultipleValues(values, property) {
        const array = [];
        values.forEach(value => array.push(value[property]));
        return array.join(', ');
    }
}
