/*****************************************************************************************
 *@Description:This script used to create IPM_Assortment Strategy specific utility methods.
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
*****************************************************************************************/
/* Below script for the delete functionality */

var jq = jQuery.noConflict();
function deleteAssortment(str) {
    jq('#ipmAssortment').modal({
        show: true,
        keyboard: false,
        backdrop: 'static'
    });
    var title = jq('.deleteStrategy').attr('value');
    jq('#ipmAssortment .modal-title').html(title);
    jq('#ipmAssortment .confirmAssortment').attr('data-result', str);
    jq('#ipmAssortment .modal-dialog').width('600px');
    jq('#ipmAssortment .modal-dialog').height('170px');
    jq('#ipmAssortment .modal-dialog').css({
        'margin-top': '10%',
        'z-index': '999'
    });
    jq(".confirmAssortment").addClass("removeAssortment");
}


function setFocusOnLoad() {}
/* Below script is show the dropdown list of Assortment Strategy */
jq(document).ready(function() {
    assortmentscript();
    jq(document).on('click', '.dropdown-menu input[type="checkbox"], .dropdown-menu li', function(e) {
        e.stopPropagation();
    });
    jq(document).click(function(e) {
        if (e.target.id != 'assortList2') {
            jq("#assortList2").hide();
        }
        if (e.target.id != 'assortList1') {
            jq("#assortList1").hide();
        }
    });
    jq('.assortSelect1').click(function() {
        jq('.assortList1').show();
    });

    jq('.assortSelect2').click(function() {
        jq('.assortList2').show();
    });   
    jq(document).on('click', '#ipmAssortment .removeAssortment', function() {
        var questionId = jq(this).attr('data-result');
        DeleteAssortRecord(questionId);
        jq("#ipmAssortment").modal('hide');
    });
    
});
/* Below script is related to function calling after rerendering */
function refreshAssort(){
    jq(".ipmAcrdnExpand").hide();
    jq(".ipmAcrdnExpand:first").not(':empty').show();
    jq(".assortmentAccordion").on("click", ".expico", function() {
        if (jq(this).closest(".pHead").next(".ipmAcrdnExpand").is(":visible")) {
            jq(this).removeClass("fa-minus");
            jq(this).addClass("fa-plus");
            jq(this).closest(".pHead").next(".ipmAcrdnExpand").slideUp("fast");
        } else {
            jq(this).closest(".pHead").next(".ipmAcrdnExpand").slideDown("fast");
            jq(this).removeClass("fa-plus");
            jq(this).addClass("fa-minus");
        }
    });
    jq(".projectContainer").find(".pHead .assortmentAccordion span.expico").removeClass("fa-minus");
    jq(".projectContainer").find(".pHead .assortmentAccordion span.expico").addClass("fa-plus");
    jq(".projectContainer:first").find(".pHead .assortmentAccordion span.expico").removeClass("fa-plus");
    jq(".projectContainer:first").find(".pHead .assortmentAccordion span.expico").addClass("fa-minus");
   
}

