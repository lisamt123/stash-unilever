/*********************************************************************************
 *@Description:This script is used for IPM Gate Document page specific interaction
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
*********************************************************************************/
jq(document).ready(function() {
    jq(".cust-overlay").delay(1500).fadeOut();
    
/* Below script works on page load. First it hides all the tabs. Then it opens only the first tab. */
    jq(".contenWrapper .ipmAcrdnExpand").hide();
    if (window.location.href.indexOf("IPM_GateDocument") > -1) {
        jq(".contenWrapper").find(".contenWrapper").find(".ecoDesignTable").find(".ipmAcrdnExpand").show();
    }
    jq(".contenWrapper").find(".ipmAcrdnExpand").find(".aHead:last").css("border", "none");
    jq(".contenWrapper .ipmAcrdnExpand:first").not(':empty').show();
    
    gateAccrdn();
    gateexpcollapse();  
    
/* Below script works on page load. First it hides all the tabs. Then it opens only the first tab. */
    jq(".gdFilterSection .ipmAcrdnExpand").hide();
    jq(".gdFilterSection .ipmAcrdnExpand").not(':empty').show();
    
/* Below script is called upon click event where it expands the tab and replaces '+' with '-' or collapses a opened tab and replaces '-' with '+' */
    jq(".gdFilterSection").on("click", ".ipmAccordion .expico", function() {
        var $this = jq(this);
        if ($this.closest(".pHead").next(".filter.ipmAcrdnExpand").is(":visible") && $this.closest(".pHead").next(".filter.ipmAcrdnExpand").not(':empty')) {
            $this.closest(".pHead").next(".filter.ipmAcrdnExpand").slideUp("fast");
            $this.removeClass("fa-minus");
            $this.addClass("fa-plus");
        } else {
            $this.closest(".pHead").next(".filter.ipmAcrdnExpand").slideDown("fast");
            $this.removeClass("fa-plus");
            $this.addClass("fa-minus");
        }
    });
    
/* Below script expands all the tabs in accordion when clicked on the Expand all button and replaces '+' with '-' sign */
    jq(".expandTool").on("click", ".filter.expandAll", function() {
        jq(".ipmAccordion").find(".ipmAcrdnExpand").not(':empty').slideDown("fast");
        jq(".ipmAccordion").find(".pHead .expico").removeClass("fa-plus");
        jq(".ipmAccordion").find(".pHead .expico").addClass("fa-minus");
    });
    
/* Below script collapses all the tabs in accordion when clicked on the Collapse all button and replaces '-' with '+' sign */
    jq(".expandTool").on("click", ".filter.collapseAll", function() {
        jq(".ipmAccordion").find(".ipmAcrdnExpand ").slideUp("fast");
        jq(".ipmAccordion").find(".pHead .expico").addClass("fa-plus");
        jq(".ipmAccordion").find(".pHead .expico").removeClass("fa-minus");
    });
    jq(document).ready(function() {
        jq(".removebutton input").removeClass('btn');
        
/* Below script works on page load. It adds the + mark for the collapsed one's and adds - for the expanded one */
        jq(".contenWrapper").find(".ipmAccordian .aHead .expico").removeClass("fa-minus");
        jq(".contenWrapper").find(".ipmAccordian .aHead .expico").addClass("fa-plus");
        jq(".contenWrapper").find(".ipmAccordian .aHead:first .expico").removeClass("fa-plus");
        jq(".contenWrapper").find(".ipmAccordian .aHead:first .expico").addClass("fa-minus");
        jq(".contenWrapper").find(".ipmAccordian .ipmAcrdnExpand:first .aHead .expico").removeClass("fa-minus");
        jq(".contenWrapper").find(".ipmAccordian .ipmAcrdnExpand:first .aHead .expico").addClass("fa-plus");
    });
    jq(".ipmFinancetable").closest("div").css("overflow", "auto");
    jq(".history").each(function() {
        var $this = jq(this);
        var url = $this.attr('value');
        var id = $this.attr('id');
        var title = $this.attr('title');
        
    /* Below script works on click event. It opens up the history modal*/
        jq(document).on('click', "#" + id, function(e) {
            e.preventDefault ? e.preventDefault() : e.returnValue = false;
            openModal(url);
            jq('#ipmModal .modal-title').html(title);
            jq('#ipmModal .modal-dialog').width('50%');
            jq('#ipmModal .modal-dialog').height('90%');
        });
    });         
    /* Below script works on click event. It opens up the change gate document status modal*/
    jq(document).on('click', '.SecStatusUpdate1', function() {
        var url = jq(this).attr('value');
        var modalTitle = 'Change current document status';
        openModal(url);
        jq('#ipmModal .modal-title').html(modalTitle);
        jq('#ipmModal .modal-dialog').width('50%');
        jq('#ipmModal .modal-dialog').height('90%');
    });
    
    /* Below script works on click event. It removes the messageBox div */
    jq('.closeMessage').on('click', function() {
        jq(this).closest('.messageBox').remove();
    });
    /* Below script works on click event. It opens up the previous gate documents modal*/
    jq(document).on('click', '.olderDocLink', function(e) {
        var $this = jq(this);
        var url = $this.attr('value');
        var modalTitle = $this.attr('modalTitle');
        openModal(url);
        jq('#ipmModal .modal-title').html(modalTitle);
        jq('#ipmModal .modal-dialog').width('40%');
        jq('#ipmModal .modal-dialog').height('40%');
    });
    openCommentModal();
    filterBlock();
});

