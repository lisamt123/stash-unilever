/***********************************************************************
 *@Description:This script is used for bosscard page specific interaction
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
***********************************************************************/
var jq = jQuery.noConflict();
jq(document).ready(function() {

/* Below script is for the Tab functionality on page load. It hides all the tabs content and shows only the first tabs content */
    var statusTab = jq('#ipmupdateStatusTab');
    statusTab.parent().find('.ipmStatusContent').hide();
    jq('#ipmupdateStatusTab .ipmstatusTabs li:first').addClass('active');
    statusTab.parent().find('.ipmStatusContent:first').show();
	
/* Below script is for the Tab functionality on click event. Based on the clicked li the tab is highlighted and the content related the clicked tab is displayed. Also it hides the previous opened content */
    jq('#ipmupdateStatusTab .ipmstatusTabs li').on('click', function(e) {
        e.preventDefault();
        jq('#ipmupdateStatusTab .ipmstatusTabs li').removeClass('active');
        var $this = jq(this);
        var getId = $this.attr('class');
        statusTab.parent().find('.ipmStatusContent').hide();
        $this.addClass('active');
        jq('#' + getId).fadeIn("fast");
    });
	
/* Below script performs on click event. When we save the BOSSCARD a message appears saying the BOSSCARD saved successfully. This message is shown for few seconds and will be hidden */
    jq(".saveBosscard").click(function() {
        jq(".floatedMsg").animate({
            "opacity": 0
        }, 1000).hide();
    });
    jq('.duplicateName').hide();
    var accordion = jq(".ipmAccordion");
	accordion.find(".ipmAcrdnExpand").hide();
    accordion.find(".pHead .expico").removeClass("fa-minus");
    accordion.find(".pHead .expico").addClass("fa-plus");
	
/* Below script works on hover for Uploading image. Once we upload an image on hover the uploaded image we allow users to delete or update the image */
    jq(".custBossPadding").hover(function() {
        jq('.imgHoverContainer').stop();
        jq('.imgHoverContainer').show(200);
    }, function() {
        jq('.imgHoverContainer').stop();
        jq('.imgHoverContainer').hide(100);
    });
	
/* Below script is for autocomplete functionality. When user starts typing the BOSSCARD name, existing BOSSCARD names will be shown */
    jq(".brandautocomplete").autocomplete({
        source: apexAccountList,
        select: function(event, ui) {
            selectedObj = ui.item;
        },
        minLength: 1
    });
	
/* Below script is for the quarter picker functionality */
    var defaults = {
        quarterOffset: 0,
        yearsIntoPast: 20
    };
    jq(".quarterForward").quarterpicker(jq.extend({}, defaults, {
        quarterOffset: 1
    }));
    jq("button").button();

/* Below script works on click event. Based on the value of the link the page will be redirected */
    jq(document).on('click', '.actionBox', function() {
        var url = jq(this).attr('value');
        window.top.location.href = url;
    });
	
/* Below script works on click event. When clicked on Upload button callsave function is being called */
    jq(document).on('click', '.uploadImage', function() {
        callsave();
    });	
	
	hilightTaskScript();
});

