/*  
***********************************************************************************
*@Description:This script is used for resource allocation page specific interaction
*@Author: Cognizant
*@Created Date: 28/05/2015 
***********************************************************************************
*/
var jq= jQuery.noConflict();
jq(document).ready(function() {
/* Below code is to show the edit container */
	jq(document).on('click', '.ipmTable .rbutton', function(){
		   jq('.editbContainer').hide(); 
		   jq('.cust-overlay').show().delay(2000).fadeOut(); 
		   jq('.editbContainer').show();
	});
	jq(".teamCheck").change(function(){
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
/* Below code is for the search functionality */
function callsearch(){
	if (document.getElementById('mycategory').checked) {
	  searchTeamMem();  
	 }
	if (document.getElementById('allcategory').checked) {
	  searchallTeamMem();
	 } 
}
/* Below code is to save the selected team members */
function submitOnClick (objSubmitBtn) {
    objSubmitBtn.disabled = true;
    objSubmitBtn.value = 'Adding...';
    saveMembers();
}
/* Below code is to add the selected members */
function submitAdd(objSubmitBtn){
   objSubmitBtn.value='Add';
   objSubmitBtn.disabled = false;
}   
/* Below code is to save the role of the members */
function submitOnClickRole(objSubmitBtn) {
    objSubmitBtn.disabled = true;
    objSubmitBtn.value = 'Adding...';
    RoleAndCategoryMem();
}
/* Below code is to close the modal */
 function dismissModal(){      
	 var frame = parent.document.getElementById("ipmAddMemberModal");
	 jq(frame).find('.close').trigger('click');
    }
/* Below code is to redirect to a page */
function closepopup(){
    window.top.location.href=IPMApp.teamurl+'?id='+IPMApp.projectID+'&TeamMemid=teammembers&showedit=true';
}