function gateAccrdn(){
    /* Below script is called upon click event where it expands the tab and replaces '+' with '-' or collapses a opened tab and replaces '-' with '+' */
    jq(".contenWrapper").on("click", ".ipmAccordian .expico", function() {
        if (jq(this).closest(".aHead").next(".ipmAcrdnExpand").is(":visible")) {
            jq(this).closest(".aHead").next(".ipmAcrdnExpand").slideUp("fast");
            jq(this).closest(".aHead").siblings(".aHead").find(".expico").removeClass("fa-minus");
            jq(this).closest(".aHead").siblings(".aHead").find(".expico").addClass("fa-plus");
            jq(this).removeClass("fa-minus");
            jq(this).addClass("fa-plus");
        } else {
            jq(this).closest(".aHead").siblings(".ipmAcrdnExpand").slideUp("fast");
            jq(this).closest(".aHead").siblings(".aHead").find(".expico").removeClass("fa-minus");
            jq(this).closest(".aHead").siblings(".aHead").find(".expico").addClass("fa-plus");
            jq(this).closest(".col-sm-12").siblings(".col-sm-12").find(".ipmAccordian>.ipmAcrdnExpand").slideUp("fast");
            jq(this).closest(".col-sm-12").siblings(".col-sm-12").find(".ipmAccordian>.aHead").find(">.expico").removeClass("fa-minus");
            jq(this).closest(".col-sm-12").siblings(".col-sm-12").find(".ipmAccordian>.aHead").find(">.expico").addClass("fa-plus");
            jq(this).closest(".aHead").next(".ipmAcrdnExpand").slideDown("fast");
            jq(this).removeClass("fa-plus");
            jq(this).addClass("fa-minus");
            jq(".consumerContainer .ipmAcrdnExpand").show();
        }
    });
}

function gateexpcollapse(){
    /* Below script expands all the tabs in accordion when clicked on the Expand all button and replaces '+' with '-' sign */
    jq(".content.expandTool").on("click", ".expandAll", function() {
        jq(".ipmAccordian").find(".ipmAcrdnExpand").not(':empty').slideDown("fast");
        jq(".ipmAccordian").find(".aHead .expico").removeClass("fa-plus");
        jq(".ipmAccordian").find(".aHead .expico").addClass("fa-minus");
    });
    
/* Below script collapses all the tabs in accordion when clicked on the Collapse all button and replaces '-' with '+' sign */
    jq(".content.expandTool").on("click", ".collapseAll", function() {
        jq(".ipmAccordian").find(".ipmAcrdnExpand ").slideUp("fast");
        jq(".ipmAccordian").find(".aHead .expico").addClass("fa-plus");
        jq(".ipmAccordian").find(".aHead .expico").removeClass("fa-minus");
    }); 
}

function openCommentModal(){
    jq(".comments").each(function() {
        var $this = jq(this);
        var url = $this.attr('value');
        var id = $this.attr('id');
        var title = $this.attr('title');
        
    /* Below script works on click event. It opens up the comments modal*/
        jq(document).on('click', "#" + id, function(e) {
            e.preventDefault ? e.preventDefault() : e.returnValue = false;          
            openModal(url);
            jq(document).find('#ipmModal').find('.modal-title').html(title);
            jq(document).find('#ipmModal').find('.modal-dialog').width('60%');
            jq(document).find('#ipmModal').find('.modal-dialog').height('90%');
        });
    });
}
function applyFilter() {
    var selValType = [],
        selValStatus = [],
        selValFunRole = [];
        
/* Below script works on the filter functionality. If the checkboxes of gate document type filter are checked, it gets the value of those and pushes it to a variable. */
    jq("ul.gdFilterType").find("input[type=checkbox]").each(function() {
        if (jq(this).is(':checked')) {
            selValType.push(jq(this).val());
        }
    });
    
/* Below script works on the filter functionality. If the checkboxes of gate document status filter are checked, it gets the value of those and pushes it to a variable. */
    jq("ul.gdFilterStatus").find("input[type=checkbox]").each(function() {
        if (jq(this).is(':checked')) {
            selValStatus.push(jq(this).val());
        }
    });
    
/* Below script works on the filter functionality. If the checkboxes of gate document functional role filter are checked, it gets the value of those and pushes it to a variable. */
    jq("ul.gdFilterFunRole").find("input[type=checkbox]").each(function() {
        if (jq(this).is(':checked')) {
            selValFunRole.push(jq(this).val());
        }
    });
    setFilterValues(selValType.toString(), selValStatus.toString(), selValFunRole.toString());
}

