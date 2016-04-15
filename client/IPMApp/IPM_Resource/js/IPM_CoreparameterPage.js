/*********************************************************************************
 *@Description:This script is used for project parameters page specific interaction
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
*********************************************************************************/
var jq = jQuery.noConflict();
jq(document).ready(function() {
	jq(".cust-overlay").hide();
    var ipmEditProjectMD = jq('#ipmEditProject .modal-dialog');
    var ipmEditCoreparametersMD = jq('#ipmEditCoreparameters .modal-dialog');
    var ipmEditAdditionalParametersMD = jq('#ipmEditAdditionalParameters .modal-dialog');
    jq('.ipmFinancialTable td').find('img[src$="spacer.gif"]').css('display', 'none');
	
/* Below script works on click event. It opens a modal where user can edit the project details. */
    jq(document).on('click', '.editProject', function(e) {
        e.preventDefault ? e.preventDefault() : e.returnValue = false;
        var url = jq(this).attr('value');
        jq("#ipmEditProject .modal-body").html('<iframe id="editPro" frameborder="0" height="100%" width="100%" marginheight="0" marginwidth="0" allowtransparency="true" src= "' + url + '"></iframe>');
        ipmEditProjectMD.addClass('editprorevamp');
        ipmEditProjectMD.width('95%');
        ipmEditProjectMD.height('95%');
    });
	
/* Below script works on click event. It opens a modal where user can edit the coreparameters. */
    jq(document).on('click', '.editcoreparam', function(e) {
        e.preventDefault ? e.preventDefault() : e.returnValue = false;
        var url = jq(this).attr('value');
        jq("#ipmEditCoreparameters .modal-body").html('<iframe frameborder="0" height="100%" width="100%" marginheight="0" marginwidth="0" allowtransparency="true" src= "' + url + '"></iframe>');
        ipmEditCoreparametersMD.addClass('editcorerevamp');
        ipmEditCoreparametersMD.width('95%');
        ipmEditCoreparametersMD.height('95%');
    });
	if(window.location.href.indexOf("BETOptions") > -1){
            document.getElementById("editAddtnlParam").click();
    }
	
	hilightTaskScript();
});
/* Below script works on page load. If both the conditions are true, it moves to third coreparameters question and also it displays the correct help text pointer below. */
jq(window).load(function() {
    if (IPMProAppCP.tpluser === 'true' && IPMProAppCP.addtnlParameter === 'false') {
        jq('#myCarousel').carousel(2);
        var $this = jq("#slideBar3 label:not('.fstchild'):");
        var labelWidth = $this.innerWidth() / 2;
        jq(".hlPointer").remove();
        jq(".helpContent").append("<div class='hlPointer'></div>");
        var posPointer = $this.position().left;
        jq(".helpContent").find(".hlPointer").css("left", posPointer + labelWidth - 14 + "px");
    }
    setTimeout(function() {
        setSlider(1);
    }, 500);
});

/* Below script works on page load. Based on the question the carousel moves to the exact question number which is retrieved from the backend. */
jq(window).load(function() {
    if (window.location.href.indexOf("qone") > -1) {
        jq('#myCarousel').carousel(0);
        setTimeout(function() {
            setSlider(1);
        }, 500);
    } else if (window.location.href.indexOf("qtwo") > -1) {
        jq('#myCarousel').carousel(1);
        setTimeout(function() {
            setSlider(2);
        }, 500);
    } else if (window.location.href.indexOf("qthree") > -1) {
        jq('#myCarousel').carousel(2);
        setTimeout(function() {
            setSlider(3);
        }, 500);
    }
});

/* Below function contains the script which has the tooltip functionality. This function is called when the rerendering happens and the script will run again */
function hilightTaskScript(){
	jq(".info").tooltip({ position: { my: 'center top', at: 'center bottom+10' }});
	jq(".deleteChannel").tooltip({ position: { my: 'center top', at: 'center bottom+10' }});	
	jq(".arrow-left").tooltip({ position: { my: 'left top', at: 'center bottom+10' },tooltipClass:'ui-lefttip'}); 
	jq(".aTabs").find("input[type=checkbox]:checked").closest(".aTabs").addClass("active");
}

var flag = false;
(function ($) {
function processValue (param) {
var el = $(this);
if(el.is(":text") || el.is("textarea") || el.is(":file")){
el.data(param, el.val());
}
else if(el.is(":checkbox") || el.is(":radio")){
el.data(param, el[0].checked);
}
else if(el.is("select")){
el.data(param, el.val());
}
}

$.fn.extend({
dumpInitialValues : function(){
this.each(function() {
  processValue.call(this, "initialValue");
});
},
checkForModifications: function() {
var flag = false;
this.each(function() {
  var el = $(this);
  if(el.is(":text") || el.is("textarea") || el.is(":file")){
	flag = (el.data("initialValue") != el.val());
  }
  else if(el.is(":checkbox") || el.is(":radio")){
	flag = (el.data("initialValue") != el[0].checked);
  }
  else if(el.is("select")){
	flag = (el.data("initialValue") != el.val());
  }
  if(flag) 
  {  
	return false;
  }
})
return flag;
}
});


$(function(){       
$(":input").dumpInitialValues();
function enableNavigationConfirmation(){
 if($(":input").checkForModifications()){
	 $(this).removeAttr( "data-dismiss" );
	 unloadIframe();
 }
 else{
	 $(this).attr("data-dismiss","modal");
 }
};


$("iframe").each(function(){
$(this).contents().find(".modal-content .close").click(enableNavigationConfirmation);
$("iframe", $(this).contents()).each(function(){
   $(this).contents().find(".modal-content .close").click(enableNavigationConfirmation);
})
});
$(".modal-content .close:visible", parent.parent.document).not(".no-navigate-away").click(enableNavigationConfirmation);   
});
function unloadIframe(){
top.location.href=IPMAppCPP.corePage+'?Id='+IPMAppCPP.projectId;
}
function unloadPage()
{ 
if($(":input").checkForModifications() && !$("body").data("isSkipNavigationConfirm") && !flag){
  return IPMAppCPP.wmessage;
}
} 

window.onbeforeunload = unloadPage;
})(jq); 
function skipValidation() {
jq("body").data("isSkipNavigationConfirm", true);
parent.parent.location.reload();
}

function validate(){
	flag = true;
}