/* Below script is used for the reset functionality of Assortment Strategy */
function resetCheckboxes(elem, selectedValues) {
    var selectedValuesArr = [];
    if (selectedValues != '' && selectedValues != undefined) {
        selectedValuesArr = selectedValues.split(',');
    }
    jq(elem).find('input:checkbox').each(function() {
        var val = jq(this).attr('value');
        if (jq.inArray(val, selectedValuesArr) != -1) {
            jq(this).prop('checked', true);
            jq(this).next('label').addClass('selected');
        } else {
            jq(this).prop('checked', false);
            jq(this).next('label').removeClass('selected');
        }
    });
}
function changeArrow(cuName,arrow,priorityNumber){
    changePrior(cuName,arrow,priorityNumber);
}
/* Below is the main function which runs onComplete of all the action functions in Assortment Strategy  */
function assortmentscript() {
    jq(document).on('click', '.createAssortmetRec', function(e) {       
        e.preventDefault();
        cusVals = jq(".chCusValue").val();
        createAssort(custChanlStr, cusVals);
    });  
     jq('.ccCheck').change(function(e) {
        if (jq('.ccListbox input[type=checkbox]:checked').length > 5) {
            jq(this).prop('checked', false);
            jq(this).next('label').removeClass('selected');
        }
    });
     
    jq(".ipmAcrdnExpand").hide();
    jq(".ipmAcrdnExpand:first").not(':empty').show();
    jq(".assortmentAccordion").on("click", ".expico", function() {
        if (jq(this).closest(".pHead").next(".ipmAcrdnExpand").is(":visible")) {
            jq(this).removeClass("fa-minus");
            jq(this).addClass("fa-plus");
            jq(this).closest(".pHead").next(".ipmAcrdnExpand").slideUp("fast");
        } else {
            jq(this).closest(".pHead").next(".ipmAcrdnExpand").slideDown("fast");
            jq(this).removeClass("fa-plus");
            jq(this).addClass("fa-minus");
        }
    });
    jq(".projectContainer").find(".pHead .assortmentAccordion span.expico").removeClass("fa-minus");
    jq(".projectContainer").find(".pHead .assortmentAccordion span.expico").addClass("fa-plus");
    jq(".projectContainer:first").find(".pHead .assortmentAccordion span.expico").removeClass("fa-plus");
    jq(".projectContainer:first").find(".pHead .assortmentAccordion span.expico").addClass("fa-minus");
    
    resetCheckboxes("#assortList1", IPMAPPAssortment.channelName);
    resetCheckboxes("#assortList2", IPMAPPAssortment.selectedValues);
    
    jq(document).on('show.bs.dropdown', '.assortChannelList1, .assortChannelList2', function() {
        var selectedValues, selectedValuesArr = [];
        if (jq(this).hasClass('assortChannelList1')) {
            jq('.assortList1').show();
            jq('.assortList2').hide();
            selectedValues = IPMAPPAssortment.channelName;
        } else if (jq(this).hasClass('assortChannelList2')) {
            jq('.assortList2').show();
            jq('.assortList1').hide();
            selectedValues = IPMAPPAssortment.selectedValues;
        }
        if (selectedValues != '' && selectedValues != undefined) {
            selectedValuesArr = selectedValues.split(',');
        }
        jq(this).find('.dropdown-menu input[type="checkbox"]').each(function() {
            var val = jq(this).attr('value');
            if (jq.inArray(val, selectedValuesArr) != -1) {
                jq(this).prop('checked', true);
                jq(this).next('label').addClass('selected');
            } else {
                jq(this).prop('checked', false);
                jq(this).next('label').removeClass('selected');
            }
        });
    });
    
    var custChanlStr = '';
    var cusStr = '';
    jq(document).on('click', '#assortChanlListDone', function() {
        var custChanlList = [];
        var ulElem = jq(this).closest('ul.dropdown-menu');
        jq(ulElem).hide();
        
        jq(this).closest('ul.dropdown-menu').find('input:checkbox:checked').each(function() {
            custChanlList.push(jq(this).val());
        });
        custChanlStr = custChanlList.toString();
        CustomChannels(custChanlStr);
    });
    
    jq(document).on('click', '#ipmAssortCusReset, #ipmAssortCustChanlReset', function() {
        var selectedValues, selectedValuesArr = [];
        if (jq(this).hasClass('ipmAssortCustChanlReset')) {
            selectedValues = IPMAPPAssortment.channelName;
        } else if (jq(this).hasClass('ipmAssortCusReset')) {
            selectedValues = IPMAPPAssortment.selectedValues;
        }
        if (selectedValues != '' && selectedValues != undefined) {
            selectedValuesArr = selectedValues.split(',');
        }
        jq(this).closest('ul.dropdown-menu').find('input:checkbox').each(function() {
            var val = jq(this).attr('value');
            if (jq.inArray(val, selectedValuesArr) != -1) {
                jq(this).prop('checked', true);
                jq(this).next('label').addClass('selected');
            } else {
                jq(this).prop('checked', false);
                jq(this).next('label').removeClass('selected');
            }
        });
    });
	jq('.ccCheck').change(function(e) {
        if (jq('.ccListbox input[type=checkbox]:checked').length > 5) {
            jq(this).prop('checked', false);
        }
    });
}