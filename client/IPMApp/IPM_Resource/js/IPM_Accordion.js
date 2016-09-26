/**********************************************************************
 *@Description:This script is used for reusable accordion functionality
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
**********************************************************************/
var jq = jQuery.noConflict();
jq(document).ready(function() {
    var ipmAccordion = jq(".ipmAccordion");
/* Below script calls a function accordion on click event */
    jq(document).on("click", ".ipmAccordion .pHead span.expico, .ipmAccordion .pHead span.expico-square", function() {
        accordion(this);
    });
    
/* Below script expands all the tabs in accordion when clicked on the Expand all button and replaces '+' with '-' sign */
    jq(document).on("click", ".expandTool .expandAll", function() {
        ipmAccordion.find(".ipmAcrdnExpand").not(':empty').slideDown("fast");
        ipmAccordion.find(".pHead .expico").removeClass("fa-plus");
        ipmAccordion.find(".pHead .expico").addClass("fa-minus");
        ipmAccordion.find(".pHead .expico-square").removeClass("fa-plus");
        ipmAccordion.find(".pHead .expico-square").addClass("fa-minus");
    });
    
/* Below script collapses all the tabs in accordion when clicked on the Collapse all button and replaces '-' with '+' sign */
    jq(document).on("click", ".expandTool .collapseAll", function() {
        ipmAccordion.find(".ipmAcrdnExpand ").slideUp("fast");
        ipmAccordion.find(".pHead .expico").addClass("fa-plus");
        ipmAccordion.find(".pHead .expico").removeClass("fa-minus");
        ipmAccordion.find(".pHead .expico-square").addClass("fa-plus");
        ipmAccordion.find(".pHead .expico-square").removeClass("fa-minus");
    });
    
/* Below script works on page load. First it hides all the tabs. Then it opens only the first tab. It also adds the + mark for the collapsed one's and adds - for the expanded one */
    jq(".ipmAcrdnExpand").hide();
    //(Changed by 260202)- For CollapseAll- On load
    jq(".ipmAcrdnExpand:first, .ipmAcrdnExpand:first .ipmAcrdnExpand").not(':empty').hide();
    ipmAccordion.find(".pHead span.expico").removeClass("fa-minus");
    ipmAccordion.find(".pHead span.expico").addClass("fa-plus");
    //(Comded by 260202)- For CollapseAll- On load
    ipmAccordion.find(".ipmAcrdnExpand:first .pHead span.expico").removeClass("fa-plus");
    ipmAccordion.find(".ipmAcrdnExpand:first .pHead span.expico").addClass("fa-minus");
    ipmAccordion.find(".pHead .recCount").removeClass("expanded");
    ipmAccordion.find(".pHead .recCount").addClass("collapsed");
    //Comded by (260202) - For CollapseAll- On load
});
/* Below function is called above upon click event where it expands the tab and replaces '+' with '-' or collapses a opened tab and replaces '-' with '+' */
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