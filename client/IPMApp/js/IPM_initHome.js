/*  
*************************************************************************
*@Description:This script is used for home page specific interaction
*@Author: Cognizant
*@Created Date: 28/05/2015 
*************************************************************************
*/
var jq = jQuery.noConflict();
/* Below code is for the accordion functionality */
function accrdn(){
	var ipmAccordion = jq(".ipmAccordion");
   	jq(".ipmAcrdnExpand").hide();
	    jq(".ipmAcrdnExpand:first, .ipmAcrdnExpand:first .ipmAcrdnExpand").not(':empty').show();    
		
		ipmAccordion.find(".pHead span.expico").removeClass("fa-minus");              
		ipmAccordion.find(".pHead span.expico").addClass("fa-plus");
		ipmAccordion.find(".pHead:first span.expico").removeClass("fa-plus");
		ipmAccordion.find(".pHead:first span.expico").addClass("fa-minus");
		ipmAccordion.find(".ipmAcrdnExpand:first .pHead span.expico").removeClass("fa-plus");
		ipmAccordion.find(".ipmAcrdnExpand:first .pHead span.expico").addClass("fa-minus");
		
		ipmAccordion.find(".pHead .recCount").removeClass("expanded");
		ipmAccordion.find(".pHead .recCount").addClass("collapsed");
		ipmAccordion.find(".pHead:first .recCount").removeClass("collapsed");
		ipmAccordion.find(".pHead:first .recCount").addClass("expanded");
		}
		
function myAssignedTasks(taskId, isChecked) {
	if(isChecked != true) {     
			jq('.taskCheck input[type=checkbox]#'+taskId).closest(".recordBox").removeClass("selected");
		}else {
			jq('.taskCheck input[type=checkbox]#'+taskId).closest(".recordBox").addClass("selected");
		}
		markComplete(taskId, isChecked);
}

/* Below code is to hide or show the alerts container */		
jq(document).ready(function(){
	accrdn();
	jq(document).on('click', '.alertAccordian', function() {
		var $this = jq(this);
		 if (jq('.alertContent').is(':visible')) {
			 $this.removeClass('fa-minus');
			 $this.addClass('fa-plus');
			 jq('.alertContent').hide();
			 jq('.alerttext').show();
		 } else {
			 jq('.alerttext').hide();
			 $this.addClass('fa-minus');
			 $this.removeClass('fa-plus');
			 jq('.alertContent').show();
		 }
	 });
	jq(document).on('click', '.actionBox', function() {
		var url = jq(this).attr('value');
		window.top.location.href = url;
	});

/* Below code is for slider more link functionality */
	jq(document).on('click', '.moreLink', function() {
		var moreLink = jq(this);
		moreLink.parent().prev().animate({
			height: '100%'
		}, 500);
		moreLink.hide();
		moreLink.next('a.lessLink').show();
	});

/* Below code is for slider less link functionality */
	jq(document).on('click', '.lessLink', function() {
		var lessLink = jq(this);
		lessLink.parent().prev().animate({
			height: '120px'
		}, 500);
		lessLink.hide();
		lessLink.prev('.moreLink').show();
	});
	
/* Below code is for key press on more or less link  */
	jq(document).on('keydown', '.actionBox,.alertAccordian,.moreLink,.lessLink,.expico', function() { 
		var keyCode = (event.keyCode ? event.keyCode : event.which); 
		if (keyCode == 13) { 
		jq(this).trigger('click'); 
		} 
	});

});
