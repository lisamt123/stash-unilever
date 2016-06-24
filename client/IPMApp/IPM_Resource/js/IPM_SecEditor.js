/*  
 ***************************************************************************************************
 *@Description:This script is used to develop Gate Document Section Editor page specific interaction 
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
 ***************************************************************************************************
 */
var jq = jQuery.noConflict();
jq(document).ready(function() {
    jq(".cust-overlay").delay(1500).fadeOut();
/* Below code is related to comments box */
    if (navigator.appVersion.match(/MSIE [\d.]+/)) {
        var placeholderText = 'Enter your action plan';
        jq('#riskCommentBox').val(placeholderText);
        
        /* Below script works on blur event. The risk comments box place holder will be hidden when the user starts typing in the box */
        jq('#riskCommentBox').blur(function() {
            var $this = jq(this);
            $this.val() === '' ? $this.val(placeholderText) : false;
        });
        /* Below script works on focus event. The risk comments box place holder will be hidden when the user focuses on the box */
        jq('#riskCommentBox').focus(function() {
            $this.val() === placeholderText ? $this.val('') : false;
        });
    }
/* Below script works on click event. It redirects to a Gate document section editor page after closing the modal */
    jq("#ipmModal .close").on("click", function() {
        if (jq("#ipmModal .modal-title").text().indexOf("Comment") !== -1 && window.top.location.href.indexOf(IPMAppSE.SectionEditorPageRef) > -1) {
            gotoPage();
        }
    });
    jq("#riskCommentBox").attr("placeholder", "Enter your action plan");
    jq("[data-toggle=tooltip]").tooltip();
    jq('#ipmSecEditorTab .ipmTabContent').hide();
    var tabToBeSelected = getParameterByName('ipmTab');

    if (tabToBeSelected.length !== 0) {
        jq('#ipmSecEditorTab .ipmTabs li.' + tabToBeSelected).addClass('active');
        jq('div#' + tabToBeSelected).show();
    } else {
        jq('#ipmSecEditorTab .ipmTabs li:first').addClass('active');
        jq('#ipmSecEditorTab .ipmTabContent:first').show();
    }
    
/* Below script is related to accordion functionality */
    jq(".contenWrapper .ipmAcrdnExpand").hide();
    if(window.location.href.indexOf("IPM_GateDocument") > -1){
        jq(".contenWrapper").find(".contenWrapper").find(".ecoDesignTable").find(".ipmAcrdnExpand").show();
    }
    /* Below script works on page load. First it hides all the tabs. Then it opens only the first tab. */
    jq(".contenWrapper").find(".ipmAcrdnExpand").find(".aHead:last").css("border","none");
    jq(".contenWrapper .ipmAcrdnExpand:first").not(':empty').show();    
    
    /* Below script is called upon click event where it expands the tab and replaces '+' with '-' or collapses a opened tab and replaces '-' with '+' */
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
    /* Below script works on page load. It adds the + mark for the collapsed one's and adds - for the expanded one */
    jq(".removebutton input").removeClass('btn');
        jq(".contenWrapper").find(".ipmAccordian .aHead .expico").removeClass("fa-minus");
        jq(".contenWrapper").find(".ipmAccordian .aHead .expico").addClass("fa-plus");
        jq(".contenWrapper").find(".ipmAccordian .aHead:first .expico").removeClass("fa-plus");
        jq(".contenWrapper").find(".ipmAccordian .aHead:first .expico").addClass("fa-minus");
        jq(".contenWrapper").find(".ipmAccordian .ipmAcrdnExpand:first .aHead .expico").removeClass("fa-minus");
        jq(".contenWrapper").find(".ipmAccordian .ipmAcrdnExpand:first .aHead .expico").addClass("fa-plus");

        /* Below script is for the Tab functionality on click event. Based on the clicked li the tab is highlighted and the content related the clicked tab is displayed. Also it hides the previous opened content */
    jq('#ipmSecEditorTab .ipmTabs li').on('click', function(e) {
        e.preventDefault();
        jq('#ipmSecEditorTab .ipmTabs li').removeClass('active');
        var $this = jq(this);
        var getId = $this.attr('class');
        jq('#ipmSecEditorTab .ipmTabContent').hide();
        $this.addClass('active');
        jq('#' + getId).fadeIn("fast");
    });
    
    /* Below script works on click event. It calls the accordion function. */
    jq(document).on("click", ".ipmAccordion .evidenceHead span.expico", function() {
        accordion(this);
    });
    chkAllfun();
    modalWin();
    custCheckSub();
    proRadio(); 
    hilightTaskScript();
});

