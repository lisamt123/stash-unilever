/***********************************************************************
 *@Description:This script used for the Gate CMI section in Gate Document
 *@Author: Cognizant
 *@Created Date: 08/01/2015
************************************************************************/
var jq = jQuery.noConflict();
/* Below code is for the reset functionality for CMI list and Country list */
jq(document).on('click', '.cmiListreset', function(e) {
    e.stopPropagation();
    var selectedValues = IPMAPPCMI.concepts;
    jq(".CMIList input:checkbox").each(function() {
        if (selectedValues.indexOf(jq(this).val()) == -1) {
            jq(this).prop('checked', false);
            jq(this).next('label').removeClass('selected');
        } else {
            jq(this).prop('checked', true);
            jq(this).next('label').addClass('selected');
        }
    });
});
jq(document).on('click', '.cmiCountryreset', function(e) {
    e.stopPropagation();
    var testvar = jq(this).parents('.cmiCountrySelector').find('.clickDrop').attr("data-list");
    var listValues = testvar;
    jq(".CMICountryList input:checkbox").each(function() {
        if (listValues.indexOf(jq(this).val()) == -1) {
            jq(this).prop('checked', false);
            jq(this).next('label').removeClass('selected');
        } else {
            jq(this).prop('checked', true);
            jq(this).next('label').addClass('selected');
        }
    });
});
/* Below code is for the dropdown functionality for CMI list and Country list */
jq(document).click(function(e) {
    if (e.target.id != 'CMIList') {
        jq(".CMIList").hide();
    }
});
var testStr = '',
    countryStr = '';
