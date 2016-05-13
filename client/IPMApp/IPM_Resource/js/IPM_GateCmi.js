/***********************************************************************
 *@Description:This script used for the Gate CMI section in Gate Document
 *@Author: Cognizant
 *@Created Date: 08/01/2015
************************************************************************/
var jq = jQuery.noConflict();
/* Below script works on click event. When clicked on reset button the recently checked checkboxes will be unchecked for CMI concepts list */
jq(document).on('click', '.cmiListreset', function(e) {
    e.stopPropagation();
    var selectedValues = IPMAPPCMI.concepts;
    jq(".CMIList input:checkbox").each(function() {
        if (selectedValues.indexOf(jq(this).val()) === -1) {
            jq(this).prop('checked', false);
            jq(this).next('label').removeClass('selected');
        } else {
            jq(this).prop('checked', true);
            jq(this).next('label').addClass('selected');
        }
    });
});
/* Below script works on click event. When clicked on reset button the recently checked checkboxes will be unchecked for CMI countries list */
jq(document).on('click', '.cmiCountryreset', function(e) {
    e.stopPropagation();
    var testvar = jq(this).parents('.cmiCountrySelector').find('.clickDrop').attr("data-list");
    var listValues = testvar;
    jq(".CMICountryList input:checkbox").each(function() {
        if (listValues.indexOf(jq(this).val()) === -1) {
            jq(this).prop('checked', false);
            jq(this).next('label').removeClass('selected');
        } else {
            jq(this).prop('checked', true);
            jq(this).next('label').addClass('selected');
        }
    });
});
/* Below script works on click event. If the condition is true it shows the dropdown for CMI list. */
jq(document).click(function(e) {
    if (e.target.id !== 'CMIList') {
        jq(".CMIList").hide();
    }
});
var testStr = '',
    countryStr = '';
jq(document).on('click', '.CMIList input[type="checkbox"], .CMIList li', function(e) {
    e.stopPropagation();
});

/* Below script works on click event. If the condition is true it shows the dropdown for Country list */
jq(document).click(function(e) {
    if (e.target.id !== 'CMICountryList') {
        jq(".CMICountryList").hide();
    }
});
jq(document).on('click', '.CMICountryList input[type="checkbox"], .CMICountryList li', function(e) {
    e.stopPropagation();
});
jq(document).ready(function() {
/* Below script works on page load. First it hides all the tabs. Then it opens only the first tab. */
    jq(".ipmAcrdnExpand").hide();
    jq(".ipmAcrdnExpand:first").not(':empty').show();
    
/* Below script is called upon click event where it expands the tab and replaces '+' with '-' or collapses a opened tab and replaces '-' with '+' */
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
    
/* Below script works on page load. It adds the + mark for the collapsed one's and adds - for the expanded one */
    jq(".ipmAccordianDiv").find(".aHead span.expico").removeClass("fa-minus");
    jq(".ipmAccordianDiv").find(".aHead span.expico").addClass("fa-plus");
    jq(".CMIGateDoc .ipmAccordianDiv:first").find(".aHead:first span.expico").removeClass("fa-plus");
    jq(".CMIGateDoc .ipmAccordianDiv:first").find(".aHead:first span.expico").addClass("fa-minus");
    jq(".cmiListcont .subCmi").find(".aHead span.expico").removeClass("fa-minus");
    jq(".cmiListcont .subCmi").find(".aHead span.expico").addClass("fa-plus");
    skipTestrender();
});
/* Below function gets the value from the checked checkboxes. Then the values will be passed to another function 'selectTest'. */
function addTest(nelem1) {
    var cmiTestList = [];
    jq('.CMIList').hide();
    jq(".CMIList input:checkbox:checked").each(function() {
        cmiTestList.push(jq(this).val());
    });
    testStr = cmiTestList.toString();
    var gate=nelem1.split(" ");
    selectTest(testStr,gate[0]);
    inputchanged = false;
}

