/*  
***********************************************************************************
*@Description:This script is used for IPM Team Assignment page specific interaction
*@Author: Cognizant
*@Created Date: 28/05/2015 
***********************************************************************************
*/  

jq(document).ready(function() {
	renderaccrdn();
});
/* Below code is for the accordion functionality */
function renderaccrdn(){
	var ipmAccordion = jq(".ipmAccordion");
	jq(document).on("click", ".expandTool .expandAll", function(){		
		ipmAccordion.find(".ipmAcrdnExpand").not(':empty').slideDown("fast");
		ipmAccordion.find(".pHead .expico").removeClass("fa-plus");
		ipmAccordion.find(".pHead .expico").addClass("fa-minus");
		ipmAccordion.find(".pHead .expico-square").removeClass("fa-plus");
		ipmAccordion.find(".pHead .expico-square").addClass("fa-minus");
	});
	jq(document).on("click", ".expandTool .collapseAll", function(){		
		ipmAccordion.find(".ipmAcrdnExpand ").slideUp("fast");
		ipmAccordion.find(".pHead .expico").addClass("fa-plus");
		ipmAccordion.find(".pHead .expico").removeClass("fa-minus");
		ipmAccordion.find(".pHead .expico-square").addClass("fa-plus");
		ipmAccordion.find(".pHead .expico-square").removeClass("fa-minus");
	});	
	ipmAccordion.find(".pHead span.expico").removeClass("fa-minus");              
	ipmAccordion.find(".pHead span.expico").addClass("fa-plus");
	ipmAccordion.find(".pHead:first span.expico").removeClass("fa-plus");
	ipmAccordion.find(".pHead:first span.expico").addClass("fa-minus");
	ipmAccordion.find(".ipmAcrdnExpand:first .pHead span.expico").removeClass("fa-plus");
	ipmAccordion.find(".ipmAcrdnExpand:first .pHead span.expico").addClass("fa-minus");
}
/* Below code is to open the add member modal */
jq(document).on('click', '.addTeamMember', function(e) { 
	e.preventDefault ? e.preventDefault() : e.returnValue = false; 
	var url = jq(this).attr('value'); 
	var rollType = jq(this).closest(".teamContainer").find(".pHead .teamHead").text();
	jq("#ipmAddMemberModal .modal-body").html('<iframe frameborder="0" height="100%" width="100%" marginheight="0" marginwidth="0" allowtransparency="true" src= "'+url+'"></iframe>');  
	jq('#ipmAddMemberModal .modal-dialog').width('700px');
	jq('#ipmAddMemberModal .modal-dialog').height('550px');                        
	jq('#ipmAddMemberModal .modal-dialog').css({'margin-top':'2%','z-index':'999'});
	jq('#ipmAddMemberModal .modal-title').html('Add Team Members'+' - '+rollType);
});

/* Below code is to open the add project leader modal */
jq(document).on('click', '.proLeader', function(e) { 
	e.preventDefault ? e.preventDefault() : e.returnValue = false; 
	var url = jq(this).attr('value'); 
	jq("#ipmAddMemberModal .modal-body").html('<iframe frameborder="0" height="100%" width="100%" marginheight="0" marginwidth="0" allowtransparency="true" src= "'+url+'"></iframe>');  
	 jq('#ipmAddMemberModal .modal-dialog').width('700px');
	jq('#ipmAddMemberModal .modal-dialog').height('550px');                        
	jq('#ipmAddMemberModal .modal-dialog').css({'margin-top':'2%','z-index':'999'}); 
	jq('#ipmAddMemberModal .modal-title').html('Edit Project Leader');     
});
/* Below code is to open the add deputy project leader modal */
jq(document).on('click', '.depproLeader', function(e) { 
	e.preventDefault ? e.preventDefault() : e.returnValue = false; 
	var url = jq(this).attr('value'); 
	jq("#ipmAddMemberModal .modal-body").html('<iframe frameborder="0" height="100%" width="100%" marginheight="0" marginwidth="0" allowtransparency="true" src= "'+url+'"></iframe>');  
	 jq('#ipmAddMemberModal .modal-dialog').width('700px');
	jq('#ipmAddMemberModal .modal-dialog').height('550px');                        
	jq('#ipmAddMemberModal .modal-dialog').css({'margin-top':'2%','z-index':'999'});     
	jq('#ipmAddMemberModal .modal-title').html('Edit Deputy Project Leader'); 
});

/* Below code is to open the add technical project leader modal */
jq(document).on('click', '.techLeader', function(e) { 
	e.preventDefault ? e.preventDefault() : e.returnValue = false; 
	var url = jq(this).attr('value'); 
	jq("#ipmAddMemberModal .modal-body").html('<iframe frameborder="0" height="100%" width="100%" marginheight="0" marginwidth="0" allowtransparency="true" src= "'+url+'"></iframe>');  
	 jq('#ipmAddMemberModal .modal-dialog').width('700px');
	jq('#ipmAddMemberModal .modal-dialog').height('550px');                        
	jq('#ipmAddMemberModal .modal-dialog').css({'margin-top':'2%','z-index':'999'});     
	jq('#ipmAddMemberModal .modal-title').html('Edit Technical Leader');
});

/* Below code is to open the add gatekeeper modal */
jq(document).on('click', '.gatekeeper', function(e) { 
	e.preventDefault ? e.preventDefault() : e.returnValue = false; 
	var url = jq(this).attr('value'); 
	jq("#ipmAddMemberModal .modal-body").html('<iframe frameborder="0" height="100%" width="100%" marginheight="0" marginwidth="0" allowtransparency="true" src= "'+url+'"></iframe>');  
	 jq('#ipmAddMemberModal .modal-dialog').width('700px');
	jq('#ipmAddMemberModal .modal-dialog').height('550px');                        
	jq('#ipmAddMemberModal .modal-dialog').css({'margin-top':'2%','z-index':'999'});     
	jq('#ipmAddMemberModal .modal-title').html('Edit Gatekeeper');
});