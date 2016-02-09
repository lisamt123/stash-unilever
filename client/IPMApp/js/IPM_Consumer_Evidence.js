/***************************************************************************
 *@Description:This script is used for is used for Consumer Evidence Concept
 *@Author: Cognizant
 *@Created Date: 23/06/2015  
**************************************************************************/
var jq = jQuery.noConflict();
/* Below script is for the Image Hover functionality */
function imageloadstatus() {
    jq('.uploadImage').hover(function() {
        jq(this).find('.updateDeletimg').toggle("slide", {
            direction: "left"
        }, 100);
    });
}
/* Below script is for deleting the country */
function delCountry(country, secId) {
    deleteSelCountry(country, secId);
}
/* Below script is for adding the country */
function addCon(country, secId) {
    addNew(country, secId);
}
/* Below script is for deleting the image */
function delImage(secConId) {
    deleteImg(secConId);
}
/* Below script is for deleting the concept */
function delConcept(country, secId, secConId) {
    deleteSelConcept(country, secId, secConId);
}
/* Below script is for adding the selected channels */
function fchannelM() {
    var conName;
    var channelM;
    channelM = [];
    jq('.channelList').hide();
    jq(".channelList input:checkbox:checked").each(function() {
        channelM.push(jq(this).val());
    });
    conName = channelM.toString();
    createConcepts(conName);
}
/* Below script is for resetting the selected channels */
function fchannelReset(e) {
    jq('.channelList').hide();
    jq(".channelList input:checkbox").each(function() {
        jq(this).prop('checked', false);
        jq(this).next('label').removeClass('selected');
    });
    createConcepts('');
}
/* Below script is for delete concept modal */
function deleteconcept(str1, str2, str3) {
    jq('#ipmConceptModalDelete').modal({
        show: true,
        keyboard: false,
        backdrop: 'static'
    });
    var title = jq('.deleteConcept').attr('title');
    jq('#ipmConceptModalDelete .modal-title').html(title);
    jq('#ipmConceptModalDelete .confirmConcept').attr('data-result1', str1);
    jq('#ipmConceptModalDelete .confirmConcept').attr('data-result2', str2);
    jq('#ipmConceptModalDelete .confirmConcept').attr('data-result3', str3);
    jq('#ipmConceptModalDelete .modal-dialog').width('600px');
    jq('#ipmConceptModalDelete .modal-dialog').height('170px');
    jq('#ipmConceptModalDelete .modal-dialog').css({
        'margin-top': '10%',
        'z-index': '999'
    });
    jq(".confirmConcept").addClass("removeConcept");
}
/* Below script is for delete country modal */
function deleteCountry(str1, str2) {
    jq('#ipmCountryModalDelete').modal({
        show: true,
        keyboard: false,
        backdrop: 'static'
    });
    var title = jq('.deleteCountry').attr('title');
    jq('#ipmCountryModalDelete .modal-title').html(title);
    jq('#ipmCountryModalDelete .confirmCountry').attr('data-result1', str1);
    jq('#ipmCountryModalDelete .confirmCountry').attr('data-result2', str2);
    jq('#ipmCountryModalDelete .modal-dialog').width('600px');
    jq('#ipmCountryModalDelete .modal-dialog').height('170px');
    jq('#ipmCountryModalDelete .modal-dialog').css({
        'margin-top': '10%',
        'z-index': '999'
    });
    jq(".confirmCountry").addClass("removeCountry");
}
function selectCheckboxScript() {
    imageloadstatus();
    /* Below script is to show the consumer evidence dropdown */
    jq(document).on('show.bs.dropdown', '.consumerDropdown', function() {
        jq('.channelList').show();
        var selectedValues = IPMAppCE.countryName;
        var selectedValuesArr = selectedValues.split(',');
        if (selectedValuesArr.length != 0) {
            jq('.consumerDropdown .dropdown-menu input[type="checkbox"]').each(function() {
                var val = jq(this).attr('value');
                if (jq.inArray(val, selectedValuesArr) != -1) {
                    jq(this).prop('checked', true);
                    jq(this).prop('disabled', true);
                    jq(this).next('label').addClass('selected');
                } else {
                    jq(this).prop('checked', false);
                    jq(this).next('label').removeClass('selected');
                    jq(this).prop('disabled', false);
                }
            });
        }
    });
    /* Below script is for resetting the selected channels */
    jq(document).on('click', '.filterActionscc .ipmDropresetcc', function(e) {
        e.stopPropagation();
		var selectedValues = IPMAppCE.countryName;
        jq(".channelList input:checkbox").each(function() {
            if (selectedValues.indexOf(jq(this).val()) == -1) {
                jq(this).prop('checked', false);
                jq(this).next('label').removeClass('selected');
            } else {
                jq(this).prop('checked', true);
                jq(this).next('label').addClass('selected');
            }
        });
    });
    /* Below script is to remove the concept */
    jq(document).on('click', '#ipmConceptModalDelete .removeConcept', function() {
        var questionId1 = jq(this).attr('data-result1');
        var questionId2 = jq(this).attr('data-result2');
        var questionId3 = jq(this).attr('data-result3');
        delConcept(questionId1, questionId2, questionId3);
        jq("#ipmConceptModalDelete").modal('hide');
    });
    /* Below script is to remove the country */
    jq(document).on('click', '#ipmCountryModalDelete .removeCountry', function() {
        var questionId1 = jq(this).attr('data-result1');
        var questionId2 = jq(this).attr('data-result2');
        delCountry(questionId1, questionId2);
        jq("#ipmCountryModalDelete").modal('hide');
    });
    jq('#customerChannels input[type=checkbox]').each(function() {
        var val = jq(this).attr('value');
        if (val === 'true') {
            jq(this).prop('checked', true);
        } else {
            jq(this).prop('checked', false);
        }
    });
    /* Below script is for the accordion functionality */
    jq(".ipmAcrdnExpand").show();
    jq(document).on("click", ".evidenceHead span.expico, .evidenceHead span.expico-square", function() {
        if (jq(this).closest(".cevidenceborder").find(".ipmAcrdnExpand").is(":visible") && jq(elem).closest(".cevidenceborder").find(".ipmAcrdnExpand").not(':empty')) {
            jq(this).closest(".cevidenceborder").find(".ipmAcrdnExpand").slideUp("fast");
        } else {
            jq(this).closest(".cevidenceborder").find(".ipmAcrdnExpand").slideDown("fast");
        }
    });
	jq(".ipmAccordion").find(".evidenceHead span.expico").removeClass("fa-plus");
    jq(".ipmAccordion").find(".evidenceHead span.expico").addClass("fa-minus");
   
}
jq(document).ready(function() {
    selectCheckboxScript();
    jq(document).on('click', '.ccChannelList input[type="checkbox"], .ccChannelList li,.filterActionscc', function(e) {
        e.stopPropagation();
    });
	/* Below script is for the accordion functionality */
    jq(".ipmAcrdnExpand").hide();
    jq(".ipmAcrdnExpand:first, .ipmAcrdnExpand:first .ipmAcrdnExpand").not(':empty').show();
    jq(document).on("click", ".evidenceHead span.expico, .evidenceHead span.expico-square", function() {
        if (jq(this).closest(".cevidenceborder").find(".ipmAcrdnExpand").is(":visible") && jq(elem).closest(".cevidenceborder").find(".ipmAcrdnExpand").not(':empty')) {
            jq(this).closest(".cevidenceborder").find(".ipmAcrdnExpand").slideUp("fast");
        } else {
            jq(this).closest(".cevidenceborder").find(".ipmAcrdnExpand").slideDown("fast");
        }
    });
    jq(".ipmAccordion").find(".evidenceHead span.expico").removeClass("fa-minus");
    jq(".ipmAccordion").find(".evidenceHead span.expico").addClass("fa-plus");
    jq(".ipmAccordion").find(".evidenceHead:first span.expico").removeClass("fa-plus");
    jq(".ipmAccordion").find(".evidenceHead:first span.expico").addClass("fa-minus");
    jq(document).click(function(e) {
        if (e.target.className != 'cecList') {
            jq(".channelList").hide();
        }
    });
});