/***************************************************************************
 *@Description:This script is used for Core Parameters BET related components
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
****************************************************************************/
var jq = jQuery.noConflict();
/* Below script calls two other functions on page load. */
jq(document).ready(function() {
    betCallBack();
    hilightTaskScript();
});
function betCallBack() {
/* Below script works on click event. When clicked on row it checks the checkbox and also highlights the row by adding a color. */
    jq('.ipmTable').on('click', 'tbody tr', function() {
        jq(this).find('td input:radio').prop('checked', true);
        jq('.ipmTable tr').removeClass("active1");
        jq(this).addClass("active1");
    });
    jq('.inputsearch').clearSearch();
    /* Below script works on key press event. It calls a function when user press enter in search box. */
    jq(".inputsearch").on("keypress", function(event) {
        if (event.which === 13) { 
            renderBets();
            return false; 
        }
    }); 
    /* Below script works on click event. It opens Add Team Member modal. */
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

/* Below function is used to get the value of an element based on the elements Id. */
function changeValue(input, textid) {
    document.getElementById(textid).value = input.value;
}

/* Below function contains the script which has the tooltip functionality. This function is called when the rerendering happens and the script will run again */
function hilightTaskScript(){
    jq(".info").tooltip({ position: { my: 'center top', at: 'center bottom+10' }});
    jq(".deleteChannel").tooltip({ position: { my: 'center top', at: 'center bottom+10' }});    
    jq(".arrow-left").tooltip({ position: { my: 'left top', at: 'center bottom+10' },tooltipClass:'ui-lefttip'}); 
    jq(".aTabs").find("input[type=checkbox]:checked").closest(".aTabs").addClass("active");
}
