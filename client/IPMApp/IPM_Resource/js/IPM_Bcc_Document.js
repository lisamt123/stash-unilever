/*********************************************************************************************************
 *@Description:This script is used to build custom accordion specifically for IPM Add Manage Section Modal
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
*********************************************************************************************************/
jq(document).ready(function() {
/* Below script works on page load. First it hides all the tabs. Then it opens only the first tab. It also adds the + mark for the collapsed one's and adds - for the expanded one */
    var accordion = jq(".ipmAccordion");
    accordion.find(".ipmAcrdnExpand").not(':empty').slideDown("fast");
    accordion.find(".pHead .expico").removeClass("fa-plus");
    accordion.find(".pHead .expico").addClass("fa-minus");
    accordion.find(".pHead .expico-square").removeClass("fa-plus");
    accordion.find(".pHead .expico-square").addClass("fa-minus");
    
/* Below script works on click. On click a CSS class being added to the Modal dialog box */
    jq(document).on('click', '.updateBox', function(e) {
        jq('#ipmModal .modal-dialog').addClass('modalMarginTop');
    });
    
    hilightTaskScript();
});
/* Below function performs a click event. On click Confirm button it hides the modal */
function changeStatus() {
    jq(document).on('click', '.confirmcase', function() {
        jq("#ipmModalConfirmBcc").modal('hide');
    });
}

/* Below function contains the script which has the tooltip functionality. This function is called when the rerendering happens and the script will run again */
function hilightTaskScript(){
    jq(".info").tooltip({ position: { my: 'center top', at: 'center bottom+10' }});
    jq(".deleteChannel").tooltip({ position: { my: 'center top', at: 'center bottom+10' }});    
    jq(".arrow-left").tooltip({ position: { my: 'left top', at: 'center bottom+10' },tooltipClass:'ui-lefttip'}); 
    jq(".aTabs").find("input[type=checkbox]:checked").closest(".aTabs").addClass("active");
}