/* Below script works on click event. When clicked on edit approver button it opens a modal. */
jq(document).on('click', '.editApprover', function(e) {
    e.preventDefault ? e.preventDefault() : e.returnValue = false;
    jq('#removeApprover .modal-dialog').width('600px');
    jq('#removeApprover .modal-dialog').height('200px');
    jq('#removeApprover .modal-dialog').css({
        'margin-top': '10%',
        'z-index': '999'
    });
});
/* Below script works on click event. When clicked on Delete button it opens a modal where user can delete the uploaded image. */
jq(document).on('click', '.imgDelButton', function(e) {
    e.preventDefault ? e.preventDefault() : e.returnValue = false;
    jq('#deleteImgPop .modal-dialog').width('600px');
    jq('#deleteImgPop .modal-dialog').height('180px');
    jq('#deleteImgPop .modal-dialog').css({
        'margin-top': '10%',
        'z-index': '999'
    });
});
/* Below function performs a validation before opening the change status modal for changing the status of BOSSCARD. If the condition is true it opens the modal else it hides the modal. */
function checkValidation() {
	mainPageUnsaved = false;
    var bossCardName = jq('.BosscardNameInputBox').val();
    var companyName = jq('.compC').val();
    var categoryName = jq('.cateG').val();
    var regex = /^[0-9a-zA-Z\_]+/
    var specChars = regex.test(bossCardName);
    var url = jq('.updateBox').attr('value');
	var bossname = jq('.hiddenBossname').attr('data-target');
    if (companyName !== '' && categoryName !== '' && bossCardName !== undefined && bossCardName !== '' && specChars === true && bossname === 'false') {
        jq('#ipmModal').modal({
            show: true,
            keyboard: false,
            backdrop: 'static'
        });
        openModal(url);
        jq('#ipmModal .modal-title').html(IPMApp.changeStatus);
        jq('#ipmModal .modal-dialog').width('70%');
        jq('#ipmModal .modal-dialog').height('70%');
        jq('#ipmModal .modal-dialog').css('margin-top', '10%');
    } else {
        jq('#ipmModal').modal('hide');
    }
}
/* Below script works on click event. When user clicks on close button of a modal, it closes the modal and reloads the BOSSCARD page. */
jq(".upimgModal .close").click(function() {
    parent.location.assign(IPMApp.bossurl + '?Id=' + IPMApp.bosscardId);
});

/* Below function is used to create a new project only when the condition is true else it displays an error message. */
function createPro() {
    Visualforce.remoting.Manager.invokeAction(
        IPMApp.RemoteAction,IPMApp.bosscardId,
        function(result, event) {
            if (event.status) {
                if (event.result !== null) {
                    window.top.location.href = IPMApp.projecturl + '?Pid=' + event.result;
                } else {
                    alert(IPMApp.systemMsg);
                }
            }
        }
    );
}

/* Below function is used to open upload image modal. When condition is true it opens a modal where user can upload image else it hides the modal. */
function upldImage(){
	mainPageUnsaved = false;
	var bossCardName = jq('.BosscardNameInputBox').val();
    var companyName = jq('.compC').val();
    var categoryName = jq('.cateG').val();
    var regex = /^[0-9a-zA-Z\_]+/
    var specChars = regex.test(bossCardName);
    var url = jq('.uploadImage').attr('value');
	var bossname = jq('.hiddenBossname').attr('data-target');
    if (companyName !== '' && categoryName !== '' && bossCardName !== undefined && bossCardName !== '' && specChars === true && bossname === 'false') {
        jq('#ipmModal').modal({
            show: true,
            keyboard: false,
            backdrop: 'static'
        });
        openModal(url);
		jq('#ipmModal .modal-title').html('Upload Image');
        jq('#ipmModal .modal-dialog').width('525px');
        jq('#ipmModal .modal-dialog').height('220px');
        jq('#ipmModal .modal-dialog').css('margin-top', '15%');
		jq("#ipmModal .modal-header").addClass("upimgModal");
    } else {
        jq('#ipmModal').modal('hide');
    }
}

/* Below function is used to open select approver modal. When condition is true it opens a modal where user can select approver else it hides the modal. */
function slctApprover(){
	mainPageUnsaved = false;
	var bossCardName = jq('.BosscardNameInputBox').val();
    var companyName = jq('.compC').val();
    var categoryName = jq('.cateG').val();
    var regex = /^[0-9a-zA-Z\_]+/
    var specChars = regex.test(bossCardName);
    var url = jq('.selectContainer').attr('value');
	var bossname = jq('.hiddenBossname').attr('data-target');
    if (companyName !== '' && categoryName !== '' && bossCardName !== undefined && bossCardName !== '' && specChars === true && bossname === 'false') {
        jq('#editApprover').modal({
            show: true,
            keyboard: false,
            backdrop: 'static'
        });
        openModal(url);
        jq('#editApprover .modal-body').html('<iframe frameborder="0" height="100%" width="100%" marginheight="0" marginwidth="0" allowtransparency="true" src= "' + url + '"></iframe>');
        jq('#editApprover .modal-dialog').width('600px');
		jq('#editApprover .modal-dialog').height('545px');
		jq('#editApprover .modal-dialog').css({
			'margin-top': '2%',
			'z-index': '999'
		});
    } else {
        jq('#editApprover').modal('hide');
    }	
}

