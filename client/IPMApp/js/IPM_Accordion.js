/**********************************************************************
 *@Description:This script is used for reusable accordion functionality
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
**********************************************************************/
/* Below script is for the accordion behaviour on page load */
var jq = jQuery.noConflict();
jq(document).ready(function() {
    var ipmAccordion = jq(".ipmAccordion");
    jq(document).on("click", ".ipmAccordion .pHead span.expico, .ipmAccordion .pHead span.expico-square", function() {
        accordion(this);
    });
    jq(document).on("click", ".expandTool .expandAll", function() {
        ipmAccordion.find(".ipmAcrdnExpand").not(':empty').slideDown("fast");
        ipmAccordion.find(".pHead .expico").removeClass("fa-plus");
        ipmAccordion.find(".pHead .expico").addClass("fa-minus");
        ipmAccordion.find(".pHead .expico-square").removeClass("fa-plus");
        ipmAccordion.find(".pHead .expico-square").addClass("fa-minus");
    });
    jq(document).on("click", ".expandTool .collapseAll", function() {
        ipmAccordion.find(".ipmAcrdnExpand ").slideUp("fast");
        ipmAccordion.find(".pHead .expico").addClass("fa-plus");
        ipmAccordion.find(".pHead .expico").removeClass("fa-minus");
        ipmAccordion.find(".pHead .expico-square").addClass("fa-plus");
        ipmAccordion.find(".pHead .expico-square").removeClass("fa-minus");
    });
    jq(".ipmAcrdnExpand").hide();
    jq(".ipmAcrdnExpand:first, .ipmAcrdnExpand:first .ipmAcrdnExpand").not(':empty').show();
    ipmAccordion.find(".pHead span.expico").removeClass("fa-minus");
    ipmAccordion.find(".pHead span.expico").addClass("fa-plus");
    ipmAccordion.find(".pHead:first span.expico").removeClass("fa-plus");
    ipmAccordion.find(".pHead:first span.expico").addClass("fa-minus");
    ipmAccordion.find(".ipmAcrdnExpand:first .pHead span.expico").removeClass("fa-plus");
    ipmAccordion.find(".ipmAcrdnExpand:first .pHead span.expico").addClass("fa-minus");
    ipmAccordion.find(".pHead .recCount").removeClass("expanded");
    ipmAccordion.find(".pHead .recCount").addClass("collapsed");
    ipmAccordion.find(".pHead:first .recCount").removeClass("collapsed");
    ipmAccordion.find(".pHead:first .recCount").addClass("expanded");
});
/* Below function is for collapse and expand functionality of accordion */
function accordion(elem) {
    if (jq(elem).closest(".pHead").next(".ipmAcrdnExpand").is(":visible")) {
        jq(elem).closest(".pHead").next(".ipmAcrdnExpand").slideUp("fast");
        jq(elem).removeClass("fa-minus");
        jq(elem).addClass("fa-plus");
        jq(elem).next('.recCount').removeClass('expanded');
        jq(elem).next('.recCount').addClass('collapsed');
    } else {
        jq(elem).closest(".pHead").next(".ipmAcrdnExpand").slideDown("fast");
        jq(elem).removeClass("fa-plus");
        jq(elem).addClass("fa-minus");
        jq(elem).next('.recCount').removeClass('collapsed');
        jq(elem).next('.recCount').addClass('expanded');
    }
}