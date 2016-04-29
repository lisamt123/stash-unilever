/***************************************************************************************
 *@Description:This script used to create IPM_ApproverList page specific utility methods.
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
**************************************************************************************/
var jq = jQuery.noConflict();
/* Below script calls the clear search functionality when the user starts typing in the text field  */
jq(document).ready(function() {
    jq(".approverSearch").clearSearch();
});

/* Below script works on the on click event. If the checkbox is checked it adds highlights the closest row by adding a color */
jq('.ipmRadioButton .ipmTable td .rbutton').click(function() {
    jq('.ipmRadioButton .ipmTable').find("tr").removeClass("selected");
    if (jq(this).is(':checked')) {
        jq(this).closest("tr").addClass("selected");
    }
});
var unsaved = false;
/* Below function performs the redirection to the BOSSCARD page */
function closepopup() {
    var approver = IPMApproverApp.bossurl;
    var id = IPMApproverApp.bosscardId;
    window.top.location.href = approver + '?id=' + id;
}
function changeText(){
		unsaved = true;
	}
jq(function(){  
	
      var frame = parent.document.getElementById("editApprover");
       jq(frame).find('.close').click(function(){
           if(unsaved){
               jq(this).removeAttr("data-dismiss");
               unloadIframe();
           }
       });
   });   
   
   function unloadIframe(){
       window.parent.location.href=IPMApproverApp.bossurl + '?id=' + IPMApproverApp.bosscardId;
   }

  function unloadPage()
  { 
      if(unsaved){
          return IPMApproverApp.wmessage;
      }
  }
 
 window.onbeforeunload = unloadPage;
  
  /* Below code is to skip the unsaved changes*/
  function skipValidation() {
    unsaved = false;
  }