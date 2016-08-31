/***********************************************************************************
 *@Description:This script is used to fill in the Customer Channel for Gate Documents
 *@Author: Cognizant
 *@Created Date: 08/01/2015
***********************************************************************************/
var jq = jQuery.noConflict();
jq(document).ready(function() {
    /* Below script works on page load. If the condition is true it checks the checkboxes */
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
    /* Below script works on click event. If the condition is true it hides the channel list */
    jq(document).click(function(e) {
        if (e.target.id !== 'channelList') {
            jq(".channelList").hide();
        }
    });
    checkboxScript();
    selectCheckboxScript();
});
/* Below function is used to open the Delete channel modal */
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
    /* Below function works on page load. If the condition is true it checks the checkboxes and disables it and vice versa */
    function checkBoxRec1() {
        jq('.channelList').show();
        if (selectedValuesArr.length !== 0) {
            jq('.customerChannelList .dropdown-menu input[type="checkbox"]').each(function() {
                var val = jq(this).attr('value');
                if (jq.inArray(val, selectedValuesArr) !== -1) {
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
    jq(document).on('keypress', '.commentBoxsmall', function() {
        rld = true;
    });
  /* Below function works on page load. If the condition is true it checks the checkboxes and disables it and vice versa */
    function checkBoxRec() {
        if (selectedValuesArr.length !== 0) {
            jq('.customerChannelList .dropdown-menu input[type="checkbox"]').each(function() {
                var val = jq(this).attr('value');
                if (jq.inArray(val, selectedValuesArr) !== -1) {
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
    /* Below function works on page load. If the checked check boxes are greater than three then the users will not be able to check the check boxes */
    jq('.ccCheck').change(function(e) {
        if (jq('.ccListbox input[type=checkbox]:checked').length > 3) {
            jq(this).prop('checked', false);
            jq(this).next('label').removeClass('selected');
        }
    });    
    /* Below script works on click event. When clicked on remove button it calls a function which removes the Customer channels */
    jq(document).on('click', '#ipmChannelDelete .removeChannel', function() {
        var questionId = jq(this).attr('data-result');
        deleteChannel(questionId);
        jq("#ipmChannelDelete").modal('hide');
    });    
    /* Below script works on click event. If the condition is true it unchecks the check boxes and enables it and vice versa */ 
    jq(document).on('click', '.filterActionscc .ipmDropresetcc', function(e) {
        e.stopPropagation();
        jq(".channelList input:checkbox").each(function() {
            if (selectedValues.indexOf(jq(this).val()) === -1) {
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
    /* Below function works on reset functionality */
    function fchannelReset(e) {
        jq('.channelList').hide();
        jq(".channelList input:checkbox").each(function() {
            jq(this).prop('checked', false);
            jq(this).next('label').removeClass('selected');
        });
        createCustomChannels('');
    }    
    /* Below script works on tooltip functionality */
    jq(".info").tooltip({
        position: {
            my: 'center top',
            at: 'center bottom+10'
        }
    });
}

/* Below function works on page load. If the condition is true it checks the checkboxes and disables it and vice versa */
function checkboxScript() {
    var selectedValues1 = IPMAppCC.channelInfo;
    var selectedValuesArr1 = selectedValues1.split(',');

    if (selectedValuesArr1.length !== 0) {
        jq('.infoCheck input[type="checkbox"]').each(function() {

            var val = jq(this).attr('value');
            if (jq.inArray(val, selectedValuesArr1) !== -1) {
                jq(this).prop('checked', true);
                jq(this).next('label').addClass('selected');                
            } else {
                jq(this).prop('checked', false);
                jq(this).next('label').removeClass('selected');
            }
        });
    }
    /* Below script works on click event. If the condition is true the value of the checked check boxes pushed to a function */
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
    /* Below script works on tooltip functionality */
    jq(".info").tooltip({
        position: {
            my: 'center top',
            at: 'center bottom+10'
        }
    });

}
/* Below function perfoms the Image hover animation for uploading image */
function ccimageloadstatus() {
    rld = false;
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
    /* Below function pushes the value of the checked check boxes to a function */
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
/* Below function calls another function 'updateContent' which updates the selected customer channels */
function update(conId, content, type) {
    updateContent(conId, content, type);
}
/* Below function calls another function 'delChannel' which deletes the selected customer channels */
function deleteChannel(conId) {
    delChannel(conId);
}
/* Below function calls another function 'updatePriority' which updates the priority of the customer channels */
function updatePriorityScript(conId, arrow, priority) {
    updatePriority(conId, arrow, priority);
}