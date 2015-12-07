/********************************************************************
 *@Description:This script is used for Closing Modal after File Upload
 *@Author: Cognizant
 *@Created Date: 25/09/2015 
********************************************************************/
/* Below code is used to close the modal after file upload */
var jq = jQuery.noConflict();
jq(document).ready(function() {
    var uploadfile = IPMAppFile.fileload;
    if (uploadfile == 'true') {
        var frame = parent.document.getElementById("ipmModal");
        jq(frame).find('.close').trigger('click');
        parent.location.assign(IPMAppFile.projurl + '?Id=' + IPMAppFile.projid + '&projDocSecId=' + IPMAppFile.docsecid);
    }
});