/*********************************************************************
 *@Description:This script is used for Closing Modal after Image Upload
 *@Author: Cognizant
 *@Created Date: 25/09/2015 
*********************************************************************/
var jq = jQuery.noConflict();
var unsaved = false;
/* Below script is related to Image upload Modal. If upload image variable is true it closes the modal and redirects to Gate document section editor page. */
jq(document).ready(function() {
    var uploadImg = IPMAppCHIMG.imgLoad;
    if (uploadImg === 'true') {
        var frame = parent.document.getElementById("ipmModal");
        jq(frame).find('.close').trigger('click');
        parent.location.assign(IPMAppCHIMG.SectionEditorPageRef + '?Id=' + IPMAppCHIMG.projId + '&projDocSecId=' + IPMAppCHIMG.proDocSecid);
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
          return IPMAppCHIMG.wmessage;
      }
  } 
 window.onbeforeunload = unloadPagebs;

function unloadImgIframe(){
  parent.location.assign(IPMAppCHIMG.SectionEditorPageRef + '?Id=' + IPMAppCHIMG.projId + '&projDocSecId=' + IPMAppCHIMG.proDocSecid);
}


function skipVal(){
  unsaved = false;
}