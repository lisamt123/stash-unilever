/********************************************************************
 *@Description:This script is used for Closing Modal after File Upload
 *@Author: Cognizant
 *@Created Date: 25/09/2015 
********************************************************************/
var jq = jQuery.noConflict();
/* Below script closes a modal and redirects to a page when the condition is true on page load. */
jq(document).ready(function() {
    var uploadfile = IPMAppFile.fileload;
    if (uploadfile === 'true') {
        var frame = parent.document.getElementById("ipmModal");
        jq(frame).find('.close').trigger('click');
        parent.location.assign(IPMAppFile.projurl + '?Id=' + IPMAppFile.projid + '&projDocSecId=' + IPMAppFile.docsecid);
    }
});