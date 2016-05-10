/***************************************************************************
 *@Description:This script is used for is used for Consumer Evidence Concept
 *@Author: Cognizant
 *@Created Date: 23/06/2015  
**************************************************************************/
var jq = jQuery.noConflict();
/* Below function performs the Hover functionality. */
function imageloadstatus() {
    jq('.uploadImage').hover(function() {
        jq(this).find('.updateDeletimg').toggle("slide", {
            direction: "left"
        }, 100);
    });
}
/* Below function calls another function 'deleteSelCountry' which is for deleting the country */
function delCountry(country, secId) {
    deleteSelCountry(country, secId);
}
/* Below function calls another function 'addNew' which is for adding new country */
function addCon(country, secId) {
    addNew(country, secId);
}
/* Below function calls another function 'deleteImg' which is for deleting the image */
function delConceptImage(secConId,country) {
    deleteImg(secConId,country);
}
/* Below function calls another function 'deleteSelConcept' which is for deleting the concept */
function delConcept(country, secId, secConId,priority) {
    deleteSelConcept(country, secId, secConId,priority);
}
/* Below function is for adding the selected concepts and pushing to function 'createConcepts' */
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

/* Below function is for resetting the selected concepts */
function fchannelReset(e) {
    jq('.channelList').hide();
    jq(".channelList input:checkbox").each(function() {
        jq(this).prop('checked', false);
        jq(this).next('label').removeClass('selected');
    });
    createConcepts('');
}