/* Below function gets the value from the checked checkboxes. Then the values will be passed to another function 'selectCountry'. */
function addCountry(gateCMIId,nelem2) {
    var cmiCountryList = [];
    jq('.CMICountryList').hide();
    jq(".CMICountryList input:checkbox:checked").each(function() {
        cmiCountryList.push(jq(this).val());
    });
    countryStr = cmiCountryList.toString();
    var gate=nelem2.split(" ");
    selectCountry(countryStr, gateCMIId,gate[0]);
    inputchanged = false;
}
/* Below function performs the modal operation. It opens the CMI delete modal.*/
function deleteCMITest(str,val1) {
    jq('#ipmCMIModalDelete').modal({
        show: true,
        keyboard: false,
        backdrop: 'static'
    });
    var title = jq('.deleteCMITest').attr('title');
    jq('#ipmCMIModalDelete .modal-title').html(title);
    jq('#ipmCMIModalDelete .confirmCMI').attr('data-result', str);
    jq('#ipmCMIModalDelete .confirmCMI').attr('data-val1', val1);
    jq('#ipmCMIModalDelete .modal-dialog').width('600px');
    jq('#ipmCMIModalDelete .modal-dialog').height('170px');
    jq('#ipmCMIModalDelete .modal-dialog').css({
        'margin-top': '10%',
        'z-index': '999'
    });
    jq(".confirmCMI").addClass("removeCMI");
}

