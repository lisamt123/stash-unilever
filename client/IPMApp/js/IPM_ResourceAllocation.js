/*  
****************************************************************************************
*@Description:This script is used for IPM Resource Part Revamp page specific interaction
*@Author: Cognizant
*@Created Date: 28/05/2015 
****************************************************************************************
*/
var jq= jQuery.noConflict();
jq(document).ready(function() {
/* Below code is to show the edit container */
	jq(document).on('click', '.ipmTable .rbutton', function(){
		var editContainer = jq('.editbContainer');
		   editContainer.hide(); 
		   jq('.cust-overlay').show().delay(2000).fadeOut(); 
		   editContainer.show();
	  });
	   jq(".teamCheck").change(function() {
		var $this = jq(this);
		if($this.is(':checked')) {
			$this.closest('tr').addClass('selected'); 
			}
		else {
			$this.closest('tr').removeClass('selected');
			}
	});
	jq('.teamSearch1 input').clearSearch();
	jq('.teamSearch2 input').clearSearch();
	jq('.teamSearch3 input').clearSearch();
});

/* Below code is to close the modal */
 function dismissModal(){      
         var frame = parent.document.getElementById("ipmAddMemberModal");
         jq(frame).find('.close').trigger('click');
}

/* Below code is for the search functionality */
function callsearch(blnInvokedFromRollOuts) {
    //if (document.getElementById('mycategory').checked) 
	//{
	   //searchTeamMem();
   if (document.getElementById('mycategory').checked) {
		if(blnInvokedFromRollOuts)
		{
			 searchLeaderMem();
		}
		else
		{
			 searchTeamMem();
		}
	}
	if (document.getElementById('allcategory').checked) {
		if (blnInvokedFromRollOuts)
		{
			   searchallLeaderMem();
		}
		else
		{
			   searchallTeamMem();
		}
	}  
				
}

/* Below code is to save the selected team members */
function submitOnClick(objSubmitBtn) {
    objSubmitBtn.disabled = true;
    objSubmitBtn.value = 'Adding...';
    saveMembers();
}

/* Below code is to add the selected members */
function submitAdd(objSubmitBtn) {
    objSubmitBtn.value = 'Add';
    objSubmitBtn.disabled = false;
}

/* Below code is to save the role of the members */
function submitOnClickRole(objSubmitBtn) {
    objSubmitBtn.disabled = true;
    objSubmitBtn.value = 'Adding...';
    RoleAndCategoryMem();
}

/* Below code is to redirect to a page */
function closepopup(){
     window.top.location.href=IPMApp.projectUrl+'?Pid='+IPMApp.projectName+'&TeamMemid=teammembers';
} 