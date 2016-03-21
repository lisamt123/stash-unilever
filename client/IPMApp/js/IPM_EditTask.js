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
	
/* Below script is related to date picker functionality. It opens the date picker when clicked on the element which has class 'date' */
    jq(function() {
        jq('.date').datepicker({
            format: dateFormat,
            autoclose: true,
            startDate: new Date(),
            startView: 0,
        });
    });
	

callEditTask();
/* Below function checks if the condition is true it redirects to Project setup page else it redirects to Task List page. */
function pageclose() {
    if (IPMApp.ProjectWizard == 'true') {
        window.top.location.href = IPMApp.PojectSetupUrl + '?Pid=' + IPMApp.projectId + '&TodoId=todos';
    } else {
        window.top.location.href = IPMApp.TasklistPageRef + '?id=' + IPMApp.projectId;
    }
}