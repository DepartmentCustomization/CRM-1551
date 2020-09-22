export class FiltersPackageHelper {
    getFiltersPackage(filters) {
        const filtersPackage = [];
        filters.forEach(filter => {
            const properties = {
                name: filter.name,
                placeholder: filter.placeholder,
                type: filter.type,
                active: true,
                value: undefined
            }
            switch (filter.type) {
                case 'Select': {
                    properties.value = {
                        value: filter.value,
                        viewValue: filter.viewValue
                    }
                    filtersPackage.push(properties);
                    break;
                }
                case 'MultiSelect': {
                    properties.value = this.getMultiSelectPackage(filter);
                    filtersPackage.push(properties);
                    break;
                }
                case 'Date':
                case 'DateTime':
                case 'Time': {
                    if (filter.timePosition === undefined) {
                        properties.value = new Date(filter.value);
                        filtersPackage.push(properties);
                    } else {
                        const index = filtersPackage.findIndex(f => f.name === filter.name);
                        const value = new Date(filter.value);
                        properties.value = {
                            dateFrom: '',
                            dateTo: ''
                        }
                        if (index === -1) {
                            this.setDoubleDateValue(filter, properties.value, value);
                            filtersPackage.push(properties);
                        } else {
                            this.setDoubleDateValue(filter, filtersPackage[index].value, value);
                        }
                    }
                    break;
                }
                case 'CheckBox':
                case 'Input': {
                    properties.value = filter.value;
                    filtersPackage.push(properties);
                    break;
                }
                default:
                    break;
            }
        });
        return filtersPackage;
    }

    setDoubleDateValue(filter, object, value) {
        if (filter.timePosition === 'dateFrom') {
            object.dateFrom = value;
            return;
        }
        if (filter.timePosition === 'dateTo') {
            object.dateTo = value;
        }
    }

    getMultiSelectPackage(filter) {
        const multiSelectPackage = [];
        const values = filter.value.split(', ');
        const viewValues = filter.viewValue.split(', ');
        values.forEach((value, index) => {
            multiSelectPackage.push({
                value: Number(value),
                viewValue: viewValues[index],
                checked: true
            });
        });
        return multiSelectPackage;
    }
}