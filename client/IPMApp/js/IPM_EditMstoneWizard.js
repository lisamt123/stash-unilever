/*  
**********************************************************
*@Description:This script is used for Edit Milestone Modal
*@Author: Cognizant
*@Created Date: 28/05/2015 
**********************************************************
*/ 
var jq = jQuery.noConflict();
jq.browser = {};
/* Below code is related to the Edit Milestone modal in Project Setup wizard */
jq(function() {
	jq("[id$=mlktp]").hide();
	jq('.dateInput .dateFormat').hide();
	if (jq('.popupContent').is(':visible')) {
		jq('#ipmModalEdit .modal-dialog', window.parent.document).height('200px');
	}
	
	jq(document).on('focus', '.calendar', function() {
		if (jq('.errorM3').is(':visible')) {
			window.parent.jq('#ipmModalEdit .modal-dialog').height('51%');
		} else {
			window.parent.jq('#ipmModalEdit .modal-dialog').height('42%');
		}
	});
	jq(document).on('click', '.saveMilestone', function() {
		jq('#ipmModalEdit .modal-dialog', window.parent.document).height('200px');
		updateTasksMileStones();
	});
	jq(document).on('focus', '.mPhaseEdit', function() {
		jq('#ipmModalEdit .modal-dialog', window.parent.document).height('200px');
	});
	jq(document).on('blur', '.mPhaseEdit', function() {
		window.parent.jq('#ipmModalEdit .modal-dialog').height('200px');
	});
	jq(document).on('blur', '.calendar', function() {
		setTimeout(function() {
			if (!jq('.datePicker').is(':visible') && !jq('.mPhaseEdit').is(':focus')) {
				window.parent.jq('#ipmModalEdit .modal-dialog').height('200px');
			}
		}, 200);
	});
});
/* Below code is to close the page and redirect to the page */
function pageclose(){
	window.top.location.href=IPMAppWizard.ProjectSetupUrl+'?Pid='+IPMAppWizard.projectId+'&Milestoneid=milestones';
} 
