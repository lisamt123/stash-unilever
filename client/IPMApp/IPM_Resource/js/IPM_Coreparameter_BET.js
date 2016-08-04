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
    sectorPicklist();
});
function sectorPicklist(){
    jq('.ccCheck').change(function(e) {
    if (jq('.sectorposList input[type=checkbox]:checked').length > 20) {
        jq(this).prop('checked', false);
        jq(this).next('label').removeClass('selected');
    }
});
jq(document).on('click', '.sectorposList input[type="checkbox"], .sectorposList li', function(e){
   e.stopPropagation();
});   
jq(document).on('show.bs.dropdown', '.sectorposListContainer', function(){
    jq(this).find('.sectorposList').show(); 
});
jq(document).click(function(e) {
    if( e.target.id !== 'sectorposListUL') {
        jq(".sectorposList").hide();    
    }   
});
jq(document).click(function(e) {
    if( e.target.id !== 'marketposListUL') {
        jq(".sectorposList").hide();    
    }   
});
jq('.ipmSectorDropbuttonscc').click(function(e) {           
    var brandPositionValue = '';
    jq(".sectorposList  input[type=checkbox]").each(function(e){
        if(jq(this).prop('checked') === true){   
            if(brandPositionValue.length > 0)
            {
                brandPositionValue = brandPositionValue +','+jq(this).val();
            }
            else
            {
                brandPositionValue = jq(this).val();
            }
        } 
    });
    jq('.hiddensectorfield').val(brandPositionValue);
    if(brandPositionValue === ''){
        jq('.sectorSelValues').text(IPMAppPS.sectorLabel);
    }
    else{
        jq('.sectorSelValues').text(brandPositionValue);
    }
    jq(".sectorposList").hide(); 
});  
 jq(document).on('click', '.filterActionscc .ipmSectorDropresetcc', function(e){
        e.stopPropagation();
        jq(".sectorposList input:checkbox").each(function() {
             jq(this).prop('checked', false);
           jq(this).next('label').removeClass('selected');
            jq('.sectorSelValues').text(IPMAppPS.sectorLabel);
        });
    });     
if( jq('.hiddensectorfield') !== null && jQuery.type(jq('.hiddensectorfield')) !== 'undefined') 
{
    var brandPicklist = jq('.hiddensectorfield').val();   
    if(jQuery.type(brandPicklist) !== "undefined" && brandPicklist.length > 0 )
    {
        jq('.sectorSelValues').text(brandPicklist);
        var brandArray = brandPicklist.split(',');  
        jq(".sectorposList  input[type=checkbox]").each(function(e){
            var checkboxObj = jq(this);
            jq.each( brandArray, function( i, savedBrandPosition ){
                if(checkboxObj.val() === savedBrandPosition)
                    {
                     checkboxObj.prop('checked',true);
                        return false;
                    }
            }); 
        });
    }
} 
}
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
 window.onload = function replacePickVals(){
            jq('option').filter(function () { return jq(this).html() == "--None--"; }).html('Not Applicable');
};
