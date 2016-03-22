/*  
**********************************************************
*@Description:This script is used for Edit Milestone Modal
*@Author: Cognizant
*@Created Date: 28/05/2015 
**********************************************************
*/ 
var jq = jQuery.noConflict();
jq.browser = {};
jq(function() {
	jq("[id$=mlktp]").hide();
	jq('.dateInput .dateFormat').hide();

/* Below script works on click event. When clicked on save button it changes the height of the modal as specified and it also calls the function 'updateTasksMileStones'. */
	jq(document).on('click', '.saveMilestone', function() {
		updateTasksMileStones();
	});

});	

/* Below function performs the page redirection to Project setup page. */
function pageclose(){
	window.top.location.href=IPMAppWizard.ProjectSetupUrl+'?Pid='+IPMAppWizard.projectId+'&Milestoneid=milestones';
} 
