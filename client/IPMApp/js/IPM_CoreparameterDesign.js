/*********************************************************************************
 *@Description:This script is used for project parameters page specific interaction
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
*********************************************************************************/
var jq = jQuery.noConflict();
/* Below code is for the additional parameter modal */
jq(document).ready(function() {
    if (IPMProAppCP.addtnlParameter == 'true') {
        jq('#myCarousel').carousel(4);
    }
    if (window.location.search.indexOf('coreId=coreparameters') > -1) {
        sliderCP('.slide-bar');
    }
});
function updateAdditional() {
	var pageURL = window.parent.location.href.replace('&BETOptions=1','');
	window.parent.location.href = pageURL;
}
/* Below code is for the reset functionality in edit coreparameter */
function resetqone() {
    window.location.href = IPMProAppCP.projectUrl + '?Pid=' + IPMProAppCP.projectName + '&question=qone&EditCoreParameter=edit';
}
function resetqtwo() {
    window.location.href = IPMProAppCP.projectUrl + '?Pid=' + IPMProAppCP.projectName + '&question=qtwo&EditCoreParameter=edit';
}
function resetqthree() {
    window.location.href = IPMProAppCP.projectUrl + '?Pid=' + IPMProAppCP.projectName + '&question=qthree&EditCoreParameter=edit';
}
/* Below code is for the edit coreparameter modal */
function checkCoreParam() {
    if (IPMProAppCP.coreParameter == 'true') {
        var pageURL = window.parent.location.href.replace('&BETOptions=1','');
		window.parent.location.href = pageURL;
    }
}
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
function cpredirect() {
    window.parent.location.reload(true);
}