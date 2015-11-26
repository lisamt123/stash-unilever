/*********************************************************************************************************
 @Description:This script is used to build custom accordion specifically for IPM Add Manage Section Modal
 @Author: Cognizant
 @Created Date: 28/05/2015 
********************************************************************************************************/
/* Below script is for the accordion functionality */
var jq = jQuery.noConflict();
jq(document).ready(function() {
    jq('.subSecDiv:empty').remove();
    jq('.ipmAcrdnExpand span:empty').remove();
    jq('.ipmAcrdnExpand:empty').remove();
    jq("span.ipmAcrdnExpand").hide();
    jq("span.ipmAcrdnExpand:first, span.ipmAcrdnExpand:first span.ipmAcrdnExpand").show();
    jq("span.ipmAcrdnExpand span.ipmAcrdnExpand").show();
    jq(".ipmAccordian").find("span.acrCollapse.aHead").prepend("<span class='expico fa fa-plus'></span>");
    jq("span.ipmAcrdnExpand:first span.aHead").find("span.expico").removeClass("fa-plus");
    jq("span.aHead:first").find("span.expico").addClass("fa-minus");
    jq("span.ipmAcrdnExpand:first span.aHead").find("span.expico").addClass("fa-minus");
    jq(".expandTool").on("click", ".expandAll", function() {
        var accordion = jq(".ipmAccordian");
        accordion.find(".ipmAcrdnExpand ").slideDown("fast");
        accordion.find(".aHead .expico").removeClass("fa-plus");
        accordion.find(".aHead .expico").addClass("fa-minus");
    });
    jq(".expandTool").on("click", ".collapseAll", function() {
        var accordion = jq(".ipmAccordian");
        accordion.find(".ipmAcrdnExpand ").slideUp("fast");
        accordion.find(".aHead .expico").addClass("fa-plus");
        accordion.find(".aHead .expico").removeClass("fa-minus");
    });
    jq(".ipmAccordian").on("click", ".checkSub", function() {
        var $this = jq(this);
        var checkSub = $this.parents(".checkContainer").find("span input[type=checkbox]:checked").closest(".cHead").length;
        var checkNot = $this.parents(".checkContainer").find("span input[type=checkbox]").closest(".cHead").length;
        if (checkSub == 0) {
            $this.parents(".checkContainer").find(".subSecDiv .checkAll").prop("checked", false);
        }
        if (checkSub >= 1) {
            $this.parents(".checkContainer").find(".subSecDiv .checkAll").prop("checked", true);
        }
    });
    jq(".ipmAccordian").on("click", "span.expico", function() {
        var $this = jq(this);
        if ($this.closest("span.aHead").next("span.ipmAcrdnExpand").is(":visible")) {
            $this.closest("span.aHead").next("span.ipmAcrdnExpand").slideUp("fast");
            $this.closest("span.aHead").next("span.ipmAcrdnExpand").find("span.ipmAcrdnExpand").slideUp("fast");
            $this.removeClass("fa-minus");
            $this.addClass("fa-plus");
        } else {
            $this.closest("span.aHead").next("span.ipmAcrdnExpand").slideDown("fast");
            $this.closest("span.aHead").next("span.ipmAcrdnExpand").find("span.ipmAcrdnExpand").slideDown("fast");
            $this.removeClass("fa-plus");
            $this.addClass("fa-minus");
        }
    });
});
/* Below script is to redirect to the Gate Document page */
function goToParentPage() {
    window.top.location.href = IPMApp.GateDocumentPageRef + '?id=' + IPMApp.projectId + '&printDoc=' + IPMApp.printDoc;
}