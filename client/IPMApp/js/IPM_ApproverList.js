/***************************************************************************************
 *@Description:This script used to create IPM_ApproverList page specific utility methods.
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
**************************************************************************************/
// Below script is used add clear search functionality and add css class to radio button
var jq = jQuery.noConflict();
jq(document).ready(function() {
    jq(".approverSearch").clearSearch();
});
jq('.ipmRadioButton .ipmTable td .rbutton').click(function() {
    jq('.ipmRadioButton .ipmTable').find("tr").removeClass("selected");
    if (jq(this).is(':checked')) {
        jq(this).closest("tr").addClass("selected");
    }
});
function closepopup() {
    var approver = IPMApproverApp.bossurl;
    var id = IPMApproverApp.bosscardId;
    window.top.location.href = approver + '?id=' + id;
}