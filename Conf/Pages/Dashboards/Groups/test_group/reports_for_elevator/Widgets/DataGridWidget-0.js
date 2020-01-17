(function () {
  return {
    config: {
        query: {
            code: 'table2',
            parameterValues: [],
            filterColumns: [],
            sortColumns: [],
            skipNotVisibleColumns: true,
            chunkSize: 1000
        },
        columns: [
            {
                dataField: 'navigation',
                caption: 'Район',
                dataType: null,
                format: null,
                width: null,
                alignment: null,
                groupIndex: null,
                fixed: true,
                sortOrder: 'asc',
                allowSorting: true,
                subColumns: []
            },  {
                dataField: 'uvaga',
                caption: 'ЖЕД',
                dataType: null,
                format: null,
                width: null,
                alignment: null,
                groupIndex: null,
                fixed: true,
                sortOrder: 'asc',
                allowSorting: true,
                subColumns: []
            },  {
                dataField: 'uvaga',
                caption: 'Номер питання',
                dataType: null,
                format: null,
                width: null,
                alignment: null,
                groupIndex: null,
                fixed: true,
                sortOrder: 'asc',
                allowSorting: true,
                subColumns: []
            },  {
                dataField: 'uvaga',
                caption: 'Тип питання',
                dataType: null,
                format: null,
                width: null,
                alignment: null,
                groupIndex: null,
                fixed: true,
                sortOrder: 'asc',
                allowSorting: true,
                subColumns: []
            },  {
                dataField: 'uvaga',
                caption: 'Стан питання',
                dataType: null,
                format: null,
                width: null,
                alignment: null,
                groupIndex: null,
                fixed: true,
                sortOrder: 'asc',
                allowSorting: true,
                subColumns: []
            },  {
                dataField: 'uvaga',
                caption: 'Результат',
                dataType: null,
                format: null,
                width: null,
                alignment: null,
                groupIndex: null,
                fixed: true,
                sortOrder: 'asc',
                allowSorting: true,
                subColumns: []
            },  {
                dataField: 'uvaga',
                caption: 'Виконавець',
                dataType: null,
                format: null,
                width: null,
                alignment: null,
                groupIndex: null,
                fixed: true,
                sortOrder: 'asc',
                allowSorting: true,
                subColumns: []
            },  {
                dataField: 'uvaga',
                caption: 'Адрес',
                dataType: null,
                format: null,
                width: null,
                alignment: null,
                groupIndex: null,
                fixed: true,
                sortOrder: 'asc',
                allowSorting: true,
                subColumns: []
            },  {
                dataField: 'uvaga',
                caption: 'Дата прийняття в роботу',
                dataType: null,
                format: null,
                width: null,
                alignment: null,
                groupIndex: null,
                fixed: true,
                sortOrder: 'asc',
                allowSorting: true,
                subColumns: []
            },  {
                dataField: 'uvaga',
                caption: 'Планова дата виконання',
                dataType: null,
                format: null,
                width: null,
                alignment: null,
                groupIndex: null,
                fixed: true,
                sortOrder: 'asc',
                allowSorting: true,
                subColumns: []
            },  {
                dataField: 'uvaga',
                caption: 'Коментар виконавця',
                dataType: null,
                format: null,
                width: null,
                alignment: null,
                groupIndex: null,
                fixed: true,
                sortOrder: 'asc',
                allowSorting: true,
                subColumns: []
            }, 
        ],
        export: {
            enabled: false,
            fileName: 'File_name'
        },
        pager: {},
        scrolling: {
            // mode = null,
            // rowRenderingMode = null,
            // columnRenderingMode = null,
            // showScrollbar = null
        },
        searchPanel: {
            visible: true,
            highlightCaseSensitive: true
        },
        editing: {
            // mode: 'row',
            // allowUpdating: true,
            // allowDeleting: true,
            // allowAdding: true,
            // useIcons: true
        },
        keyExpr: 'Id',
        showBorders: true,
        showColumnLines: true,
        showRowLines: true,
        remoteOperations: null,
        allowColumnReordering: null,
        rowAlternationEnabled: null,
        columnAutoWidth: null,
        hoverStateEnabled: true,
        columnWidth: null,
        wordWrapEnabled: true,
        allowColumnResizing: true,
        showFilterRow: false,
        showHeaderFilter: false,
        showColumnChooser: false,
        showColumnFixing: true,
        // sortingMode: 'multiple',
        // selectionMode: 'multiple',
        groupingAutoExpandAll: null,
        masterDetail: null,
        onRowUpdating: function(data) {},
        onRowExpanding: function(data) {},
        onRowInserting: function(data) {},
        onRowRemoving: function(data) {},
        onCellClick: function(data) {},
        onRowClick: function(data) {},
        selectionChanged: function(data) {}
    },
    sub: [],
    start_date: '',
    finish_date: '',
    filter_district: 0,
    filter_dataStart: '03.10.2018',
    filter_dataEnd: '10.10.2018',
    
    init: function() {
        const weekAgo = 1000*60*60*24*7;
        const currentDate = new Date();
        let  startDate = new Date(Date.now() - weekAgo);
        
        this.filter_dataStart = startDate;
        this.filter_dataEnd = currentDate;
        
        
        this.sub = this.messageService.subscribe('GlobalFilterChanged', this.setDataFilterValue, this);
        this.loadData();
    },
    setDataFilterValue:function(message) {
        // this.districts = message.package.value.values.find(f => f.name === 'FilterDistrict').value;
        
        function checkDateFrom(val){
            return val ? val.dateFrom : null;
        };
        function checkDateTo(val){
            return val ? val.dateTo : null;
        };
        this.start_date = checkDateFrom(message.package.value.values[0].value);
        this.finish_date = checkDateTo(message.package.value.values[0].value);
    },
    destroy: function() {
        this.sub.unsubscribe();
    }
};
}());