/* Below function calls another function */
function movePhase() {
    moveToNextPhase();
}
/* Below function contains the code which disables the checkboxes. If the related conditions are true it disables the checkboxes. */
function filterBlock() {
    jq('.skipButtoncontainer .ipmButton').removeClass('btn');
    var filterSelector = jq(".docFilter");
    if (IPMApp.NonNegotiableCount === 0) {
        filterSelector.find(".NonNegotiable").prop('disabled', true);
        filterSelector.find(".NonNegotiable").addClass('disabled');
        filterSelector.find(".NonNegotiable").next().addClass('disabled');
    }
    if (IPMApp.OptionalCount === 0) {
        filterSelector.find(".Optional").prop('disabled', true);
        filterSelector.find(".Optional").addClass('disabled');
        filterSelector.find(".Optional").next().addClass('disabled');
    }
    if (IPMApp.NotstartedCount === 0) {
        filterSelector.find(".NotStarted").prop('disabled', true);
        filterSelector.find(".NotStarted").addClass('disabled');
        filterSelector.find(".NotStarted").next().addClass('disabled');
    }
    if (IPMApp.FilledinCount === 0) {
        filterSelector.find(".filled-in").prop('disabled', true);
        filterSelector.find(".filled-in").addClass('disabled');
        filterSelector.find(".filled-in").next().addClass('disabled');
    }

    if (IPMApp.BDCount === 0) {
        filterSelector.find(".bd").prop('disabled', true);
        filterSelector.find(".NonNegotiable").addClass('disabled');
        filterSelector.find(".NonNegotiable").next().addClass('disabled');
    }
    if (IPMApp.CMICount === 0) {
        filterSelector.find(".cmi").prop('disabled', true);
        filterSelector.find(".cmi").addClass('disabled');
        filterSelector.find(".cmi").next().addClass('disabled');
    }
    if (IPMApp.CDCount === 0) {
        filterSelector.find(".cd").prop('disabled', true);
        filterSelector.find(".cd").addClass('disabled');
        filterSelector.find(".cd").next().addClass('disabled');
    }
    if (IPMApp.RnDCount === 0) {
        filterSelector.find(".rnd").prop('disabled', true);
        filterSelector.find(".rnd").addClass('disabled');
        filterSelector.find(".rnd").next().addClass('disabled');
    }
    if (IPMApp.SCCount === 0) {
        filterSelector.find(".sc").prop('disabled', true);
        filterSelector.find(".sc").addClass('disabled');
        filterSelector.find(".sc").next().addClass('disabled');
    }
    if (IPMApp.FinanceCount === 0) {
        filterSelector.find(".fc").prop('disabled', true);
        filterSelector.find(".fc").addClass('disabled');
        filterSelector.find(".fc").next().addClass('disabled');
    }
    if (IPMApp.BBCount === 0) {
        filterSelector.find(".bb").prop('disabled', true);
        filterSelector.find(".bb").addClass('disabled');
        filterSelector.find(".bb").next().addClass('disabled');
    }
    jq(document).on('click', '.actionBox', function() {
        var url = jq(this).attr('value');
        window.setTimeout(function() {
            window.top.location.href = url;
        }, 1500);
    });
    filterSelector.find("input[type=checkbox]").prop("checked", true);
    filterSelector.find("label").addClass("selected");

    /* Below script works on click event. When clicked on checkAll link it checks all the checkboxes. */
    jq(document).on("click", ".docFilter .checkAll", function() {
        if (jq(this).is(":checked")) {
            jq(this).closest("ul.docFilter").find("input[type=checkbox]").prop("checked", true);
            jq(this).closest("ul").find("input[type=checkbox]").next().addClass("selected");
        } else {
            jq(this).closest("ul.docFilter").find("input[type=checkbox]").prop("checked", false);
            jq(this).closest("ul").find("input[type=checkbox]").next().removeClass("selected");
        }
    });
    
    /* Below script works on click event. It performs the reset functionality by reverting back all the changes which are recently done to the checkboxes. */
    jq(document).on('click', '#resetFilterBtn', function() {
        filterSelector.find("input[type=checkbox]").prop("checked", true);
    });
    
    /* Below script works on click event. If the checked boxes are not equal to the total number of checkboxes it unchecks all the checkboxes else it checks all the checkboxes. */
    filterSelector.on("click", ".checkSub", function() {
        var $this = jq(this);
        var checkSub = $this.closest("ul").find(".checkSub:checked").closest("li").length;
        var checkNot = $this.closest("ul").find(".checkSub").closest("li").length;
        if (checkNot !== checkSub) {
            $this.closest("ul").find("li input.checkAll").prop("checked", false);
            $this.closest("ul").find("li input.checkAll").next().removeClass("selected");
        }
        if (checkNot === checkSub) {
            $this.closest("ul").find("li input.checkAll").prop("checked", true);
            $this.closest("ul").find("li input.checkAll").next().addClass("selected");
        }
    });
}

