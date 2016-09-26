 /*  
*******************************************************
*@Description:This script is used for All Projects Page
*@Author: Cognizant
*@Created Date: 28/05/2015 
*******************************************************
*/ 
// To prevent conflict with prototype.js
var jq = jQuery.noConflict();
jq(document).ready(function() {

/* Below script works on page load. First it hides all the tabs. Then it opens only the first tab. It also adds the + mark for the collapsed one's and adds - for the expanded one */
     jq(".ipmAcrdnExpand, .ipmAcrdnExpand:first .ipmAcrdnExpand").not(':empty').show();
     jq(".ipmAccordion").find(".pHead span.expico").removeClass("fa-plus");
     jq(".ipmAccordion").find(".pHead span.expico").addClass("fa-minus");
     jq(".ipmAcrdnExpand .ipmAcrdnExpand").hide();
    var docFilterCont = jq(".docFilter");
    var ipmAccordionCont = jq(".ipmAccordion");
    
/* Below script works on click event. When clicked on reset button the recently made changes to the checkboxes will be reverted back and all the checkboxes will be checked. */
    jq(document).on('click', '#resetFilterBtn', function() {
        docFilterCont.find("input[type=checkbox]").prop("checked", true);
        docFilterCont.find("label").addClass("selected");
    });
    var stop = IPMAppAllprojects.stop;
    if( stop === 'true')
        {       
            docFilterCont.find("input[type=checkbox]:not('.statusAll')").prop("checked", true);
            docFilterCont.find('.checkStopped').next('label').addClass('stopProject');
            docFilterCont.find('.checkStopped').prop('checked', false);
            docFilterCont.find('.checkStopped').next('label').addClass('stopProject');
            docFilterCont.find("input[type=checkbox]")
        }
        else{
            docFilterCont.find("input[type=checkbox]").prop("checked", true);
            docFilterCont.find("label").addClass("selected");
            docFilterCont.find('.checkStopped').next('label').removeClass('stopProject');
        }
            
/* Below script works on mouse over event. On mouseover a table row, the background color of that row will be changed. */           
    jq(document).on('mouseover', '.ipmTable tbody tr.genRow', function() {
        var trOdd = jq(this);        
        trOdd.next('tr').addClass('tr_hover');
    });
    
/* Below script works on mouseout event. On mouseout a table row, the background color of that row will be removed. */
    jq(document).on('mouseout', '.ipmTable tbody tr.genRow', function() {
        var trOdd = jq(this);        
        trOdd.next('tr').removeClass('tr_hover');
    });

/* Below script works on mouse over event. On mouseover a table row, the background color of that row will be changed. */
    jq(document).on('mouseover', '.ipmTable tbody tr.genRowOdd, .ipmTable tbody tr.noBackground', function() {
        var trEven = jq(this);
        trEven.prev('tr').addClass('tr_hover');       
    });
    
/* Below script works on mouseout event. On mouseout a table row, the background color of that row will be removed. */
    jq(document).on('mouseout', '.ipmTable tbody tr.genRowOdd, .ipmTable tbody tr.noBackground', function() {
        var trEven = jq(this);
        trEven.prev('tr').removeClass('tr_hover');        
    });
    jq("input.disable").prop("disabled", true);


// To change and override default accordion
    ipmAccordionCont.find(".pHead span.expico-square").removeClass("fa-minus");
    ipmAccordionCont.find(".pHead span.expico-square").addClass("fa-plus");
     jq('.ipmCheckbox input[type=checkbox]').each(function(){
          if(jq(this).attr('data-html') === 'disabled')
          {
              jq(this).attr("disabled", true);
              jq(this).prop("checked",false)
              jq(this).next().removeClass('selected');
          }
      });
});

window.onload = function () {
        jq('#not-active').css('display','block');
       }