/* Below function opens the delete concept modal */
function deleteconcept(str1, str2, str3,str4) {
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
    jq('#ipmConceptModalDelete .confirmConcept').attr('data-result4', str4);
    jq('#ipmConceptModalDelete .modal-dialog').width('600px');
    jq('#ipmConceptModalDelete .modal-dialog').height('170px');
    jq('#ipmConceptModalDelete .modal-dialog').css({
        'margin-top': '10%',
        'z-index': '999'
    });
    jq(".confirmConcept").addClass("removeConcept");
}
/* Below function opens the delete country modal */
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
function selectCheckboxScript(elem1,elem2) {
    imageloadstatus();
    /* Below script works on click event. It shows the consumer evidence drop down list with the selected values. Also the checkboxes of selected values will be checked and disabled */
    jq(document).on('show.bs.dropdown', '.consumerDropdown', function() {
        jq('.channelList').show();
        var selectedValues = IPMAppCE.countryName;
        var selectedValuesArr = selectedValues.split(',');
        if (selectedValuesArr.length !== 0) {
            jq('.consumerDropdown .dropdown-menu input[type="checkbox"]').each(function() {
                var val = jq(this).attr('value');
                if (jq.inArray(val, selectedValuesArr) !== -1) {
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
    /* Below script works on click event. When clicked on remove button it calls up a function which removes the country */
    jq(document).on('click', '#ipmCountryModalDelete .removeCountry', function() {
        var questionId1 = jq(this).attr('data-result1');
        var questionId2 = jq(this).attr('data-result2');
        delCountry(questionId1, questionId2);
        jq("#ipmCountryModalDelete").modal('hide');
    });
    
/* Below script works on page load. Where if the condition is true it checks the checkbox else it will not check */
    jq('#customerChannels input[type=checkbox]').each(function() {
        var val = jq(this).attr('value');
        if (val === 'true') {
            jq(this).prop('checked', true);
        } else {
            jq(this).prop('checked', false);
        }
    });
    if((elem2 !== 'addNew' && elem2 !== 'delImage' && elem2 !== 'delConcept') || elem2 === 'blank'){

        /* Below script works on click event. If the condition is true it collapses the tab else it expands the tab */
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
    }
    else{
        jq(document).on("click", ".evidenceHead span.expico, .evidenceHead span.expico-square", function() {
            if (jq(this).closest(".cevidenceborder").find(".ipmAcrdnExpand").is(":visible") && jq(elem).closest(".cevidenceborder").find(".ipmAcrdnExpand").not(':empty')) {
                jq(this).closest(".cevidenceborder").find(".ipmAcrdnExpand").slideUp("fast");
            } else {
                jq(this).closest(".cevidenceborder").find(".ipmAcrdnExpand").slideDown("fast");
            }
        });
        jq('.ipmAcrdnExpand').each(function(){
            if(jq(this).hasClass(elem1)){
                jq(this).show();
            }
        });
        jq(".ipmAccordion").find(".evidenceHead span.expico").removeClass("fa-minus");
        jq(".ipmAccordion").find(".evidenceHead span.expico").addClass("fa-plus");
        jq(".cevidenceborder").each(function(){
            if(jq(this).find('.evidenceHead').hasClass(elem1)){
                jq(this).find(".evidenceHead span.expico").removeClass("fa-plus");
                jq(this).find(".evidenceHead span.expico").addClass("fa-minus");
            }
        });
    }
}

function getParameterByName(name, url) {
    if (!url)
    {
        url = window.location.href;
        name = name.replace(/[\[\]]/g, "\\$&");
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    }
    if (!results)
    {
        return null;
    }
    if (!results[2])
    {
        return '';
    }
        return decodeURIComponent(results[2].replace(/\+/g, " "));
}

/* Below script woks on click event. If the condition is true it un checks the check box else it checks the check box. */
    jq(document).on('click', '.filterActionscc .ipmDropresetcc', function(e) {
        e.stopPropagation();
        var selectedValues = IPMAppCE.countryName;
        jq(".channelList input:checkbox").each(function() {
            if (selectedValues.indexOf(jq(this).val()) === -1) {
                jq(this).prop('checked', false);
                jq(this).next('label').removeClass('selected');
            } else {
                jq(this).prop('checked', true);
                jq(this).next('label').addClass('selected');
            }
        });
    });
    
    /* Below script woks on click event. When clicked on remove button it calls the function 'delConcept' which removes the concept */
    jq(document).on('click', '#ipmConceptModalDelete .removeConcept', function() {
        var questionId1 = jq(this).attr('data-result1');
        var questionId2 = jq(this).attr('data-result2');
        var questionId3 = jq(this).attr('data-result3');
        var questionId4 = jq(this).attr('data-result4');
        delConcept(questionId1, questionId2, questionId3, questionId4);
        jq("#ipmConceptModalDelete").modal('hide');
    });
jq(document).ready(function() {
    selectCheckboxScript();
    jq(document).on('click', '.ccChannelList input[type="checkbox"], .ccChannelList li,.filterActionscc', function(e) {
        e.stopPropagation();
    });
    /* Below script works on click event. If the condition is true it collapses the tab else it expands the tab */
    jq(document).on("click", ".evidenceHead span.expico, .evidenceHead span.expico-square", function() {
        if (jq(this).closest(".cevidenceborder").find(".ipmAcrdnExpand").is(":visible") && jq(elem).closest(".cevidenceborder").find(".ipmAcrdnExpand").not(':empty')) {
            jq(this).closest(".cevidenceborder").find(".ipmAcrdnExpand").slideUp("fast");
        } else {
            jq(this).closest(".cevidenceborder").find(".ipmAcrdnExpand").slideDown("fast");
        }
    });
    
    var cntrys = getParameterByName('urlCountry');
    jq(".ipmAcrdnExpand").hide();
    var i=0;
    jq(".ipmAcrdnExpand").each(function(){
        if(jq(this).hasClass(cntrys)){
            jq(this).show();
            i=1;
        }
    });
    if(i === 0)
    {
        jq(".ipmAcrdnExpand:first, .ipmAcrdnExpand:first .ipmAcrdnExpand").not(':empty').show();
    }
    jq(".ipmAccordion").find(".evidenceHead span.expico").removeClass("fa-minus");
    jq(".ipmAccordion").find(".evidenceHead span.expico").addClass("fa-plus");
    j=0;
    jq(".cevidenceborder").each(function(){
        if(jq(this).find('.evidenceHead').hasClass(cntrys)){
            jq(this).find(".evidenceHead span.expico").removeClass("fa-plus");
            jq(this).find(".evidenceHead span.expico").addClass("fa-minus");
            j=1;
        }
    });   
    if(j === 0){
        jq(".ipmAccordion").find(".evidenceHead span.expico").removeClass("fa-minus");
        jq(".ipmAccordion").find(".evidenceHead span.expico").addClass("fa-plus");
        jq(".ipmAccordion").find(".evidenceHead:first span.expico").removeClass("fa-plus");
        jq(".ipmAccordion").find(".evidenceHead:first span.expico").addClass("fa-minus");
    }
    jq(document).click(function(e) {
        if (e.target.className !== 'cecList') {
            jq(".channelList").hide();
        }
    });
});