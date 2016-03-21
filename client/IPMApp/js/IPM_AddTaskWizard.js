/****************************************************************************************
 *@Description:This script used to create IPM_Addtaskwizard page specific utility methods.
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
****************************************************************************************/
var jq = jQuery.noConflict();
jq("[id$=mlktp]").hide();
jq('.dateInput .dateFormat').hide();
jq('.gatedocModal').find('.errorMsg').addClass('custErr');
/* Below function performs the redirection to Project setup page */
function pageclose() {
    window.top.location.href = IPMAppComp.pageRefProSetupView + '?Pid=' + IPMAppComp.projectId + '&TodoId=todos';
}
/* Below function checks a condition. If the condition is true it will redirect to Gate Document section editor page. If condition is false it will redirect to Task List Page */
function pagecloseNewTask(){ 
	if (IPMAppComp.redirectToGateDocument == 'true') { 
			window.top.location.href = IPMAppComp.pageRefProjDocSec + '?Id=' + IPMAppComp.projectId + '&' + IPMAppComp.redirectToGateDocumentUrl + '=' + IPMAppComp.docSecList; 
	} else { 
			window.top.location.href = IPMAppComp.TasklistPageRef + '?id=' + IPMAppComp.projectId; 
	} 
}

