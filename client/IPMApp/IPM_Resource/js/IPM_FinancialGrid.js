/**********************************************************************************************************
 *@Description:This Page gives a grid where users will be able to Copy and Paste the data from Excel sheet.
 *@Author: Cognizant
 *@Created Date: 02/06/2015 
**********************************************************************************************************/
var hot;
var cleanCalled = false;
var globalchanges = [];
var errorflag = "false";
var Validationflag7 = "false";
var volSwitch = false;
var cellsArray =    [{
            row: 0,
            col: 0,
            rowspan: 1,
            colspan: 15
        }, {
            row: 1,
            col: 0,
            rowspan: 1,
            colspan: 15
        }, {
            row: 2,
            col: 0,
            rowspan: 1,
            colspan: 5
        }, {
            row: 2,
            col: 5,
            rowspan: 1,
            colspan: 5
        }, {
            row: 2,
            col: 10,
            rowspan: 1,
            colspan: 5
        }, {
            row: 3,
            col: 0,
            rowspan: 1,
            colspan: 4
        }, {
            row: 14,
            col: 0,
            rowspan: 1,
            colspan: 15
        }, {
            row: 18,
            col: 0,
            rowspan: 1,
            colspan: 15
        }, {
            row: 19,
            col: 9,
            rowspan: 1,
            colspan: 6
        }, {
            row: 20,
            col: 9,
            rowspan: 1,
            colspan: 6
        }, {
            row: 21,
            col: 6,
            rowspan: 1,
            colspan: 9
        }, {
            row: 22,
            col: 0,
            rowspan: 2,
            colspan: 15
        }, {
            row: 23,
            col: 0,
            rowspan: 1,
            colspan: 15
        }, {
            row: 24,
            col: 0,
            rowspan: 1,
            colspan: 15
        }, {
            row: 25,
            col: 0,
            rowspan: 1,
            colspan: 15
        }, {
            row: 26,
            col: 5,
            rowspan: 1,
            colspan: 5
        }, {
            row: 26,
            col: 10,
            rowspan: 1,
            colspan: 5
        }, {
            row: 26,
            col: 0,
            rowspan: 1,
            colspan: 5
        }, {
            row: 27,
            col: 0,
            rowspan: 1,
            colspan: 4
        }, {
            row: 38,
            col: 0,
            rowspan: 1,
            colspan: 15
        }];

