import { BaseFilter } from '/Modules/Models/Filters/BaseFilter.js';

export class Filter extends BaseFilter {
    constructor(name, placeholder, type, value) {
        super(name, placeholder, type);
        this.value = value;
    }
}
