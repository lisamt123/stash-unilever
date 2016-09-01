/*  
***********************************************************************************
*@Description:This page is used to upload images in BOSSCARD and Project Initiation pages
*@Author: Cognizant
*@Created Date: 25/06/2015
************************************************************************************/ 
 
var jq=jQuery.noConflict();
var unsaved = false;
/* Below script is related to Image upload Modal. If uploads image variable is true it triggers close button which closes the modal. */ 
    jq(document).ready(function() {
    var uploadImg = IPMAppImgLoad.loadImg;
         if(uploadImg === 'true'){
            if(window.parent.location.href.indexOf("Bosscard") > -1) {
             window.parent.location.href=IPMAppImgLoad.bossurl + '?id=' + IPMAppImgLoad.bosscardId;
           }else if(window.parent.location.href.indexOf('Project') > -1){
            window.parent.location.href=IPMAppImgLoad.ProjectSetupUrl + '?Pid=' + IPMAppImgLoad.bosscardId+'&Projectid=projectdetails';
          }else{
                  window.parent.location.reload();       
          }
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
          return IPMAppImgLoad.wmessage;
      }
  } 
 window.onbeforeunload = unloadPagebs;

function unloadImgIframe(){
  if(window.parent.location.href.indexOf("Bosscard") > -1) {
       window.parent.location.href=IPMAppImgLoad.bossurl + '?id=' + IPMAppImgLoad.bosscardId;
   }
}


function skipVal(){
  unsaved = false;
}


