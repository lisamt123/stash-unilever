/***********************************************************************
 *@Description:This script is used for bosscard page specific interaction
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
***********************************************************************/
var jq = jQuery.noConflict();
/* Below script is for the Tab Functionality */
jq(document).ready(function() {
    var statusTab = jq('#ipmupdateStatusTab');
    statusTab.parent().find('.ipmStatusContent').hide();
    jq('#ipmupdateStatusTab .ipmstatusTabs li:first').addClass('active');
    statusTab.parent().find('.ipmStatusContent:first').show();
    jq('#ipmupdateStatusTab .ipmstatusTabs li').on('click', function(e) {
        e.preventDefault();
        jq('#ipmupdateStatusTab .ipmstatusTabs li').removeClass('active');
        var $this = jq(this);
        var getId = $this.attr('class');
        statusTab.parent().find('.ipmStatusContent').hide();
        $this.addClass('active');
        jq('#' + getId).fadeIn("fast");
    });
    jq(".saveBosscard").click(function() {
        jq(".floatedMsg").animate({
            "opacity": 0
        }, 1000).hide();
    });
    jq('.duplicateName').hide();
    var accordion = jq(".ipmAccordion");
    accordion.find(".ipmAcrdnExpand").not(':empty').slideDown("fast");
    accordion.find(".pHead .expico").removeClass("fa-plus");
    accordion.find(".pHead .expico").addClass("fa-minus");
    jq(".custBossPadding").hover(function() {
        jq('.imgHoverContainer').stop();
        jq('.imgHoverContainer').show(200);
    }, function() {
        jq('.imgHoverContainer').stop();
        jq('.imgHoverContainer').hide(100);
    });
    jq(".brandautocomplete").autocomplete({
        source: apexAccountList,
        select: function(event, ui) {
            selectedObj = ui.item;
        },
        minLength: 1
    });
    var defaults = {
        quarterOffset: 0,
        yearsIntoPast: 20
    };
    jq(".quarterForward").quarterpicker(jq.extend({}, defaults, {
        quarterOffset: 1
    }));
    jq("button").button();

    jq(document).on('click', '.actionBox', function() {
        var url = jq(this).attr('value');
        window.top.location.href = url;
    });
    jq(document).on('click', '.uploadImage', function() {
        callsave();
    });	
});
/* Below script is for Edit Approver modal */
jq(document).on('click', '.selectContainer', function(e) {
    
});
/* Below script is for Remove Approver modal */
jq(document).on('click', '.editApprover', function(e) {
    e.preventDefault ? e.preventDefault() : e.returnValue = false;
    jq('#removeApprover .modal-dialog').width('600px');
    jq('#removeApprover .modal-dialog').height('200px');
    jq('#removeApprover .modal-dialog').css({
        'margin-top': '10%',
        'z-index': '999'
    });
});
/* Below script is for Remove Image modal */
jq(document).on('click', '.imgDelButton', function(e) {
    e.preventDefault ? e.preventDefault() : e.returnValue = false;
    jq('#deleteImgPop .modal-dialog').width('600px');
    jq('#deleteImgPop .modal-dialog').height('180px');
    jq('#deleteImgPop .modal-dialog').css({
        'margin-top': '10%',
        'z-index': '999'
    });
});
/* Below script is validate for Change status Modal */
function checkValidation() {
    var bossCardName = jq('.BosscardNameInputBox').val();
    var companyName = jq('.compC').val();
    var categoryName = jq('.cateG').val();
    var regex = /^[0-9a-zA-Z\_]+/
    var specChars = regex.test(bossCardName);
    var url = jq('.updateBox').attr('value');
	var bossname = jq('.hiddenBossname').attr('data-target');
    if (companyName != '' && categoryName != '' && bossCardName != undefined && bossCardName != '' && specChars == true && bossname == 'false') {
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
/* Below script is close the Modal */
jq("#ipmModal .close").click(function() {
    parent.location.assign(IPMApp.bossurl + '?Id=' + IPMApp.bosscardId);
});
/* Below script is to Create New Project */
function createPro() {
    Visualforce.remoting.Manager.invokeAction(
        IPMApp.RemoteAction,IPMApp.bosscardId,
        function(result, event) {
            if (event.status) {
                if (event.result != null) {
                    window.top.location.href = IPMApp.projecturl + '?Pid=' + event.result;
                } else {
                    alert(IPMApp.systemMsg);
                }
            }
        }
    );
}
function upldImage(){
	var bossCardName = jq('.BosscardNameInputBox').val();
    var companyName = jq('.compC').val();
    var categoryName = jq('.cateG').val();
    var regex = /^[0-9a-zA-Z\_]+/
    var specChars = regex.test(bossCardName);
    var url = jq('.uploadImage').attr('value');
	var bossname = jq('.hiddenBossname').attr('data-target');
    if (companyName != '' && categoryName != '' && bossCardName != undefined && bossCardName != '' && specChars == true && bossname == 'false') {
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
    } else {
        jq('#ipmModal').modal('hide');
    }
}

function slctApprover(){
	var bossCardName = jq('.BosscardNameInputBox').val();
    var companyName = jq('.compC').val();
    var categoryName = jq('.cateG').val();
    var regex = /^[0-9a-zA-Z\_]+/
    var specChars = regex.test(bossCardName);
    var url = jq('.selectContainer').attr('value');
	var bossname = jq('.hiddenBossname').attr('data-target');
    if (companyName != '' && categoryName != '' && bossCardName != undefined && bossCardName != '' && specChars == true && bossname == 'false') {
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
set();