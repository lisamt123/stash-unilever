/**********************************************************************************************************
 *@Description:This Page gives a grid where users will be able to Copy and Paste the data from Excel sheet.
 *@Author: Cognizant
 *@Created Date: 02/06/2015 
**********************************************************************************************************/
var hot;
var cleanCalled = false;
var globalchanges = [];
var errorflag = "false";
var Validationflag = "false";
var Validationflag1 = "false";
var Validationflag2 = "false";
var Validationflag3 = "false";
var Validationflag4 = "false";
var Validationflag5 = "false";
var Validationflag6 = "false";
var Validationflag7 = "false";
var myWindow;
function openWin() {
    myWindow = window.open(IPMAppFin.UploadBusinessCase + "?parentId=" + IPMAppFin.projectId, "myWindow", "width=400, height=200, top = 300, left= 500");
}
var jq = jQuery.noConflict();
jq(document).ready(function() {
    var sustPeriod = IPMAppFin.Sustainability;
	var BI = IPMAppFin.BI;
    var personalData;
    var customValidator = function(value, callback) {};
    var container = document.getElementById('FinancialGrid');
    var copyData;
    var headerRenderer = function(instance, td, row, col, prop, value, cellProperties) {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        td.style.backgroundColor = '#dceefa';
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
    FinancialData = [
        ["INNOVATION YEAR", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
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
            } else if ([19, 20].indexOf(row) != -1 && [4, 6, 7, 9].indexOf(col) != -1) {
                cellProperties.readOnly = true;
                cellProperties.renderer = ReadOnlyRenderer;
            } else if ([21].indexOf(row) != -1 && [4, 6, 7, 8, 9].indexOf(col) != -1) {
                cellProperties.readOnly = true;
                cellProperties.renderer = ReadOnlyRenderer;
            } else if (sustPeriod == '3' && [8, 9, 13, 14].indexOf(col) != -1 && [19, 20].indexOf(row) == -1) {
                cellProperties.readOnly = true;
                cellProperties.renderer = ReadOnlyRenderer;
            } else if ([0, 1, 2, 3].indexOf(col) != -1) {
                cellProperties.readOnly = true;
                cellProperties.renderer = headerRenderer2;
            }
            if (row === 0) {
                cellProperties.renderer = headerRenderer;
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
                cellProperties.type = 'text';
            } else if (row === 31 && col === 1) {
                cellProperties.readOnly = false;
                cellProperties.type = 'text';
            }
            return cellProperties;
        },
        mergeCells: [{
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
        }],
        afterChange: function(changes, source, isValid) {
            var Y1GTO = 0,
                Y2GTO = 0,
                Y3GTO = 0,
                Y4GTO = 0,
                Y5GTO = 0;
            var Y1CGTO = 0,
                Y2CGTO = 0,
                Y3CGTO = 0,
                Y4CGTO = 0,
                Y5CGTO = 0;
            var Y1ITO = 0,
                Y2ITO = 0,
                Y3ITO = 0,
                Y4ITO = 0,
                Y5ITO = 0;
            var Y1CITO = 0,
                Y2CITO = 0,
                Y3CITO = 0,
                Y4CITO = 0,
                Y5CITO = 0;
            Validationflag = 'false';
			Validationflag1 = 'false';
			Validationflag2 = 'false';
			Validationflag3 = 'false';
			Validationflag4 = 'false';
			Validationflag5 = 'false';
			Validationflag6 = 'false';
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
					    if(BI != 'Small'){
							if ((globalchanges[j][0].toString() == '9' || globalchanges[j][0].toString() == '33') && (globalchanges[j][3] == '' || globalchanges[j][3].toString() == '0') && Validationflag == 'false') {
								alert(IPMAppFin.IPM_TurnOverCP);
								Validationflag = 'true';
							}
							if ((globalchanges[j][0].toString() == '11' || globalchanges[j][0].toString() == '35') && (globalchanges[j][3] == '' || globalchanges[j][3].toString() == '0') && Validationflag1 == 'false') {
								alert(IPMAppFin.IPM_GrossProfitCP);
								Validationflag1 = 'true';
							}
							if ((globalchanges[j][0].toString() == '12' || globalchanges[j][0].toString() == '36') && (globalchanges[j][3] == '' || globalchanges[j][3].toString() == '0') && Validationflag2 == 'false') {
								alert(IPMAppFin.IPM_AdvertisingCP);
								Validationflag2 = 'true';
							}
							if ((globalchanges[j][0].toString() == '13' || globalchanges[j][0].toString() == '37') && (globalchanges[j][3] == '' || globalchanges[j][3].toString() == '0') && Validationflag3 == 'false') {
								alert(IPMAppFin.IPM_PBOCP);
								Validationflag3 = 'true';
							}
							if ((globalchanges[j][0].toString() == '15' || globalchanges[j][0].toString() == '39') && (globalchanges[j][3] == '' || globalchanges[j][3].toString() == '0') && Validationflag4 == 'false') {
								alert(IPMAppFin.IPM_GMCP);
								Validationflag4 = 'true';
							}
							if ((globalchanges[j][0].toString() == '16' || globalchanges[j][0].toString() == '40') && (globalchanges[j][3] == '' || globalchanges[j][3].toString() == '0') && Validationflag5 == 'false') {
								alert(IPMAppFin.IPM_AandP);
								Validationflag5 = 'true';
							}
							if ((globalchanges[j][0].toString() == '17' || globalchanges[j][0].toString() == '41') && (globalchanges[j][3] == '' || globalchanges[j][3].toString() == '0') && Validationflag6 == 'false') {
								alert(IPMAppFin.IPM_PBOPCP);
								Validationflag6 = 'true';
                            }
							
							
					    }
						
						if ((globalchanges[j][0].toString() == '7'  && globalchanges[j][1] == 1) && (globalchanges[j][3] == '' || globalchanges[j][3].toString() == '0') && Validationflag7 == 'false') {
						   	    alert(IPMAppFin.IPM_CopyPastevolumevalid);
								Validationflag7 = 'true';
						}
                        if (globalchanges[j][0].toString() == '9' && globalchanges[j][1] == 5) {
                            Y1GTO = globalchanges[j][3];
                        }
                        if (globalchanges[j][0].toString() == '9' && globalchanges[j][1] == 6) {
                            Y2GTO = globalchanges[j][3];
                        }
                        if (globalchanges[j][0].toString() == '9' && globalchanges[j][1] == 7) {
                            Y3GTO = globalchanges[j][3];
                        }
                        if (globalchanges[j][0].toString() == '9' && globalchanges[j][1] == 8) {
                            Y4GTO = globalchanges[j][3];
                        }
                        if (globalchanges[j][0].toString() == '9' && globalchanges[j][1] == 9) {
                            Y5GTO = globalchanges[j][3];
                        }
                        if (globalchanges[j][0].toString() == '9' && globalchanges[j][1] == 10) {
                            Y1ITO = globalchanges[j][3];
                        }
                        if (globalchanges[j][0].toString() == '9' && globalchanges[j][1] == 11) {
                            Y2ITO = globalchanges[j][3];
                        }
                        if (globalchanges[j][0].toString() == '9' && globalchanges[j][1] == 12) {
                            Y3ITO = globalchanges[j][3];
                        }
                        if (globalchanges[j][0].toString() == '9' && globalchanges[j][1] == 13) {
                            Y4ITO = globalchanges[j][3];
                        }
                        if (globalchanges[j][0].toString() == '9' && globalchanges[j][1] == 14) {
                            Y5ITO = globalchanges[j][3];
                        }
                        if (globalchanges[j][0].toString() == '33' && globalchanges[j][1] == 5) {
                            Y1CGTO = globalchanges[j][3];
                        }
                        if (globalchanges[j][0].toString() == '33' && globalchanges[j][1] == 6) {
                            Y2CGTO = globalchanges[j][3];
                        }
                        if (globalchanges[j][0].toString() == '33' && globalchanges[j][1] == 7) {
                            Y3CGTO = globalchanges[j][3];
                        }
                        if (globalchanges[j][0].toString() == '33' && globalchanges[j][1] == 8) {
                            Y4CGTO = globalchanges[j][3];
                        }
                        if (globalchanges[j][0].toString() == '33' && globalchanges[j][1] == 9) {
                            Y5CGTO = globalchanges[j][3];
                        }
                        if (globalchanges[j][0].toString() == '33' && globalchanges[j][1] == 10) {
                            Y1CITO = globalchanges[j][3];
                        }
                        if (globalchanges[j][0].toString() == '33' && globalchanges[j][1] == 11) {
                            Y2CITO = globalchanges[j][3];
                        }
                        if (globalchanges[j][0].toString() == '33' && globalchanges[j][1] == 12) {
                            Y3CITO = globalchanges[j][3];
                        }
                        if (globalchanges[j][0].toString() == '33' && globalchanges[j][1] == 13) {
                            Y4CITO = globalchanges[j][3];
                        }
                        if (globalchanges[j][0].toString() == '33' && globalchanges[j][1] == 14) {
                            Y5CITO = globalchanges[j][3];
                        }
                    }
					
						GTO = Y1GTO + Y2GTO + Y3GTO + Y4GTO + Y5GTO;
						CGTO = Y1CGTO + Y2CGTO + Y3CGTO + Y4CGTO + Y5CGTO;
						ITO = Y1ITO + Y2ITO + Y3ITO + Y4ITO + Y5ITO;
						CITO = Y1CITO + Y2CITO + Y3CITO + Y4CITO + Y5CITO;
						if (ITO > GTO) {
							alert(IPMAppFin.IPM_ITOValidation);
							Validationflag = 'true';
						}
						if (CITO > CGTO) {
							alert(IPMAppFin.IPM_ITOCalValidation);
							Validationflag = 'true';
						}
					
					/* If we reduce the number of conditional operators it will contradict with the other sonar issue 'Merge this if statement with the nested one' */
                    if (Validationflag == 'false' && Validationflag1 == 'false' && Validationflag2 == 'false' 
					&& Validationflag3 == 'false' && Validationflag4 == 'false' && Validationflag5 == 'false' 
					&& Validationflag6 == 'false' && Validationflag7 == 'false') {
                        document.getElementById('DivButton').style.display = 'inline';
                    } else {
                        document.getElementById('DivButton').style.display = 'none';
                    }
                }
            }
        },
        afterValidate: function(isValid, value, row, prop, source) {
            if (source == "paste" && !isValid && errorflag == "false") {
				alert(IPMAppFin.FinancialGrid_MSG3);
				errorflag = "true";
				document.getElementById("Clrbtn").click();             
            } else if (source == "edit" && !isValid) {
                    alert(IPMAppFin.FinancialGrid_MSG3);
                    document.getElementById("Clrbtn").click();
            }
        }
    });
});
function chdropdown(valx) {
    if (globalchanges == '') {
        alert(IPMAppFin.FinancialGrid_MSG4);
        return;
    }
    Visualforce.remoting.Manager.invokeAction(IPMAppFin.GetFinancialYearRA,
        JSON.stringify(globalchanges), valx, IPMAppFin.span, IPMAppFin.projectType,
        function(result, event) {
            if (event.type === 'exception') {
                document.getElementById("responseErrors").innerHTML = event.message + ":" + event.where;
            } else {
                document.getElementById("responseErrors").innerHTML = event.message;
            }
        }, {
            escape: true
        });
    globalchanges = [];
    document.getElementById("Clrbtn").click();
    clearAll();
}
/* Below code is for the clear all functionality */
function clearAll() {
    cleanCalled = true;
    //hot.selection.selectAll();
    hot.selection.empty();
}