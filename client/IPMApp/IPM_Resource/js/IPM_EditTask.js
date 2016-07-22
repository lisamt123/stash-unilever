/**********************************************************************
 *@Description:This script used for edit to-do's related utility methods.
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
***********************************************************************/
var jq = jQuery.noConflict();
function callEditTask() {
    jq("[id$=mlktp]").hide();
    jq('.dateInput .dateFormat').hide();
    var dateFormat = "dd/mm/yyyy";
    jq.browser = {};
}
callEditTask();
/* Below function checks if the condition is true it redirects to Project setup page else it redirects to Task List page. */
function pageclose() {
    if (IPMApp.ProjectWizard === 'true') {
        window.top.location.href = IPMApp.PojectSetupUrl + '?Pid=' + IPMApp.projectId + '&TodoId=todos';
    } else {
        window.top.location.href = IPMApp.TasklistPageRef + '?id=' + IPMApp.projectId;
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
var jq = jQuery.noConflict();
jq(function(){       
      jq(":input").change(function() {
           unsaved = true;
       });
     var frame = parent.document.getElementById("ipmModalDiv");
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
     window.top.location.href = IPMApp.TasklistPageRef + '?id=' + IPMApp.projectId;
   } else {
       window.top.location.href = IPMApp.PojectSetupUrl + '?Pid=' + IPMApp.projectId + '&TodoId=todos';
    }
  }
  
   function unloadPage()
 { 
     if(unsaved){
         return IPMApp.wmessage;
     }
 } 

 window.onbeforeunload = unloadPage;
 
 /* Below code is to skip the unsaved changes*/
 function skipValidation() {
     unsaved = false;
 }