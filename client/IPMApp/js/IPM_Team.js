/*  
***************************************************************************************
*@Description:This script is used to override default accordian in IPM Team Revamp page
*@Author: Cognizant
*@Created Date: 28/05/2015 
***************************************************************************************
*/  
  var jq = jQuery.noConflict(); 

/* Below code is for the accordion and tooltip functionality */  
  jq(document).ready(function() {
  jq("[data-toggle=tooltip]").tooltip();
  var ipmAccordion = jq(".ipmAccordion");
      ipmAccordion.find(".ipmAcrdnExpand").not(':empty').slideDown("fast");
      ipmAccordion.find(".pHead .expico").removeClass("fa-plus");
      ipmAccordion.find(".pHead .expico").addClass("fa-minus");
      ipmAccordion.find(".pHead .expico-square").removeClass("fa-plus");
      ipmAccordion.find(".pHead .expico-square").addClass("fa-minus");
  });
   
/* Below code is to open the delete modal */
function delTeamMem(str) {  
	jq('#ipmModalDelete .modal-dialog').width('40%');
	jq('#ipmModalDelete .modal-dialog').height('200px');                        
	jq('#ipmModalDelete .modal-dialog').css({'margin-top':'10%','z-index':'999'});
	jq('#ipmModalDelete .confirmAction').attr('data-value', str);
	jq(".confirmAction").addClass("removeTeamMember");
}
/* Below code is to hide the delete modal */
jq(document).on('click', '#ipmModalDelete .removeTeamMember', function(){
	var teamMemId = jq(this).attr('data-value');            
	DeleteMember(teamMemId);
	jq("#ipmModalDelete").modal('hide');
});