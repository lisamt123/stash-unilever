var jq = jQuery.noConflict();
jq(document).ready(function() {
    var uploadImg = IPMAppImgLoad.loadImg;
    if (uploadImg === "true") {
        setCookie("uploadImgFilePath", "");
        var frame = parent.document.getElementById("ipmModal");
        var frame2 = parent.document.getElementById("ipmUploadImage");
        jq(frame).find(".close").trigger("click");
        jq(frame2).find(".close").trigger("click");
    }
    

});



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
        flag = (el.data("initialValue") !== el.val());
      }
      else if(el.is(":checkbox") || el.is(":radio")){
        flag = (el.data("initialValue") !== el[0].checked);
      }
      else if(el.is("select")){
        flag = (el.data("initialValue") !== el.val());
      }
      if(flag) {return false;}
    })
    return flag;
  }
});


$(function(){
$("body").data("isSkipNavigationConfirm", false);
$(":input").dumpInitialValues();
$("body").data("closeFired", null);
function enableNavigationConfirmation(){
     if($(":input").checkForModifications(2)){
         $(this).removeAttr( "data-dismiss" );
         window.parent.location.reload();
     }
     else{
         $(this).attr("data-dismiss","modal");
     }
 };
$(".modal-content .close:visible", parent.parent.document).not(".no-navigate-away").click(enableNavigationConfirmation);   
});
function unloadIframe(){
  top.location.href=IPMAppImgLoad.coreUrl+"?Id="+IPMAppImgLoad.projId;
}
function unloadPage()
{ 
  if($(":input").checkForModifications() && !$("body").data("isSkipNavigationConfirm")){
      return IPMAppImgLoad.wmessage;
  }
} 

window.onbeforeunload = unloadPage;

})(jq);
/* Below code is to skip the unsaved changes*/
function skipValidation() {
  jq("body").data("isSkipNavigationConfirm", true);
  
}