/* Below function contains the script which has the tooltip functionality. This function is called when the rerendering happens and the script will run again */
function hilightTaskScript(){
	jq(".info").tooltip({ position: { my: 'center top', at: 'center bottom+10' }});
	jq(".deleteChannel").tooltip({ position: { my: 'center top', at: 'center bottom+10' }});	
	jq(".arrow-left").tooltip({ position: { my: 'left top', at: 'center bottom+10' },tooltipClass:'ui-lefttip'}); 
	jq(".aTabs").find("input[type=checkbox]:checked").closest(".aTabs").addClass("active");
}
set();

var mainPageUnsaved = false;
var fileUploadUnsaved = false;
var modalCloseClicked = false;
var imgUploadedStatus = false;
var OldBosscardNameVal = "";
var NewBosscardNameVal = "";
var uploadImgFilePath = "";

jq(function(){
   OldBosscardNameVal = jq(".BosscardNameInputBox ").val();
   jq(":input").change(function() {
		mainPageUnsaved = true;
	});
	editorObj = CKEDITOR.instances;
	 
	for (prop in editorObj) {
		if(editorObj.hasOwnProperty(prop)){
      		defineOnchange(CKEDITOR.instances, prop);
		}
     }
  
  	function defineOnchange(CKEDITORObj, index){
	    CKEDITORObj[index].on("change", function() {
	      mainPageUnsaved = true
	    });
  	}
});

 function changeAlert(){
	mainPageUnsaved = true;
 }
 
 function changeAlertBosscardName(){
	 CurrentBosscardNameVal = jq(".BosscardNameInputBox ").val();
	 
	 if( OldBosscardNameVal !== CurrentBosscardNameVal){
		mainPageUnsaved= true;
	  
	}else{
		mainPageUnsaved = false;
		OldBosscardNameVal = CurrentBosscardNameVal;
	}
 }

function uploadPageUnload()
{ 
	if(fileUploadUnsaved){
		return IPMApp.wmessage;
	}           
} 

function mainPageUnload()
{ 
	if(mainPageUnsaved){
		return IPMApp.wmessage;
	}           
} 

function unloadPage()
{ 
	if(modalCloseClicked === false){
		if(fileUploadUnsaved || mainPageUnsaved || getCookie("uploadImgFilePath") !== ""){
			return IPMApp.wmessage;
		}
	}else{
		imgUploadedStatus = getCookie("imgUploaded");
		if(fileUploadUnsaved && imgUploadedStatus !== "true"){
			return IPMApp.wmessage;
		}
	}
} 

window.onbeforeunload = unloadPage;

function skipValidation() {
	mainPageUnsaved = false;
}

function getCookie(cname) {
	var name = cname + "=";
	var ca = document.cookie.split(';');
	for(var i=0; i<ca.length; i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') {
		c = c.substring(1);
		}
		if(c.indexOf(name) === 0){ 
		return c.substring(name.length,c.length);
		}
	}
	return "";
}

function deleteCookie(name) {
	document.cookie = name + '=;expires=Thu, 01 Jan 1970 00:00:01 GMT;';
}

jq(".close").click(function(){
  modalCloseClicked = true;
  FilePath = getCookie("uploadImgFilePath");
	if(FilePath !== "") { 
		fileUploadUnsaved = true;
	}else{
		fileUploadUnsaved = false;
	}
	
	if(fileUploadUnsaved){
		jq(this).removeAttr("data-dismiss");
		unloadIframe();
	}
	else{
		jq(this).attr("data-dismiss","modal");
	}
});

function unloadIframe(){
   deleteCookie("uploadImgFilePath");
  unloadPage();
}