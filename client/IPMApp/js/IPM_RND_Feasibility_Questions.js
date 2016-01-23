/*  
****************************************************************************************
*@Description:This page is used for displaying R&D Feasibility Questions in Project Document Section Editor page and user can change the answer through the slider bar
*@Author: Cognizant
*@Created Date: 08/01/2015  
****************************************************************************************
*/

 var jq = jQuery.noConflict();
 jq(document).ready(function() {
     initSliderRnd();
 });
/* Below code is to update the RND list */
 function updateRndList(id, ans, cmnts) {
     callupdateRnDList(id, ans, cmnts);
 }
/* Below code is for the slider functionality */
 function initSliderRnd() {

     var itemsRnd = [IPMAppRNDfq.select, IPMAppRNDfq.yes, IPMAppRNDfq.no, IPMAppRNDfq.na];
     var s = jq(".sliderRND");
     var score;
     var PointerT = 100 / (itemsRnd.length - 1);
	 
jq(s).each(function() {

	var RnD = jq(this).find("input[name=RnD]").val();
     jq(this).slider({
         min: 1,
         max: itemsRnd.length,
         animate: 'slow',
		 value:itemsRnd.indexOf(RnD)+1,
         stop: function(event, ui) {
             var pointer = ui.value - 1;
             jq('#s' + itemsRnd.indexOf(RnD)+1).prop('checked', true);
             score = itemsRnd[pointer];
         },
		 slide: function( event, ui ) {
			jq(this).find(".legendSld label").css({color: "#555", fontWeight: "normal"}).eq(ui.value -1).css({color: "#E98824", fontWeight: "bold"});
			jq(this).find(".legendSld label").eq(ui.value -1).click();
		}
     });
	 
	 if (RnD == IPMAppRNDfq.yes) {             
             jq(this).find(".sld4 label[for=s1]").css({
                 'color': '#e98824',
                 'font-weight': 'bold'
             });
         } else if (RnD == IPMAppRNDfq.no) {            
             jq(this).find(".sld4 label[for=s2]").css({
                 'color': '#e98824',
                 'font-weight': 'bold'
             });
         } else if (RnD == IPMAppRNDfq.na) {             
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
});
jq(".legendSld label").on("click", function() {
	 var lpos = jq(".legendSld label").offset().left;
	 jq(this).parent().find('label').css({
		 'color': '#222222'
	 });
	 jq(this).css({
		 'color': '#e98824'
	 });
	 jq("toolTipMsg:before").css("left", lpos + "px");

	});
	jq("input[type=radio][id^='s']").hide();

 }