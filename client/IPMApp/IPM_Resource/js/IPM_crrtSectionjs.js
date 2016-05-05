/*  
****************************************************************
*@Description:This script is used for gate document CRRT section
*@Author: Cognizant
*@Created Date: 28/05/2015 
****************************************************************
*/ 
 var jq= jQuery.noConflict();
    jq(document).ready( function() {
/* Below script works on page load. First it hides all the tabs. Then it opens only the first tab. */
        jq(".ipmAcrdnExpand").hide();
        jq(".ipmAcrdnExpand:first, .ipmAcrdnExpand:first .ipmAcrdnExpand").not(':empty').show();  
/* Below script is called upon click event where it expands the tab and replaces '+' with '-' or collapses a opened tab and replaces '-' with '+' */
        jq(document).on("click", ".pHead .expico", function(){  
            var $this = jq(this);
            if($this.closest(".pHead").next(".ipmAcrdnExpand").is(":visible") && jq(this).closest(".pHead").next(".ipmAcrdnExpand").not(':empty')){
                $this.closest(".pHead").next(".ipmAcrdnExpand").slideUp("fast");
                $this.removeClass("fa-minus");
                $this.addClass("fa-plus");
            }else{
                $this.closest(".pHead").next(".ipmAcrdnExpand").slideDown("fast");
                $this.removeClass("fa-plus");
                $this.addClass("fa-minus");
            }
        });
    jq(".projectContainer:first").find(".pHead span.expico").removeClass("fa-plus").addClass("fa-minus");    
}); 
