export class QueryHelper {
    queryParameters = [];
    defaultFilterValue = null;
    setQueryParameters(filters) {
        filters.forEach(filter => {
            switch (filter.type) {
                case 'Date':
                    if(filter.value.dateFrom === undefined || filter.value.dateTo === undefined) {
                        this.setSimpleQueryParametersKey(filter);
                    } else {
                        this.setDateTimeQueryParametersKey(filter);
                    }
                    break;
                case 'DateTime':
                case 'Time': {
                    this.setDateTimeQueryParametersKey(filter);
                    break;
                }
                case 'Select':
                case 'MultiSelect':
                case 'CheckBox':
                case 'Input': {
                    this.setSimpleQueryParametersKey(filter);
                    break;
                }
                default:
                    break;
            }
        });
    }

    setDateTimeQueryParametersKey(filter) {
        if (filter.value.dateFrom || filter.value.dateFrom === '') {
            const parameters = { key: `@${filter.name}DateFrom`, value: this.defaultFilterValue }
            this.queryParameters.push(parameters);
        }
        if (filter.value.dateTo || filter.value.dateTo === '') {
            const parameters = { key: `@${filter.name}DateTo`, value: this.defaultFilterValue }
            this.queryParameters.push(parameters);
        }
    }

    setSimpleQueryParametersKey(filter) {
        const parameters = { key: `@${filter.name}`, value: this.defaultFilterValue }
        this.queryParameters.push(parameters);
    }

    getQueryParameters(filters, activeFilters) {
        this.setQueryParameters(filters);
        activeFilters.forEach(filter => {
            switch (filter.type) {
                case 'Date':
                    if (filter.value || filter.value === '') {
                        this.setQueryParameterValue(filter.value, filter.name, null);
                    } else {
                        this.setDateTimeQueryParametersValues(filter);
                    }
                    break;
                case 'DateTime':
                case 'Time': {
                    this.setDateTimeQueryParametersValues(filter);
                    break;
                }
                case 'Select':
                case 'MultiSelect':
                case 'CheckBox':
                case 'Input': {
                    this.setQueryParameterValue(filter.value, filter.name, null);
                    break;
                }
                default:
                    break;
            }
        });
        return this.queryParameters;
    }

    setDateTimeQueryParametersValues(filter) {
        if (filter.dateFrom) {
            this.setQueryParameterValue(filter.dateFrom, filter.name, 'DateFrom');
        }
        if (filter.dateTo) {
            this.getQueryParameterProps(filter.dateTo, filter.name, 'DateTo');
        }
    }

    getIndex(key) {
        return this.queryParameters.findIndex(p => p.key === key);
    }

    setQueryParameterValue(value, name, suffix) {
        const index = suffix === null ? this.getIndex(`@${name}`) : this.getIndex(`@${name}${suffix}`);
        this.queryParameters[index].value = value;
    }
}