jq(document).on('click', '.CMIList input[type="checkbox"], .CMIList li', function(e) {
    e.stopPropagation();
});
jq(document).click(function(e) {
    if (e.target.id != 'CMICountryList') {
        jq(".CMICountryList").hide();
    }
});
jq(document).on('click', '.CMICountryList input[type="checkbox"], .CMICountryList li', function(e) {
    e.stopPropagation();
});
/* Below code is for the accordion functionality */
jq(document).ready(function() {
    jq(".ipmAcrdnExpand").hide();
    jq(".ipmAcrdnExpand:first").not(':empty').show();
    jq(document).on("click", ".ipmAccordian .expico", function() {
        if (jq(this).closest(".aHead").next(".ipmAcrdnExpand").is(":visible") && jq(this).closest(".aHead").next(".ipmAcrdnExpand").not(':empty')) {
            jq(this).closest(".aHead").next(".ipmAcrdnExpand").slideUp("fast");
            jq(this).removeClass("fa-minus");
            jq(this).addClass("fa-plus");
        } else {
            jq(this).closest(".aHead").next(".ipmAcrdnExpand").slideDown("fast");
            jq(this).removeClass("fa-plus");
            jq(this).addClass("fa-minus");
        }
    });
    jq(".ipmAccordianDiv").find(".aHead span.expico").removeClass("fa-minus");
    jq(".ipmAccordianDiv").find(".aHead span.expico").addClass("fa-plus");
	jq(".CMIGateDoc .ipmAccordianDiv:first").find(".aHead:first span.expico").removeClass("fa-plus");
    jq(".CMIGateDoc .ipmAccordianDiv:first").find(".aHead:first span.expico").addClass("fa-minus");
	jq(".cmiListcont .subCmi").find(".aHead span.expico").removeClass("fa-minus");
	jq(".cmiListcont .subCmi").find(".aHead span.expico").addClass("fa-plus");
    skipTestrender();
});
/* Below code is for adding the CMI and Country values */
function addTest() {
    var cmiTestList = [];
    jq('.CMIList').hide();
    jq(".CMIList input:checkbox:checked").each(function() {
        cmiTestList.push(jq(this).val());
    });
    testStr = cmiTestList.toString();
    selectTest(testStr);
}
function addCountry(gateCMIId) {
    var cmiCountryList = [];
    jq('.CMICountryList').hide();
    jq(".CMICountryList input:checkbox:checked").each(function() {
        cmiCountryList.push(jq(this).val());
    });
    countryStr = cmiCountryList.toString();
    selectCountry(countryStr, gateCMIId);
}
/* Below code is to delete the CMI and Country values */
function deleteCMITest(str) {
    jq('#ipmCMIModalDelete').modal({
        show: true,
        keyboard: false,
        backdrop: 'static'
    });
    var title = jq('.deleteCMITest').attr('title');
    jq('#ipmCMIModalDelete .modal-title').html(title);
    jq('#ipmCMIModalDelete .confirmCMI').attr('data-result', str);
    jq('#ipmCMIModalDelete .modal-dialog').width('600px');
    jq('#ipmCMIModalDelete .modal-dialog').height('170px');
    jq('#ipmCMIModalDelete .modal-dialog').css({
        'margin-top': '10%',
        'z-index': '999'
    });
    jq(".confirmCMI").addClass("removeCMI");
}
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
/* Below code is to check the check boxes based on selected values*/
function skipTestrender() {
    function conceptcheck() {
        var selectedValues = IPMAPPCMI.concepts;
        var selectedValuesArr = selectedValues.split(';');
        if (selectedValuesArr.length != 0) {
            jq('.cmiTestList .dropdown-menu input[type="checkbox"]').each(function() {
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
    }
    /* Below code is to open the delete modal for both CMI list and Country */
    jq(document).on('click', '#ipmCMIModalDelete .removeCMI', function() {
        var questionId = jq(this).attr('data-result');
        deletCMI(questionId);
        jq("#ipmCMIModalDelete").modal('hide');
    });
    jq(document).on('click', '#ipmCountryModalDelete .removeCountry', function() {
        var questionId1 = jq(this).attr('data-result1');
        var questionId2 = jq(this).attr('data-result2');
        deleteContry(questionId1, questionId2);
        jq("#ipmCountryModalDelete").modal('hide');
    });
    /* Below code is to show the cmi and country dropdown */
    jq(document).on('show.bs.dropdown', '.cmiTestList', function() {
        jq(".CMIList").hide();
        jq(this).find('.CMIList').show();
        jq(".CMICountryList").hide();
        conceptcheck();
    });
    jq(document).on('show.bs.dropdown', '.cmiCountrySelector', function() {
        jq(".CMICountryList").hide();
        jq(this).find('.CMICountryList').show();
        jq(".CMIList").hide();
        var listValues = jq(this).find('.clickDrop').attr("data-list");
        var listValuesArray = listValues.split(';');
        if (listValuesArray.length != 0) {
            jq('.cmiCountrySelector .dropdown-menu input[type="checkbox"]').each(function() {
                var val = jq(this).attr('value');
                if (jq.inArray(val, listValuesArray) != -1) {
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
    jq('.ccListbox').each(function() {
        if (jq(this).val() == 'true') {
            jq(this).attr('checked', 'checked');
            jq(this).next().addClass('selected');
        }
    });
    jq(".ccListbox").click(function() {
        var status;
        var list;
        if (jq(this).prop('checked')) {
            status = "True";
            list = jq(this).attr('id');
        } else {
            status = "False";
            list = jq(this).attr('id');
        }
        skipTestScript(list, status);
    });
    /* Below code is to check the check boxes based on selected values*/
    jq(document).on('click', '.clickCmiList', function() {
        var $this = jq(this);
        var selectedValues = jq(this).attr("data-list");
        jq(".CMIList input:checkbox").each(function() {
            if (selectedValues.indexOf(jq(this).val()) == -1) {
                jq(this).prop('checked', false);
                jq(this).next('label').removeClass('selected');
            } else {
                jq(this).prop('checked', true);
                jq(this).next('label').addClass('selected');
            }
        });
    });
    jq(document).on('click', '.clickDrop', function() {
        var $this = jq(this);
        var listValues = jq(this).attr("data-list");
        var listValuesArray = listValues.split(';');
        if (listValuesArray.length != 0) {
            jq.each(listValuesArray, function(i) {
                $this.next().find("input[type='checkbox']").filter(function() {
                    return this.value == listValuesArray[i];
                }).prop("checked", "true").next('label').addClass('selected');
            });
        }
    });
}