/*********************************************************************************************************
 @Description:This script is used to build custom accordion specifically for IPM Add Manage Section Modal
 @Author: Cognizant
 @Created Date: 28/05/2015 
********************************************************************************************************/
var jq = jQuery.noConflict();
jq(document).ready(function() {

/* Below script works on page load. First it hides all the tabs. Then it opens only the first tab. It also adds the + mark for the collapsed one's and adds - for the expanded one */
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
    
/* Below script expands all the tabs in accordion when clicked on the Expand all button and replaces '+' with '-' sign */
    jq(".expandTool").on("click", ".expandAll", function() {
        var accordion = jq(".ipmAccordian");
        accordion.find(".ipmAcrdnExpand ").slideDown("fast");
        accordion.find(".aHead .expico").removeClass("fa-plus");
        accordion.find(".aHead .expico").addClass("fa-minus");
    });
  
/* Below script collapses all the tabs in accordion when clicked on the Collapse all button and replaces '-' with '+' sign */
    jq(".expandTool").on("click", ".collapseAll", function() {
        var accordion = jq(".ipmAccordian");
        accordion.find(".ipmAcrdnExpand ").slideUp("fast");
        accordion.find(".aHead .expico").addClass("fa-plus");
        accordion.find(".aHead .expico").removeClass("fa-minus");
    });
  
/* Below script checks the child checkboxes. If all the child checkboxes are checked parent checkbox i.e 'All' checkbox will be checked else it will be not be checked */
    jq(".ipmAccordian").on("click", ".checkSub", function() {
        var $this = jq(this);
        var checkSub = $this.parents(".checkContainer").find("span input[type=checkbox]:checked").closest(".cHead").length;
        var checkNot = $this.parents(".checkContainer").find("span input[type=checkbox]").closest(".cHead").length;
        if (checkSub === 0) {
            $this.parents(".checkContainer").find(".subSecDiv .checkAll").prop("checked", false);
        }
        if (checkSub >= 1) {
            $this.parents(".checkContainer").find(".subSecDiv .checkAll").prop("checked", true);
        }
    });
  
/* Below script is called upon click event where it expands the tab and replaces '+' with '-' or collapses a opened tab and replaces '-' with '+' */
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
/* Below function performs a redirection to the Gate Document page */
function goToParentPage() {
    window.top.location.href = IPMApp.GateDocumentPageRef + '?id=' + IPMApp.projectId + '&printDoc=' + IPMApp.printDoc;
}

var unsaved = false;
jq(function(){  
  jq(":input").change(function() {
           unsaved = true;
       });
      var frame = parent.document.getElementById("ipmModalDiv");
       jq(frame).find('.close').click(function(){
           if(unsaved){
               jq(this).removeAttr("data-dismiss");
               unloadIframe();
           }
       });
   });   
   
   function unloadIframe(){
       window.parent.location.href=IPMApp.GateDocumentPageRef + '?id=' + IPMApp.projectId + '&printDoc=' + IPMApp.printDoc;
   }

  function unloadPage()
  { 
      if(unsaved){
          return IPMApp.wmessage;
      }
  }
 
 window.onbeforeunload = unloadPage;
  
  /* Below code is to skip the unsaved changes*/
  function skipValidation() {
    unsaved = false;
  }