/*  
*************************************************************************
*@Description:This script is used for home page specific interaction
*@Author: Cognizant
*@Created Date: 28/05/2015 
*************************************************************************
*/
var jq = jQuery.noConflict();
function accrdn(){
    var ipmAccordion = jq(".ipmAccordion");
/* Below script works on page load. First it hides all the tabs. Then it opens only the first tab. It also adds the + mark for the collapsed one's and adds - for the expanded one */
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
        }

/* Below function checks for the validation. If the condition is true the selected checkbox will be unchecked else it will be checked. It also calls another function 'markComplete' */     
function myAssignedTasks(taskId, isChecked) {
    if(isChecked !== true) {     
            jq('.taskCheck input[type=checkbox]#'+taskId).closest(".recordBox").removeClass("selected");
        }else {
            jq('.taskCheck input[type=checkbox]#'+taskId).closest(".recordBox").addClass("selected");
        }
        markComplete(taskId, isChecked);
}
        
jq(document).ready(function(){
    accrdn();
    
/* Below script works on click event. If the content of the accordion exists it displays the alert text. Also it removes '-' sign and adds '+' and vice versa. */
    jq(document).on('click', '.alertAccordian', function() {
        var $this = jq(this);
         if (jq('.alertContent').is(':visible')) {
             $this.removeClass('fa-minus');
             $this.addClass('fa-plus');
             jq('.alertContent').hide();
             jq('.alerttext').show();
         } else {
             jq('.alerttext').hide();
             $this.addClass('fa-minus');
             $this.removeClass('fa-plus');
             jq('.alertContent').show();
         }
     });
     
 /* Below script works on click event. Once the link is clicked, based on the value of the attribute it redirects to a page. */
    jq(document).on('click', '.actionBox', function() {
        var url = jq(this).attr('value');
        window.top.location.href = url;
    });

/* Below script works on click event. It is related to home page carousel. When clicked on more link it expands to display more text. */
    jq(document).on('click', '.moreLink', function() {
        var moreLink = jq(this);
        moreLink.parent().prev().animate({
            height: '100%'
        }, 500);
        moreLink.hide();
        moreLink.next('a.lessLink').show();
    });

/* Below script works on click event. It is related to home page carousel. When clicked on less link it collapses to display less text. */
    jq(document).on('click', '.lessLink', function() {
        var lessLink = jq(this);
        lessLink.parent().prev().animate({
            height: '120px'
        }, 500);
        lessLink.hide();
        lessLink.prev('.moreLink').show();
    });
    
/* Below script works on click event. It triggers all the links when user press enter key. */
    jq(document).on('keydown', '.actionBox,.alertAccordian,.moreLink,.lessLink,.expico', function() { 
        var keyCode = (event.keyCode ? event.keyCode : event.which); 
        if (keyCode === 13) { 
        jq(this).trigger('click'); 
        } 
    });
});