function chkAllfun(){
        /* Below script works on click event. If the check all checkbox is checked it checks the other child checkboxes */
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
    /* Below script works on click event. If the check all checkbox is checked it checks the other child checkboxes */
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
}

function modalWin(){
    ipmModal('#addTask', 'Add To-do', '38%', '560px', '2%');
    ipmModal('#uploadImage', 'Click to Upload Image', '400px', '200px', '15%','','upimgModal');
    ipmModal('#consumerImage', 'Click to Upload Image', '400px', '200px', '15%','','upimgModal');
    
/* Below script is to open comments and history modal */
    jq(".comments,.history").each(function() {
        var $this = jq(this);
        var url = $this.attr('value');
        var id = $this.attr('id');
        var title = $this.attr('title');
        ipmModal("#" + id, title, '50%', '90%', '2%');

    });
    
/* Below script is to open attach files modal */
    jq(".attachFiles").each(function() {
        var $this = jq(this);
        var url = $this.attr('value');
        var id = $this.attr('id');
        var title = $this.attr('title');
        ipmModal("#" + id, title, '35%', '30%', '10%');

    });
}

function proRadio(){
    /* ***CRRT Section*** */
    /* Below script check if the condition is true. If it is true it checks the radio button. */
    jq(".projectRadioButton input[type=radio]").each(function() {
        var $this = jq(this);
        var statCRRT = $this.attr("data-checked");
        if (statCRRT === "true") {
            $this.prop("checked", true);
        } else {
            $this.prop("checked", false);
        }
    });

    /* Below script check if the condition is true. If it is true it disables the radio button. */
    jq(".projectRadioButton input[type=radio]").each(function() {
        var $this = jq(this);
        var statCRRT = jq(this).attr("data-disabled");
        if (statCRRT === "true") {
            $this.attr("disabled", "disabled");
        } else {
            $this.removeAttr("disabled");
        }
    });
    /* Below script works on click. When clicked on remove button it calls a function which deletes the task */
    jq(document).on('click', '#ipmDeleteModal .removeTask', function() {
        deleteTaskJs(this);
    });
}

function custCheckSub(){
    /**** Customer Channel ****/
    
    /* Below script works on click event. It checks if the condition is true. If it is true it adds a class else removes the class. */
    jq('.infoCheck .checkSub').click(function() {
        var $this = jq(this);
        if (jq(this).is(":checked")) {
            $this.parent().prev().addClass("fontBold");
        } else {
            $this.parent().prev().removeClass("fontBold");
        }
    });

    /* Below script check if the condition is true. If it is true it adds a class else removes the class. */
    jq('.checkSub').each(function() {
        var $this = jq(this);
        if ($this.is(":checked")) {
            $this.closest(".infoCheck").prev().addClass("fontBold");
        } else {
            $this.closest(".infoCheck").prev().removeClass("fontBold");
        }
    });
}

/* Below function performs a validation. If the condition is true it shows the accordion content. Also it removes '-' and replaces it with '+'. Also vice versa. */
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

/* Below function performs the replacing the regular expressions */
function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}
/* Below function contains the script which has the tooltip functionality. This function is called when the rerendering happens and the script will run again */
function hilightTaskScript(){
    jq(".info").tooltip({ position: { my: 'center top', at: 'center bottom+10' }});
    jq(".deleteChannel").tooltip({ position: { my: 'center top', at: 'center bottom+10' }});    
    jq(".arrow-left").tooltip({ position: { my: 'left top', at: 'center bottom+10' },tooltipClass:'ui-lefttip'}); 
    jq(".aTabs").find("input[type=checkbox]:checked").closest(".aTabs").addClass("active");
}