/* Below function checks for the checked checkboxes and calls another function 'filteredValues' */
function resetDocFilters() {
    var filterSelector = jq(".docFilter");
    filterSelector.find("input[type=checkbox]").prop("checked", true);
    filterSelector.find("label").addClass("selected");
    filteredValues();
}

/* Below function adds a span element to the accordion. */
function addbuttonStyle() {
    jq(".ipmAccordian").find("span.aHead").prepend("<span class='expico fa fa-plus'></span>");
}

/* Below function calls another function */
function movePhase() {
    moveToNextPhase();
}
/* Below function checks all the checkboxes based on its Id. If the condition is true it checks the checkboxes based on the mentioned ID's. */
function setFiltersAsPrevious() {
    //set types as previous
    var filterTypes = IPMApp.typeFilters;
    if (filterTypes.search('All') > -1) {
        document.getElementById('typeAll').checked = true;
    }
    if (filterTypes.search('Non-negotiable') > -1) {
        document.getElementById('typeNonNegotiable').checked = true;
    }
    if (filterTypes.search('Optional') > -1) {
        document.getElementById('typeOptional').checked = true;
    }
    //set status as previous
    var filterStatus = IPMApp.statusFilters;
    if (filterStatus.search('All') > -1) {
        document.getElementById('statusAll').checked = true;
    }
    if (filterStatus.search('Not started') > -1) {
        document.getElementById('statusNotStarted').checked = true;
    }
    if (filterStatus.search('Filled-in') > -1) {
        document.getElementById('statusFilledIn').checked = true;
    }
    //set functional role as previous
    var filterFunctionalRole = IPMApp.roleFilters;
    if (filterFunctionalRole.search('All') > -1) {
        document.getElementById('FRAll').checked = true;
    }
    if (filterFunctionalRole.search('PL') > -1) {
        document.getElementById('FRpl').checked = true;
    }
    if (filterFunctionalRole.search('BD') > -1) {
        document.getElementById('FRBd').checked = true;
    }
    if (filterFunctionalRole.search('CMI') > -1) {
        document.getElementById('FRCmi').checked = true;
    }
    if (filterFunctionalRole.search('CD') > -1) {
        document.getElementById('FRCd').checked = true;
    }
    if (filterFunctionalRole.search('R&D') > -1) {
        document.getElementById('FRrnd').checked = true;
    }
    if (filterFunctionalRole.search('SC') > -1) {
        document.getElementById('FRsc').checked = true;
    }
    if (filterFunctionalRole.search('Finance') > -1) {
        document.getElementById('FRfc').checked = true;
    }
    if (filterFunctionalRole.search('BB') > -1) {
        document.getElementById('FRbb').checked = true;
    }
}
var statusCheckApproved = IPMApp.proDoc;
if (statusCheckApproved === IPMApp.proposed) {
    jq(".ipmAccordian").find(".ipmAcrdnExpand a").removeAttr("href");
}
/* Below script works on click event. If the condition is true it performs page reload of gate document page*/
jq("#ipmModal .close").on("click", function() {
    if (jq("#ipmModal .modal-title").text().indexOf("Comment") !== -1) {
        window.top.location.href = IPMApp.GateDocPageRef + '?id=' + IPMApp.projectId + '&printDoc=' + IPMApp.printDoc;
    }
});
/* Below script works on click event. When clicked on the button it adds css styles to the button. */
jq(document).on('click', '.shipTrade', function(e) {
    e.preventDefault ? e.preventDefault() : e.returnValue = false;
    jq('#shipToPLE .modal-dialog').css({
        'margin-top': '10%',
        'z-index': '999'
    });
});
/* Below function first it hides all the tabs. It also adds the + mark for the collapsed one's and adds - for the expanded one */
function resetPanel() {
    jq(".contenWrapper").find(".ipmAcrdnExpand").find(".aHead:last").css("border", "none");
    jq(".contenWrapper .ipmAcrdnExpand").find(".ipmAcrdnExpand").hide();
    jq(".contenWrapper .ipmAcrdnExpand").find(".aHead").find(".expico").removeClass("fa-minus");
    jq(".contenWrapper .ipmAcrdnExpand").find(".aHead").find(".expico").addClass("fa-plus");
    jq(".contenWrapper").find(".contenWrapper").find(".ecoDesignTable").find(".ipmAcrdnExpand").show();
    dirApp();
    openCommentModal();
}

