/******************************************************************
 *@Description:This script used to manage and display the financials
 *@Author: Cognizant
 *@Created Date: 13/05/2015 
 *******************************************************************/
var jq = jQuery.noConflict();
function finScriptCallBack() {
    jq('[data-toggle="tooltip"]').tooltip();
    hilightTaskScript();
/* Below script works on click event. If the condition is true it shows the Left side menu. Also it removes '+' and replaces it with '-' which indicates the menu expansion */
    jq(".initAccordian").on("click", function() {
        var $this = jq(this);
        if ($this.parent().nextUntil(".leftsidemenu").is(":hidden")) {
            $this.parent().nextUntil(".leftsidemenu").show();
            $this.removeClass("fa-plus-square");
            $this.addClass("fa-minus-square");
        } else {
            $this.parent().nextUntil(".leftsidemenu").hide();
            $this.removeClass("fa-minus-square");
            $this.addClass("fa-plus-square");
        }
    });
    
/* Below function performs the page redirection. It redirects to Financial currency page */
    function loadCurrencyPage() {
        window.location = '/apex/IPM_Financial_Currency?id=' + IPMFINAPP.projectid;
    }
    
/* Below script works on click event. When clicked on confirm button it hides the opened modal and calls a function 'refreshFromLocal' */
    jq(document).on('click', '#ipmDeleteModal .confirmAction.refreshFromLocal', function() {
        jq('#ipmDeleteModal').modal('hide');
        refreshFromLocal();
    });
    
/* Below script works on click event. When clicked on confirm button it hides the opened modal and calls a function 'refreshFromRegional' */
    jq(document).on('click', '#ipmDeleteModal .confirmAction.refreshFromRegional', function() {
        jq('#ipmDeleteModal').modal('hide');
        refreshFromRegional();
    });
}

/* Below function validates for a condition. If user enters any key within the set of keys provided in the condition the value will returned as false. */
function defKeyPrev() {
    if ((event.keyCode < 48 && event.keyCode !== 46) || (event.keyCode > 57 && event.keyCode !== 190 && event.keyCode !== 110)) {
        return false;
    }
}
jq(document).ready(function() {
    jq('[data-toggle="tooltip"]').tooltip();
    jq('.ipmFinancetable > tbody > tr').each(function() {
        var $this = jq(this);
        $this.find('td.iPLBorderGay:first').addClass('finTabletr');
    });
    hilightTaskScript();
/* Below script works on click event. If the condition is true it hides the Financial Filter. Also it removes angle left class and replaces it with angle right css class. */
    jq(document).on('click', '.finArrow', function() {
        var $this = jq(this);
        var finFilter = jq('.finFilter');
        var finTable = jq('.finTableData');
        if ($this.children().hasClass('fa-angle-left')) {
            finFilter.hide();
            finTable.removeClass('col-sm-10');
            finTable.addClass('col-sm-12');
            $this.children().removeClass('fa-angle-left');
            $this.children().addClass('fa-angle-right');
        } else {
            finTable.removeClass('col-sm-12');
            finTable.addClass('col-sm-10');
            finFilter.show();
            $this.children().removeClass('fa-angle-right');
            $this.children().addClass('fa-angle-left');
        }
    });
    finScriptCallBack();
});

/* Below function calls two other functions and also deletes a css class and adds new css class. */
function refreshFromLocalJs(title, confirmMsg) {
    modalFunc(title, confirmMsg);
    var delModal = jq('#ipmDeleteModal .confirmAction');
    delModal.removeClass('refreshFromRegional');
    delModal.addClass('refreshFromLocal');
    finScriptCallBack();
}

/* Below function calls two other functions and also deletes a css class and adds new css class. */
function refreshFromRegionalJs(title, confirmMsg) {
    modalFunc(title, confirmMsg);
    var delModal = jq('#ipmDeleteModal .confirmAction');
    delModal.removeClass('refreshFromLocal');
    delModal.addClass('refreshFromRegional');
    finScriptCallBack();
}

/* Below function calls two other functions and also deletes a css class and adds new css class. */
function refreshFromGlobalJs(title, confirmMsg) {
	modalFunc(title, confirmMsg);
	var delModal = jq('#ipmDeleteModal .confirmAction');
	delModal.removeClass('refreshFromLocal');
	delModal.addClass('refreshFromRegional');
	finScriptCallBack();
}

/*Below function changes the modal title and message in the modal content */
function modalFunc(title, confirmMsg) {
    jq('#ipmDeleteModal .modal-title').html(title);
    jq('#ipmDeleteModal .confirmMsg').html(confirmMsg);
}

/* Below function calls another function 'ActionUpdate' */
function updateCheckbox(Country, check) {
    ActionUpdate(Country, check);
}
var dots;

