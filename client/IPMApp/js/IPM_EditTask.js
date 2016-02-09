/**********************************************************************
 *@Description:This script used for edit to-do's related utility methods.
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
***********************************************************************/
var jq = jQuery.noConflict();
/* Below code is related to date picker functionality */
function callEditTask() {
    jq("[id$=mlktp]").hide();
    jq('.dateInput .dateFormat').hide();
    var dateFormat = "dd/mm/yyyy";
    jq.browser = {};
    jq(function() {
        jq('.date').datepicker({
            format: dateFormat,
            autoclose: true,
            startDate: new Date(),
            startView: 0,
        });
    });
    jq(document).on('focus', '.dateInputBox', function() {
        window.parent.jq('#ipmModalEdit .modal-dialog').height('51%');
    });
    jq(document).on('focus', '.tPhaseEdit, .tGateDocEdit, .tFuncEdit', function() {;
        window.parent.jq('#ipmModalEdit .modal-dialog').height('35%');
    });
    jq(document).on('blur', '.tPhaseEdit, .tGateDocEdit, .tFuncEdit', function() {
        window.parent.jq('#ipmModalEdit .modal-dialog').height('16%');
    });
    jq(document).on('blur', '.dateInputBox', function() {
        setTimeout(function() {
            if (!jq('.datePicker').is(':visible') && !jq('.tGateDocEdit').is(':focus') && !jq('.tFuncEdit').is(':focus') && !jq('.tPhaseEdit').is(':focus')) {
                window.parent.jq('#ipmModalEdit .modal-dialog').height('16%');
            }
        }, 200);
    });
}
callEditTask();
/* Below code is to close the modal and redirect to the respective page */
function pageclose() {
    if (IPMApp.ProjectWizard == 'true') {
        window.top.location.href = IPMApp.PojectSetupUrl + '?Pid=' + IPMApp.projectId + '&TodoId=todos';
    } else {
        window.top.location.href = IPMApp.TasklistPageRef + '?id=' + IPMApp.projectId;
    }
}