/*************************************************************************************
 *@Description:This script used to create edit milestone page specific utility methods.
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
*************************************************************************************/
var jq = jQuery.noConflict();
function callMilestone() {
    jq.browser = {};
    jq("[id$=mlktp]").hide();
    jq('.dateInput .dateFormat').hide();
/* Below script works based on the condition. If condition is true it changes the height of the modal as specified in the condition. */
    if (jq('.popupContent').is(':visible')) {
        jq('#ipmModalEdit .modal-dialog', window.parent.document).height('200px');
    }
/* Below script works on focus event. If condition is true it changes the height of the modal as specified in the condition. */
    jq(document).on('focus', '.dateInputBox', function() {
        if (jq('.errorM3').is(':visible')) {
            window.parent.jq('#ipmModalEdit .modal-dialog').height('51%');
        } else {
            window.parent.jq('#ipmModalEdit .modal-dialog').height('42%');
        }
    });
	
/* Below script works on click event. When clicked on save button it changes the height of the modal as specified and it also calls the function 'updateTasksMileStones'. */
    jq(document).on('click', '.saveMilestone', function() {
        jq('#ipmModalEdit .modal-dialog', window.parent.document).height('200px');
        updateTasksMileStones();
    });
	
/* Below script works on focus event. It changes the height of the modal as specified in the condition. */
    jq(document).on('focus', '.mPhaseEdit', function() {
        jq('#ipmModalEdit .modal-dialog', window.parent.document).height('200px');
    });
	
/* Below script works on blur event. It changes the height of the modal as specified in the condition. */
    jq(document).on('blur', '.mPhaseEdit', function() {
        window.parent.jq('#ipmModalEdit .modal-dialog').height('200px');
    });
	
/* Below script works on blur event. If condition is true it changes the height of the modal as specified in the condition. */
    jq(document).on('blur', '.dateInputBox', function() {
        setTimeout(function() {
            if (!jq('.datePicker').is(':visible') && !jq('.mPhaseEdit').is(':focus')) {
                window.parent.jq('#ipmModalEdit .modal-dialog').height('200px');
            }
        }, 200);
    });
}
callMilestone();
/* Below function performs the page redirection to Task list page. */
function pageclose() {
    window.top.location.href = IPMApp.TasklistPageRef + '?id=' + IPMApp.projectId;
}