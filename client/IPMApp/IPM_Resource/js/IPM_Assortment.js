/*****************************************************************************************
 *@Description:This script used to create IPM_Assortment Strategy specific utility methods.
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
*****************************************************************************************/
var jq = jQuery.noConflict();
/* Below function is used to open a modal where a user can perform the delete operation */
function deleteAssortment(str) {
    jq("#ipmAssortment").modal({
        show: true,
        keyboard: false,
        backdrop: "static"
    });
    var title = jq(".deleteStrategy").attr("value");
    jq("#ipmAssortment .modal-title").html(title);
    jq("#ipmAssortment .confirmAssortment").attr("data-result", str);
    jq("#ipmAssortment .modal-dialog").width("600px");
    jq("#ipmAssortment .modal-dialog").height("170px");
    jq("#ipmAssortment .modal-dialog").css({
        "margin-top": "10%",
        "z-index": "999"
    });
    jq(".confirmAssortment").addClass("removeAssortment")
}

function setFocusOnLoad() {}
jq(document).ready(function() {
    assortmentscript();
/* Below script is based on click event. If user clicks on dropdown or on a checkbox the dropdown will still be displayed instead of hiding */
    jq(document).on("click", '.dropdown-menu input[type="checkbox"], .dropdown-menu li', function(e) {
        e.stopPropagation()
    });
/* Below script is to hide the dropdown list on click event if condition is true */
    jq(document).click(function(e) {
        if (e.target.id !== "assortList2") {
            jq("#assortList2").hide()
        }
        if (e.target.id !== "assortList1") {
            jq("#assortList1").hide()
        }
    });
/* Below script is to show the dropdown list of Assortment Strategy on click event */
    jq(".assortSelect1").click(function() {
        jq(".assortList1").show()
    });
/* Below script is to show the dropdown list of Assortment Strategy on click event */
    jq(".assortSelect2").click(function() {
        jq(".assortList2").show()
    });
/* Below script is performed on click event. When user clicks on Remove the assortment strategy will be removed and the modal will be closed */
    jq(document).on("click", "#ipmAssortment .removeAssortment", function() {
        var questionId = jq(this).attr("data-result");
        DeleteAssortRecord(questionId);
        jq("#ipmAssortment").modal("hide")
    });
    hilightTaskScript()
});
/* Below script is related to function calling after rerendering */
function refreshAssort() {
/* Below script works on page load. First it hides all the tabs. Then it opens only the first tab. */
    jq(".ipmAcrdnExpand").hide();
    jq(".ipmAcrdnExpand:first").not(":empty").show();
/* Below script is called upon click event where it expands the tab and replaces '+' with '-' or collapses a opened tab and replaces '-' with '+' */
    jq(".assortmentAccordion").on("click", ".expico", function() {
        if (jq(this).closest(".pHead").next(".ipmAcrdnExpand").is(":visible")) {
            jq(this).removeClass("fa-minus");
            jq(this).addClass("fa-plus");
            jq(this).closest(".pHead").next(".ipmAcrdnExpand").slideUp("fast")
        } else {
            jq(this).closest(".pHead").next(".ipmAcrdnExpand").slideDown("fast");
            jq(this).removeClass("fa-plus");
            jq(this).addClass("fa-minus");
        }
    });
/* Below script works on page load. It adds the + mark for the collapsed one's and adds - for the expanded one */
    jq(".projectContainer").find(".pHead .assortmentAccordion span.expico").removeClass("fa-minus");
    jq(".projectContainer").find(".pHead .assortmentAccordion span.expico").addClass("fa-plus");
    jq(".projectContainer:first").find(".pHead .assortmentAccordion span.expico").removeClass("fa-plus");
    jq(".projectContainer:first").find(".pHead .assortmentAccordion span.expico").addClass("fa-minus");
}
/* Below function performs the reset functionality */
function resetCheckboxes(elem, selectedValues) {
    var selectedValuesArr = [];
    if (selectedValues !== "" && selectedValues !== undefined) {
        selectedValuesArr = selectedValues.split(",")
    }
/* Below script is used to check the checkboxes based on the checkbox value. If value matches and condition is true the checkbox will be checked and also it will be disabled */
    jq(elem).find("input:checkbox").each(function() {
        var val = jq(this).attr("value");
        if (jq.inArray(val, selectedValuesArr) !== -1) {
            jq(this).prop("checked", true);
            jq(this).prop("disabled", true);
            jq(this).next("label").addClass("selected");
            jq(this).next("label").addClass("disabled")
        } else {
            jq(this).prop("checked", false);
            jq(this).next("label").removeClass("selected");
            jq(this).prop("disabled", false);
            jq(this).next("label").removeClass("disabled")
        }
    });
}
/* Below function calls 'changePrior' function */
function changeArrow(cuName, arrow, priorityNumber) {
    changePrior(cuName, arrow, priorityNumber)
}
var custChanlStr = "";

