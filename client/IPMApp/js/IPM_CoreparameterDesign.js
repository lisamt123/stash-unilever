/*********************************************************************************
 *@Description:This script is used for project parameters page specific interaction
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
*********************************************************************************/
var jq = jQuery.noConflict();
/* Below script works on page load. If the conditions are true the correct carousel will be set. */
jq(document).ready(function() {
    if (IPMProAppCP.addtnlParameter == 'true') {
        jq('#myCarousel').carousel(4);
    }
    if (window.location.search.indexOf('coreId=coreparameters') > -1) {
        sliderCP('.slide-bar');
    }
});

/* Below function performs a page reload. It removes a attribute from the url when this function is called. */
function updateAdditional() {
	var pageURL = window.parent.location.href.replace('&BETOptions=1','');
	window.parent.location.href = pageURL;
}
/* Below function performs a page reload. It reloads the page when reset is clicked for first question. */
function resetqone() {
    window.location.href = IPMProAppCP.projectUrl + '?Pid=' + IPMProAppCP.projectName + '&question=qone&EditCoreParameter=edit';
}

/* Below function performs a page reload. It reloads the page when reset is clicked for second question. */
function resetqtwo() {
    window.location.href = IPMProAppCP.projectUrl + '?Pid=' + IPMProAppCP.projectName + '&question=qtwo&EditCoreParameter=edit';
}

/* Below function performs a page reload. It reloads the page when reset is clicked for third question. */
function resetqthree() {
    window.location.href = IPMProAppCP.projectUrl + '?Pid=' + IPMProAppCP.projectName + '&question=qthree&EditCoreParameter=edit';
}

/* Below function performs a page reload. If the condition is true it removes a attribute from the url. */
function checkCoreParam() {
    if (IPMProAppCP.coreParameter == 'true') {
        var pageURL = window.parent.location.href.replace('&BETOptions=1','');
		window.parent.location.href = pageURL;
    }
}

/* Below function displays the tooltip when clicked on save and continue button */
function checkTooltip(){
	jq(".info").tooltip({ position: { my: 'center top', at: 'center bottom+10' }});	
}

/* Below function performs moving of the carousel to the exact coreparameters question. Also for each question based on the number of options it calculates dynamic width for each option. */
function sliderCP(el) {
	jq('.selText').hide();
    var elm = jq('#myCarousel').find('.active').find(el);
    var str = elm.attr("id");
	if( jq('label').hasClass('fstchild active')){
		jq('.helpDesc').prepend('<div class="selText">'+IPMProAppCP.select+'</div>');
	}
    var s = str.match(/\d+$/)[0];
    var totalwidth = elm.width();
    var lblCount = elm.find('label').length;
    var lblWidth = totalwidth / lblCount;
    elm.find('label').css('width', lblWidth);
    setSlider(s);
}

/* Below function performs a page reload. */
function cpredirect() {
    window.parent.location.reload(true);
	jq(".info").tooltip({ position: { my: 'center top', at: 'center bottom+10' }});
}

/* Below function performs key code check. If key code is 95 it returns nothing else it returns true value. */
function invalidChar(key)
 {
   var keycode = (key.which) ? key.which : key.keyCode; 
   if(keycode==95){
	  return false;
   }else{
	  return true;
   }   
}