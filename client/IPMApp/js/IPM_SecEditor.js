/*  
 ***************************************************************************************************
 *@Description:This script is used to develop Gate Document Section Editor page specific interaction 
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
 ***************************************************************************************************
 */
var jq = jQuery.noConflict();
jq(document).ready(function() {
	jq('.cust-overlay').hide();
/* Below code is related to comments box */
    if (navigator.appVersion.match(/MSIE [\d.]+/)) {
        var placeholderText = 'Enter your action plan';
        jq('#riskCommentBox').val(placeholderText);
        jq('#riskCommentBox').blur(function() {
            var $this = jq(this);
            $this.val() == '' ? $this.val(placeholderText) : false;
        });
        jq('#riskCommentBox').focus(function() {
            $this.val() == placeholderText ? $this.val('') : false;
        });
    }
	
/* Below code is to redirect to a page after closing the modal */
	jq("#ipmModal .close").on("click", function() {
		if (jq("#ipmModal .modal-title").text().indexOf("Comment") != -1 && window.top.location.href.indexOf(IPMAppSE.SectionEditorPageRef) > -1) {
			gotoPage();
		}
	});
    jq("#riskCommentBox").attr("placeholder", "Enter your action plan");
    jq("[data-toggle=tooltip]").tooltip();
    jq('#ipmSecEditorTab .ipmTabContent').hide();
    var tabToBeSelected = getParameterByName('ipmTab');

    if (tabToBeSelected.length != 0) {
        jq('#ipmSecEditorTab .ipmTabs li.' + tabToBeSelected).addClass('active');
        jq('div#' + tabToBeSelected).show();
    } else {
        jq('#ipmSecEditorTab .ipmTabs li:first').addClass('active');
        jq('#ipmSecEditorTab .ipmTabContent:first').show();
    }
	
/* Below code is related to accordion functionality */

	jq(".contenWrapper .ipmAcrdnExpand").hide();
	if(window.location.href.indexOf("IPM_GateDocument") > -1){
		jq(".contenWrapper").find(".contenWrapper").find(".ecoDesignTable").find(".ipmAcrdnExpand").show();
	}
	jq(".contenWrapper").find(".ipmAcrdnExpand").find(".aHead:last").css("border","none");
	jq(".contenWrapper .ipmAcrdnExpand:first").not(':empty').show();    
	jq(".contenWrapper").on("click", ".ipmAccordian .expico", function(){ 
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
	jq(".removebutton input").removeClass('btn');
		jq(".contenWrapper").find(".ipmAccordian .aHead .expico").removeClass("fa-minus");
		jq(".contenWrapper").find(".ipmAccordian .aHead .expico").addClass("fa-plus");
		jq(".contenWrapper").find(".ipmAccordian .aHead:first .expico").removeClass("fa-plus");
		jq(".contenWrapper").find(".ipmAccordian .aHead:first .expico").addClass("fa-minus");
		jq(".contenWrapper").find(".ipmAccordian .ipmAcrdnExpand:first .aHead .expico").removeClass("fa-minus");
		jq(".contenWrapper").find(".ipmAccordian .ipmAcrdnExpand:first .aHead .expico").addClass("fa-plus");

    jq('#ipmSecEditorTab .ipmTabs li').on('click', function(e) {
        e.preventDefault();
        jq('#ipmSecEditorTab .ipmTabs li').removeClass('active');
        var $this = jq(this);
        var getId = $this.attr('class');
        jq('#ipmSecEditorTab .ipmTabContent').hide();
        $this.addClass('active');
        jq('#' + getId).fadeIn("fast");
    });
    jq(".ipmSectionEditor .checkAll").each(function() {
        var $this = jq(this);
        $this.on("click", function() {
            if ($this.is(":checked")) {
                jq(".ipmSectionEditor .checkAll").prop("checked", true);
                Notify();
            } else {
                jq(".ipmSectionEditor .checkAll").prop("checked", false);
                Notify1();
            }
        });
    });
    jq(".ipmSectionEditor .checkAll1").each(function() {
        var $this = jq(this);
        $this.on("click", function() {
            if ($this.is(":checked")) {
                jq(".ipmSectionEditor .checkAll1").prop("checked", true);
                Notify();
            } else {
                jq(".ipmSectionEditor .checkAll1").prop("checked", false);
                Notify1();
            }
        });
    });

    ipmModal('#addTask', 'Add To-do', '320px', '600px', '2%');
    ipmModal('#uploadImage', 'Click to Upload Image', '400px', '200px', '15%');
	ipmModal('#consumerImage', 'Click to Upload Image', '400px', '200px', '15%');

    jq(document).on("click", ".ipmAccordion .evidenceHead span.expico", function() {
        accordion(this);
    });
	
/* Below code is to open comments and history modal */
    jq(".comments,.history").each(function() {
        var $this = jq(this);
        var url = $this.attr('value');
        var id = $this.attr('id');
        var title = $this.attr('title');
        ipmModal("#" + id, title, '50%', '90%', '2%');

    });
	
/* Below code is to open attach files modal */
    jq(".attachFiles").each(function() {
        var $this = jq(this);
        var url = $this.attr('value');
        var id = $this.attr('id');
        var title = $this.attr('title');
        ipmModal("#" + id, title, '35%', '30%', '10%');

    });
    /**** Customer Channel ****/
    jq('.infoCheck .checkSub').click(function() {
        var $this = jq(this);
        if (jq(this).is(":checked")) {
            $this.parent().prev().addClass("fontBold");
        } else {
            $this.parent().prev().removeClass("fontBold");
        }
    });

    jq('.checkSub').each(function() {
        var $this = jq(this);
        if ($this.is(":checked")) {
            $this.closest(".infoCheck").prev().addClass("fontBold");
        } else {
            $this.closest(".infoCheck").prev().removeClass("fontBold");
        }
    });

    jq(document).on('click', '#ipmDeleteModal .removeTask', function() {
        deleteTaskJs(this);
    });

    /* ***CRRT Section*** */
    jq(".projectRadioButton input[type=radio]").each(function() {
        var $this = jq(this);
        var statCRRT = $this.attr("data-checked");
        if (statCRRT == "true") {
            $this.prop("checked", true);
        } else {
            $this.prop("checked", false);
        }
    });

    jq(".projectRadioButton input[type=radio]").each(function() {
        var $this = jq(this);
        var statCRRT = jq(this).attr("data-disabled");
        if (statCRRT == "true") {
            $this.attr("disabled", "disabled");
        } else {
            $this.removeAttr("disabled");
        }
    });
	
	hilightTaskScript();

});

/* Below code is related to accordion functionality */
function accordion(elem) {
    if (jq(elem).closest(".evidenceHead").parents(".cevidenceborder").next(".ipmAcrdnExpand").is(":visible") && jq(elem).closest(".evidenceHead").parents(".cevidenceborder").next(".ipmAcrdnExpand").not(':empty')) {
        jq(elem).closest(".evidenceHead").parents(".cevidenceborder").next(".ipmAcrdnExpand").slideUp("fast");
        jq(elem).removeClass("fa-minus");
        jq(elem).addClass("fa-plus");
    } else {
        jq(elem).closest(".evidenceHead").parents(".cevidenceborder").next(".ipmAcrdnExpand").slideDown("fast");
        jq(elem).removeClass("fa-plus");
        jq(elem).addClass("fa-minus");
    }
}

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function hilightTaskScript(){
	jq(".info").tooltip({ position: { my: 'center top', at: 'center bottom+10' }});
	jq(".deleteChannel").tooltip({ position: { my: 'center top', at: 'center bottom+10' }});	
	jq(".arrow-left").tooltip({ position: { my: 'left top', at: 'center bottom+10' },tooltipClass:'ui-lefttip'}); 
	jq(".aTabs").find("input[type=checkbox]:checked").closest(".aTabs").addClass("active");
}

function callAttachDelete(attid) {
    CallAttachId(attid);
}

/* \\** CRRT Section*** */

/* Below code is to open delete modal */
function ipmTaskDel(str, isLst, gateName, secName) {

    var errMsg = ''
    if (isLst == 1) {
        errMsg = 'All tasks correlating to the ' + gateName + ' Section ' + secName + '  have been removed. Would you like to remove this section from the ' + gateName + ' Document?';
    } else {
        errMsg = IPMAppSE.deleteTaskMsg;
    }
    jq('#ipmDeleteModal .modal-title').html(IPMAppSE.RemoveTask);
    jq('#ipmDeleteModal .confirmMsg').html(errMsg);	
    jq('#ipmDeleteModal .modal-body').css({"height":"120px","margin-right":"15px"});
    jq('#ipmDeleteModal .confirmAction').attr('value', str);
    jq(".confirmAction").addClass("removeTask");
}

/* Below code is to redirect to a page */
function gotoPage() {
             window.top.location.href = IPMAppSE.SectionEditorPageRef+'?id='+IPMAppSE.projectId+'&projDocSecId='+IPMAppSE.projDocSecId;
}
