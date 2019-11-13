(function () {
  return {
    title: ' ',
    hint: '',
    formatTitle: function() {},
    customConfig:
                `
                <style>
                    .btnWrap{
                        text-align: center;
                    }
                    #btnExcel{
                        background-color: rgba(21, 189, 244, 1)!important;
                        border-color: transparent;
                        color: #fff;
                        display: inline-block;
                        cursor: pointer;
                        text-align: center;
                        vertical-align: middle;
                        padding: 7px 18px 8px;
                        border-radius: 5px;                        
                    }
                </style>
                <div id='container'></div>
                `
    ,
    afterViewInit: function() {
        this.sub = this.messageService.subscribe('setData', this.setData, this );
        this.counter = 0
        const CONTAINER = document.getElementById('container');
        let btnExcel = this.createElement('button', { id: 'btnExcel', innerText: 'Вигрузити в Excel', disabled: true } );
        let btnWrap = this.createElement('div', { className: 'btnWrap' }, btnExcel );
        CONTAINER.appendChild(btnWrap);
        
        btnExcel.addEventListener('click', event => {
            event.stopImmediatePropagation();
            this.createTableExcel();
        });
    },
    setData: function(message){
        if( message.rep1_data){
            this.rep1_data =  message.rep1_data;
            this.rep1_title =  message.rep1_title;
            this.counter += 1;
        }else if( message.rep2_data){
            this.rep2_data =  message.rep2_data;
            this.rep2_title =  message.rep2_title;
            this.counter += 1;
        }else if( message.rep3_data){
            this.rep3_data =  message.rep3_data;
            this.rep3_title =  message.rep3_title;
            this.counter += 1;
        }else if( message.rep4_data){
            this.rep4_data =  message.rep4_data;
            this.rep4_title =  message.rep4_title;
            this.counter += 1;
        }else if( message.rep5_data){
            this.rep5_data =  message.rep5_data;
            this.rep5_title =  message.rep5_title;
            this.counter += 1;
        }
        if( this.counter === 5 ){
            this.dataArray = [ this.rep1_data, this.rep2_data, this.rep3_data, this.rep4_data, this.rep5_data];
            document.getElementById('btnExcel').disabled = false;
            this.counter = 0;
        }
    },
    createElement: function(tag, props, ...children) {
        const element = document.createElement(tag);
        Object.keys(props).forEach( key => element[key] = props[key] );
        if(children.length > 0){
            children.forEach( child =>{
                element.appendChild(child);
            });
        } return element;
    },   
    createTableExcel: function(){
        this.showPagePreloader('Зачекайте, формується документ');
        const workbook = this.createExcel();
        const worksheet = workbook.addWorksheet('Заявки', {
            pageSetup:{
                orientation: 'landscape',
                fitToPage: false,
            }
        });
        worksheet.pageSetup.margins = {
            left: 0.4, right: 0.3,
            top: 0.4, bottom: 0.4,
            header: 0.0, footer: 0.0
        };
        let mainHeaders = [];
        for(let i = 0; i <  this.dataArray.length; i++){
            
            let data =  this.dataArray[i];
            this.indexArr = [];
            let name = { name: 'orgName', index: 0 };
            let counter = { name: 'questionQty', index: 1 };
            let empty1 = { name: 'empty', index: 2 };
            let name2 = { name: 'orgName', index: 3 };
            let counter2 = { name: 'questionQty', index: 4 };
            this.indexArr = [ name, counter, empty1, name2, counter2 ];
        
            let indexArr = this.indexArr;
            let rows = [];
            let captions = [];
            let columnsHeader = [];
            
            
            indexArr.forEach( el => {
                if( el.name === 'orgName'){
                    let obj =  {
                        key: el.name,
                        width: 44,
                    };
                    columnsHeader.push(obj);
                    captions.push('Назва');
                }else if(el.name === 'questionQty'){
                    let obj =  { 
                        key: el.name,
                        width: 8
                    };
                    columnsHeader.push(obj);
                    captions.push('Кiлькiсть');
                }else if(el.name === 'empty'){
                    let obj =  { 
                        key: el.name,
                        width: 8
                    };
                    columnsHeader.push(obj);
                    captions.push(' ');
                }
            });
            let columnText;
            let columnCounter;
            let captionName = 'Назва';
            let captionCounter = 'Кiлькiсть';
            let tds = [];
            let tdsCounter = [];
            if(i === 0){
                let cellInfoCaption0 = worksheet.getCell('A1');
                cellInfoCaption0.value = this.rep1_title;
                worksheet.mergeCells('A1:B1'); 
                mainHeaders.push(1);
                worksheet.getCell('A2').value = captionName;
                worksheet.getCell('B2').value = captionCounter;
                tds.push('A1');
                tds.push('A2');
                tds.push('B2');
                for(let i = 3; i < (data.length + 3); i++ ){
                    let value = data[i-3];
                    columnText = worksheet.getCell('A'+i);
                    columnCounter = worksheet.getCell('B'+i);
                    columnText.value = value[0];
                    columnCounter.value = value[1];
                    tds.push('A'+i);
                    tdsCounter.push('B'+i);
                }
            }else if(i === 1){
                let cellInfoCaption1 = worksheet.getCell('D1');  
                cellInfoCaption1.value = this.rep2_title;
                worksheet.mergeCells('D1:E1');
                tds.push('D1');
                worksheet.getCell('D2').value = captionName;
                worksheet.getCell('E2').value = captionCounter;
                tds.push('D1');
                tds.push('D2');
                tds.push('E2');                
                for(let i = 3; i < (data.length + 3); i++ ){
                    let value = data[i-3];
                    columnText = worksheet.getCell('D'+i);
                    columnCounter = worksheet.getCell('E'+i);
                    columnText.value = value[0];
                    columnCounter.value = value[1];
                    tds.push('D'+i);
                    tdsCounter.push('E'+i);                    
                }
            }else if(i === 2){
                this.rowTable1 = (this.dataArray[0].length+3 + 1);
                let cellInfoCaption2 = worksheet.getCell('A'+(this.rowTable1));
                cellInfoCaption2.value = this.rep3_title;
                worksheet.mergeCells('A'+(this.rowTable1)+':'+'B'+(this.rowTable1));
                tds.push('A'+(this.rowTable1));
                worksheet.getCell('A'+(this.rowTable1+1)).value = captionName;
                worksheet.getCell('B'+(this.rowTable1+1)).value = captionCounter;
                tds.push('A'+(this.rowTable1+1));
                tds.push('B'+(this.rowTable1+1));
                for(let i =  this.rowTable1 + 2; i < (data.length + this.rowTable1 + 2); i++ ){
                    let value = data[i-(2 + this.rowTable1)];
                    columnText = worksheet.getCell('A'+i);
                    columnCounter = worksheet.getCell('B'+i);
                    columnText.value = value[0];
                    columnCounter.value = value[1];
                    tds.push('A'+i);
                    tdsCounter.push('B'+i);                    
                }
            }else if(i === 3){
                this.rowTable2 = (this.dataArray[1].length+3 + 1);
                let counter = this.rowTable1 >= this.rowTable2 ? this.rowTable1 : this.rowTable2;
                mainHeaders.push(counter);
                let cellInfoCaption3 = worksheet.getCell('D'+(counter));
                cellInfoCaption3.value = this.rep4_title;
                worksheet.mergeCells('D'+(counter)+':'+'E'+(counter)); 
                tds.push('D'+counter);
                worksheet.getCell('D'+(counter+1)).value = captionName;
                worksheet.getCell('E'+(counter+1)).value = captionCounter;
                tds.push('D'+(counter+1));
                tds.push('E'+(counter+1));
                for(let i =  counter + 2; i < (data.length + counter + 2); i++ ){
                    let value = data[i-(2 + counter)];
                    columnText = worksheet.getCell('D'+i);
                    columnCounter = worksheet.getCell('E'+i);
                    columnText.value = value[0];
                    columnCounter.value = value[1];
                    tds.push('D'+i);
                    tdsCounter.push('E'+i);                   
                }
            }else if(i === 4){
                let counter =  this.rowTable2 + this.rowTable1 - 1;
                this.lastTableCounter =  counter;
                mainHeaders.push(counter);
                let cellInfoCaption3 = worksheet.getCell('A'+counter);
                cellInfoCaption3.value = this.rep4_title;
                worksheet.mergeCells('A'+counter+':'+'B'+counter);
                tds.push('A'+counter);
                worksheet.getCell('A'+(counter+1)).value = captionName;
                worksheet.getCell('B'+(counter+1)).value = captionCounter;
                tds.push('A'+(counter+1));
                tds.push('B'+(counter+1));
                for(let i =  counter + 2; i < (data.length + counter + 2); i++ ){
                    let value = data[i-(2 + counter)];
                    columnText = worksheet.getCell('A'+i);
                    columnCounter = worksheet.getCell('B'+i);
                    columnText.value = value[0];
                    columnCounter.value = value[1];
                    tds.push('A'+i);
                    tdsCounter.push('B'+i);                     
                }
            }
            worksheet.columns = columnsHeader;

            for(let  i = 0; i < tds.length; i++ ){
                let td = tds[i];
                worksheet.getCell(td).border = {
                    top: {style:'thin'},
                    left: {style:'thin'},
                    bottom: {style:'thin'},
                    right: {style:'thin'}
                };
                worksheet.getCell(td).alignment = { 
                    vertical: 'middle',
                    horizontal: 'left',
                    wrapText: true 
                };
                worksheet.getCell(td).font = {
                    name: 'Times New Roman',
                    family: 4, size: 10,
                    underline: false,
                    bold: false ,
                    italic: false
                };
            };
            for(let  i = 0; i < tdsCounter.length; i++ ){
                let td = tdsCounter[i];
                worksheet.getCell(td).border = {
                    top: {style:'thin'},
                    left: {style:'thin'},
                    bottom: {style:'thin'},
                    right: {style:'thin'}
                };
                worksheet.getCell(td).alignment = { 
                    vertical: 'middle',
                    horizontal: 'center',
                    wrapText: true 
                };
                worksheet.getCell(td).font = {
                    name: 'Times New Roman',
                    family: 4, size: 10,
                    underline: false,
                    bold: false ,
                    italic: false
                };
            };
            mainHeaders.forEach( number => {
                worksheet.getRow(number).height = 70;
                worksheet.getRow(number).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
                worksheet.getRow(number).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true  };
                worksheet.getRow(number+1).font = { name: 'Times New Roman', family: 4, size: 10, underline: false, bold: true , italic: false};
                worksheet.getRow(number+1).alignment = { vertical: 'middle', horizontal: 'center', wrapText: true  };
            });
        }
        this.helperFunctions.excel.save(workbook, 'Заявки', this.hidePagePreloader);
    }, 
    changeDateTimeValues: function(value){
        let trueDate ;
        if( value !== null){
            let date = new Date(value);
            let dd = date.getDate();
            let MM = date.getMonth();
            let yyyy = date.getFullYear();
            let HH = date.getUTCHours()
            let mm = date.getMinutes();
            MM += 1 ;
            if( (dd.toString()).length === 1){  dd = '0' + dd; }
            if( (MM.toString()).length === 1){ MM = '0' + MM ; }
            if( (HH.toString()).length === 1){  HH = '0' + HH; }
            if( (mm.toString()).length === 1){ mm = '0' + mm; }
            trueDate = dd+'.'+MM+'.' + yyyy;
        }else{
            trueDate = ' ';
        }
        return trueDate;
    }, 
    
};
}());
