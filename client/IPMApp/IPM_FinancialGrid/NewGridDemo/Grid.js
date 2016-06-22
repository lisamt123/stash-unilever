  <script src="https://code.jquery.com/jquery-1.11.1.min.js"></script>
     <link href="{!URLFOR($Resource.IPMFianancialGrid, 'NewGridDemo/main.css')}" rel="stylesheet"/>
     <link href="{!URLFOR($Resource.IPMFianancialGrid, 'NewGridDemo/handsontable.full.min.css')}" rel="stylesheet"/>
     <script src="{!URLFOR($Resource.IPMFianancialGrid, 'NewGridDemo/handsontable.full.min.js')}"></script>
     <script src="{!URLFOR($Resource.IPMFianancialGrid, 'NewGridDemo/ruleJS/dist/full/ruleJS.all.full.js')}"></script>
     <script src="{!URLFOR($Resource.IPMFianancialGrid, 'NewGridDemo/handsontable.formula.js')}"></script>    
     <apex:stylesheet value="{!URLFOR($Resource.IPM_Resource, 'css/ipmModal1.css')}"/>
    <apex:stylesheet value="{!URLFOR($Resource.IPM_Resource, 'css/ipmHeader-new.css')}"/>
    <apex:stylesheet value="{!URLFOR($Resource.IPM_Resource, 'css/ipmfinancial.css')}"/>  
          $(document).ready(function() {
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
                            //console.log('Changes' + JSON.stringify(changes));
                            //console.log('GlobalChanges' + JSON.stringify(globalchanges));
                        }
                    }
                },
                afterValidate: function(isValid, value, row, prop, source) {
                    if (source == "paste") {
                        if (!isValid) {
                            alert(isValid);
                            if (errorflag == "false") {
                                alert('{!$Label.IPM_FinancialGrid_MSG3}');
                                errorflag = "true";
                                document.getElementById("btn13").click();
                            }
                        }
                    } else if (source == "edit") {
                        if (!isValid) {
                            alert('{!$Label.IPM_FinancialGrid_MSG3}');
                            document.getElementById("btn13").click();
                        }
                    }
                }
            });
      });  
        