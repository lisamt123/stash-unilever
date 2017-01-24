/*  
 ***************************************************************************************************
 *@Description:This script is used to open the risk questions modal
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
 ***************************************************************************************************
 */
 /* Below script works on click event. It opens the risk questionnaire modal. */
    var jq = jQuery.noConflict();
    jq(document).on('click', '.riskModal', function(e){
    e.preventDefault();
            var url =jq(this).attr('value');
            var modalTitle = jq(this).attr('modalTitle');
            openModal(url);
            jq('#ipmModal .modal-title').html(modalTitle);
            jq('#ipmModal .modal-dialog').width('75%');
            jq('#ipmModal .modal-dialog').height('90%');
    }); 
                       