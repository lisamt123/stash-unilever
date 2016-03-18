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
	
/* Below script works on focus event. It changes the height of the modal as specified in the condition. */
    jq(document).on('focus', '.dateInputBox', function() {
        window.parent.jq('#ipmModalEdit .modal-dialog').height('51%');
    });
	
/* Below script works on focus event. It changes the height of the modal as specified in the condition. */
    jq(document).on('focus', '.tPhaseEdit, .tGateDocEdit, .tFuncEdit', function() {;
        window.parent.jq('#ipmModalEdit .modal-dialog').height('35%');
    });
	
/* Below script works on blur event. It changes the height of the modal as specified in the condition. */
    jq(document).on('blur', '.tPhaseEdit, .tGateDocEdit, .tFuncEdit', function() {
        window.parent.jq('#ipmModalEdit .modal-dialog').height('16%');
    });
	
/* Below script works on blur event. If condition is true it changes the height of the modal as specified in the condition. */
    jq(document).on('blur', '.dateInputBox', function() {
        setTimeout(function() {
            if (!jq('.datePicker').is(':visible') && !jq('.tGateDocEdit').is(':focus') && !jq('.tFuncEdit').is(':focus') && !jq('.tPhaseEdit').is(':focus')) {
                window.parent.jq('#ipmModalEdit .modal-dialog').height('16%');
            }
        }, 200);
    });
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