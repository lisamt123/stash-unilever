/*********************************************************************************
 *@Description:This script is used for IPM RolloutPlans GKM Feasibility page specific interaction
 *@Author: Cognizant
 *@Created Date: 11/08/2016 
*********************************************************************************/
var jq=jQuery.noConflict();
        var selectedMCOs=[];
        var unselectedMCOs=[];
        var selectedCountries=[];
        var unselectedCountries=[];
        var selectedNoRollouts=[];
        var unselectedNoRollouts=[];                        
        var intiallySelectedMCOs =[];
        var intiallySelectedCountries=[];
        var intiallySelectedNoRollouts=[]; 
        var selectedCountries1=[];
        var unselectedCountries1=[];
        var retainedCountries=[];
    
    function retainVal(){
        var rollVal = [];
        jq('.textC input:radio[name ^=grp]').each(function() {
            if (jq(this).is(":checked")) {
                rollVal.push(jq(this).attr('id'));
            }
            retainedCountries = rollVal.toString();
        });
    }
    
    jq(document).ready(function(){
        scriptPanelLoad()
        regionalscriptpanel();
        hilightTaskScript();
        jq(document).off('click', '.changeClusterTab').on('click','.changeClusterTab', function(){
            var previousMcoCode = IPMregionalApp.SelectedMCO;
            var clusterCode = jq(this).attr('id');
            var keyMCO = jq('#keyMCO').is(":checked");
            var mcoCode = jq(this).attr('id')
            var previousMcoCode = IPMregionalApp.SelectedMCO;
            getRecentCountrySelection();
            retainVal();
            changeCluster(selectedCountries1.toString(),unselectedCountries1.toString(),clusterCode,previousMcoCode,keyMCO);
        });
    });
    
    /* Below code is to check or disable the checkboxes */
    function regionalscriptpanel()
    {   
        jq('input:radio[name ^=grp]').each(function(){
        var $this = jq(this);
        if($this.hasClass('checked')){
            $this.prop('checked', 'true');
        }
        if($this.hasClass('disabled')){
            $this.prop('disabled', 'true');
            }
        });
        var srchTxt = jq('#srchTxt');
        srchTxt.addClass('placeholder');
        srchTxt.val(srchTxt.attr('placeholder'));
        jq(document).on('keypress, keydown','[placeholder]',function() {
            var input = jq(this);
            if (input.val() === input.attr('placeholder')) {
                input.val('');
                input.removeClass('placeholder');
            }
        })
        jq('[placeholder]').blur(function() {
            var input = jq(this);
            if (input.val() === '' || input.val() === input.attr('placeholder')) {
                input.addClass('placeholder');
                input.val(input.attr('placeholder'));
            }
        }).blur();
        
        getInitialCountrySelection();
    
        /* Below code is to push the selected values */
        jq(document).off('click', '.changeMCOTab').on('click','.changeMCOTab', function()
        {
            var mcoCode = jq(this).attr('id')
            var previousMcoCode = IPMregionalApp.SelectedMCO;
            getRecentCountrySelection();
            retainVal();
            changeMCO(selectedCountries1.toString(), unselectedCountries1.toString(), selectedMCOs.toString(),unselectedMCOs.toString(),selectedCountries.toString(),unselectedCountries.toString(),selectedNoRollouts.toString(),unselectedNoRollouts.toString(),mcoCode, previousMcoCode, retainedCountries.toString());
            retainVal();
        });
    }
    function invokeRolloutGeneration()
    {
        generateRollouts(selectedCountries1.toString(), unselectedCountries1.toString(),selectedMCOs.toString(),unselectedMCOs.toString(),selectedCountries.toString(),unselectedCountries.toString(),selectedNoRollouts.toString(),unselectedNoRollouts.toString(), keyMCO);
    }
    
    /* Below code is to redirect to regional page */
    function setRedirect()
    {
        if(IPMregionalApp.completed)
        {
            window.top.location = IPMregionalApp.url+'?Id='+IPMregionalApp.proid+'&EditMode=false';
        }
    }
    
    function getInitialCountrySelection()
    {
    
    var regretainedCountries  = IPMregionalApp.retainedCountries;
    
        jq('input:radio[name ^=grp]').each(function()
        {
            var $radio = jq(this);
            if($radio.is(":checked"))
            {
                //MCO
                if($radio.attr('id').indexOf('grp1') > -1)
                {
                    intiallySelectedMCOs.push($radio.val());
                }
                //Country
                if($radio.attr('id').indexOf('grp2') > -1)
                {
                    intiallySelectedCountries.push($radio.val());
                } 
                //No Rollouts
                if($radio.attr('id').indexOf('grp3') > -1)
                {
                    intiallySelectedNoRollouts.push($radio.val());
                }           
            }
        });
    }
    var keyMCO;
    function getRecentCountrySelection()
    {
        selectedNoRollouts=[];
        keyMCO = jq('#keyMCO').is(":checked");
        jq('input:radio[name ^=grp]').each(function()
        {
            var $radio = jq(this);             
            if($radio.is(":checked"))
            {
                var countryCode = $radio.val();
                if(jq.inArray(countryCode, selectedMCOs) > -1)
                {
                    selectedMCOs.splice(jq.inArray(countryCode, selectedMCOs),1);
                }                   
                if(jq.inArray(countryCode, selectedCountries) > -1)
                {
                    selectedCountries.splice(jq.inArray(countryCode, selectedCountries),1); 
                    
                }
                if(jq.inArray(countryCode, selectedNoRollouts) > -1)
                {
                    selectedNoRollouts.splice(jq.inArray(countryCode, selectedNoRollouts),1);
                }
                
                //MCO
                if($radio.attr('id').indexOf('grp1') !==-1 )
                {
                    selectedMCOs.push(countryCode);
                    selectedCountries1.push(countryCode);
                }
                
                //Country
                if($radio.attr('id').indexOf('grp2') !==-1 )
                {
                    selectedCountries.push(countryCode);
                    selectedCountries1.push(countryCode);
                }
                
                //No Rollouts
                if($radio.attr('id').indexOf('grp3') !==-1 )
                {
                    selectedNoRollouts.push(countryCode);
                    selectedCountries1.push(countryCode);
                }           
            }
        }
        );
    }
    
    function validateNoRolloutSelectionChange() 
    { 
        var noRolloutAdded = false;
        for(counter = 0; counter < selectedNoRollouts.length; counter++)
        {
            var selectedNoRollout = selectedNoRollouts[counter];
            if(jq.inArray(selectedNoRollout,intiallySelectedNoRollouts) === -1)
            {
                noRolloutAdded = true;
                break;
            }
        }
        return noRolloutAdded
    }
     
    function getChangedCountries() 
    {
        for(counter=0;counter<intiallySelectedMCOs.length;counter++)
        {
            var countryCode = intiallySelectedMCOs[counter];
            if(jq.inArray(countryCode,selectedMCOs) === -1)
            {
                unselectedMCOs.push(countryCode);
            }
        }
        
        for(counter=0;counter<intiallySelectedCountries.length;counter++)
        {
            var countryCode = intiallySelectedCountries[counter];
            if( jq.inArray(countryCode,selectedCountries) === -1)
            {
                unselectedCountries.push(countryCode);
            }
        }
        
        for(counter=0;counter<intiallySelectedNoRollouts.length;counter++)
        {
            var countryCode = intiallySelectedNoRollouts[counter];
            if( jq.inArray(countryCode,selectedNoRollouts) === -1)
            {
                unselectedNoRollouts.push(countryCode);
            }
        }
    }
    
    jq(document).off('click', '.generateRolloutBtn').on('click','.generateRolloutBtn', function(e)
    {   
        e.stopPropagation();
        getRecentCountrySelection();
        getChangedCountries();
        if(!validateNoRolloutSelectionChange())
        {
            invokeRolloutGeneration();
        }
    });

    function hilightTaskScript(){
        jq(".info").tooltip({ position: { my: 'center top', at: 'center bottom+10' }});
        jq(".deleteChannel").tooltip({ position: { my: 'center top', at: 'center bottom+10' }});    
        jq(".arrow-left").tooltip({ position: { my: 'left top', at: 'center bottom+10' },tooltipClass:'ui-lefttip'}); 
        jq(".aTabs").find("input[type=checkbox]:checked").closest(".aTabs").addClass("active");
    }

    var unsaved = false;
    
    jq(function(){
     /* DOM ready */
        jq(':input').change(function() {
            unsaved = true;
        });
     });     
    function unloadPage()
    { 
        if(unsaved){
            return IPMregionalApp.wmessage;             
        }
    } 
    
    window.onbeforeunload = unloadPage;
    /* Below code is to skip the unsaved changes*/
    function skipValidation() {
        unsaved = false;
    }
    
    jq("[id*=srchTxt]").keypress(function(){
        var keyCode = (event.keyCode ? event.keyCode : event.which);
        if (keyCode === 13) {
            callsearch();
            skipValidation();
            return false;
        }
    });
    function scriptPanelLoad(){
        var keyMCO = jq('#keyMCO');
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
    }