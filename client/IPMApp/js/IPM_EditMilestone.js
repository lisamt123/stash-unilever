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

/* Below script works on click event. When clicked on save button it changes the height of the modal as specified and it also calls the function 'updateTasksMileStones'. */
    jq(document).on('click', '.saveMilestone', function() {
        updateTasksMileStones();
    });
}

callMilestone();
/* Below function performs the page redirection to Task list page. */
function pageclose() {
    window.top.location.href = IPMApp.TasklistPageRef + '?id=' + IPMApp.projectId;
}