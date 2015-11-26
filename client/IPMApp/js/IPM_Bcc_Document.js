/*********************************************************************************************************
 *@Description:This script is used to build custom accordion specifically for IPM Add Manage Section Modal
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
*********************************************************************************************************/
/* Below script is for the accordion and modal functionality */
jq(document).ready(function() {
    var accordion = jq(".ipmAccordion");
    accordion.find(".ipmAcrdnExpand").not(':empty').slideDown("fast");
    accordion.find(".pHead .expico").removeClass("fa-plus");
    accordion.find(".pHead .expico").addClass("fa-minus");
    accordion.find(".pHead .expico-square").removeClass("fa-plus");
    accordion.find(".pHead .expico-square").addClass("fa-minus");
    jq(document).on('click', '.updateBox', function(e) {
        jq('#ipmModal .modal-dialog').addClass('modalMarginTop');
    });
});
/* Below script is for hiding the modal */
function changeStatus() {
    jq(document).on('click', '.confirmcase', function() {
        jq("#ipmModalConfirmBcc").modal('hide');
    });
}