/* Below function calls another function */
function callAttachDelete(attid) {
    CallAttachId(attid);
}

/* \\** CRRT Section*** */

/* Below function performs a validation to display the error message inside the modal based on the condition. It also changes 
                    the modal title, modal body's content as per the condition. */
function ipmTaskDel(str, isLst, gateName, secName) {
    var errMsg = ''
    if (isLst === 1) {
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

/* Below function performs a page reload of Gate document section editor page. */
function gotoPage() {
    window.top.location.href = IPMAppSE.SectionEditorPageRef+'?id='+IPMAppSE.projectId+'&projDocSecId='+IPMAppSE.projDocSecId;
}

/* Below script is related to performance breakdown */
function isNumber(e,ele) {
        var element ="";
        if ((window.clipboardData && window.clipboardData.getData) ||  (e.clipboardData && e.clipboardData.getData)){
            var pastedText = undefined;
       
            if (window.clipboardData && window.clipboardData.getData) { // IE
                pastedText = window.clipboardData.getData('Text');
            } 
            
            else if (e.clipboardData && e.clipboardData.getData) {
        
            pastedText = e.clipboardData.getData('text/plain');
            }
               completeText = e.target.value + pastedText;
        
             element = completeText;
         }else{
             element = e.target.value;
        }
        
        var charCode = (e.which) ? e.which : event.keyCode

        if ((charCode !== 44) && (charCode !== 46 || element.indexOf('.') !== -1) &&
            (charCode < 48 || charCode > 57))
            {
            return false;
            }
        return true;
    }
    function paste(e,obj) {
            var totalCharacterCount = e.clipboardData.getData('Text');
            var strValidChars = "0123456789.,";
            var strChar;
            var FilteredChars = "";
            for (i = 0; i < totalCharacterCount.length; i++) {
                strChar = totalCharacterCount.charAt(i);
                if (strValidChars.indexOf(strChar) !== -1) {
                    FilteredChars = FilteredChars + strChar;
                    
                }
            }
           obj.value = FilteredChars;
            
            return false;
        }
        
var editorunsaved = false;
var ckedited = false;
var inputchanged = false;
var rld = false;

jq(function(){
    editorunsaved = false;
    jq('.listContainer :input').change(function(){
        editorunsaved = false;
        inputchanged = false;
    });
    jq('.compcustchannelContainer :input').change(function(){
        editorunsaved = false;
        inputchanged = false;
    });
    
    jq('.secEditorNavList :input').change(function(){
        if(ckedited === true|| inputchanged === true){
            editorunsaved = true;            
        }
    });
    
    editorObj = CKEDITOR.instances;
     
     for (prop in editorObj) {
        if(editorObj.hasOwnProperty(prop)){
            defineOnchange(CKEDITOR.instances, prop);
        }
     }
  
    function defineOnchange(CKEDITORObj, index){
        CKEDITORObj[index].on("change", function() {
          ckedited = true;
          editorunsaved = true;
        });
    }
});
    
function unloadPageseceditor()
{ 
if((ckedited === true || inputchanged === true) && editorunsaved === true)
{
        return IPMAppSE.wmessage;            
}else if(rld)
{
     return IPMAppSE.wmessage;  
}
} 

function saveChanges(){
editorunsaved = false;
}

window.onbeforeunload = unloadPageseceditor;

/* Below code is to redirect to a page on cancel*/
function gotoPageNew() {
editorunsaved = false;
window.top.location.href = IPMAppSE.SectionEditorPageRef+'?id='+IPMAppSE.projectId+'&projDocSecId='+IPMAppSE.projDocSecId;
}    

jq('#ipmModal').on('show.bs.modal', function (e) {
    if(editorunsaved){
        errorMsg = IPMAppSE.wmessage + "\n\nAre you sure you want to leave this page?";
        if (confirm(errorMsg)) {
            editorunsaved = false;
        } else {
            e.preventDefault();
            e.stopPropagation();
        }
    }
})