var headerRenderer = function(instance, td, row, col, prop, value, cellProperties) {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        td.style.backgroundColor = '#dceefa';       
        td.style.fontWeight = 'bold';       
        td.style.textAlign = 'center';
    };
    var headerRendererMain = function(instance, td, row, col, prop, value, cellProperties) {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        td.style.backgroundColor = '#80B726';       
        td.style.color = 'White';
        td.style.fontWeight = 'bold';       
        td.style.textAlign = 'center';
    };
    var headerRenderer2 = function(instance, td, row, col, prop, value, cellProperties) {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        td.style.backgroundColor = '#F6FAFE';
        td.style.fontWeight = 'bold';
        td.style.textAlign = 'center';
    };
    var ReadOnlyRenderer = function(instance, td, row, col, prop, value, cellProperties) {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        td.style.backgroundColor = '#FBFBF9';
    };
    var boldAndAlignRenderer = function(instance, td, row, col, prop, value, cellProperties) {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        td.style.fontWeight = 'bold';
        td.style.verticalAlign = 'middle';
        td.style.textAlign = 'left';
    };
    
    var FinanceValidationFunction = function(changes, source, isValid) {
                
            Validationflag7 = 'false';
            if (cleanCalled) {
                cleanCalled = false;
                return;
            } else {
                var changesJson = JSON.stringify(changes);
                if ((source !== "loadData")) {
                    for (var i = 0; i < changes.length; i++) {
                        for (var j = 0; j < globalchanges.length; j++) {
                            if (changes[i][0].toString() + ',' + changes[i][1].toString() === globalchanges[j][0].toString() + ',' + globalchanges[j][1].toString()) {
                                globalchanges.splice(j, 1);
                            }
                        }
                        globalchanges.push([changes[i][0], changes[i][1], changes[i][2], changes[i][3]]);
                    }
                    for (var j = 0; j < globalchanges.length; j++) {
                            
                            
                            
                        
                        if (globalchanges[j][0].toString() === '7'  && globalchanges[j][1] === 1 && Validationflag7 === 'false') {
                            if(globalchanges[j][3].toString().replace(/'/g, "\'").toLowerCase().trim() !== 'total tons' ){
                                volSwitch = true;
                            }
                            if(globalchanges[j][3].toString().replace(/'/g, "\'").toLowerCase().trim() !== 'total \'000 units' && volSwitch === true){
                                  volSwitch = true;
                            }else{
                                volSwitch = false;
                            }
                            if(volSwitch === true ){
                                alert(IPMAppFin.IPM_CopyPastevolumevalid);
                                Validationflag7 = 'true';
                            }
                        }
                        
                            
                    }
                    
                        
                    
                    /* If we reduce the number of conditional operators it will contradict with the other sonar issue 'Merge this if statement with the nested one' */
                    if ( Validationflag7 === 'false') {
                        document.getElementById('DivButton').style.display = 'inline';
                    } else {
                        document.getElementById('DivButton').style.display = 'none';
                    }
                }
            }
        };
    
    FinancialData = [
        ["INNOVATION YEAR - Click Here To Paste(Ctrl + V) Your Data", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "GROSS P&L", "", "", "", "", "INCREMENTAL P&L", "", "", ""],
        ["", "", "", "", "Y0", "Y1", "Y2", "Y3", "Y4", "Y5", "Y1", "Y2", "Y3", "Y4", "Y5"],
        ["Value Market Share ", " % ", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Value Growth ", " % ", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Volume Growth ", " % ", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Volume ", "", " + ", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["GSV ", " € '000 ", " + ", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Turnover ", " € '000 ", " + ", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Supply Chain Cost ", " € '000 ", " - ", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Gross Profit ", " € '000 ", " + ", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Advertising & Promotions ", " € '000 ", " - ", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Profit Before Overheads ", " € '000 ", " + ", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["GM (% of T/O)", "%", "+", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["A&P (% of T/O)", "%", "-", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["PBO (% of T/O)", "%", "+", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["NPV ", " € '000 ", "", "", "", "", "", "CAPEX ", "", "", "", "", "", "", ""],
        ["IRR", " % ", "", "", "", "", "", "BIC", "", "", "", "", "", "", ""],
        ["Payback ", " Years ", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["CALENDAR YEAR ", "", "", "", " ", "", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "GROSS P&L", "", "", "", "", "INCREMENTAL P&L", "", "", "", ""],
        ["", "", "", "", "Y0", "Y1", "Y2", "Y3", "Y4", "Y5", "Y1", "Y2", "Y3", "Y4", "Y5"],
        ["Value Market Share ", " % ", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Value Growth ", " % ", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Volume Growth ", " % ", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Volume ", "", " + ", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["GSV ", " € '000 ", " + ", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Turnover ", " € '000 ", " + ", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Supply Chain Cost ", " € '000 ", " - ", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Gross Profit ", " € '000 ", " + ", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Advertising & Promotions ", " € '000 ", " - ", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["Profit Before Overheads ", " € '000 ", " + ", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["", "  ", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["GM (% ofT/O)", "%", "+", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["A&P (% of T/O)", "%", "-", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["PBO (% of T/O)", "%", "+", "", "", "", "", "", "", "", "", "", "", "", ""]
    ];


var jq = jQuery.noConflict();
jq(document).ready(function() {
    var sustPeriod = IPMAppFin.Sustainability;
    var BI = IPMAppFin.BI;
    var personalData;
    var customValidator = function(value, callback) {};
    var container = document.getElementById('FinancialGrid');
    var copyData;
    
    hot = new Handsontable(container, {
        data: FinancialData,
        height: 600,
        fixedRowsTop: 1,
        colHeaders: false,
        rowHeaders: false,
        maxCols: 15,
        maxRows: 42,
        formulas: true,
        comments: true,
        colWidths: [195, 62, 35, 1, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62],
        cells: function(row, col, prop) {
            var cellProperties = {};
            if ([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 23, 24, 25, 26, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42].indexOf(row) !== -1 && col >= 0) {
                cellProperties.type = 'numeric';
                cellProperties.format = '£0,0.00';
            }
            if ([0, 1, 2, 3, 14, 18, 22, 23, 24, 25, 26, 27, 38].indexOf(row) !== -1 && col >= 0) {
                cellProperties.readOnly = true;
                cellProperties.renderer = ReadOnlyRenderer;
            } else if ([19, 20].indexOf(row) !== -1 && [4, 6, 7, 9].indexOf(col) !== -1) {
                cellProperties.readOnly = true;
                cellProperties.renderer = ReadOnlyRenderer;
            } else if ([21].indexOf(row) !== -1 && [4, 6, 7, 8, 9].indexOf(col) !== -1) {
                cellProperties.readOnly = true;
                cellProperties.renderer = ReadOnlyRenderer;
            } else if (sustPeriod === '3' && [8, 9, 13, 14].indexOf(col) !== -1 && [19, 20].indexOf(row) === -1) {
                cellProperties.readOnly = true;
                cellProperties.renderer = ReadOnlyRenderer;
            } else if ([0, 1, 2, 3].indexOf(col) !== -1) {
                cellProperties.readOnly = true;
                cellProperties.renderer = headerRenderer2;
            }
            if (row === 0) {
                cellProperties.renderer = headerRendererMain;
            } else if (row === 1) {
                cellProperties.renderer = headerRenderer2;
            } else if (row === 2) {
                cellProperties.renderer = headerRenderer2;
            } else if (row === 3) {
                cellProperties.renderer = headerRenderer2;
            } else if (row === 24) {
                cellProperties.renderer = headerRenderer;
            } else if (row === 25) {
                cellProperties.renderer = headerRenderer2;
            } else if (row === 26) {
                cellProperties.renderer = headerRenderer2;
            } else if (row === 27) {
                cellProperties.renderer = headerRenderer2;
            } else if (row === 19 && col === 7) {
                cellProperties.renderer = headerRenderer2;
            } else if (row === 20 && col === 7) {
                cellProperties.renderer = headerRenderer2;
            } else if (row === 27) {
                cellProperties.renderer = boldAndAlignRenderer;
            } else if (row === 7 && col === 1) {
                cellProperties.readOnly = false;
                cellProperties.type = 'autocomplete';
                
            } else if (row === 31 && col === 1) {
                cellProperties.readOnly = true;
                cellProperties.type = 'text';
            }
            return cellProperties;
        },
        mergeCells: cellsArray,
        afterChange: FinanceValidationFunction,
        
        
        afterValidate: function(isValid, value, row, prop, source) {
            if (source === "paste" && !isValid && errorflag === "false") {
                alert(IPMAppFin.FinancialGrid_MSG3);
                errorflag = "true";
                document.getElementById("Clrbtn").click();             
            } else if (source === "edit" && !isValid) {
                    alert(IPMAppFin.FinancialGrid_MSG3);
                    document.getElementById("Clrbtn").click();
            }
        }
    });
});
function chdropdown(valx) {
    jq(".cust-overlay").show();
    if (globalchanges === '') {
        alert(IPMAppFin.FinancialGrid_MSG4);
        return;
    }
    Visualforce.remoting.Manager.invokeAction(IPMAppFin.GetFinancialYearRA,
        JSON.stringify(globalchanges), valx, IPMAppFin.span, IPMAppFin.projectType,
        function(result, event) {
            
            if (event.type === 'exception') {
 
                jq(".cust-overlay").hide(); // hide the loader
                
                openModal(); // open a dialog box to show a pop up message that error has occured
                
                jq("#DivButton").css("display", "inline"); // show submit button
            } 
            else {
                
                jq(".cust-overlay").hide(); // hide the loader
				
				//code for non error scenario
				//refresh the page
                globalchanges = [];
                document.getElementById("Clrbtn").click();
                clearAll();
                
            }
        }, {
            escape: true
        });
        

        function openModal(){
            jq('#ipmModalException').modal({
                backdrop: 'static',
                keyboard: false
            });
            jq('#ipmModalException').modal('show');               
            jq('#ipmModalException .modal-dialog').width('600px');
            jq('#ipmModalException .modal-dialog').height('170px');               
            jq('#ipmModalException .modal-dialog').css({'margin-top':'10%','z-index':'999'});
        }
}
/* Below code is for the clear all functionality */
function clearAll() {
    cleanCalled = true;
    hot.selection.empty();
}

var unsaved = false;
var initialValue = true;
var strBrowser = "";

jq('table td').on('dblclick keyup', function(){
    checkValueChanged();
});

jq(this).bind('paste', function(event) {
    if (navigator.userAgent.indexOf("Chrome") > -1) {
        strBrowser = "CHROME";
    }
    if (navigator.userAgent.indexOf("Trident") > -1) {
        strBrowser = "IE";
    }
    
    var strText;
    if (strBrowser === "IE") {
        strText = window.clipboardData.getData('Text');
    } else if (strBrowser === "CHROME") {
        strText = (event.originalEvent || event).clipboardData.getData("text/plain");
    }
    
    if(initialValue !== false){
        oldInputTextAreaVal = jq('.handsontableInputHolder .handsontableInput').val();
    }
    
    newInputTextAreaVal = strText;
    initialValue = false;
    if( oldInputTextAreaVal !== newInputTextAreaVal ){
        unsaved = true;
    }else{
        unsaved = false;
    }
    
});

jq(".drpfield").change(function() {
    unsaved = true;
});
        
function checkValueChanged(){
    if(initialValue !== false){
        oldInputTextAreaVal = jq('.handsontableInputHolder .handsontableInput').val();
    }
    
    inputTextArea = jq('.handsontableInputHolder .handsontableInput');
    inputTextArea.bind('input propertychange', function() {
        newInputTextAreaVal = jq('.handsontableInputHolder .handsontableInput').val();
        initialValue = false;
        if( oldInputTextAreaVal !== newInputTextAreaVal ){
            unsaved = true;
        }else{
            unsaved = false;
        }
     });
}
function unloadPage() 
{ 
    if(unsaved){
        return IPMAppFin.wmessage;            
    }
} 

window.onbeforeunload = unloadPage;

/* Below code is to skip the unsaved changes*/
function skipValidation() {
    unsaved = false;
}