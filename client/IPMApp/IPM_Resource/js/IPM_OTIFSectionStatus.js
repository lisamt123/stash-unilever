/*  
***********************************************************************************
*@Description:This script is used for OTIF section status in IPM Gate Document page
*@Author: Cognizant
*@Created Date: 23/01/2015 
***********************************************************************************
*/  
var jq = jQuery.noConflict();
/* Below script calls a function 'initSliderOTIF' on page load. */
jq(document).ready(function() {
    initSliderOTIF();
    initSliderOTIFsecond();
});

/* Below function calls another function 'callupdateOtifList' which updates the otif list */
function changeStatus(id, status) {
    callupdateOtifList(id, status);
}

/* Below function contains the script for the slider functionality in first Otif list. It contains the complete functionality code when user clicks on the options the pointer ball moves to the clicked option. Also it highlights the selected option with a different color on page load. Also it saves the selected option when clicked on it. */
function initSliderOTIF() {
    var itemsGK3 = [IPMAppOTS.select, IPMAppOTS.green, IPMAppOTS.red, IPMAppOTS.na];
    var s = jq(".sliderOTIF");
    var score;
    var PointerS = 100 / (itemsGK3.length - 1);
    jq(s).each(function() {
    var answer = jq(this).find("input[name=answer]").val();
            jq(this).slider({
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
                    if(jq(this).find(".legendSld input").attr('new') === 'ReadonlySlider')
                    {
                        event.preventDefault();
                    }else{ 
                        jq(this).find(".legendSld label").css({color: "#555", fontWeight: "normal"}).eq(ui.value -1).css({color: "#E98824", fontWeight: "bold"});
                        jq(this).find(".legendSld label").eq(ui.value -1).click();
                    }
                }
            });
            if (answer === IPMAppOTS.green) { 
            jq(this).find("label[for=s1]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
        } else if (answer === IPMAppOTS.red) { 
            jq(this).find("label[for=s2]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
        } else if (answer === IPMAppOTS.na) { 
            jq(this).find("label[for=s3]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
        } else { 
            jq(this).find("label[for=s0]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
        }
    });
    labelClick();
}
function initSliderOTIFsecond() {
    var itemsGK = [IPMAppOTS.select, IPMAppOTS.green, IPMAppOTS.amber, IPMAppOTS.red, IPMAppOTS.na];
    var s2 = jq(".sliderOTIF5");
    var score;
    var PointerT = 100 / (itemsGK.length - 1);
    /* Below function contains the script for the slider functionality in second Otif list. It contains the complete functionality code when user clicks on the options the pointer ball moves to the clicked option. Also it highlights the selected option with a different color on page load. Also it saves the selected option when clicked on it. */
    jq(s2).each(function() {    
        var answer = jq(this).find("input[name=answer]").val();
            jq(this).slider({
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
                     if(jq(this).find(".legendSld input").attr('new') === 'ReadonlySlider')
                    {
                        event.preventDefault();
                    }else{ 
                        jq(this).find(".legendSld label").css({color: "#555", fontWeight: "normal"}).eq(ui.value -1).css({color: "#E98824", fontWeight: "bold"});
                        jq(this).find(".legendSld label").eq(ui.value -1).click();
                    }
                }
            });
        if (answer === IPMAppOTS.green) {            
            jq(this).find(".sld5 label[for=s1]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });           
        } else if (answer === IPMAppOTS.amber) {            
            jq(this).find(".sld5 label[for=s2]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
        } else if (answer === IPMAppOTS.red) {            
            jq(this).find(".sld5 label[for=s3]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });            
        } else if (answer === IPMAppOTS.na) {           
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
    });
    labelClick();
}

function labelClick(){
    /* Below works on click event. It highlights the selected option with a different color and different font style. Also it moves the help text pointer to selected option. */    
    jq(".legendSld label").on("click", function() {
        if(jq(this).prev().attr('new') === 'ReadonlySlider')
        {
            event.preventDefault();
        }else{
            var lpos = jq(".legendSld label").offset().left;
            jq(this).parent().find('label').css({
                'color': '#555',
                'font-weight': 'normal'
            });
            jq(this).css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
            jq("toolTipMsg:before").css("left", lpos + "px");
        }
    });
    jq("input[type=radio][id^='s']").hide();
}