/* Below is the main function which runs onComplete of all the action functions in Assortment Strategy  */
function assortmentscript() {
    createAssortment();
    assortAccordion();
    showAssortdrpdown();
    assortReset();
/* Below script works on page load. If the total number of checkboxes checked are more than 5 user will not be able to check the other checkboxes */
    jq(".ccCheck").change(function(e) {
        if (jq(".ccListbox input[type=checkbox]:checked").length > 5) {
            jq(this).prop("checked", false);
            jq(this).next("label").removeClass("selected")
        }
    });
/* Below script works on page load. First it hides all the tabs. Then it opens only the first tab. */  
    jq(".ipmAcrdnExpand").hide();
    jq(".ipmAcrdnExpand:first").not(":empty").show();
    jq(".projectContainer").find(".pHead .assortmentAccordion span.expico").removeClass("fa-minus");
    jq(".projectContainer").find(".pHead .assortmentAccordion span.expico").addClass("fa-plus");
    jq(".projectContainer:first").find(".pHead .assortmentAccordion span.expico").removeClass("fa-plus");
    jq(".projectContainer:first").find(".pHead .assortmentAccordion span.expico").addClass("fa-minus");
    resetCheckboxes("#assortList1", IPMAPPAssortment.channelName);
    resetCheckboxes("#assortList2", IPMAPPAssortment.selectedValues);
    
    var cusStr = "";
/* Below script works on click. When the user clicks on 'Done' the dropdown list will be hidden. Also all the checked checkboxes value will be converted to string and will be passed to a function */
    jq(document).on("click", "#assortChanlListDone", function() {
        var custChanlList = [];
        var ulElem = jq(this).closest("ul.dropdown-menu");
        jq(ulElem).hide();
        jq(this).closest("ul.dropdown-menu").find("input:checkbox:checked").each(function() {
            custChanlList.push(jq(this).val())
        });
        custChanlStr = custChanlList.toString();
        CustomChannels(custChanlStr)
    });
/* Below script works on page load. If the total number of checkboxes checked are more than 5 user will not be able to check the other checkboxes */
    jq(".ccCheck").change(function(e) {
        if (jq(".ccListbox input[type=checkbox]:checked").length > 5) {
            jq(this).prop("checked", false)
        }
    })
}

function createAssortment() {
/* Below script works on click event. On click a value is saved and it is passed to function 'createAssort' */
    jq(document).on("click", ".createAssortmetRec", function(e) {
        e.preventDefault();
        cusVals = jq(".chCusValue").val();
        createAssort(custChanlStr, cusVals)
    })
}

