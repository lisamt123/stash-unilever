/****************************************************************************************
 *@Description:This script used to create IPM_Addtaskwizard page specific utility methods.
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
****************************************************************************************/
var jq = jQuery.noConflict();
jq("[id$=mlktp]").hide();
jq('.dateInput .dateFormat').hide();
jq('.gatedocModal').find('.errorMsg').addClass('custErr');
/* Below function performs the redirection to Project setup page */
function pageclose() {
    window.top.location.href = IPMAppComp.pageRefProSetupView + '?Pid=' + IPMAppComp.projectId + '&TodoId=todos';
}
/* Below function checks a condition. If the condition is true it will redirect to Gate Document section editor page. If condition is false it will redirect to Task List Page */
function pagecloseNewTask(){ 
    if (IPMAppComp.redirectToGateDocument === 'true') { 
            window.top.location.href = IPMAppComp.pageRefProjDocSec + '?Id=' + IPMAppComp.projectId + '&' + IPMAppComp.redirectToGateDocumentUrl + '=' + IPMAppComp.docSecList; 
    } else { 
            window.top.location.href = IPMAppComp.TasklistPageRef + '?id=' + IPMAppComp.projectId; 
    } 
}
jq(document).ready(function($) {
    var max = 225;
    jq('textarea.todoName').keypress(function(e) {
        if (e.which < 0x20) {
            return;
        }
        if (this.value.length === max) {
            e.preventDefault();
        } else if (this.value.length > max) {
            this.value = this.value.substring(0, max);
        }
    });
});

var unsaved = false;
jq(function(){       
      jq(":input").change(function() {
           unsaved = true;
       });
       if(window.parent.location.href.indexOf("Tasklist") > -1) {
            var frame = parent.document.getElementById("ipmModalDiv");
       }else{
            var frame = parent.document.getElementById("ipmMstoneTaskWizard");
       }
      jq(frame).find('.close').click(function(){
          if(unsaved){
              jq(this).removeAttr( "data-dismiss" );
              unloadIframe();
          }
          else{
              jq(this).attr("data-dismiss","modal");
          }
      }); 
  });   
  
  function unloadIframe(){
      if(window.parent.location.href.indexOf("Tasklist") > -1) {
           window.parent.location.href=IPMAppComp.TasklistPageRef + '?id=' + IPMAppComp.projectId;
      }else{
           window.parent.location.href=IPMAppComp.pageRefProSetupView + '?Pid=' + IPMAppComp.projectId + '&TodoId=todos';
      }
  }
  
   function unloadPage()
 { 
     if(unsaved){
         return IPMAppComp.wmessage;
     }
 } 

 window.onbeforeunload = unloadPage;
 
 /* Below code is to skip the unsaved changes*/
 function skipValidation() {
     unsaved = false;
 }
