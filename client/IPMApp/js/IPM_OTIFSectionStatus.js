/*  
***********************************************************************************
*@Description:This script is used for OTIF section status in IPM Gate Document page
*@Author: Cognizant
*@Created Date: 23/01/2015 
***********************************************************************************
*/  


var jq = jQuery.noConflict();
jq(document).ready(function() {
    initSliderOTIF();
});

/* Below code is to change the otif status */
function changeStatus(id, status) {
    callupdateOtifList(id, status);
}

/* Below code is for the OTIF slider functionality */
function initSliderOTIF() {

    var itemsGK = [IPMAppOTS.select, IPMAppOTS.green, IPMAppOTS.amber, IPMAppOTS.red, IPMAppOTS.na];
    var itemsGK3 = [IPMAppOTS.select, IPMAppOTS.green, IPMAppOTS.red, IPMAppOTS.na];

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
                }
            });
			
		if (answer == IPMAppOTS.green) {            
            jq(this).find(".sld5 label[for=s1]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });           
        } else if (answer == IPMAppOTS.amber) {            
            jq(this).find(".sld5 label[for=s2]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
        } else if (answer == IPMAppOTS.red) {            
            jq(this).find(".sld5 label[for=s3]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });            
        } else if (answer == IPMAppOTS.na) {           
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
                }
            });
			
			if (answer == IPMAppOTS.green) { 
            jq(this).find(".sld4 label[for=s1]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
        } else if (answer == IPMAppOTS.red) { 
            jq(this).find(".sld4 label[for=s2]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
        } else if (answer == IPMAppOTS.na) { 
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
	
jq(".legendSld label").on("click", function() {
	var lpos = jq(".legendSld label").offset().left;
	jq(this).closest(".legendSld").find("label").css({
		'color': '#222222'
	});
	jq(this).css({
		'color': '#e98824'
	});
	jq("toolTipMsg:before").css("left", lpos + "px");

});
jq("input[type=radio][id^='s']").hide();
 
}