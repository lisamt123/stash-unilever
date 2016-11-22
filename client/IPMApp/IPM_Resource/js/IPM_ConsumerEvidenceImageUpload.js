/***********************************************************************
 *@Description:This script is used to upload images for Consumer Evidence
 *@Author: Cognizant
 *@Created Date: 25/06/2015  
 ***********************************************************************/
var jq = jQuery.noConflict();
var unsaved = false;
/* Below script works on page load. If the condition is true it closes the modal and redirects the page to Gate document section editor page. */
jq(document).ready(function() {
    var uploadImg = IPMAppCEIMG.imgLoad;
    if (uploadImg === 'false') {
        var frame = parent.document.getElementById("ipmModal");
        jq(frame).find('.close').trigger('click');
        parent.location.assign(IPMAppCEIMG.SectionEditorPageRef + '?Id=' + IPMAppCEIMG.projId + '&projDocSecId=' + IPMAppCEIMG.proDocSecid + '&urlCountry=' + IPMAppCEIMG.urlCountry);
    }
});

jq(function() {
    jq(".imgBrowse").change(function() {
        unsaved = true;
    });
  var frame = parent.document.getElementById("ipmModal");
      jq(frame).find('.upimgModal .close').click(function(){
           if(unsaved){
               jq(this).removeAttr( "data-dismiss" );
               unloadImgIframe();
           }
           else{
               jq(this).attr("data-dismiss","modal");
           }
       });
});

function unloadPagebs()
  { 
      if(unsaved){
          return IPMAppCEIMG.wmessage;
      }
  } 
 window.onbeforeunload = unloadPagebs;

function unloadImgIframe(){
  parent.location.assign(IPMAppCEIMG.SectionEditorPageRef + '?Id=' + IPMAppCEIMG.projId + '&projDocSecId=' + IPMAppCEIMG.proDocSecid + '&urlCountry=' + IPMAppCEIMG.urlCountry);
}


function skipVal(){
  unsaved = false;
}