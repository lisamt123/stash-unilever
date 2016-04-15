/*********************************************************************************
 *@Description:This script is used for IPM Gate Document page specific interaction
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
*********************************************************************************/
/* Below code is for the accordion functionality */
jq(document).ready(function() {
	jq(".cust-overlay").delay(1500).fadeOut();
    jq(".contenWrapper .ipmAcrdnExpand").hide();
    if (window.location.href.indexOf("IPM_GateDocument") > -1) {
        jq(".contenWrapper").find(".contenWrapper").find(".ecoDesignTable").find(".ipmAcrdnExpand").show();
    }
    jq(".contenWrapper").find(".ipmAcrdnExpand").find(".aHead:last").css("border", "none");
    jq(".contenWrapper .ipmAcrdnExpand:first").not(':empty').show();
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
        }
    });
    jq(".content.expandTool").on("click", ".expandAll", function() {
        jq(".ipmAccordian").find(".ipmAcrdnExpand").not(':empty').slideDown("fast");
        jq(".ipmAccordian").find(".aHead .expico").removeClass("fa-plus");
        jq(".ipmAccordian").find(".aHead .expico").addClass("fa-minus");
    });
    jq(".content.expandTool").on("click", ".collapseAll", function() {
        jq(".ipmAccordian").find(".ipmAcrdnExpand ").slideUp("fast");
        jq(".ipmAccordian").find(".aHead .expico").addClass("fa-plus");
        jq(".ipmAccordian").find(".aHead .expico").removeClass("fa-minus");
    });
    jq(".gdFilterSection .ipmAcrdnExpand").hide();
    jq(".gdFilterSection .ipmAcrdnExpand").not(':empty').show();
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
    jq(".expandTool").on("click", ".filter.expandAll", function() {
        jq(".ipmAccordion").find(".ipmAcrdnExpand").not(':empty').slideDown("fast");
        jq(".ipmAccordion").find(".pHead .expico").removeClass("fa-plus");
        jq(".ipmAccordion").find(".pHead .expico").addClass("fa-minus");
    });
    jq(".expandTool").on("click", ".filter.collapseAll", function() {
        jq(".ipmAccordion").find(".ipmAcrdnExpand ").slideUp("fast");
        jq(".ipmAccordion").find(".pHead .expico").addClass("fa-plus");
        jq(".ipmAccordion").find(".pHead .expico").removeClass("fa-minus");
    });
    jq(document).ready(function() {
        jq(".removebutton input").removeClass('btn');
        jq(".contenWrapper").find(".ipmAccordian .aHead .expico").removeClass("fa-minus");
        jq(".contenWrapper").find(".ipmAccordian .aHead .expico").addClass("fa-plus");
        jq(".contenWrapper").find(".ipmAccordian .aHead:first .expico").removeClass("fa-plus");
        jq(".contenWrapper").find(".ipmAccordian .aHead:first .expico").addClass("fa-minus");
        jq(".contenWrapper").find(".ipmAccordian .ipmAcrdnExpand:first .aHead .expico").removeClass("fa-minus");
        jq(".contenWrapper").find(".ipmAccordian .ipmAcrdnExpand:first .aHead .expico").addClass("fa-plus");
    });
    /* Below code is for the history modal*/
    jq(".ipmFinancetable").closest("div").css("overflow", "auto");
    jq(".history").each(function() {
        var $this = jq(this);
        var url = $this.attr('value');
        var id = $this.attr('id');
        var title = $this.attr('title');
        jq(document).on('click', "#" + id, function(e) {
            e.preventDefault ? e.preventDefault() : e.returnValue = false;
            openModal(url);
            jq('#ipmModal .modal-title').html(title);
            jq('#ipmModal .modal-dialog').width('50%');
            jq('#ipmModal .modal-dialog').height('90%');
        });
    });		    
    /* Below code is for the change gate document status modal*/
    jq(document).on('click', '.SecStatusUpdate1', function() {
        var url = jq(this).attr('value');
        var modalTitle = 'Change current document status';
        openModal(url);
        jq('#ipmModal .modal-title').html(modalTitle);
        jq('#ipmModal .modal-dialog').width('50%');
        jq('#ipmModal .modal-dialog').height('90%');
    });
    
    jq('.closeMessage').on('click', function() {
        jq(this).closest('.messageBox').remove();
    });
    /* Below code is for the previous gate documents modal*/
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
/* Below code is for the comments modal*/
function openCommentModal(){
	jq(".comments").each(function() {
		var $this = jq(this);
		var url = $this.attr('value');
		var id = $this.attr('id');
		var title = $this.attr('title');
		jq(document).on('click', "#" + id, function(e) {
			e.preventDefault ? e.preventDefault() : e.returnValue = false;			
			openModal(url);
			jq(document).find('#ipmModal').find('.modal-title').html(title);
			jq(document).find('#ipmModal').find('.modal-dialog').width('60%');
			jq(document).find('#ipmModal').find('.modal-dialog').height('90%');
		});
	});
}
/* Below code is for the apply filter functionality*/
function applyFilter() {
    var selValType = [],
        selValStatus = [],
        selValFunRole = [];
    jq("ul.gdFilterType").find("input[type=checkbox]").each(function() {
        if (jq(this).is(':checked')) {
            selValType.push(jq(this).val());
        }
    });
    jq("ul.gdFilterStatus").find("input[type=checkbox]").each(function() {
        if (jq(this).is(':checked')) {
            selValStatus.push(jq(this).val());
        }
    });
    jq("ul.gdFilterFunRole").find("input[type=checkbox]").each(function() {
        if (jq(this).is(':checked')) {
            selValFunRole.push(jq(this).val());
        }
    });
    setFilterValues(selValType.toString(), selValStatus.toString(), selValFunRole.toString());
}
function movePhase() {
    moveToNextPhase();
}
/* Below code is to disable the checkboxes */
function filterBlock() {
    jq('.skipButtoncontainer .ipmButton').removeClass('btn');
    var filterSelector = jq(".docFilter");
    if (IPMApp.NonNegotiableCount == 0) {
        filterSelector.find(".NonNegotiable").prop('disabled', true);
        filterSelector.find(".NonNegotiable").addClass('disabled');
        filterSelector.find(".NonNegotiable").next().addClass('disabled');
    }
    if (IPMApp.OptionalCount == 0) {
        filterSelector.find(".Optional").prop('disabled', true);
        filterSelector.find(".Optional").addClass('disabled');
        filterSelector.find(".Optional").next().addClass('disabled');
    }
    if (IPMApp.NotstartedCount == 0) {
        filterSelector.find(".NotStarted").prop('disabled', true);
        filterSelector.find(".NotStarted").addClass('disabled');
        filterSelector.find(".NotStarted").next().addClass('disabled');
    }
    if (IPMApp.FilledinCount == 0) {
        filterSelector.find(".filled-in").prop('disabled', true);
        filterSelector.find(".filled-in").addClass('disabled');
        filterSelector.find(".filled-in").next().addClass('disabled');
    }

    if (IPMApp.BDCount == 0) {
        filterSelector.find(".bd").prop('disabled', true);
        filterSelector.find(".NonNegotiable").addClass('disabled');
        filterSelector.find(".NonNegotiable").next().addClass('disabled');
    }
    if (IPMApp.CMICount == 0) {
        filterSelector.find(".cmi").prop('disabled', true);
        filterSelector.find(".cmi").addClass('disabled');
        filterSelector.find(".cmi").next().addClass('disabled');
    }
    if (IPMApp.CDCount == 0) {
        filterSelector.find(".cd").prop('disabled', true);
        filterSelector.find(".cd").addClass('disabled');
        filterSelector.find(".cd").next().addClass('disabled');
    }
    if (IPMApp.RnDCount == 0) {
        filterSelector.find(".rnd").prop('disabled', true);
        filterSelector.find(".rnd").addClass('disabled');
        filterSelector.find(".rnd").next().addClass('disabled');
    }
    if (IPMApp.SCCount == 0) {
        filterSelector.find(".sc").prop('disabled', true);
        filterSelector.find(".sc").addClass('disabled');
        filterSelector.find(".sc").next().addClass('disabled');
    }
    if (IPMApp.FinanceCount == 0) {
        filterSelector.find(".fc").prop('disabled', true);
        filterSelector.find(".fc").addClass('disabled');
        filterSelector.find(".fc").next().addClass('disabled');
    }
    if (IPMApp.BBCount == 0) {
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
    /* Below code is for the previous gate documents modal*/
    jq(document).on("click", ".docFilter .checkAll", function() {
        if (jq(this).is(":checked")) {
            jq(this).closest("ul.docFilter").find("input[type=checkbox]").prop("checked", true);
            jq(this).closest("ul").find("input[type=checkbox]").next().addClass("selected");
        } else {
            jq(this).closest("ul.docFilter").find("input[type=checkbox]").prop("checked", false);
            jq(this).closest("ul").find("input[type=checkbox]").next().removeClass("selected");
        }
    });
    /* Below code is for the reset functionality*/
    jq(document).on('click', '#resetFilterBtn', function() {
        filterSelector.find("input[type=checkbox]").prop("checked", true);
    });
    filterSelector.on("click", ".checkSub", function() {
        var $this = jq(this);
        var checkSub = $this.closest("ul").find(".checkSub:checked").closest("li").length;
        var checkNot = $this.closest("ul").find(".checkSub").closest("li").length;
        if (checkNot != checkSub) {
            $this.closest("ul").find("li input.checkAll").prop("checked", false);
            $this.closest("ul").find("li input.checkAll").next().removeClass("selected");
        }
        if (checkNot == checkSub) {
            $this.closest("ul").find("li input.checkAll").prop("checked", true);
            $this.closest("ul").find("li input.checkAll").next().addClass("selected");
        }
    });
}
function resetDocFilters() {
    var filterSelector = jq(".docFilter");
    filterSelector.find("input[type=checkbox]").prop("checked", true);
    filterSelector.find("label").addClass("selected");
    filteredValues();
}
function addbuttonStyle() {
    jq(".ipmAccordian").find("span.aHead").prepend("<span class='expico fa fa-plus'></span>");
}
function movePhase() {
    moveToNextPhase();
}
/* Below code is to check the check boxes*/
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
if (statusCheckApproved == IPMApp.proposed) {
    jq(".ipmAccordian").find(".ipmAcrdnExpand a").removeAttr("href");
}
/* Below code is to close the modal and redirect to gate document page*/
jq("#ipmModal .close").on("click", function() {
    if (jq("#ipmModal .modal-title").text().indexOf("Comment") != -1) {
        window.top.location.href = IPMApp.GateDocPageRef + '?id=' + IPMApp.projectId + '&printDoc=' + IPMApp.printDoc;
    }
});
/* Below code is to open the ship to trade modal*/
jq(document).on('click', '.shipTrade', function(e) {
    e.preventDefault ? e.preventDefault() : e.returnValue = false;
    jq('#shipToPLE .modal-dialog').css({
        'margin-top': '10%',
        'z-index': '999'
    });
});
/* Below code is for the accordion functionality*/
function resetPanel() {
    jq(".contenWrapper").find(".ipmAcrdnExpand").find(".aHead:last").css("border", "none");
    jq(".contenWrapper .ipmAcrdnExpand").find(".ipmAcrdnExpand").hide();
    jq(".contenWrapper .ipmAcrdnExpand").find(".aHead").find(".expico").removeClass("fa-minus");
    jq(".contenWrapper .ipmAcrdnExpand").find(".aHead").find(".expico").addClass("fa-plus");
    jq(".contenWrapper").find(".contenWrapper").find(".ecoDesignTable").find(".ipmAcrdnExpand").show();
    dirApp();
	openCommentModal();
}
function resetPanelSub() {
    jq(".contenWrapper").find(".ipmAcrdnExpand").find(".aHead:last").css("border", "none");
    jq(".contenWrapper .ipmAcrdnExpand").find(".ipmAcrdnExpand").find(".ipmAcrdnExpand").hide();
    jq(".contenWrapper .ipmAcrdnExpand").find(".ipmAcrdnExpand").find(".aHead").find(".expico").removeClass("fa-minus");
    jq(".contenWrapper .ipmAcrdnExpand").find(".ipmAcrdnExpand").find(".aHead").find(".expico").addClass("fa-plus");
    dirApp();
	openCommentModal();
}
function fetchAppendixSections() {
    getAppSections();
}
function shiptrade() {
    parent.location.assign(IPMApp.OverviewPageRef + '?Id=' + IPMApp.projectId);
}
function dirApp() {
    jq(".ipmAccordian.mainTable").on("click", ".appText", function() {
        var appDir = jq(this).attr("data-dir");
        jq(".ipmAccordian.mainTable").find(".aHead").find(".expico").removeClass("fa-minus").addClass("fa-plus");
        jq(".ipmAccordian.mainTable").find(".ipmAcrdnExpand").slideUp("fast");
        jq(".ipmAccordian.appendix").find(">.aHead").find(".expico").removeClass("fa-plus").addClass("fa-minus");
        jq(".ipmAccordian.appendix").find(">.ipmAcrdnExpand").slideDown("fast").find("." + appDir).slideDown("fast");
        jq("." + appDir).closest(".ipmAcrdnExpand").prev(".aHead").find(".expico").removeClass("fa-plus").addClass("fa-minus");
        jq("html, body").scrollTop(jq("." + appDir).offset().top);
    });
}
jq(window).load(function(){
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