/* Below function performs the modal operation. It opens the CMI delete Country modal. */
function deleteCountry(str1, str2,val1) {
    jq('#ipmCountryModalDelete').modal({
        show: true,
        keyboard: false,
        backdrop: 'static'
    });
    var title = jq('.deleteCountry').attr('title');
    jq('#ipmCountryModalDelete .modal-title').html(title);
    jq('#ipmCountryModalDelete .confirmCountry').attr('data-result1', str1);
    jq('#ipmCountryModalDelete .confirmCountry').attr('data-result2', str2);
    jq('#ipmCountryModalDelete .confirmCountry').attr('data-val1', val1);
    jq('#ipmCountryModalDelete .modal-dialog').width('600px');
    jq('#ipmCountryModalDelete .modal-dialog').height('170px');
    jq('#ipmCountryModalDelete .modal-dialog').css({
        'margin-top': '10%',
        'z-index': '999'
    });
    jq(".confirmCountry").addClass("removeCountry");
}
function skipTestrender(elem1,elem2,elem3) {
    conceptcheck();
    clikevnts();
    /* Below script works on click event. When clicked on remove button it deletes the cmi by calling 'deletCMI' function and hides the modal. */
    jq(document).on('click', '#ipmCMIModalDelete .removeCMI', function() {
        var questionId = jq(this).attr('data-result');
        var typeval = jq(this).attr('data-val1');
        inputchanged = false;
        deletCMI(questionId,typeval);
        jq("#ipmCMIModalDelete").modal('hide');
    });
    
    /* Below script works on click event. When clicked on remove button it deletes the country by calling 'deleteContry' function and hides the modal. */
    jq(document).on('click', '#ipmCountryModalDelete .removeCountry', function() {
        var questionId1 = jq(this).attr('data-result1');
        var questionId2 = jq(this).attr('data-result2');
        var typeval = jq(this).attr('data-val1');
        inputchanged = false;
        deleteContry(questionId1, questionId2,typeval);
        jq("#ipmCountryModalDelete").modal('hide');
    });
    
    /* Below script works on click event. It displays the CMI list and also hides the CMI countries list. */
    jq(document).on('show.bs.dropdown', '.cmiTestList', function() {
        jq(".CMIList").hide();
        jq(this).find('.CMIList').show();
        jq(".CMICountryList").hide();
        conceptcheck();
    });
    
    /* Below function checks the checkboxes value with the backend values. If the values match the checkboxes will be checked and disables the checkbox. */
    jq(document).on('show.bs.dropdown', '.cmiCountrySelector', function() {
        jq(".CMICountryList").hide();
        jq(this).find('.CMICountryList').show();
        jq(".CMIList").hide();
        var listValues = jq(this).find('.clickDrop').attr("data-list");
        var listValuesArray = listValues.split(';');
        if (listValuesArray.length !== 0) {
            jq('.cmiCountrySelector .dropdown-menu input[type="checkbox"]').each(function() {
                var val = jq(this).attr('value');
                if (jq.inArray(val, listValuesArray) !== -1) {
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
    
    /* Below function checks the checkboxes value. If the condition is true the checkboxes will be checked. */
    jq('.ccListbox').each(function() {
        if (jq(this).val() === 'true') {
            jq(this).attr('checked', 'checked');
            jq(this).next().addClass('selected');
        }
    });   
    
    if(elem2 !== 'addNew'){
        jq(".ipmAccordianDiv").find(".aHead span.expico").removeClass("fa-minus");
        jq(".ipmAccordianDiv").find(".aHead span.expico").addClass("fa-plus");
        jq(".CMIGateDoc .ipmAccordianDiv:first").find(".aHead:first span.expico").removeClass("fa-plus");
        jq(".CMIGateDoc .ipmAccordianDiv:first").find(".aHead:first span.expico").addClass("fa-minus");
        jq(".cmiListcont .subCmi").find(".aHead span.expico").removeClass("fa-minus");
        jq(".cmiListcont .subCmi").find(".aHead span.expico").addClass("fa-plus");
    }else{
        jq(".ipmAcrdnExpand").hide();
        jq('.ipmAcrdnExpand').each(function(){
            if(jq(this).hasClass(elem1)){
                jq(this).show();
            }
        });
        jq(".ipmAccordianDiv").find(".aHead span.expico").removeClass("fa-minus");
        jq(".ipmAccordianDiv").find(".aHead span.expico").addClass("fa-plus");
        jq(".aHead").each(function(){
            if(jq(this).hasClass(elem1)){
                jq(this).find("span.expico").removeClass("fa-plus");
                jq(this).find("span.expico").addClass("fa-minus");
            }
        });
        if(elem3 !== '')
        {
            jq(".cmiListcont .ipmAcrdnExpand").hide();
            jq('.ipmAcrdnExpand').each(function(){
                if(jq(this).hasClass(elem3)){
                    jq(this).show();
                }
            });
            jq(".cmiListcont").find(".aHead span.expico").removeClass("fa-minus");
            jq(".cmiListcont").find(".aHead span.expico").addClass("fa-plus");
            jq(".aHead").each(function(){
                if(jq(this).hasClass(elem3)){
                    jq(this).find("span.expico").removeClass("fa-plus");
                    jq(this).find("span.expico").addClass("fa-minus");
                }
            });
        }
    }
}

/* Below function checks the checkboxes value with the backend values. If the values match the checkboxes will be checked and disables the checkbox. */
    function conceptcheck() {
        var selectedValues = IPMAPPCMI.concepts;
        var selectedValuesArr = selectedValues.split(';');
        if (selectedValuesArr.length !== 0) {
            jq('.cmiTestList .dropdown-menu input[type="checkbox"]').each(function() {
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
    }

function clikevnts(){
/* Below script works on click event. It checks whether the checkbox is checked or not. If it is checked it sets the status to 'True' else 'False' */
    jq(".ccListbox").click(function() {
        var status;
        var list;
        var tyval;
        var gate;
        if (jq(this).prop('checked')) {
            status = "True";
            list = jq(this).attr('id');
            tyval = jq(this).attr('data-val');
            gate=tyval.split(" ");
        } else {
            status = "False";
            list = jq(this).attr('id');
            tyval = jq(this).attr('data-val');
            gate=tyval.split(" ");
        }
        inputchanged = false;
        skipTestScript(list, status,gate[0]);
    });
    
    /* Below script works on click event. If the condition is true it unchecks the checkboxes. */
    jq(document).on('click', '.clickCmiList', function() {
        var $this = jq(this);
        var selectedValues = jq(this).attr("data-list");
        jq(".CMIList input:checkbox").each(function() {
            if (selectedValues.indexOf(jq(this).val()) === -1) {
                jq(this).prop('checked', false);
                jq(this).next('label').removeClass('selected');
            } else {
                jq(this).prop('checked', true);
                jq(this).next('label').addClass('selected');
            }
        });
    });
    
    /* Below script works on click event. If the condition is true it checks the checkboxes and adds a class. */
    jq(document).on('click', '.clickDrop', function() {
        var $this = jq(this);
        var listValues = jq(this).attr("data-list");
        var listValuesArray = listValues.split(';');
        if (listValuesArray.length !== 0) {
            jq.each(listValuesArray, function(i) {
                $this.next().find("input[type='checkbox']").filter(function() {
                    return this.value === listValuesArray[i];
                }).prop("checked", "true").next('label').addClass('selected');
            });
        }
    });    
}

