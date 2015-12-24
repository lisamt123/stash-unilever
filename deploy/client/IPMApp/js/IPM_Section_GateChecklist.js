/*  
***********************************************************************************
*@Description:This script is used for Section Gate check list in IPM Gate Document page
*@Author: Cognizant
*@Created Date: 07/01/2015 
***********************************************************************************
*/ 

var jq = jQuery.noConflict();
/* Below code is to set the slider */
jq(document).ready(function() {
    initSliderSecGk();
});

/* Below code is to update the gate keeper list */
function updateSecGateKeeperList(id, ans, comment, cmnts) {
    callupdateSecGateKeeperList(id, ans, comment, cmnts);
}
function updateGKList(id, ans, comment, cmnts) {
    callupdateGKList(id, ans, comment, cmnts);
}

/* Below code is for the slider functionality */
function initSliderSecGk() {

    var itemsSecGK = [IPMAppSecGK.select, IPMAppSecGK.yes, IPMAppSecGK.partly, IPMAppSecGK.no, IPMAppSecGK.na];
    var s = jq(".sliderGk");
    var score;
    var PointerT = 100 / (itemsSecGK.length - 1);

jq(s).each(function() {
    var answerSecGK = jq(this).find("input[name=secGkans]").val(); 
	
    jq(this).slider({
        min: 1,
        max: itemsSecGK.length,
        animate: 'slow',
        value:itemsSecGK.indexOf(answerSecGK)+1,
        stop: function(event, ui) {
            var pointer = ui.value - 1;
            jq('#s' + itemsSecGK.indexOf(answerSecGK)+1).prop('checked', true);
            score = itemsSecGK[pointer];
        }
    });
    
    if (answerSecGK == IPMAppSecGK.yes) {           
            jq(this).find("label[for=s1]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
        } else if (answerSecGK == IPMAppSecGK.partly) {            
            jq(this).find("label[for=s2]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
        } else if (answerSecGK == IPMAppSecGK.no) {           
            jq(this).find("label[for=s3]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
        } else if (answerSecGK == IPMAppSecGK.na) {           
            jq(this).find("label[for=s4]").css({
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
jq(".legendSld label").on("click", function() {
    var lpos = jq(".legendSld label").offset().left;
    jq(this).parent().find('label').css({
        'color': '#555555',
        'font-weight': 'normal'
    });
    jq(this).css({
        'color': '#e98824',
        'font-weight': 'bold'
    });
});
    
jq("input[type=radio][id^='s']").hide();

}