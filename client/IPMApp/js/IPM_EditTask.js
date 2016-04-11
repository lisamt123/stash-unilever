/**********************************************************************
 *@Description:This script used for edit to-do's related utility methods.
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
***********************************************************************/
var jq = jQuery.noConflict();
function callEditTask() {
    jq("[id$=mlktp]").hide();
    jq('.dateInput .dateFormat').hide();
    var dateFormat = "dd/mm/yyyy";
    jq.browser = {};
}
callEditTask();
/* Below function checks if the condition is true it redirects to Project setup page else it redirects to Task List page. */
function pageclose() {
    if (IPMApp.ProjectWizard === 'true') {
        window.top.location.href = IPMApp.PojectSetupUrl + '?Pid=' + IPMApp.projectId + '&TodoId=todos';
    } else {
        window.top.location.href = IPMApp.TasklistPageRef + '?id=' + IPMApp.projectId;
    }
}
jq(document).ready(function($) {
	var max = 225;
	jq('textarea.todoName').keypress(function(e) {
		if (e.which < 0x20) {
			return;
		}
		if (this.value.length === max) {
			e.preventDefault();
		} else if (this.value.length > max) {
			this.value = this.value.substring(0, max);
		}
	});
});