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
checkForModifications001: function() {
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
 if($(":input").checkForModifications001()){
     $(this).removeAttr( "data-dismiss" );
     unloadIframe();
 }
 else{
     $(this).attr("data-dismiss","modal");
 }
};



$(".modal-content .close:visible", parent.parent.document).not(".no-navigate-away").click(enableNavigationConfirmation);
});
function unloadIframe(){
window.top.location.href=IPMAppCPP.corePage+'?Id='+IPMAppCPP.projectId;
}
function unloadPage()
{ 
if($(":input").checkForModifications001() && !$("body").data("isSkipNavigationConfirm") && !flag){
  return IPMAppCPP.wmessage;

}
} 

window.onbeforeunload = unloadPage;
})(jq); 
function skipValidation() {
jq("body").data("isSkipNavigationConfirm", true);
}

function validate(){
    flag = true;
}