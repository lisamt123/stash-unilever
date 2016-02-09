/*  
***********************************************************************************
*@Description:This script is used for project overview page specific interaction
*@Author: Cognizant
*@Created Date: 28/05/2015 
***********************************************************************************
*/
 var jq = jQuery.noConflict();
 jq(document).ready(function(){
	jq(".dueDate").each(function () {
		jq(this).text(jq(this).text().replace('00:00:00 GMT',''));
	});
	jq('.modal-header-bet .close').click(function() {  
		jq('#myModal').modal('hide');
	});
 /* Below code is to show or hide the alerts container */
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
	 
 /* Below code is to open the modal */
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

	 jq('.closeMessage').on('click', function() {
		 jq(this).closest('div').remove();
	 }); 

  /* Below code is to open the ship to trade modal */
	jq(document).on('click', '.shipTrade', function(e) { 
		e.preventDefault ? e.preventDefault() : e.returnValue = false;                        
		jq('#shipToPLE .modal-dialog').css({'margin-top':'10%','z-index':'999'});     
	});	
	 
 /*BET Section*/
 
 jq(".dueDate").each(function () {
	  jq(this).text(jq(this).text().replace('00:00:00 GMT',''));
 });

  /* Below code is to open the BET modal */
 jq(document).on('click', '.createBET', function(e) { 
	e.preventDefault ? e.preventDefault() : e.returnValue = false;  
	 jq('#initiateProjectBKPanel .modal-dialog').width('80%');
	jq('#initiateProjectBKPanel .modal-dialog').height('90%');                        
	jq('#initiateProjectBKPanel .modal-dialog').css({'margin-top':'2%','z-index':'999'});     
});	

if(IPMApp.showSuggestedMembers == true && window.location.href.indexOf("showMembers") > -1){
	   document.getElementById("suggestedMembersButton").click();
   }else if (window.location.href.indexOf("createBET") > -1){
		document.getElementById("createBETButton").click();
}
	 
var statusCheckApproved = IPMApp.DocumentStatus;
	jq("#ipmModal .close").on("click", function() 
		{
		   if (jq("#ipmModal .modal-title").text().indexOf("Comment") != -1) {
		   window.top.location.href = IPMApp.ProjectOverviewPage+'?id='+IPMApp.projectId;
		}
});
	
jq('.skipButtoncontainer .ipmButton').removeClass('btn');
	          
jq( ".unfollowLink" ).click(function( event ) {
		event.preventDefault();
		document.getElementById('followchatter').style.display = "none";
		document.getElementById('chatterblock').style.display = "block";
	});	
	jq('.zen-media.zen-mediaExt img.chatter-followIcon').addClass('chatterIcon');
	jq('.zen-media.zen-mediaExt img.chatter-checkedIcon').addClass('chatterIcon');
});

function compScript(){
	jq('.ipmCheckbox > input[type=checkbox].selected').each(function(){
		 jq(this).attr("checked", true);
	}); 
}

function showDiv() {
	document.getElementById('followchatter').style.display = "block";
	document.getElementById('chatterblock').style.display = "none";
}  

function moveToNextDoc(){
	window.top.location.href=IPMApp.ProjectOverviewPage+'?id='+IPMApp.projectId+'&showMembers=true&createBET=true'
}