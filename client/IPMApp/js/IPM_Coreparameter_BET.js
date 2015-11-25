/***************************************************************************
 *@Description:This script is used for Core Parameters BET related components
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
****************************************************************************/
var jq = jQuery.noConflict();
/* Below script is used for the clear search functionality */
jq(document).ready(function() {
    betCallBack();
});
/* Below script is used add a class for the table row */
function betCallBack() {
    jq('.ipmTable').on('click', 'tbody tr', function() {
        jq(this).find('td input:radio').prop('checked', true);
        jq('.ipmTable tr').removeClass("active1");
        jq(this).addClass("active1");
    });
    jq('.inputsearch').clearSearch();
    /* Below script is used call a function on key press enter in search box  */
    jq(".inputsearch").on("keypress", function(event) {
        if (event.which == 13) { 
            renderBets();
            return false; 
        }
    }); 
    /* Below script is used to open the Add Team Member modal */
    jq(document).on('click', '.addTeamMember', function(e)  {    
        e.preventDefault ? e.preventDefault() : e.returnValue = false;    
        jq('#basicModal .modal-dialog').width('700px');    
        jq('#basicModal .modal-dialog').height('220px');    
        jq('#basicModal .modal-dialog').css({        
            'margin-top': '2%',
            'z-index': '999'    
        });    
        jq('#basicModal .modal-title').html();
    }); 
}
function changeValue(input, textid) {
    document.getElementById(textid).value = input.value;
}