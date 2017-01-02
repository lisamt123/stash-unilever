/*********************************************************************************
 *@Description:This script is used for IPM Gate Document page specific interaction
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
*********************************************************************************/
jq(document).ready(function() {
    if(IPMApp.IsPdldoc === 'false') {
        getMainDataFunc();
        getAppendixDataFunc();
    }  
    getUserTypeFunc();
/* Below script works on page load. First it hides all the tabs. Then it opens only the first tab. */
    jq(".contenWrapper .ipmAcrdnExpand").hide();
    if (window.location.href.indexOf("IPM_GateDocument") > -1) {
        jq(".contenWrapper").find(".contenWrapper").find(".ecoDesignTable").find(".ipmAcrdnExpand").show();
    }
    jq(".contenWrapper").find(".ipmAcrdnExpand").find(".aHead:last").css("border", "none");
    jq(".contenWrapper .ipmAcrdnExpand:first").not(':empty').show();
    jq(".pdlCollapse .ipmAcrdnExpand:first").hide();
    jq(".consumerContainer .ipmAcrdnExpand").show();
    jq(".ecoDesignTable .ipmAcrdnExpand").show();
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

jq(document).ready(function() {
        jq(".removebutton input").removeClass('btn');
/* Below script works on page load. It adds the + mark for the collapsed one's and adds - for the expanded one */
        jq(".contenWrapper").find(".ipmAccordian .aHead .expico").removeClass("fa-minus");
        jq(".contenWrapper").find(".ipmAccordian .aHead .expico").addClass("fa-plus");
        jq(".contenWrapper").find(".ipmAccordian .aHead:first .expico").removeClass("fa-plus");
        jq(".contenWrapper").find(".ipmAccordian .aHead:first .expico").addClass("fa-minus");
        jq(".pdlCollapse").find(".ipmAccordian .aHead:first .expico").removeClass("fa-minus");
        jq(".pdlCollapse").find(".ipmAccordian .aHead:first .expico").addClass("fa-plus");
        jq(".contenWrapper").find(".ipmAccordian .ipmAcrdnExpand:first .aHead .expico").removeClass("fa-minus");
        jq(".contenWrapper").find(".ipmAccordian .ipmAcrdnExpand:first .aHead .expico").addClass("fa-plus");
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
            jq(this).closest(".aHead").next(".ipmAcrdnExpand").slideDown("fast");
            jq(this).removeClass("fa-plus");
            jq(this).addClass("fa-minus");
            jq(".consumerContainer .ipmAcrdnExpand").show();
        }
    });
}

