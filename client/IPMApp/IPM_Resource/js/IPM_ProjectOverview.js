/*  
***********************************************************************************
*@Description:This script is used for project overview page specific interaction
*@Author: Cognizant
*@Created Date: 28/05/2015 
***********************************************************************************
*/
 var jq = jQuery.noConflict();
 jq(document).ready(function(){
     hilightTaskScript();
 
 /* Below script replace a text with a specific time format. */
    jq(".dueDate").each(function () {
        jq(this).text(jq(this).text().replace('00:00:00 GMT',''));
    });
    
    /* Below script works on click event. It hides the modal. */
    jq('.modal-header-bet .close').click(function() {  
        jq('#myModal').modal('hide');
    });
 /* Below script works on click event. If the condition is true it shows the alerts content with the text. Also it replaces '-' with '+' else vice versa. */
     jq(document).on('click', '.alertAccordian', function() {
        var $this = jq(this);
         if (jq('.alertContent').is(':visible')) {
             $this.removeClass('fa-minus');
             $this.addClass('fa-plus');
             jq('.alertContent').hide();
             jq('.alerttext').show();
         } else {
             jq('.alerttext').hide();
             $this.addClass('fa-minus');
             $this.removeClass('fa-plus');
             jq('.alertContent').show();
         }
     });
     
 /* Below works on click event. It is to open the modal */
     jq(document).on('click', '.openModal', function() {
         var $this = jq(this);
         var modalDlg = jq('#ipmModal .modal-dialog');
         var url = $this.attr('value');
         var modalTitle = $this.attr('modalTitle');
         openModal(url);
         jq('#ipmModal .modal-title').html(modalTitle);
         modalDlg.width('900px');
         modalDlg.height('90%');
     });

     /* Below works on click event. It is to remove a div. */
     jq('.closeMessage').on('click', function() {
         jq(this).closest('div').remove();
     }); 

  /* Below script works on click event. When clicked on the button it changes the css styles of the modal. */
    jq(document).on('click', '.shipTrade', function(e) { 
        e.preventDefault ? e.preventDefault() : e.returnValue = false;                        
        jq('#shipToPLE .modal-dialog').css({'margin-top':'10%','z-index':'999'});     
    }); 
     
 /*BET Section*/
 
 /* Below script replace a text with a specific time format. */
 jq(".dueDate").each(function () {
      jq(this).text(jq(this).text().replace('00:00:00 GMT',''));
 });

  /* Below script works on click event. When clicked on the button it changes the css styles of the modal. */
 jq(document).on('click', '.createBET', function(e) { 
    e.preventDefault ? e.preventDefault() : e.returnValue = false;  
     jq('#initiateProjectBKPanel .modal-dialog').width('80%');
    jq('#initiateProjectBKPanel .modal-dialog').height('90%');                        
    jq('#initiateProjectBKPanel .modal-dialog').css({'margin-top':'2%','z-index':'999'});     
}); 

if(IPMApp.showSuggestedMembers === true && window.location.href.indexOf("showMembers") > -1){
       document.getElementById("suggestedMembersButton").click();
   }else if (window.location.href.indexOf("createBET") > -1){
        document.getElementById("createBETButton").click();
}
     
var statusCheckApproved = IPMApp.DocumentStatus;

  /* Below script works on click event. If the condition is true the page will be reloaded. */
    jq("#ipmModal .close").on("click", function() 
        {
           if (jq("#ipmModal .modal-title").text().indexOf("Comment") !== -1) {
           window.top.location.href = IPMApp.ProjectOverviewPage+'?id='+IPMApp.projectId;
        }
});
    
jq('.skipButtoncontainer .ipmButton').removeClass('btn');

  /* Below script works on click event. When clicked on the link it hides one div and displays another div. Also it adds a css class for two elements. */
jq( ".unfollowLink" ).click(function( event ) {
        event.preventDefault();
        document.getElementById('followchatter').style.display = "none";
        document.getElementById('chatterblock').style.display = "block";
    }); 
    jq('.zen-media.zen-mediaExt img.chatter-followIcon').addClass('chatterIcon');
    jq('.zen-media.zen-mediaExt img.chatter-checkedIcon').addClass('chatterIcon');
});

/* Below function checks the checkboxes based on the selected class */
function compScript(){
    jq('.ipmCheckbox > input[type=checkbox].selected').each(function(){
         jq(this).attr("checked", true);
    }); 
}

/* Below function hides one div and displays another div. */
function showDiv() {
    document.getElementById('followchatter').style.display = "block";
    document.getElementById('chatterblock').style.display = "none";
}  

 /* Below function redirects the page to Project overview page. */
function moveToNextDoc(){
    window.top.location.href=IPMApp.ProjectOverviewPage+'?id='+IPMApp.projectId+'&showMembers=true&createBET=true'
}

/* Below function contains the script which has the tooltip functionality. This function is called when the rerendering happens and the script will run again */
function hilightTaskScript(){
    jq(".info").tooltip({ position: { my: 'center top', at: 'center bottom+10' }});
    jq(".deleteChannel").tooltip({ position: { my: 'center top', at: 'center bottom+10' }});    
    jq(".arrow-left").tooltip({ position: { my: 'left top', at: 'center bottom+10' },tooltipClass:'ui-lefttip'}); 
    jq(".aTabs").find("input[type=checkbox]:checked").closest(".aTabs").addClass("active");
}