/*  
***********************************************************************************
*@Description:This page is used to upload images in BOSSCARD and Project Initiation pages
*@Author: Cognizant
*@Created Date: 25/06/2015
***********************************************************************************
*/  
var jq=jQuery.noConflict();
/* Below script is related to Image upload Modal. If uploads image variable is true it triggers close button which closes the modal. */
    jq(document).ready(function() {
        var uploadImg = IPMAppImgLoad.loadImg;
         if(uploadImg === 'true'){
             var frame = parent.document.getElementById("ipmModal");
             var frame2 = parent.document.getElementById("ipmUploadImage");
             jq(frame).find('.close').trigger('click');
             jq(frame2).find('.close').trigger('click');
         }
    });