// Variable to get the attachments only the first time, there-by disabling it
var getAllAttachmentsBool = "true";
function gateexpcollapse(){
    /* Below script expands all the tabs in accordion when clicked on the Expand all button and replaces '+' with '-' sign */
    jq(".content.expandTool").on("click", ".expandAll", function() {
        jq(".ipmAccordian").find(".ipmAcrdnExpand").not(':empty').slideDown("fast");
        jq(".ipmAccordian").find(".aHead .expico").removeClass("fa-plus");
        jq(".ipmAccordian").find(".aHead .expico").addClass("fa-minus");
        loadAllIframesIfVisiblefirst();
        loadAllIframesIfVisiblesecond();
        if(getAllAttachmentsBool === "true"){
			getAllAttachmentsBool = "false";
			getAllAttachments();
		}
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
    jq(document).on('click', '.actionBox', function() {
        var url = jq(this).attr('value');
        window.setTimeout(function() {
            window.top.location.href = url;
        }, 1500);
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
    if (IPMApp.MKTGDEVCount === 0) {
        filterSelector.find(".mktgdev").prop('disabled', true);
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
    if (IPMApp.MKTGLOCALCount === 0) {
        filterSelector.find(".mktglocal").prop('disabled', true);
        filterSelector.find(".mktglocal").addClass('disabled');
        filterSelector.find(".mktglocal").next().addClass('disabled');
    }
    filterSelector.find("input[type=checkbox]").prop("checked", true);
    filterSelector.find("label").addClass("selected");
    /* Below script works on click event. When clicked on checkAll link it checks all the checkboxes. */
    jq(".checkAll").click(function() {
        if (jq(this).is(":checked")) {
            jq(this).closest("ul.docFilter").find("input[type=checkbox]").prop("checked", true);
            jq(this).closest("ul").find("input[type=checkbox]").next().addClass("selected");
        } else {
            jq(this).closest("ul.docFilter").find("input[type=checkbox]").prop("checked", false);
            jq(this).closest("ul").find("input[type=checkbox]").next().removeClass("selected");
        }
        applyFilterJs();
    });
    /* Below script works on click event. It performs the reset functionality by reverting back all the changes which are recently done to the checkboxes. */
    jq(document).on('click', '#resetFilterBtn', function() {
        filterSelector.find("input[type=checkbox]").prop("checked", true);
        applyFilterJs();
    });
    /* Below script works on click event. If the checked boxes are not equal to the total number of checkboxes it unchecks all the checkboxes else it checks all the checkboxes. */
    // filter data immediately on click of any filter
    filterSelector.on("click", ".checkSub", function() {
        applyFilterJs();
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
    if (filterFunctionalRole.search('MKTGDEV') > -1) {
        document.getElementById('FRMktgDev').checked = true;
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
    if (filterFunctionalRole.search('MKTGLOCAL') > -1) {
        document.getElementById('FRMktgLocal').checked = true;
    }
}
var statusCheckApproved = IPMApp.proDoc;
if (statusCheckApproved === IPMApp.proposed) {
    jq(".ipmAccordian").find(".ipmAcrdnExpand a").removeAttr("href");
}
/* Below script works on click event. If the condition is true it performs page reload of gate document page*/
jq("#ipmModal .close").on("click", function() {
    if (jq("#ipmModal .modal-title").text().indexOf("Comment") !== -1) {
        jq(this).modal('hide');
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
    jq('.ipmAcrdnExpand').attr('class', function() {
        return jq(this).attr('class').replace('/', '_');
    });

/* Below script is called upon click event where it expands the tab and replaces '+' with '-' or collapses a opened tab and replaces '-' with '+' */
	jq(".ipmAccordian.mainTable").on("click", ".appText", function() {
        var appDir = jq(this).attr("data-dir");
        appDir = appDir.replace('/','_');
        jq(".ipmAccordian.appendix").find(".aHead").next(".appendixExpnd").show();
        jq(".ipmAccordian.appendix").find(">.aHead").find(".expico").removeClass("fa-plus").addClass("fa-minus");
        jq(".ipmAccordian.appendix").find(">.ipmAcrdnExpand").slideDown("fast").find("." + appDir).slideDown("fast");
        jq("." + appDir).closest(".ipmAcrdnExpand").prev(".aHead").find(".expico").removeClass("fa-plus").addClass("fa-minus");
        jq("html, body").scrollTop(jq("." + appDir).offset().top);
        jq(".consumerContainer .ipmAcrdnExpand").show();
        jq(".ecoDesignTable .ipmAcrdnExpand").show();
        if(appDir === "Customers_Channels")
        {
            getCustomersChannelsAppendix();
        }
        else if(appDir === "Mix_Qualification_Plan_and_Action_Standards")
        {
            getMixQualificationPlanandActionStandardsAppendix();
        }
        else if(appDir === "Milestones")
        {
            getMilestonesAppendix();
        }
        else if(appDir === "Initial_Estimate_of_Opportunity")
        {
            getInitialEstimateofOpportunityAppendix();
        }
        else if(appDir === "Consumer_Evidence_Concept")
        {
            getConsumerEvidenceConceptAppendix();
        }
        else if(appDir === "Environmental_Impact")
        {
            getEnvironmentalImpactAppendix();
        }
        else if(appDir === "Risk")
        {
            getRiskAppendix();
        }
        else if(appDir === "Rollout_Plans")
        {
            getRolloutPlansAppendix();
        }
        else if(appDir === "Country_Feedback_Requirements")
        {
             getCountryFeedbackRequirementsAppendix();
        }
        else if(appDir === "Assumptions")
        {
              getAssumptionsAppendix();
        }
        else if(appDir === "BD_BB_Alignment")
        {
              getBDBBAlignmentAppendix();
        }
        else if(appDir === "Assortment_Strategy")
        {
              getAssortmentStrategyAppendix();
        }
        else if(appDir === "Monitoring_Performance_in_Market")
        {
              getMonitoringPerformanceinMarketAppendix();
        }else if(appDir === "Technical")
        {
             getTechnicalAppendix();
        }
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

/* The below code is done part of the revamp of the Gate Document page to fix the View State Issue */

/////////////////////////////////////////////////////////////////////////////////////
/////////// filter functionality   //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
function applyFilterJs() {
    // hide content of sections based on filter
    jq(".contenWrapper .ipmAcrdnExpand").show();
    jq(".contenWrapper .ipmAccordian").find(".aHead").find(".expico").removeClass("fa-plus");
    jq(".contenWrapper .ipmAccordian").find(".aHead").find(".expico").addClass("fa-minus");

    jq(".contenWrapper .ipmAcrdnExpand").find("span.ipmAcrdnExpand").find(".aHead").closest("span.ipmAcrdnExpand").show();
    jq(".contenWrapper .ipmAcrdnExpand").find("span.ipmAcrdnExpand").find(".aHead").closest("span.ipmAcrdnExpand").prev('.aHead').find(".expico").removeClass("fa-plus");
    jq(".contenWrapper .ipmAcrdnExpand").find("span.ipmAcrdnExpand").find(".aHead").closest("span.ipmAcrdnExpand").prev('.aHead').find(".expico").addClass("fa-minus");
    
   if(jq("#typeOptional").is(':checked')) {jq(".truenegotiableclass").attr("style", "display:block");} else { jq(".truenegotiableclass").attr("style", "display:none");}
    if(jq("#typeNonNegotiable").is(':checked')) {jq(".falsenegotiableclass").attr("style", "display:block");} else {jq(".falsenegotiableclass").attr("style", "display:none");}
    if(jq("#statusNotStarted").is(':checked')) {jq(".NotStartedstatusclass").attr("style", "display:block");} else {jq(".NotStartedstatusclass").attr("style", "display:none");}
    if(jq("#statusFilledIn").is(':checked')) {jq(".Filledinstatusclass").attr("style", "display:block");} else {jq(".Filledinstatusclass").attr("style", "display:none"); }
    if(jq("#FRpl").is(':checked')) {jq(".PLfrclass").attr("style", "display:block");} else {jq(".PLfrclass").attr("style", "display:none");}
    if(jq("#FRMktgDev").is(':checked')) {jq(".MKTGDEVfrclass").attr("style", "display:block");} else {jq(".MKTGDEVfrclass").attr("style", "display:none");}
    if(jq("#FRCmi").is(':checked')) {jq(".CMIfrclass").attr("style", "display:block");} else {jq(".CMIfrclass").attr("style", "display:none");}
    if(jq("#FRCd").is(':checked')) {jq(".CDfrclass").attr("style", "display:block");} else {jq(".CDfrclass").attr("style", "display:none");}
    if(jq("#FRrnd").is(':checked')) {jq(".RDfrclass").attr("style", "display:block");} else {jq(".RDfrclass").attr("style", "display:none");}
    if(jq("#FRsc").is(':checked')) {jq(".SCfrclass").attr("style", "display:block");} else {jq(".SCfrclass").attr("style", "display:none");}
    if(jq("#FRfc").is(':checked')) {jq(".Financefrclass").attr("style", "display:block");} else {jq(".Financefrclass").attr("style", "display:none");}
    if(jq("#FRMktgLocal").is(':checked')) {jq(".MKTGLOCALfrclass").attr("style", "display:block");} else {jq(".MKTGLOCALfrclass").attr("style", "display:none");}
                    
    // hide appendix if no content in it
    jq(".appendixvisibleclass").attr("style", "display:block");
    jq(".appendixvisibleclass").filter(function(){
        return jq(".expico:visible", this).length === 1;
    }).css({'display': 'none'});
    
    // hide subheaders totally where there is no content
    jq(".msubHeaderClass").attr("style", "display:block");
    jq(".subheaderclass").attr("style", "display:block");
    jq(".subheaderclass").filter(function(){
        return ((jq(".headerinsideexpico:visible", this).length === 0) && (jq(".topicclass:visible", this).length === 1));
    }).css({'display': 'none'});
    
    // hide headers completely where there is no data
    jq(".headerclass").attr("style", "display:block");
    jq(".headerclass").filter(function(){
        return ((jq(".headerinsideexpico:visible", this).length === 1) && (jq(".topicheaderclass:visible", this).length === 0));
    }).css({'display': 'none'});

    jq(".msubHeaderClass").attr("style", "display:block");
    jq(".msubHeaderClass").filter(function(){
        return jq(".topicclass:visible", this).length === 0;
    }).css({'display': 'none'});

     // some subheaders are displayed when headers property is changed in above step, so hide those displayed subheaders
    jq(".subheaderclass").attr("style", "display:block");
    jq(".subheaderclass").filter(function(){
        return ((jq(".headerinsideexpico:visible", this).length === 0) && ((jq(".topicclass:visible", this).length === 1) || (jq(".topicclass:visible", this).length === 0)));
    }).css({'display': 'none'});
        
    jq(".contenWrapper .ipmAcrdnExpand").find(".ipmAcrdnExpand").hide();
    jq(".contenWrapper .ipmAcrdnExpand").find(".aHead").find(".expico").removeClass("fa-minus");
    jq(".contenWrapper .ipmAcrdnExpand").find(".aHead").find(".expico").addClass("fa-plus");
    jq(".contenWrapper .ipmAcrdnExpand").find("span.ipmAcrdnExpand").find(".aHead").closest("span.ipmAcrdnExpand").hide();
    jq(".contenWrapper .ipmAcrdnExpand").find("span.ipmAcrdnExpand").find(".aHead").closest("span.ipmAcrdnExpand").prev('.aHead').find(".expico").addClass("fa-plus");
    jq(".contenWrapper .ipmAcrdnExpand").find("span.ipmAcrdnExpand").find(".aHead").closest("span.ipmAcrdnExpand").prev('.aHead').find(".expico").removeClass("fa-minus");

}

//////////////////////////////////////////////////////////////////////////////////                
// load (expand all/collapse all) after main data is loaded///////////////////////
//////////////////////////////////////////////////////////////////////////////////
function expandCloseShow(){
    jq(".expandgate").attr("style", "visibility:visible");
    jq(".closegate").attr("style", "visibility:visible");
}

////////////////////////////////////////////////////////////////////////////////////
// get count of comments directly on gate document page without refresh/////////////
////////////////////////////////////////////////////////////////////////////////////
var idForCommentsCount;
function getCommentsCount(parentID) {
    idForCommentsCount = parentID;
    sforce.connection.query(
        "SELECT Id FROM FeedItem WHERE ParentId = '" + parentID + "' and type = 'TextPost'",
        {onSuccess: getCount, onFailure: sfailed});
}                               
function getCount(queryResult) {
    if(queryResult.size>0){jq("#count"+idForCommentsCount).attr("style", "display:inline");}
    else{jq("#count"+idForCommentsCount).attr("style", "display:none");}
    jq("#count"+idForCommentsCount).text(queryResult.size);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// functions for loading iframes only for initial load, there-by disabling their functionality//////
////////////////////////////////////////////////////////////////////////////////////////////////////
var getCustomers_ChannelsAppendixVar = "true";
var getTrademarksSecondLevelSectionVar = "true";
var getCU_And_ComplexitySecondLevelSectionVar = "true";
var getBusiness_Case_Action_StandardsMainSectionVar = "true";
var getInitial_Estimate_of_OpportunityMainSectionVar = "true";
var getGate_Keeper_ChecklistMainSectionVar = "true";
var getOTIF_StatusMainSectionVar = "true";
var getRD_Initial_Outline_Product_PackMainSectionVar = "true";
var getSupply_Chain_FeasibilityMainSectionVar = "true";
var getRD_FeasibilityMainSectionVar = "true";
var getRD_Technical_ReadinessMainSectionVar = "true";
var getSupply_Chain_Technical_ReadinessMainSectionVar = "true";
var getInitial_Estimate_of_OpportunityAppendixVar = "true";
var getConsumer_Evidence_ConceptAppendixVar = "true";
var getEnvironmental_ImpactAppendixVar = "true";
var getMilestonesAppendixVar = "true";
var getRiskAppendixVar = "true";
var getRollout_PlansAppendixVar = "true";
var getCountry_Feedback_RequirementsAppendixVar = "true";
var getMix_Qualification_Plan_and_Action_StandardsAppendixVar = "true";
var getAssumptionsAppendixVar = "true";
var getBDBB_AlignmentAppendixVar = "true";
var getAssortment_StrategyAppendixVar = "true";
var getMonitoring_Performance_in_MarketAppendixVar = "true";
var getTechnicalAppendixVar = "true";

// iframes should be loaded only when its own expico is visible, or else height will not be dynamic, thereby getting large empty space in iframe when expanded
function loadAllIframesIfVisiblefirst() {
    if(jq(".iframeCustomers_ChannelsAppendixexpico").is(":visible")){getCustomersChannelsAppendix();}
    if(jq(".iframeTrademarksSecondLevelSectionexpico").is(":visible")){getTrademarksSecondLevelSection();}
    if(jq(".iframeCU_And_ComplexitySecondLevelSectionexpico").is(":visible")){getCUAndComplexitySecondLevelSection();}
    if(jq(".iframeBusiness_Case_Action_StandardsMainSectionexpico").is(":visible")){getBusinessCaseActionStandardsMainSection();}
    if(jq(".iframeInitial_Estimate_of_OpportunityMainSectionexpico").is(":visible")){getInitialEstimateofOpportunityMainSection();}
    if(jq(".iframeGate_Keeper_ChecklistMainSectionexpico").is(":visible")){getGateKeeperChecklistMainSection();}
    if(jq(".iframeOTIF_StatusMainSectionexpico").is(":visible")){getOTIFStatusMainSection();}
    if(jq(".iframeRD_Initial_Outline_Product_PackMainSectionexpico").is(":visible")){getRDInitialOutlineProductPackMainSection();}
    if(jq(".iframeSupply_Chain_FeasibilityMainSectionexpico").is(":visible")){getSupplyChainFeasibilityMainSection();}
    if(jq(".iframeRD_FeasibilityMainSectionexpico").is(":visible")){getRDFeasibilityMainSection();}
    if(jq(".iframeRD_Technical_ReadinessMainSectionexpico").is(":visible")){getRDTechnicalReadinessMainSection();}
}

function loadAllIframesIfVisiblesecond(){
    if(jq(".iframeSupply_Chain_Technical_ReadinessMainSectionexpico").is(":visible")){getSupplyChainTechnicalReadinessMainSection();}
    if(jq(".iframeInitial_Estimate_of_OpportunityAppendixexpico").is(":visible")){getInitialEstimateofOpportunityAppendix();}
    if(jq(".iframeConsumer_Evidence_ConceptAppendixexpico").is(":visible")){getConsumerEvidenceConceptAppendix();}
    if(jq(".iframeEnvironmental_ImpactAppendixexpico").is(":visible")){getEnvironmentalImpactAppendix();}
    if(jq(".iframeMilestonesAppendixexpico").is(":visible")){getMilestonesAppendix();}
    if(jq(".iframeRiskAppendixexpico").is(":visible")){getRiskAppendix();}
    if(jq(".iframeRollout_PlansAppendixexpico").is(":visible")){getRolloutPlansAppendix();}
    if(jq(".iframeCountry_Feedback_RequirementsAppendixexpico").is(":visible")){getCountryFeedbackRequirementsAppendix();}
    if(jq(".iframeMix_Qualification_Plan_and_Action_StandardsAppendixexpico").is(":visible")){getMixQualificationPlanandActionStandardsAppendix();}
    if(jq(".iframeAssumptionsAppendixexpico").is(":visible")){getAssumptionsAppendix();}
    if(jq(".iframeBDBB_AlignmentAppendixexpico").is(":visible")){getBDBBAlignmentAppendix();}
    if(jq(".iframeAssortment_StrategyAppendixexpico").is(":visible")){getAssortmentStrategyAppendix();}
    if(jq(".iframeMonitoring_Performance_in_MarketAppendixexpico").is(":visible")){getMonitoringPerformanceinMarketAppendix();}
    if(jq(".iframeTechnicalAppendixexpico").is(":visible")){getTechnicalAppendix();}
}

function loadAllIframes() {
    getCustomersChannelsAppendix();
    getTrademarksSecondLevelSection();
    getCUAndComplexitySecondLevelSection();
    getBusinessCaseActionStandardsMainSection();
    getInitialEstimateofOpportunityMainSection();
    getGateKeeperChecklistMainSection();
    getOTIFStatusMainSection();
    getRDInitialOutlineProductPackMainSection();
    getSupplyChainFeasibilityMainSection();
    getRDFeasibilityMainSection();
    getRDTechnicalReadinessMainSection();
    getSupplyChainTechnicalReadinessMainSection();
    getInitialEstimateofOpportunityAppendix();
    getConsumerEvidenceConceptAppendix();
    getEnvironmentalImpactAppendix();
    getMilestonesAppendix();
    getRiskAppendix();
    getRolloutPlansAppendix();
    getCountryFeedbackRequirementsAppendix();
    getMixQualificationPlanandActionStandardsAppendix();
    getAssumptionsAppendix();
    getBDBBAlignmentAppendix();
    getAssortmentStrategyAppendix();
    getMonitoringPerformanceinMarketAppendix();
    getTechnicalAppendix();
}

function getTrademarksSecondLevelSection() {
    var iframe = jq("#iframeTrademarksSecondLevelSection");
    var url = jq('#idTrademarksSecondLevelSection').attr('value');   
    if(getTrademarksSecondLevelSectionVar === "true") {
        getTrademarksSecondLevelSectionVar = "false";    
        loadIframe(iframe,url);                        
    }
}

function getCUAndComplexitySecondLevelSection() {
    var iframe = jq("#iframeCU_And_ComplexitySecondLevelSection");
    var url = jq('#idCU_And_ComplexitySecondLevelSection').attr('value');                             
    var iframe2 = jq("#iframeCU_And_ComplexityConsolidatedSecondLevelSection");
    var url2 = jq('#idCU_And_ComplexityConsolidatedSecondLevelSection').attr('value');
    if(getCU_And_ComplexitySecondLevelSectionVar === "true") {
        getCU_And_ComplexitySecondLevelSectionVar = "false";
        loadIframe(iframe,url);  
        loadIframe(iframe2,url2); 
    }
}

function getBusinessCaseActionStandardsMainSection() {
    var iframe = jq("#iframeBusiness_Case_Action_StandardsMainSection");
    var url = jq('#idBusiness_Case_Action_StandardsMainSection').attr('value');                       
    var iframe2 = jq("#iframeBusiness_Case_Action_StandardsSecondMainSection");
    var url2 = jq('#idBusiness_Case_Action_StandardsSecondMainSection').attr('value');                      
    var iframe3 = jq("#iframeBusiness_Case_Action_StandardsThirdMainSection");
    var url3 = jq('#idBusiness_Case_Action_StandardsMainThirdSection').attr('value');
    if(getBusiness_Case_Action_StandardsMainSectionVar === "true") {
        getBusiness_Case_Action_StandardsMainSectionVar = "false";
        loadIframe(iframe,url);   
        loadIframe(iframe2,url2);
        loadIframe(iframe3,url3);
    }
}

function getInitialEstimateofOpportunityMainSection() {
    var iframe = jq("#iframeInitial_Estimate_of_OpportunityMainSection");
    var url = jq('#idInitial_Estimate_of_OpportunityMainSection').attr('value'); 
    if(getInitial_Estimate_of_OpportunityMainSectionVar === "true") {
        getInitial_Estimate_of_OpportunityMainSectionVar = "false";
        loadIframe(iframe,url);                        
    }
}

function getGateKeeperChecklistMainSection() {
    var iframe = jq("#iframeGate_Keeper_ChecklistMainSection");
    var url = jq('#idGate_Keeper_ChecklistMainSection').attr('value');     
    if(getGate_Keeper_ChecklistMainSectionVar === "true") {
        getGate_Keeper_ChecklistMainSectionVar = "false"; 
        loadIframe(iframe,url);                        
    }
}

function getOTIFStatusMainSection() {
    var iframe = jq("#iframeOTIF_StatusMainSection");
    var url = jq('#idOTIF_StatusMainSection').attr('value');      
    if(getOTIF_StatusMainSectionVar === "true") {
        getOTIF_StatusMainSectionVar = "false";     
        loadIframe(iframe,url);                        
    }
}

function getRDInitialOutlineProductPackMainSection() {
    var iframe = jq("#iframeRD_Initial_Outline_Product_PackMainSection");
    var url = jq('#idRD_Initial_Outline_Product_PackMainSection').attr('value');
    if(getRD_Initial_Outline_Product_PackMainSectionVar === "true") {
        getRD_Initial_Outline_Product_PackMainSectionVar = "false";
        loadIframe(iframe,url);                        
    }
}

function getSupplyChainFeasibilityMainSection() {
    var iframe = jq("#iframeSupply_Chain_FeasibilityMainSection");
    var url = jq('#idSupply_Chain_FeasibilityMainSection').attr('value');  
    if(getSupply_Chain_FeasibilityMainSectionVar === "true") {
        getSupply_Chain_FeasibilityMainSectionVar = "false";
        loadIframe(iframe,url);                        
    }
}

function getRDFeasibilityMainSection() {
    var iframe = jq("#iframeRD_FeasibilityMainSection");
    var url = jq('#idRD_FeasibilityMainSection').attr('value');     
    if(getRD_FeasibilityMainSectionVar === "true") {
        getRD_FeasibilityMainSectionVar = "false";
        loadIframe(iframe,url);                        
    }
}

function getRDTechnicalReadinessMainSection() {
    var iframe = jq("#iframeRD_Technical_ReadinessMainSection");
    var url = jq('#idRD_Technical_ReadinessMainSection').attr('value');   
    if(getRD_Technical_ReadinessMainSectionVar === "true") {
        getRD_Technical_ReadinessMainSectionVar = "false";
        loadIframe(iframe,url);                        
    }
}

function getSupplyChainTechnicalReadinessMainSection() {
    var iframe = jq("#iframeSupply_Chain_Technical_ReadinessMainSection");
    var url = jq('#idSupply_Chain_Technical_ReadinessMainSection').attr('value');
    if(getSupply_Chain_Technical_ReadinessMainSectionVar === "true") {
        getSupply_Chain_Technical_ReadinessMainSectionVar = "false";
        loadIframe(iframe,url);                        
    }
}

function getInitialEstimateofOpportunityAppendix() {
    var iframe = jq("#iframeInitial_Estimate_of_OpportunityAppendix");
    var url = jq('#idInitial_Estimate_of_OpportunityAppendix').attr('value');   
    if(getInitial_Estimate_of_OpportunityAppendixVar === "true") {
        getInitial_Estimate_of_OpportunityAppendixVar = "false";
        loadIframe(iframe,url);                        
    }
}

function getConsumerEvidenceConceptAppendix() {
    var iframe = jq("#iframeConsumer_Evidence_ConceptAppendix");
    var url = jq('#idConsumer_Evidence_ConceptAppendix').attr('value');     
    if(getConsumer_Evidence_ConceptAppendixVar === "true") {
        getConsumer_Evidence_ConceptAppendixVar = "false"; 
        loadIframe(iframe,url);                        
    }
}

function getEnvironmentalImpactAppendix() {
    var iframe = jq("#iframeEnvironmental_ImpactAppendix");
    var url = jq('#idEnvironmental_ImpactAppendix').attr('value');
    if(getEnvironmental_ImpactAppendixVar === "true") {
        getEnvironmental_ImpactAppendixVar = "false";
        loadIframe(iframe,url);                        
    }
}

function getMilestonesAppendix() {
    var iframe = jq("#iframeMilestonesAppendix");
    var url = jq('#idMilestonesAppendix').attr('value');      
    if(getMilestonesAppendixVar === "true") {
        getMilestonesAppendixVar = "false";  
        loadIframe(iframe,url);                        
    }
}

function getRiskAppendix() {
    var iframe = jq("#iframeRiskAppendix");
    var url = jq('#idRiskAppendix').attr('value');        
    if(getRiskAppendixVar === "true") {
        getRiskAppendixVar = "false";         
        loadIframe(iframe,url);                        
    }
}

function getRolloutPlansAppendix() {
    var iframe = jq("#iframeRollout_PlansAppendix");
    var url = jq('#idRollout_PlansAppendix').attr('value');    
    if(getRollout_PlansAppendixVar === "true") {
        getRollout_PlansAppendixVar = "false";               
        loadIframe(iframe,url);                        
    }
}

function getCountryFeedbackRequirementsAppendix() {
    var iframe = jq("#iframeCountry_Feedback_RequirementsAppendix");
    var url = jq('#idCountry_Feedback_RequirementsAppendix').attr('value');    
    if(getCountry_Feedback_RequirementsAppendixVar === "true") {
        getCountry_Feedback_RequirementsAppendixVar = "false";      
        loadIframe(iframe,url);                        
    }
}

function getMixQualificationPlanandActionStandardsAppendix() {
    var iframe = jq("#iframeMix_Qualification_Plan_and_Action_StandardsAppendix");
    var url = jq('#idMix_Qualification_Plan_and_Action_StandardsAppendix').attr('value');   
    if(getMix_Qualification_Plan_and_Action_StandardsAppendixVar === "true") {
        getMix_Qualification_Plan_and_Action_StandardsAppendixVar = "false";
        loadIframe(iframe,url);                        
    }
}

function getAssumptionsAppendix() {
    var iframe = jq("#iframeAssumptionsAppendix");
    var url = jq('#idAssumptionsAppendix').attr('value');           
    if(getAssumptionsAppendixVar === "true") {
        getAssumptionsAppendixVar = "false";       
        loadIframe(iframe,url);                        
    }
}

function getBDBBAlignmentAppendix() {
    var iframe = jq("#iframeBDBB_AlignmentAppendix");
    var url = jq('#idBDBB_AlignmentAppendix').attr('value');       
    if(getBDBB_AlignmentAppendixVar === "true") {
        getBDBB_AlignmentAppendixVar = "false";            
        loadIframe(iframe,url);                        
    }             
}

function getAssortmentStrategyAppendix() {
    var iframe = jq("#iframeAssortment_StrategyAppendix");
    var url = jq('#idAssortment_StrategyAppendix').attr('value');     
    if(getAssortment_StrategyAppendixVar === "true") {
        getAssortment_StrategyAppendixVar = "false";
        loadIframe(iframe,url);                        
    }
}

function getMonitoringPerformanceinMarketAppendix() {
    var iframe = jq("#iframeMonitoring_Performance_in_MarketAppendix");
    var url = jq('#idMonitoring_Performance_in_MarketAppendix').attr('value');
    var iframe2 = jq("#iframeMonitoring_Performance_in_MarketLocalAppendix");
    var url2 = jq('#idMonitoring_Performance_in_MarketLocalAppendix').attr('value');
    if(getMonitoring_Performance_in_MarketAppendixVar === "true") {
        getMonitoring_Performance_in_MarketAppendixVar = "false";
        loadIframe(iframe,url);   
        loadIframe(iframe2,url2);
    }
}

function getTechnicalAppendix() {
    var iframe = jq("#iframeTechnicalAppendix");
    var url = jq('#idTechnicalAppendix').attr('value'); 
    if(getTechnicalAppendixVar === "true") {
        getTechnicalAppendixVar = "false";
        loadIframe(iframe,url);                        
    }
}

function getCustomersChannelsAppendix() {
    var iframe = jq("#iframeCustomers_ChannelsAppendix");
    var url = jq('#idCustomers_ChannelsAppendix').attr('value');
    if(getCustomers_ChannelsAppendixVar === "true") {
        getCustomers_ChannelsAppendixVar = "false";
        loadIframe(iframe,url);                        
    }                    
}

function loadIframe(iframe,url) {
    iframe.height('0px');                                                
    iframe.attr("style", "display:block;"); 
    iframe.attr("src", url);  
    iframe.attr("width", "100%");
    iframe.attr("scrolling", "no");
    iframe.iFrameResize( [{autoResize: true, sizeWidth: true, checkOrigin: false}] );
}  
var sectionId;
function getAttachments(secId) {
    sectionId = secId;
    sforce.connection.query(
        "SELECT Id,ParentId,Name FROM Attachment WHERE ParentId = '" + secId + "'",
        {onSuccess: getSAttachments, onFailure: sfailed});
}                
function sfailed(error) {alert(IPMApp.ContactAdmin);}                
function getSAttachments(queryResult) {
    if(queryResult.size>0){
        var output = "";                                                    
        var records = queryResult.getArray('records');
        for (var i = 0; i < records.length; i++) {
            var attach = records[i];
            output += "<a href=\"/servlet/servlet.FileDownload?file="+attach.Id+"\" target=\"_blank\">"+attach.Name+"</a>, ";
        }
        output = output.slice(0,-2);
        jq("#attachments"+sectionId).html("<span class=\"appBlock fileName\">See attachments: "+output+"</span>");
    }
}

function getAllAttachments() {
    sforce.connection.query(
        "SELECT Id,ParentId,Name FROM Attachment WHERE ParentId in (SELECT ID FROM IPM_Project_Document_Section__c WHERE IPM_Project_Document__c=\'"+IPMApp.projectdocid+"\') ORDER BY ParentId",
        {onSuccess: getAllSAttachments, onFailure: sfailed});
}              
function getAllSAttachments(queryResult) {
    if(queryResult.size>0){                        
        var parentIdArray = [];
        var records = queryResult.getArray('records');
        for (var i = 0; i < records.length; i++) {
            var attach = records[i];
            if(parentIdArray.indexOf(attach.ParentId) === -1) {
                parentIdArray.push(attach.ParentId);
            }
        }
        for (var p = 0; p < parentIdArray.length; p++) {
            var output = "";
            var pId = parentIdArray[p];
            for (var i = 0; i < records.length; i++) {
                var attach = records[i];
                if(pId === attach.ParentId) {
                    output += "<a href=\"/servlet/servlet.FileDownload?file="+attach.Id+"\" target=\"_blank\">"+attach.Name+"</a>, ";
                }
            }
            output = output.slice(0,-2);
            jq("#attachments"+pId).html("<span class=\"appBlock fileName\">See attachments: "+output+"</span>");
        }
    }
}

