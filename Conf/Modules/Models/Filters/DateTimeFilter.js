import { BaseFilter } from '/Modules/Models/Filters/BaseFilter.js';

export class DateTimeFilter extends BaseFilter {
    constructor(name, placeholder, type, dateFrom, dateTo) {
        super(name, placeholder, type);
        this.dateFrom = dateFrom;
        this.dateTo = dateTo;
    }
}
