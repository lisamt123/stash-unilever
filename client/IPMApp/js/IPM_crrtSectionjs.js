/*  
****************************************************************
*@Description:This script is used for gate document CRRT section
*@Author: Cognizant
*@Created Date: 28/05/2015 
****************************************************************
*/ 
/* Below code is for the accordion functionality */
 var jq= jQuery.noConflict();
    jq(document).ready( function() {
        jq(".ipmAcrdnExpand").hide();
        jq(".ipmAcrdnExpand:first, .ipmAcrdnExpand:first .ipmAcrdnExpand").not(':empty').show();                          
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
