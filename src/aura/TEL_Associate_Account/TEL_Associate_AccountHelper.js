({
    // Retrieve the search param. 
    getSearchParam : function(component, event, helper){
        console.log("Entering <getSearchParam>");
        var action 		= component.get("c.searchOTM");
        // Create a callback that is executed after the server-side action returns 
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set('v.lstOTM', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        console.log("Exit <getSearchParam>");
    },
    
    // Retrieve accounts based on search param. 
    getAccounts : function(component,event) {
        console.log("Entering <getAccounts>");
        var selected 	= component.find("types").get("v.value");
        
        // Retrieve the accounts. 
        var action 		= component.get("c.searchAccounts");
        component.set('v.spinnerEnable',true);
        action.setParams({ 
            "type" 		: selected,
            "segment"	: "None",
            "subSegment": "None"
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.lstAccounts", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
        // Retrieve the frequency param 
        var action 		= component.get("c.frequencyOppGeneration");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.lstFrequency", response.getReturnValue());
                component.set('v.spinnerEnable',false);
                component.set('v.searchAccEnable', true); 
            }
        });
        $A.enqueueAction(action);
        console.log("Exit <getAccounts>");
    },
    
    // Create the opportunity based on frequency set and associate the account selected to the campaign. 
    createOpp : function(component, event, helper) {
        console.log("Entering <createOpp>");
        var lstAccounts 	= component.get("v.lstAccounts");
        var mondayWeek		= component.get("v.mondayWeek");
        var tuesdayWeek		= component.get("v.tuesdayWeek");
        var wednesdayWeek	= component.get("v.wednesdayWeek");
        var thursdayWeek	= component.get("v.thursdayWeek");
        var fridayWeek		= component.get("v.fridayWeek");
        var frequency		= component.find("frequency").get("v.value");
        var campaign 		= component.get("v.recordId");
        
        console.log("ID da Campanha: "+campaign);
        component.set('v.spinnerEnable',true);
        
        if(!$A.util.isEmpty(lstAccounts) && !$A.util.isUndefined(lstAccounts)){
            var action 		= component.get("c.createOpp");
            var accounts	= JSON.stringify(lstAccounts);
            var oppType		= $A.get("$Label.c.TEL_Sales_Drive_Type");
            
            console.log("Valor do oppType: "+oppType);
            action.setParams({
                accSelected : accounts, 
                monday		: mondayWeek,
                tuesday		: tuesdayWeek, 
                wednesday	: wednesdayWeek, 
                thursday	: thursdayWeek,
                friday		: fridayWeek,
                frequency	: frequency,
                oppGenType 	: oppType, 
                campaignId	: campaign
            });
            
            action.setCallback(this, function(response){
                var state 	= response.getState();
                if(state === "SUCCESS"){
                    component.set('v.showAlert', false);	
                    component.set('v.spinnerEnable',false);
                    $A.get('e.force:refreshView').fire();
                }
            });
        }
        $A.enqueueAction(action);
        
        if(!$A.util.isEmpty(campaign)){
            console.log("campaign != None");
            if(!$A.util.isEmpty(lstAccounts) && !$A.util.isUndefined(lstAccounts)){
                var action 		= component.get("c.createAccCampaign");
                var accounts	= JSON.stringify(lstAccounts);
                
                action.setParams({
                    accSelected : accounts, 
                    campaignId 	: campaign,
                });
                
                action.setCallback(this, function(response){
                    var state 	= response.getState();
                    if(state === "SUCCESS"){
                        component.set('v.showAlert', false);	
                        component.set('v.spinnerEnable',false);
                        $A.get("e.force:closeQuickAction").fire();
                        $A.get('e.force:refreshView').fire();
                    }
                });
            }
            $A.enqueueAction(action);
        };
        console.log("Exit <createOpp>");
    },
    
    // Set the frequency selected to be used as param on creation of opportunity. 
    onCheckWeek : function(component, event, helper, week) {
        console.log("Entering <onCheck>");
        var check 		= week;
        var monday 		= component.get("v.mondayWeek");
        var tuesday 	= component.get("v.tuesdayWeek");
        var wednesday 	= component.get("v.wednesdayWeek");
        var thursday 	= component.get("v.thursdayWeek");
        var friday 		= component.get("v.fridayWeek");
        component.set('v.spinnerEnable',true);
        console.log("Valor do: "+check);
        console.log("Valor do: "+monday);
        console.log("Valor do: "+tuesday);
        console.log("Valor do: "+wednesday);
        console.log("Valor do: "+thursday);
        console.log("Valor do: "+friday);
        if(check === "monday"){
            if(monday === "monday"){
                component.set("v.mondayWeek", "none");
                component.set('v.spinnerEnable',false);
            }else{
                component.set("v.mondayWeek", check);
                component.set('v.spinnerEnable',false);
            };
        };
        if(check === "tuesday"){
            if(tuesday === "tuesday"){
                component.set("v.tuesdayWeek", "none");
                component.set('v.spinnerEnable',false);
            }else{
                component.set("v.tuesdayWeek", check);
                component.set('v.spinnerEnable',false);
            };            
        };
        if(check === "wednesday"){
            if(wednesday === "wednesday"){
                component.set("v.wednesdayWeek", "none");
            }else{
                component.set("v.wednesdayWeek", check);
                component.set('v.spinnerEnable',false);
            };            
        };
        if(check === "thursday"){
            if(thursday === "thursday"){
                component.set("v.thursdayWeek", "none");
            }else{
                component.set("v.thursdayWeek", check);
                component.set('v.spinnerEnable',false);
            };            
        };
        if(check === "friday"){
            if(friday === "friday"){
                component.set("v.fridayWeek", "none");
                component.set('v.spinnerEnable',false);
            }else{
                component.set("v.fridayWeek", check);
                component.set('v.spinnerEnable',false);
            };            
        };
        var monday 		= component.get("v.mondayWeek");
        var tuesday 	= component.get("v.tuesdayWeek");
        var wednesday 	= component.get("v.wednesdayWeek");
        var thursday 	= component.get("v.thursdayWeek");
        var friday 		= component.get("v.fridayWeek");
        console.log("Valor do: "+monday);
        console.log("Valor do: "+tuesday);
        console.log("Valor do: "+wednesday);
        console.log("Valor do: "+thursday);
        console.log("Valor do: "+friday);
    },
    
    // Select all products to be associated to campaign. 
    selectAllAccounts : function(component) {
        console.log("Initiating selectAllAccounts");
        var selected 	= component.find("selectAll").get("v.value");
        var lstAccounts = component.get("v.lstAccounts");
        if(selected === true) {
            for(var counter = 0; counter < lstAccounts.length; counter++) {
                if(lstAccounts[counter].isSelected === false) {
                    lstAccounts[counter].isSelected = true;
                    component.set('v.selectedAll', true);
                }
            }
        } else {
            for(var counter = 0; counter < lstAccounts.length; counter++) {
                lstAccounts[counter].isSelected = false;
                component.set('v.selectedAll', false);
            }
        }
        component.set("v.lstAccounts", lstAccounts);
        console.log("Exiting selectAllAccounts");
    }
})