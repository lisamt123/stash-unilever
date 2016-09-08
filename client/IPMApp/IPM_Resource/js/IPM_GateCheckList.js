/*  
***********************************************************************************
*@Description:This script is used for Section Gate check list in IPM Gate Document page
*@Author: Cognizant
*@Created Date: 07/01/2015 
***********************************************************************************
*/ 

var jq = jQuery.noConflict();
 /* Below script calls a function 'initSliderSecGk' on page load. */
jq(document).ready(function() {
    initSliderSecGk2();
});

/* Below function calls another function 'callupdateSecGateKeeperList' which updates the Section Gate keeper list */
function updateSecGateKeeperList(id, ans, comment, cmnts) {
    callupdateSecGateKeeperList(id, ans, comment, cmnts);
}

/* Below function calls another function 'callupdateGKList' which updates the Gate keeper list */
function updateGKList(id, ans, comment, cmnts) {
    callupdateGKList(id, ans, comment, cmnts);
}

 /* Below function contains the script for the slider functionality in Section Gate keeper list. It contains the complete functionality code when user clicks on the options the pointer ball moves to the clicked option. Also it highlights the selected option with a different color on page load. Also it saves the selected option when clicked on it. */
function initSliderSecGk2() {

    var itemsSecGK = [IPMAppSecGK.select, IPMAppSecGK.yes, IPMAppSecGK.partly, IPMAppSecGK.no, IPMAppSecGK.na];
    var s = jq(".sliderGk2");
    var score;
    var PointerT = 100 / (itemsSecGK.length - 1);

jq(s).each(function() {
    var answerSecGK = jq(this).find("input[name=secGkans2]").val(); 
	
    jq(this).slider({
        min: 1,
        max: itemsSecGK.length,
        animate: 'slow',
        value:itemsSecGK.indexOf(answerSecGK)+1,
        stop: function(event, ui) {
            var pointer = ui.value - 1;
            jq('#s' + itemsSecGK.indexOf(answerSecGK)+1).prop('checked', true);
            score = itemsSecGK[pointer];
        },
		slide: function( event, ui ) {
			jq(this).find(".legendSld.gateKeeperSlider label").css({color: "#555", fontWeight: "normal"}).eq(ui.value -1).css({color: "#E98824", fontWeight: "bold"});
			jq(this).find(".legendSld.gateKeeperSlider label").eq(ui.value -1).click();			
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

/* Below works on click event. It highlights the selected option with a different color and different font style.*/
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