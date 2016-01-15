/****************************************************************************************
 *@Description:This script used to create IPM_Addtaskwizard page specific utility methods.
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
****************************************************************************************/
var jq = jQuery.noConflict();
jq("[id$=mlktp]").hide();
jq('.dateInput .dateFormat').hide();
jq('.gatedocModal').find('.errorMsg').addClass('custErr');
/* Below script will redirect page to Project setup page */
function pageclose() {
    window.top.location.href = IPMAppComp.pageRefProSetupView + '?Pid=' + IPMAppComp.projectId + '&TodoId=todos';
}
/* Below script will refresh the current opened page */
function pagecloseNewTask(){ 
	if (IPMAppComp.redirectToGateDocument == 'true') { 
			window.top.location.href = IPMAppComp.pageRefProjDocSec + '?Id=' + IPMAppComp.projectId + '&' + IPMAppComp.redirectToGateDocumentUrl + '=' + IPMAppComp.docSecList; 
	} else { 
			window.top.location.href = IPMAppComp.TasklistPageRef + '?id=' + IPMAppComp.projectId; 
	} 
}

