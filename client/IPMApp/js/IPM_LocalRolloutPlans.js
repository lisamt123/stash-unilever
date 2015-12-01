/***********************************************************************************
 *@Description:This script is used for Local Roll out component specific interaction
 *@Author: Cognizant
 *@Created Date: 22/05/2015 
***********************************************************************************/
/* Below code is to open the local roll out modal */
jq(document).on('click', '.localRollout', function(e) {
    e.preventDefault ? e.preventDefault() : e.returnValue = false;
    jq('#ipmLocalRollout .modal-dialog').width('600px');
    jq('#ipmLocalRollout .modal-dialog').height('250px');
    jq('#ipmLocalRollout .modal-dialog').css({
        'margin-top': '2%',
        'z-index': '999'
    });
});