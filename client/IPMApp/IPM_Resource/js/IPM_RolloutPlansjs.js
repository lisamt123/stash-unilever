/*  
**************************************************************************************************
*@Description:This script is used to maintain specific view of accordian for IPM Rollout Plan Page
*@Author: Cognizant
*@Created Date: 28/05/2015 
**************************************************************************************************
*/
var jq= jQuery.noConflict();
jq(document).ready(function(){

jq(".ipmAccordion").find(".pHead:first span.expico-square").removeClass("fa-plus").addClass("fa-minus");

    var selectedCountries=[];
    var unselectedCountries=[];
    
/* Below script works on click event. If the country list check box is checkbox then the id of the element is pushed to a array. 
    Then the array is passed to function which changes the MCO. */
    jq(document).off('click', '.changeMCOTab').on('click','.changeMCOTab', function()
    {
        var changeMCOTab = jq(this);
        // passed from front end
        var previousMcoCode = IPMRollOutAdd.SelectedMCO;
        var mcoCode = changeMCOTab.attr('id');
        var keyMCO = jq('#keyMCO').is(":checked");
        
        jq('.countryFilter .countryList input:checkbox').each(function(){
            var cntryInput = jq(this);
            if(cntryInput.is(":checked")){
                selectedCountries.push(cntryInput.attr('id'));
            } else {
                unselectedCountries.push(cntryInput.attr('id'));
            }
        });
        changeMCO(selectedCountries.toString(),unselectedCountries.toString(),mcoCode,previousMcoCode,keyMCO);
    });
    
    /* Below script works on click event. If the country list check box is checkbox then the id of the element is pushed to a array. 
    Then the array is passed to function which changes the cluster. */
    jq(document).off('click', '.changeClusterTab').on('click','.changeClusterTab', function()
    {
        var previousMcoCode = IPMRollOutAdd.SelectedMCO;
        var clusterCode = jq(this).attr('id');
        var keyMCO = jq('#keyMCO').is(":checked");
        
        jq('.countryFilter .countryList input:checkbox').each(function(){
            var cntryInput = jq(this);
            if(cntryInput.is(":checked")){
                selectedCountries.push(cntryInput.attr('id'));
            } else {
                unselectedCountries.push(cntryInput.attr('id'));
            }
        });
        changeCluster(selectedCountries.toString(),unselectedCountries.toString(),clusterCode,previousMcoCode,keyMCO);
    });
    
    /* Below script works on click event. If the country list check box is checkbox then the id of the element is pushed to a array. 
    Then the array is passed to function which generates the rollouts */
    jq(document).off('click', '.generateRolloutBtn').on('click','.generateRolloutBtn', function()
    {
        var previousMcoCode = IPMRollOutAdd.SelectedMCO;
        var keyMCO = jq('#keyMCO').is(":checked");
        jq('.countryFilter .countryList input:checkbox').each(function(){
            var cntryInput = jq(this);
            if(cntryInput.is(":checked")){
                selectedCountries.push(cntryInput.attr('id'));
            } else {
                unselectedCountries.push(cntryInput.attr('id'));
            }
        });
        generateRollouts(selectedCountries.toString(),unselectedCountries.toString(),previousMcoCode,keyMCO);
        var projectId = "{!projectId}";
                            
    });
    
/* Below script works on click. If the select all checkbox is checked then all the other checkboxes will be checked. */
    jq(document).off('click', '#selectAll').on('click','#selectAll', function()
    {
        var $this = jq(this);
        var findInput = $this.closest("ul").find("li input[type=checkbox]");
        var findLabel = $this.closest("ul").find("li label");
        if($this.is(":checked")){
            findInput.prop("checked", true);
            findLabel.addClass("selected");
        }else{
            findInput.prop("checked", false);
            findLabel.removeClass("selected");
        }
    });

/* Below script works on click event. It opens the add member modal */
     jq(document).off('click', '#selectproLeader').on('click','#selectproLeader', function(e)
     {
        e.preventDefault ? e.preventDefault() : e.returnValue = false;
        var url = jq(this).attr('value');
        var mtitle = jq(this).attr('html-text');
        jq("#ipmAddMemberModal .modal-body").html('<iframe frameborder="0" height="100%" width="100%" marginheight="0" marginwidth="0" allowtransparency="true" src= "' + url + '"></iframe>');
        jq('#ipmAddMemberModal .modal-dialog').width('700px');
        jq('#ipmAddMemberModal .modal-dialog').height('610px');
        jq('#ipmAddMemberModal .modal-dialog').css({'margin-top': '2%','z-index': '999'});
        jq('#ipmAddMemberModal .modal-title').html(mtitle);
    });
    scriptPanelLoad();  
        
});
function setFocusOnLoad() {}
function scriptPanelLoad(){
    var keyMCO = jq('#keyMCO');
    var srchTxt = jq('#srchTxt');
    
    /* Below script performs a css class check. If the checkbox has a class 'selected' it checks the checkbox */
   jq('.countrybg input:checkbox').each(function(){
        var $this = jq(this);
        if($this.hasClass('selected')){
            $this.prop('checked', 'true');
        }
        
        if($this.hasClass('disabled')){
            $this.prop('disabled', 'true');
        }
    }); 
    
        if(keyMCO.hasClass('selected')){
            keyMCO.prop('checked', 'true');
        }
        srchTxt.addClass('placeholder');
        srchTxt.val(srchTxt.attr('placeholder'));   
        
        /* Below script works on keypress. When user presses enter key a search function is called */
        jq( ".placeholder" ).on( "keypress", function(event) {
              if(event.which === 13) {                                      
              callsearch();
              return false;        
              }
         });                  
}