/* Below function checks whether the condition is true. If it is true it empties the inner html of a element */
function progressDots() {
    var currSel = document.getElementById(IPMApp.compSlst).options[document.getElementById(IPMApp.compSlst).selectedIndex].text;
    document.getElementById(IPMApp.compOtl).textContent = 'Currency: ' + currSel + ': exchange rate is being applied..';
    dots = window.setInterval(function() {
        var wait = document.getElementById("wait");
        if (wait.innerHTML.length > 3){
            wait.innerHTML = "";
            }
        else{
            wait.innerHTML += ".";
            }
    }, 500);
}
function stopDots() {
    window.clearInterval(dots);
    document.getElementById("wait").innerHTML = '';
}

/* Below script works on click event. If the condition is true if hides a div and return false else it displays a div and returns true. */
jq('#button').on('click', function() {
    var div = jq('#newpost');
    if (div.style.display !== 'none') {
        div.style.display = 'none';
        return false;
    } else {
        div.style.display = 'block';
        return false;
    }
});



var jq = jQuery.noConflict();
jq(document).ready(function() {
    var ipmAccordion = jq(".ipmAccordion");
/* Below script calls a function accordion on click event */
    jq(document).on("click", ".ipmAccordion .pHead span.expico, .ipmAccordion .pHead span.expico-square", function() {
        accordion(this);
    });
    
/* Below script expands all the tabs in accordion when clicked on the Expand all button and replaces '+' with '-' sign */
    jq(document).on("click", ".expandTool .expandAll", function() {
        ipmAccordion.find(".ipmAcrdnExpand").not(':empty').slideDown("fast");
        ipmAccordion.find(".pHead .expico").removeClass("fa-plus");
        ipmAccordion.find(".pHead .expico").addClass("fa-minus");
        ipmAccordion.find(".pHead .expico-square").removeClass("fa-plus");
        ipmAccordion.find(".pHead .expico-square").addClass("fa-minus");
    });
    
/* Below script collapses all the tabs in accordion when clicked on the Collapse all button and replaces '-' with '+' sign */
    jq(document).on("click", ".expandTool .collapseAll", function() {
        ipmAccordion.find(".ipmAcrdnExpand ").slideUp("fast");
        ipmAccordion.find(".pHead .expico").addClass("fa-plus");
        ipmAccordion.find(".pHead .expico").removeClass("fa-minus");
        ipmAccordion.find(".pHead .expico-square").addClass("fa-plus");
        ipmAccordion.find(".pHead .expico-square").removeClass("fa-minus");
    });
    
/* Below script works on page load. First it hides all the tabs. Then it opens only the first tab. It also adds the + mark for the collapsed one's and adds - for the expanded one */
    jq(".ipmAcrdnExpand").hide();
    jq(".ipmAcrdnExpand:first, .ipmAcrdnExpand:first .ipmAcrdnExpand").not(':empty').show();
    ipmAccordion.find(".pHead span.expico").removeClass("fa-minus");
    ipmAccordion.find(".pHead span.expico").addClass("fa-plus");
    ipmAccordion.find(".pHead:first span.expico").removeClass("fa-plus");
    ipmAccordion.find(".pHead:first span.expico").addClass("fa-minus");
    ipmAccordion.find(".ipmAcrdnExpand:first .pHead span.expico").removeClass("fa-plus");
    ipmAccordion.find(".ipmAcrdnExpand:first .pHead span.expico").addClass("fa-minus");
    ipmAccordion.find(".pHead .recCount").removeClass("expanded");
    ipmAccordion.find(".pHead .recCount").addClass("collapsed");
});
/* Below function is called above upon click event where it expands the tab and replaces '+' with '-' or collapses a opened tab and replaces '-' with '+' */
function accordion(elem) {
    if (jq(elem).closest(".pHead").next(".ipmAcrdnExpand").is(":visible")) {
        jq(elem).closest(".pHead").next(".ipmAcrdnExpand").slideUp("fast");
        jq(elem).removeClass("fa-minus");
        jq(elem).addClass("fa-plus");
        jq(elem).next('.recCount').removeClass('expanded');
        jq(elem).next('.recCount').addClass('collapsed');
    } else {
        jq(elem).closest(".pHead").next(".ipmAcrdnExpand").slideDown("fast");
        jq(elem).removeClass("fa-plus");
        jq(elem).addClass("fa-minus");
        jq(elem).next('.recCount').removeClass('collapsed');
        jq(elem).next('.recCount').addClass('expanded');
    }
}

function hilightTaskScript(){
    jq(".info").tooltip({ position: { my: 'center top', at: 'center bottom+10' },tooltipClass:'info_tip'});
    jq(".smalllinfo").tooltip({ position: { my: 'center top', at: 'center bottom+10'},tooltipClass:'normal_tip'});
}

function isNumber(evt, finval) {
    evt = (evt) ? evt : window.event;
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if((finval.length===0 && charCode === 45) || (finval.indexOf('.')===-1 && charCode === 46))
    {
        return true;
    }
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}