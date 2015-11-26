/***********************************************************************
 *@Description:This script is used to upload images for Consumer Evidence
 *@Author: Cognizant
 *@Created Date: 25/06/2015  
 ***********************************************************************/
/* Below script is to close the Image upload Modal */
var jq = jQuery.noConflict();
jq(document).ready(function() {
    var uploadImg = IPMAppCEIMG.imgLoad;
    if (uploadImg == 'false') {
        var frame = parent.document.getElementById("ipmModal");
        jq(frame).find('.close').trigger('click');
        parent.location.assign(IPMAppCEIMG.SectionEditorPageRef + '?Id=' + IPMAppCEIMG.projId + '&projDocSecId=' + IPMAppCEIMG.proDocSecid);
    }
});