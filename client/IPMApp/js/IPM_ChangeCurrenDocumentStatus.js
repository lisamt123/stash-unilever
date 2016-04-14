/*********************************************************************************************
 *@Description:This script is used for change current document status page specific interaction
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
*********************************************************************************************/
var jq = jQuery.noConflict();
jq.browser = {};
/* Below script is for the date picker Functionality */
jq(document).ready(function() {
	//jq(".proInitLoader").show().delay(1500).fadeOut();
    changeCurrentStatus(IPMApp.gateStatus);
    gkmComplete();
    var dateFormat = "dd/mm/yyyy";
    var slider4 = jq(".slider4");
    jq('.date').datepicker({
        format: dateFormat,
        autoclose: true,
        startDate: new Date(),
        startView: 0,
    });
	jq('.ipmStatusTabs').find('li:first').addClass("active").find('label').addClass("selected");
	jq('.ipmStatusTabs li').each(function(){
		if(jq(this).children('span').hasClass('Postponed') && status == IPMApp.Postponed){
			jq('.ipmStatusTabs li').removeClass('active').find('label').removeClass("selected");;
			jq(this).addClass("active").find('label').addClass("selected");	
		}
	});
		
    /* Below script is for the Approver with Edits Modal */
    jq(document).on('click', '.apprWithEdits', function(e) {
        e.preventDefault ? e.preventDefault() : e.returnValue = false;
        var url = jq(this).attr('value');
        jq('#ipmModalApproveEdits .modal-dialog').width('60%');
        jq('#ipmModalApproveEdits .modal-dialog').height('220px');
        jq('#ipmModalApproveEdits .modal-dialog').css({
            'margin-top': '10%',
            'z-index': '999'
        });
    });
    /* Below script is for the Tab Functionality */
    jq(".ipmStatusTabs").on("click", 'li', function() {
		jq(".proInitLoader").show().delay(1000).fadeOut();
        var $this = jq(this);
        var statTabList = jq('.ipmStatusTabs').find('li');
        statTabList.removeClass('active');
        statTabList.removeClass('stop_active');
        $this.parents('.sliderDiv').next().find('.changeStatusPage').removeClass('stopBG');
        jq("#legend label").removeClass('selected');
        var lpos = jq(".ipmRadioButton label").offset().left;
        $this.find(".ipmRadioButton label").addClass('selected');
        $this.addClass('active');
        if ($this.find(".ipmRadioButton label").next("input").val() == IPMApp.Stopped) {
            $this.addClass('stop_active');
            $this.parents('.sliderDiv').next().find('.changeStatusPage').addClass('stopBG');
        }
        if (status == IPMApp.Postponed) {
            slider4.find("label:first").off("click").css("cursor", "default");
            slider4.find('input[value=' + IPMApp.Postponed + ']').prop("checked", true);
        }
    });
    /*if (status == IPMApp.Postponed) {
		alert('inside1');
        slider4.find("label:first").off("click").css("cursor", "default");
        slider4.find('input[value=' + IPMApp.Postponed + ']').prop("checked", true);
    }*/
    if (jq("label[for=statusRadioBtn_2]").text().indexOf(IPMApp.Stopped) != -1) {
        jq("label[for=statusRadioBtn_2]").css({
            'text-align': 'right',
            'right': '-30px'
        });
    }
    if (status == IPMApp.inProgress) {
        jq(".ui-slider-handle").css("left", "0%");
        jq("label[for=statusRadioBtn_0]").css({
            'color': '#e98824'
        });
    }
    if (status == IPMApp.Proposed) {
        jq("label[for=statusRadioBtn_0]").css({
            'color': '#e98824'
        });
    }
    if (status == IPMApp.Postponed) {
        jq(".ui-slider-handle").css("left", "66.66%");
        jq("label[for=statusRadioBtn_2]").css({
            'color': '#e98824'
        });
    }
    if (status == IPMApp.Stopped) {
        jq(".ui-slider-handle").css("left", "100%");
        jq("label[for=statusRadioBtn_2]").css({
            'color': '#e98824'
        });
    }
});
/* Below script is validate the status and navigate to respective pages */
function goToParentPage() {
    if (window.location.search.indexOf('ipmProjectOverview') > -1) {
		window.top.location.href = IPMApp.ProjectOverviewPage + '?id=' + IPMApp.projectId;
    } else {
		if (status == IPMApp.Stopped && makeStop == true) {
            window.top.location.href = IPMApp.ProjectOverviewPage + '?id=' + IPMApp.projectId;
        } else if (status == IPMApp.Proposed && makeValid == true) {
            window.top.location.href = IPMApp.GateDocumentPage + '?id=' + IPMApp.projectId + '&printDoc=' + IPMApp.projectDoc;
        } else if (status == IPMApp.Postponed && makePostpone == true) {
            window.top.location.href = IPMApp.GateDocumentPage + '?id=' + IPMApp.projectId + '&printDoc=' + IPMApp.projectDoc;
        } else if (status == IPMApp.Approved && makeApprove == true && IPMApp.projectPhase == 'Ideas') {
            window.top.location.href = IPMApp.ProjectOverviewPage + '?id=' + IPMApp.projectId + '&showMembers=true&createBET=true';
		} else if (status == IPMApp.Approved && makeApprove == true) {
			window.top.location.href = IPMApp.ProjectOverviewPage + '?id=' + IPMApp.projectId;
        } else if (status == IPMApp.ApprovedEdit && makeValid == true) {
            window.top.location.href = IPMApp.GateDocumentPage + '?id=' + IPMApp.projectId + '&printDoc=' + IPMApp.projectDoc;
        }
    }
}
function gkmComplete() {
    /* Below script is for the project panel modal */
    jq(document).on('click', '.projectBKProcess', function(e) {
        e.preventDefault ? e.preventDefault() : e.returnValue = false;
        jq('#initiateProjectBKPanel .modal-dialog').width('500px');
        jq('#initiateProjectBKPanel .modal-dialog').height('200px');
        jq('#initiateProjectBKPanel .modal-dialog').css({
            'margin-top': '2%',
            'z-index': '999'
        });
    });
    /* Below script is for the Tool tip for all status */
    jq('.gkm input[type=radio]').each(function(e) {
        jq(this).click(function() {
            var redData = jq(this).attr("value").split(" ");
            var actData = redData[0];
            jq(".approveToolTip").hide();
            jq("#" + actData).show();
        });
    });
    jq('.proroute input[type=radio]').each(function(e) {
        jq(this).click(function() {
            var redData = jq(this).attr("value").split(" ");
            var actData = redData[0];
            jq(".routeTip").hide();
            jq("#" + actData).show();
        });
    });
    jq('.gkm input[type=radio]').each(function(i) {
        var rdChecked = jq('.ipmApproveButtons input[type=radio]:checked').attr("value").split(" ");
        var rdData = rdChecked[0];
        jq("#" + rdData).show();
    });
    jq('.proroute input[type=radio]').each(function(i) {
        var rdChecked = jq('.proroute input[type=radio]:checked').attr("value").split(" ");
        var rdData = rdChecked[0];
        jq("#" + rdData).show();
    });
}
/* Below script is to change the status */
function changeCurrentStatus(changestatus) {
    jq("[id$=mlktp]").hide();
    jq('.date .dateInput .dateFormat').hide();
    var items = [IPMApp.inProgress, IPMApp.Proposed, IPMApp.Stopped];
    var itemsProposed = [IPMApp.Proposed, IPMApp.Stopped, IPMApp.Postponed, IPMApp.ApprovedEdit, IPMApp.Approved];
    var s = jq("#slider");
    var status = changestatus;
    var PointerT = 100 / (items.length - 1);
    var PointerF = 100 / (itemsProposed.length - 1);
    if (status == IPMApp.Proposed || status == IPMApp.Postponed) {
        s.slider({
            min: 1,
            max: itemsProposed.length,
            animate: 'slow',
            stop: function(event, ui) {
                var pointer = ui.value - 1;
                jq('#statusRadioBtn_' + ui.value).prop('checked', true);

                jq("label").css({
                    'color': 'rgb(34, 34, 34)'
                });
                jq("label[for=statusRadioBtn_" + pointer + "]").css({
                    'color': '#e98824'
                });
                if (status == 'Postponed' && pointer == 0) {
                    jq('.ui-slider-handle').animate({
                        'left': '66.66%'
                    }, 100);
                    jq("label[for=statusRadioBtn_0").css({
                        'color': 'rgb(34, 34, 34)'
                    });
                    jq("label[for=statusRadioBtn_2").css({
                        'color': '#e98824'
                    });
                    jq("label[for=statusRadioBtn_3").css({
                        'color': '#e98824'
                    });

                    changeStatus(itemsProposed[ui.value + 1]);
                }
                if (status == IPMApp.Postponed && itemsProposed[ui.value - 1] != IPMApp.Proposed) {
                    changeStatus(itemsProposed[ui.value - 1]);
                } else if (status == IPMApp.Proposed) {
                    changeStatus(itemsProposed[ui.value - 1]);
                }
            }
        });
        jq("#changeStatus_links").addClass("slider4");
        jq("#changeStatus").addClass("slider4");
        jq.each(itemsProposed, function(key, value) {
            var w = PointerF;
            if (key === 0 || key === itemsProposed.length - 1){
                w = PointerF / 2;
				}
            jq("#legend .ipmStatusTabs").append("<li><span class='" + value + "'></span><span class='StatusLabel'>" + value + "</span><div class='ipmRadioButton'><label for='statusRadioBtn_" + key + "'></label><input type='radio' name='gateStatus' value='" + value + "' id='statusRadioBtn_" + key + "' /></div></li>");
        });
    } else {
        s.slider({
            min: 1,
            max: items.length,
            animate: 'slow',
            stop: function(event, ui) {
                var pointer = ui.value - 1;
                jq('#statusRadioBtn_' + ui.value).prop('checked', true);
                jq("label").css({
                    'color': 'rgb(34, 34, 34)'
                });
                jq("label[for=statusRadioBtn_" + pointer + "]").css({
                    'color': '#e98824'
                });
                if (status == IPMApp.Proposed || status == IPMApp.Postponed) {
                    changeStatus(items[ui.value - 1]);
                } else {
                    changeStatus(items[ui.value - 1]);
                }
            }
        });
        jq("#changeStatus_links").addClass("slider3");
        jq("#changeStatus").addClass("slider3");
        jq.each(items, function(key, value) {
            var w = PointerT;
            if (key === 0 || key === items.length - 1){
                w = PointerT / 2;
				}
            jq("#legend .ipmStatusTabs").append("<li><span class='" + value + "'></span><span class='StatusLabel'>" + value + "</span><div class='ipmRadioButton'><label for='statusRadioBtn_" + key + "'></label><input type='radio' name='gateStatus' value='" + value + "' id='statusRadioBtn_" + key + "' /></div></li>");
        });
    }
}