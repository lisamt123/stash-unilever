/*************************************************************************************
 *@Description:This script used to create edit milestone page specific utility methods.
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
*************************************************************************************/
var jq = jQuery.noConflict();
/* Below code is related to the Edit Milestone modal */
function callMilestone() {
    jq.browser = {};
    jq("[id$=mlktp]").hide();
    jq('.dateInput .dateFormat').hide();
    if (jq('.popupContent').is(':visible')) {
        jq('#ipmModalEdit .modal-dialog', window.parent.document).height('200px');
    }
    jq(document).on('focus', '.dateInputBox', function() {
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
    jq(document).on('blur', '.dateInputBox', function() {
        setTimeout(function() {
            if (!jq('.datePicker').is(':visible') && !jq('.mPhaseEdit').is(':focus')) {
                window.parent.jq('#ipmModalEdit .modal-dialog').height('200px');
            }
        }, 200);
    });
}
callMilestone();
/* Below code is to close the page and redirect to the page */
function pageclose() {
    window.top.location.href = IPMApp.TasklistPageRef + '?id=' + IPMApp.projectId;
}