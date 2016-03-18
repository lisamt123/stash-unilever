/***************************************************************************************
 *@Description:This script used to create IPM_ApproverList page specific utility methods.
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
**************************************************************************************/
var jq = jQuery.noConflict();
/* Below script calls the clear search functionality when the user starts typing in the text field  */
jq(document).ready(function() {
    jq(".approverSearch").clearSearch();
});

/* Below script works on the on click event. If the checkbox is checked it adds highlights the closest row by adding a color */
jq('.ipmRadioButton .ipmTable td .rbutton').click(function() {
    jq('.ipmRadioButton .ipmTable').find("tr").removeClass("selected");
    if (jq(this).is(':checked')) {
        jq(this).closest("tr").addClass("selected");
    }
});

/* Below function performs the redirection to the BOSSCARD page */
function closepopup() {
    var approver = IPMApproverApp.bossurl;
    var id = IPMApproverApp.bosscardId;
    window.top.location.href = approver + '?id=' + id;
}