/* Below function opens a delete countries modal. */
 function deleteRcountries() {
        var title = jq('.delrout').attr('value');
        jq('#deleteRcountry').modal({
            show: true,
            keyboard: false,
            backdrop: 'static'
        });
        jq('#deleteRcountry .modal-title').html(title);
        jq('#deleteRcountry .modal-dialog').width('600px');
        jq('#deleteRcountry .modal-dialog').height('170px');
        jq('#deleteRcountry .modal-dialog').css({
            'margin-top': '10%',
            'z-index': '999'
        });
        jq(".confirmdelrollout").addClass("removerollout");
    }
    
    /* Below function performs the tld date check. If the condition is true it displays a tld warning modal */
    function checkTLDDate(param){
        selectedDateInputBox = param;
        var newTLDValue = param.defaultValue;
        tldOrignalValue = param.value;
        if(newTLDValue !== tldOrignalValue){
            jq('#tldWarningDialog').modal('show'); 
            return false;
        }
        return true;
    }

    function revertTLDValue(){
       selectedDateInputBox.value = selectedDateInputBox.defaultValue;
    }
    function hideTldWarningDialog(){
        jq('#tldWarningDialog').modal('hide'); 
    }
    var selectedDateInputBox = "";
    function setChangedDate()
    {
        saveChangedTLDjs();
    }
    
    /* Below function assigns a variable to the value. */
    function revertTLDValue(){
        selectedDateField.value = tldOrignalValue;
    }
    
    /* Below function hides the tld warning modal. */
    function hideTldWarningDialog(){
        jq('#tldWarningDialog').modal('hide'); 
    }
    var tldOrignalValue = "";
    var selectedDateField = "";
    
var unsaved = false;

jq(function(){
    jq(':input').change(function() {
        
        if(jq(this).attr('id') !== "phSearchInput"){
            unsaved = true;
        }
    });
});
        
function unloadPage()
{ 
    if(unsaved){
        return IPMProAppRP.wmessage;           
    }
} 

window.onbeforeunload = unloadPage;

/* Below code is to skip the unsaved changes*/
function skipValidation() {
    unsaved = false;
}

jq('.rollSelectList').on('click', function (e) {
    var valueSelected = this.value;
    jq(this).prev('.hideDupfield').attr('value',valueSelected);
    var dataId = jq(this).prev('.hideDupfield').attr('data-holder');
    holdRolloutsBrand(dataId,valueSelected);
});
jq(function(){
    jq('.hideDupfield').each(function(){
        var holder = jq(this).attr('value');
       jq('.rollSelectList option').filter(function() {
            return this.text === holder; 
        }).attr('selected', true);
    });    
});