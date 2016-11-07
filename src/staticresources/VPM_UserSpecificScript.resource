function func(){
  alert('Only relevant for Manual Blocks/Unblocks/Deletes/Undeletes'); 
}

function openAdvanceform(){
	window.location = 'apex/VPM_AdvancedForm?id={!VPM_PurchasingRequests__c.Id}'; 
	var localhost = document.domain;
	window.top.location='https://'+localhost+'/apex/VPM_AdvancedForm_V1?id={!VPM_PurchasingRequests__c.Id}';
}
function PageReload(){
  var localhost = document.domain;
  window.top.location='https://'+localhost+'/{!VPM_PurchasingRequests__c.id}';
  return false;
}

function redirectToListView(customId)
{
	debugger;
	alert(customId);
  var localhost = document.domain;
  //var id='{!VPM_PurchasingRequests__c.id}';
  var id=customId;
  window.top.location='https://'+localhost+'/apex/VPM_VendorRequestsHome';
  return false;
}

function reworkBtnClick(){
	var purId="{!VPM_PurchasingRequests__c.Id}";
	var currentstatus="{!VPM_PurchasingRequests__c.VPM_Status__c}"; 
	var LastGroup = "{!VPM_PurchasingRequests__c.VPM_RequestLastWithGroup__c}"; 
	var FinanceApproveRequired ="{!VPM_PurchasingRequests__c.VPM_FinanceApprovalRequired__c}"; 
	var ProcurementApproveRequired = "{!VPM_PurchasingRequests__c.VPM_ProcurementApprovalRequired__c}"; 
	var CreatedBy="{!VPM_PurchasingRequests__c.CreatedById}"; 
	var rework ="{!VPM_PurchasingRequests__c.VPM_Rework__c}";
	if ((currentstatus.indexOf('Draft') >= 0 )||(rework=='Yes') || (currentstatus.indexOf('MDM Ops') >= 0 )){ 
		if(rework=='Yes'){ 
			alert('Already send for rework'); 
		} 
		else{ 
			alert('Business Requestor & MDM Ops cannot send for rework'); 
		} 
		
	}
	else
	{
		var r = confirm("Are you sure you want to rework the request? \nPlease provide guidance via the Chatter feed"); 
		if(r == true){
				ReworkAction();
				return false;
		   }
		
		else 
			alert("Rework Cancelled");
	} 
}
function callSendToSAPAPI()
{
	callSendToSAPAPI();
	return false;
}

function openProcureAtAGlance(){
	var localhost = document.domain; 
	window.top.location='https://'+localhost+'/apex/VPM_ProcurementAtAGlance?id={!VPM_PurchasingRequests__c.Id}';
}