/*********************************************************************
 *@Description:This script is used for Closing Modal after Image Upload
 *@Author: Cognizant
 *@Created Date: 25/09/2015 
*********************************************************************/
var jq = jQuery.noConflict();
/* Below script is related to Image upload Modal. If upload image variable is true it closes the modal and redirects to Gate document section editor page. */
jq(document).ready(function() {
    var uploadImg = IPMAppCHIMG.imgLoad;
    if (uploadImg == 'true') {
        var frame = parent.document.getElementById("ipmModal");
        jq(frame).find('.close').trigger('click');
        parent.location.assign(IPMAppCHIMG.SectionEditorPageRef + '?Id=' + IPMAppCHIMG.projId + '&projDocSecId=' + IPMAppCHIMG.proDocSecid);
    }
});