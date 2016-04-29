/*************************************************************************
 *@Description:This script is used for BOSSCARD status specific interaction
 *@Author: Cognizant
 *@Created Date: 28/05/2015
*************************************************************************/
var jq = jQuery.noConflict();
var unsaved = false;
jq(document).ready(function() {

/* Below script is for the Tab functionality on page load. It hides all the tabs content and shows only the first tabs content */
    var statusTab = jq('#ipmUpdateStatusTab');
    statusTab.parent().find('.ipmGetStartedContent').hide();
    jq('#ipmUpdateStatusTab .ipmStatusTabs li:first').addClass('active');
    statusTab.parent().find('.ipmGetStartedContent:first').show();
    jq('#ipmUpdateStatusTab .ipmStatusTabs li:first').find('input:radio').prop("checked", "true");
	
/* Below script is for the Tab functionality on click event. Based on the clicked li the tab is highlighted and the content related the clicked tab is displayed. Also it hides the previous opened content */
    jq('#ipmUpdateStatusTab .ipmStatusTabs li').on('click', function(e) {
        e.preventDefault();
		unsaved = true;
        var $this = jq(this);
        jq('#ipmUpdateStatusTab .ipmStatusTabs li').removeClass('active');
        jq('#ipmUpdateStatusTab .ipmStatusTabs li').removeClass('highlightRed');
        var getId = $this.attr('class');
        if (getId === 'status_discard') {
            $this.addClass('highlightRed');
            $this.addClass('active').find('input:radio').prop("checked", "true");
            statusTab.parent().find('.ipmGetStartedContent').hide();
            jq('#' + getId).show();
            jq('#status_discard .sContainer').addClass('highlightBgred');
        } else {
            $this.addClass('active').find('input:radio').prop("checked", "true");
            statusTab.parent().find('.ipmGetStartedContent').hide();
            jq('#' + getId).show();
        }
    });
});
/* Below function performs a page redirection to BOSSCARD page when clicked on cancel button. */
function cancel() {
    window.top.location.href = IPMApp.bossurl + '?id=' + IPMApp.bosscardId;
}
/* Below function checks the BOSSCARD status and navigate to respective pages based on the status of the BOSSCARD. */
function goToBosscardParentPage() {
    if (IPMApp.status === 'In Progress' || IPMApp.status === 'Not Approved') {
        window.top.location.href = IPMApp.bossurl + '?id=' + IPMApp.bosscardId;
    } else if (IPMApp.status === 'Approved') {
        if (IPMApp.CurrentPage === 'true') {
            window.top.location.href = IPMApp.projecturl + '?Pid=' + IPMApp.projectId;
        } else {
            window.top.location.href = IPMApp.homeurl;
        }
    } else if (IPMApp.status === 'In Progress' || IPMApp.status === 'Discard') {
        window.top.location.href = IPMApp.homeurl;
    }
}
/* Below function calls another function 'updateBosscardStatus' which updates the BOSSCARD status */
function changeBosscardStatus(status) {
    updateBosscardStatus(status);
}
/* Below script works on key press event. It searches the user entered value. */
jq('.searchLeader').keypress(function(e) {
    if (e.which === 13) {
        callsearch(jq('.searchLeader').val());
        return false;
    }
});

var oldTextareaval = "";
var newTextareaval = "";
var initialValue = true;
jq(function(){  
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
        if(initialValue !== false){
            oldTextareaval = jq(".txtArea ").val();
        }
		
   });   
   
   function unloadIframe(){
       window.parent.location.href=IPMApp.bossurl + '?id=' + IPMApp.bosscardId;
   }
   
   function checktextval(){
   inputTextArea = jq(".txtArea ");
    inputTextArea.bind('input propertychange', function() {
            newTextareaval = jq(".txtArea ").val();
            initialValue = false;
            if( oldTextareaval !== newTextareaval ){
              unsaved = true;
            }else{
              unsaved = false;
            }
            oldTextareaval = newTextareaval;
         });
     }
  
function unloadPagebs()
  { 
      if(unsaved){
          return IPMApp.wmessage;
      }
  } 
 window.onbeforeunload = unloadPagebs;
 
  /* Below code is to skip the unsaved changes*/
  function skipValidation() {
    unsaved = false;
  }