function assortAccordion() {
/* Below script is called upon click event where it expands the tab and replaces '+' with '-' or collapses a opened tab and replaces '-' with '+' */
    jq(".assortmentAccordion").on("click", ".expico", function() {
        if (jq(this).closest(".pHead").next(".ipmAcrdnExpand").is(":visible")) {
            jq(this).removeClass("fa-minus");
            jq(this).addClass("fa-plus");
            jq(this).closest(".pHead").next(".ipmAcrdnExpand").slideUp("fast")
        } else {
            jq(this).closest(".pHead").next(".ipmAcrdnExpand").slideDown("fast");
            jq(this).removeClass("fa-plus");
            jq(this).addClass("fa-minus")
        }
    })
}

function showAssortdrpdown() {
/* Below script works on click. It displays the dropdown list based on the Assortment list */
    jq(document).on("show.bs.dropdown", ".assortChannelList1, .assortChannelList2", function() {
        var selectedValues, selectedValuesArr = [];
        if (jq(this).hasClass("assortChannelList1")) {
            jq(".assortList1").show();
            jq(".assortList2").hide();
            selectedValues = IPMAPPAssortment.channelName
        } else if (jq(this).hasClass("assortChannelList2")) {
            jq(".assortList2").show();
            jq(".assortList1").hide();
            selectedValues = IPMAPPAssortment.selectedValues
        }
        if (selectedValues !== "" && selectedValues !== undefined) {
            selectedValuesArr = selectedValues.split(",")
        }
/* Below script is used to check the checkboxes based on the checkbox value. If value matches and condition is true the checkbox will be checked and also it will be disabled */
        jq(this).find('.dropdown-menu input[type="checkbox"]').each(function() {
            var val = jq(this).attr("value");
            if (jq.inArray(val, selectedValuesArr) !== -1) {
                jq(this).prop("checked", true);
                jq(this).prop("disabled", true);
                jq(this).next("label").addClass("selected");
                jq(this).next("label").addClass("disabled")
            } else {
                jq(this).prop("checked", false);
                jq(this).next("label").removeClass("selected");
                jq(this).next("label").removeClass("disabled");
                jq(this).prop("disabled", false)
            }
        })
    })
}
/* Below script works on click. When clicked on 'Reset' button the list of values will be assigned to the respective variables.  */
function assortReset() {
    jq(document).on("click", "#ipmAssortCusReset, #ipmAssortCustChanlReset", function() {
        var selectedValues, selectedValuesArr = [];
        if (jq(this).hasClass("ipmAssortCustChanlReset")) {
            selectedValues = IPMAPPAssortment.channelName
        } else if (jq(this).hasClass("ipmAssortCusReset")) {
            selectedValues = IPMAPPAssortment.selectedValues
        }
        if (selectedValues !== "" && selectedValues !== undefined) {
            selectedValuesArr = selectedValues.split(",")
        }
/* Below script is used to check the checkboxes based on the checkbox value. If value matches and condition is true the checkbox will be checked and also it will be disabled */
        jq(this).closest("ul.dropdown-menu").find("input:checkbox").each(function() {
            var val = jq(this).attr("value");
            if (jq.inArray(val, selectedValuesArr) !== -1) {
                jq(this).prop("checked", true);
                jq(this).prop("disabled", true);
                jq(this).next("label").addClass("selected");
                jq(this).next("label").addClass("disabled")
            } else {
                jq(this).prop("checked", false);
                jq(this).next("label").removeClass("selected");
                jq(this).next("label").removeClass("disabled");
                jq(this).prop("disabled", false)
            }
        })
    })
}
/* Below function contains the script which has the tooltip functionality. This function is called when the rerendering happens and the script will run again */
function hilightTaskScript() {
    jq(".info").tooltip({
        position: {
            my: "center top",
            at: "center bottom+10"
        }
    });
    jq(".deleteChannel").tooltip({
        position: {
            my: "center top",
            at: "center bottom+10"
        }
    });
    jq(".arrow-left").tooltip({
        position: {
            my: "left top",
            at: "center bottom+10"
        },
        tooltipClass: "ui-lefttip"
    });
    jq(".aTabs").find("input[type=checkbox]:checked").closest(".aTabs").addClass("active")
}