/***********************************************************************************
 *@Description:This script is used to fill in the Customer Channel for Gate Documents
 *@Author: Cognizant
 *@Created Date: 08/01/2015
***********************************************************************************/
var jq = jQuery.noConflict();
jq(document).ready(function() {
    /* Below code is to check the checkboxes */
    jq('#customerChannels input[type=checkbox]').each(function() {
        var val = jq(this).attr('value');
        if (val === 'true') {
            jq(this).prop('checked', true);
        } else {
            jq(this).prop('checked', false);
        }
    });
    jq(document).on('click', '.ccChannelList input[type="checkbox"], .ccChannelList li', function(e) {
        e.stopPropagation();
    });
    jq(document).click(function(e) {
        if (e.target.id != 'channelList') {
            jq(".channelList").hide();
        }
    });
    checkboxScript();
    selectCheckboxScript();
});
/* Below code is to open the Delete channel modal */
function deletecc(str) {
    jq('#ipmChannelDelete').modal({
        show: true,
        keyboard: false,
        backdrop: 'static'
    });
    var title = jq('.deleteChannel').attr('title');
    jq('#ipmChannelDelete .modal-title').html(title);
    jq('#ipmChannelDelete .confirmChannel').attr('data-result', str);
    jq('#ipmChannelDelete .modal-dialog').width('600px');
    jq('#ipmChannelDelete .modal-dialog').height('170px');
    jq('#ipmChannelDelete .modal-dialog').css({
        'margin-top': '10%',
        'z-index': '999'
    });
    jq(".confirmChannel").addClass("removeChannel");
}
function selectCheckboxScript() {
    ccimageloadstatus();
    var selectedValues = IPMAppCC.channelName;
    var selectedValuesArr = selectedValues.split(',');
    /* Below code is to show the Customer channels list */
    function checkBoxRec1() {
        jq('.channelList').show();
        if (selectedValuesArr.length != 0) {
            jq('.customerChannelList .dropdown-menu input[type="checkbox"]').each(function() {
                var val = jq(this).attr('value');
                if (jq.inArray(val, selectedValuesArr) != -1) {
                    jq(this).prop('checked', true);
                    jq(this).prop('disabled', true);
                    jq(this).next('label').addClass('selected');
					jq(this).next('label').addClass('disabled');
                } else {
                    jq(this).prop('checked', false);
                    jq(this).next('label').removeClass('selected');
                    jq(this).prop('disabled', false);
					jq(this).next('label').removeClass('disabled');
                }
            });
        }
    }
    /* Below code is to check the selected customer channels */
    function checkBoxRec() {
        if (selectedValuesArr.length != 0) {
            jq('.customerChannelList .dropdown-menu input[type="checkbox"]').each(function() {
                var val = jq(this).attr('value');
                if (jq.inArray(val, selectedValuesArr) != -1) {
                    jq(this).prop('checked', true);
                    jq(this).prop('disabled', true);
                    jq(this).next('label').addClass('selected');
					jq(this).next('label').addClass('disabled');
                } else {
                    jq(this).prop('checked', false);
					jq(this).prop('disabled', false);
                    jq(this).next('label').removeClass('selected');
					jq(this).next('label').removeClass('disabled');
                }
            });
        }
    }
    jq(document).on('show.bs.dropdown', '.customerChannelList', function() {
        checkBoxRec1();
    });
    checkBoxRec();
    jq('.ccCheck').change(function(e) {
        if (jq('.ccListbox input[type=checkbox]:checked').length > 3) {
            jq(this).prop('checked', false);
            jq(this).next('label').removeClass('selected');
        }
    });
    /* Below code is to remove the Customer channels */
    jq(document).on('click', '#ipmChannelDelete .removeChannel', function() {
        var questionId = jq(this).attr('data-result');
        deleteChannel(questionId);
        jq("#ipmChannelDelete").modal('hide');
    });
    /* Below code is to reset the selected the customer channel list */
    jq(document).on('click', '.filterActionscc .ipmDropresetcc', function(e) {
        e.stopPropagation();
        jq(".channelList input:checkbox").each(function() {
            if (selectedValues.indexOf(jq(this).val()) == -1) {
                jq(this).prop('checked', false);
				jq(this).prop('disabled', false);
                jq(this).next('label').removeClass('selected');
				jq(this).next('label').removeClass('disabled');
            } else {
                jq(this).prop('checked', true);
				jq(this).prop('disabled', true);
                jq(this).next('label').addClass('selected');
				jq(this).next('label').addClass('disabled');
            }
        });
    });
    function fchannelReset(e) {
        jq('.channelList').hide();
        jq(".channelList input:checkbox").each(function() {
            jq(this).prop('checked', false);
            jq(this).next('label').removeClass('selected');
        });
        createCustomChannels('');
    }
    jq(".info").tooltip({
        position: {
            my: 'center top',
            at: 'center bottom+10'
        }
    });
}

/* Below code is to check the selected customer channels */
function checkboxScript() {
    var selectedValues1 = IPMAppCC.channelInfo;
    var selectedValuesArr1 = selectedValues1.split(',');

    if (selectedValuesArr1.length != 0) {
        jq('.infoCheck input[type="checkbox"]').each(function() {

            var val = jq(this).attr('value');
            if (jq.inArray(val, selectedValuesArr1) != -1) {
                jq(this).prop('checked', true);
                jq(this).next('label').addClass('selected');				
            } else {
                jq(this).prop('checked', false);
                jq(this).next('label').removeClass('selected');
            }
        });
    }
    jq(document).on('click', '.ipmCheckbox.infoCheck > input[type="checkbox"]', function() {
        var channelM = [];
        jq('.infoCheck input[type="checkbox"]').each(function() {
            var val = jq(this).attr('value');
            var conName;
            if (jq(this).is(":checked")) {
                channelM.push(jq(this).val());
            }
            conName = channelM.toString();
            updateInfoLogo(conName);
        });
    });
    jq(".info").tooltip({
        position: {
            my: 'center top',
            at: 'center bottom+10'
        }
    });

}
/* Below code is used for the Image hover for uploading image */
function ccimageloadstatus() {
    jq('.uploadImage').hover(function() {
        jq(this).find('.updateDeletimg').toggle("slide", {
            direction: "left"
        }, 100);
    });
    jq('.uploadImage').hover(function() {
        jq(this).find('.imgloader1').toggle("slide", {
            direction: "left"
        }, 100);
    });
}
/* Below code is add the selected customer channels */
function fchannelM() {
    var conName;
    var channelM;
    channelM = [];
    jq('.channelList').hide();
    jq(".channelList input:checkbox:checked").each(function() {
        channelM.push(jq(this).val());
    });
    conName = channelM.toString();
    createCustomChannels(conName);
}
/* Below code is to update the selected customer channels */
function update(conId, content, type) {
    updateContent(conId, content, type);
}
/* Below code is to delete the selected customer channels */
function deleteChannel(conId) {
    delChannel(conId);
}
/* Below code is to update the priority of the customer channels */
function updatePriorityScript(conId, arrow, priority) {
    updatePriority(conId, arrow, priority);
}