/* Below function first it hides all the tabs. It also adds the + mark for the collapsed one's and adds - for the expanded one */
function resetPanelSub() {
    jq(".contenWrapper").find(".ipmAcrdnExpand").find(".aHead:last").css("border", "none");
    jq(".contenWrapper .ipmAcrdnExpand").find(".ipmAcrdnExpand").find(".ipmAcrdnExpand").hide();
    jq(".contenWrapper .ipmAcrdnExpand").find(".ipmAcrdnExpand").find(".aHead").find(".expico").removeClass("fa-minus");
    jq(".contenWrapper .ipmAcrdnExpand").find(".ipmAcrdnExpand").find(".aHead").find(".expico").addClass("fa-plus");
    dirApp();
    openCommentModal();
}

/* Below function calls another function */
function fetchAppendixSections() {
    getAppSections();
}

/* Below function performs a page redirection to Overview Page. */
function shiptrade() {
    parent.location.assign(IPMApp.OverviewPageRef + '?Id=' + IPMApp.projectId);
}
function dirApp() {

/* Below script is called upon click event where it expands the tab and replaces '+' with '-' or collapses a opened tab and replaces '-' with '+' */
    jq(".ipmAccordian.mainTable").on("click", ".appText", function() {
        var appDir = jq(this).attr("data-dir");
        appDir = appDir.replace('/','_');
        jq(".ipmAccordian.mainTable").find(".aHead").find(".expico").removeClass("fa-minus").addClass("fa-plus");
        jq(".ipmAccordian.mainTable").find(".ipmAcrdnExpand").slideUp("fast");
        jq(".ipmAccordian.appendix").find(">.aHead").find(".expico").removeClass("fa-plus").addClass("fa-minus");
        jq(".ipmAccordian.appendix").find(">.ipmAcrdnExpand").slideDown("fast").find("." + appDir).slideDown("fast");
        jq("." + appDir).closest(".ipmAcrdnExpand").prev(".aHead").find(".expico").removeClass("fa-plus").addClass("fa-minus");
        jq("html, body").scrollTop(jq("." + appDir).offset().top);
        jq(".consumerContainer .ipmAcrdnExpand").show();
    });
}
jq(window).load(function(){

/* Below script works on click event. It opens the modal. */
    jq(document).on('click', '.openModal', function() {
        var url = jq(this).attr('value');
        var modalTitle = jq(this).attr('modalTitle');
        openModal(url);
        jq('#ipmModal .modal-title').html(modalTitle);
        jq('#ipmModal .modal-dialog').width('900px');
        jq('#ipmModal .modal-dialog').height('90%');
        jq('#ipmModal .modal-body').addClass('status_body');
    });
});

jq(".clipinfo").tooltip({ position: { my: 'left bottom', at: 'center bottom+10' },placement: 'bottom'}); 
 jq(document).on('click', '.paper-clip', function(e) {
    jq('#ipmAttachmentModal .modal-dialog').width('500px');
    jq('#ipmAttachmentModal .modal-dialog').height('460px');
    jq('#ipmAttachmentModal .modal-dialog').css('margin-top','10%');
    jq('#ipmNoAttachmentModal .modal-dialog').width('500px');
    jq('#ipmNoAttachmentModal .modal-dialog').height('100px');
    jq('#ipmNoAttachmentModal .modal-dialog').css('margin-top','10%');
});
jq(document).on('click', '.dwnldClick', function(e) {
    jq('td.attchImgtd a').each(function() {
        var list = jq(this).attr('href');
     window.open(list);
  });
 });
jq('.ipmAcrdnExpand').attr('class', function() {
    return jq(this).attr('class').replace('/', '_');
});