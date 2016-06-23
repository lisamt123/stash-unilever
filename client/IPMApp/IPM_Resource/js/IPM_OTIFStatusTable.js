/*  
***********************************************************************************
*@Description:This component is used for displaying OTIF Questions in Project 
Document Section Editor page and user can change the answer through 
the slider bar
*@Author: Cognizant
*@Created Date: 03/01/2015
***********************************************************************************
*/  
var jq = jQuery.noConflict();
/* Below script calls a function 'initSliderOTIF' on page load. */
jq(document).ready(function() {
    initSliderOTIF();
});

/* Below function calls another function 'callupdateOtifList' which updates the otif list */
function changeStatus(id, status) {
    callupdateOtifList(id, status);
}

/* Below function contains the script for the slider functionality in first Otif list. It contains the complete functionality code when user clicks on the options the pointer ball moves to the clicked option. Also it highlights the selected option with a different color on page load. Also it saves the selected option when clicked on it. */
function initSliderOTIF() {
    var itemsGK = [IPMAppOTT.select, IPMAppOTT.green, IPMAppOTT.amber, IPMAppOTT.red, IPMAppOTT.na];
    var itemsGK3 = [IPMAppOTT.select, IPMAppOTT.green, IPMAppOTT.red, IPMAppOTT.na];
    var s = jq(".sliderOTIF");
    var score;
    var PointerT = 100 / (itemsGK.length - 1);
    var PointerS = 100 / (itemsGK3.length - 1);
    jq(s).each(function() {
    var answer = jq(this).find("input[name=answer]").val();
        if (jq('.sliderOTIF > div').has(".sld5")) {
            jq(".sld5").closest(s).slider({
                min: 1,
                max: itemsGK.length,
                animate: 'slow',
                value:itemsGK.indexOf(answer)+1,
                stop: function(event, ui) {
                    var pointer = ui.value - 1;
                    jq('#s' + itemsGK.indexOf(answer)+1).prop('checked', true);
                    score = itemsGK[pointer];
                },
                slide: function( event, ui ) {
                    jq('label', ".legendSldOtifTable").css({color: "#555", fontWeight: "normal"}).eq(ui.value -1).css({color: "#E98824", fontWeight: "bold"});
                    jq('label', ".legendSldOtifTable").eq(ui.value -1).click();
                }
            });
            if (answer === IPMAppOTT.green) {            
                jq(this).find(".sld5 label[for=s1]").css({
                    'color': '#e98824',
                    'font-weight': 'bold'
                });
            } else if (answer === IPMAppOTT.amber) {
                jq(this).find(".sld5 label[for=s2]").css({
                    'color': '#e98824',
                    'font-weight': 'bold'
                });
            } else if (answer === IPMAppOTT.red) {
                jq(this).find(".sld5 label[for=s3]").css({
                    'color': '#e98824',
                    'font-weight': 'bold'
                });          
            } else if (answer === IPMAppOTT.na) {
                jq(this).find(".sld5 label[for=s4]").css({
                    'color': '#e98824',
                    'font-weight': 'bold'
                });         
            } else {
                jq(this).find(".sld5 label[for=s0]").css({
                    'color': '#e98824',
                    'font-weight': 'bold'
                });        
            }
        }
        if (jq('.sliderOTIF > div').has(".sld4")) {
            jq(".sld4").closest(s).slider({
                min: 1,
                max: itemsGK3.length,
                animate: 'slow',
                value:itemsGK3.indexOf(answer)+1,
                stop: function(event, ui) {
                    var pointer = ui.value - 1;
                    jq('#s' + itemsGK3.indexOf(answer)+1).prop('checked', true);
                    score = itemsGK3[pointer];
                },
                slide: function( event, ui ) {
                    jq(this).find(".legendSldOtifTable label").css({color: "#555", fontWeight: "normal"}).eq(ui.value -1).css({color: "#E98824", fontWeight: "bold"});
                    jq(this).find(".legendSldOtifTable label").eq(ui.value -1).click();
                }
            });
        if (answer === IPMAppOTT.green) { 
            jq(this).find(".sld4 label[for=s1]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
        } else if (answer === IPMAppOTT.red) {        
            jq(this).find(".sld4 label[for=s2]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
        } else if (answer === IPMAppOTT.na) {         
            jq(this).find(".sld4 label[for=s3]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
        } else {          
            jq(this).find(".sld4 label[for=s0]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
        }
        }
    });
    labelClick();
}

function labelClick(){
    /* Below works on click event. It highlights the selected option with a different color and different font style. Also it moves the help text pointer to selected option. */    
    jq(".legendSldOtifTable label").on("click", function() {
        var lpos = jq(".legendSldOtifTable label").offset().left;
        jq(this).closest(".legendSldOtifTable").find("label").css({
            'color': '#222222'
        });
        jq(this).css({
            'color': '#e98824'
        });
        jq("toolTipMsg:before").css("left", lpos + "px");
    });
    jq("input[type=radio][id^='s']").hide();
}