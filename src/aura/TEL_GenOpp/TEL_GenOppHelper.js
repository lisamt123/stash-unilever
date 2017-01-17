({
    // Retrieve search param used to query the account result. 
    getSearchParam : function(component, event, helper){
        console.log("Entering <getSearchParam>");
        this.retrieveOTMParam(component);
        this.retrieveSegmentParam(component);
        this.retrieveSubSegmentParam(component);
        console.log("Exit <getSearchParam>");
    },
    
    // Retrieve the OTM param.
    retrieveOTMParam : function(component){
        console.log("Entering <retrieveOTMParam>");
        var action 		= component.get("c.searchOTM");
        component.set("v.spinnerEnable", true);
        action.setCallback(this, function(response){
            var state 	= response.getState();
            if(state === "SUCCESS"){
                component.set("v.lstOTM", response.getReturnValue());
                component.set("v.spinnerEnable", false);
            }
        });
        $A.enqueueAction(action);
        console.log("Exit <retrieveOTMParam>");
    },
    
    // Retrieve the segment param. 
    retrieveSegmentParam : function(component){
        console.log("Entering <retrieveSegmentParam>");
        var action 		= component.get("c.searchSegment");
        action.setCallback(this, function(response){
            var state 	= response.getState();
            if(state === "SUCCESS"){
                component.set("v.lstSegment", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        console.log("Exit <retrieveSegmentParam>");
    },
    
    // Retrieve the Sub-Segment param.
    retrieveSubSegmentParam : function(component){
        console.log("Entering <retrieveSubSegmentParam>");
        var action 		= component.get("c.searchSubSegment");
        action.setCallback(this, function(response){
            var state 	= response.getState();
            if(state === "SUCCESS"){
                component.set("v.lstSubSegment", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        console.log("Exit <retrieveSubSegmentParam>");
    },
    
    // Retrieve the account to generate the opportunities based on search param. 
    getAccounts : function(component,event) {
        console.log("Entering <getAccounts>"); 
        var typeSelected = component.find("oppGenType").get("v.value");
        var types = component.find("types").get("v.value");
        var segment = component.find("segment").get("v.value");
        var subSegment = component.find("subSegment").get("v.value");
        console.log("Valor do typeSelected: "+typeSelected);
        if(typeSelected === 'None' ||
           (types === 'None' && 
            segment === 'None' && 
            subSegment === 'None')) 
        {
            var toastEvent 	= $A.get("e.force:showToast");
            toastEvent.setParams({
                "title"		: "Alert!",
                "message"	: "The type field and at least one of OTM, Segment or SubSegment are mandatory!",
                "duration"	: 2000,
                "type"		: "warning"
            });
            toastEvent.fire();
        } else {
            this.retrieveAccountSearch(component,event);
            var accounts = component.get("v.lstAccounts");
            console.log("Valor da lista de contas retornadas: "+accounts.length);
            console.log("Valor da lista de contas $A.util.isUndefined(accounts): "+$A.util.isUndefined(accounts));
            console.log("Valor da lista de contas $A.util.isEmpty(accounts): "+$A.util.isEmpty(accounts));
            if((!$A.util.isEmpty(accounts) && !$A.util.isUndefined(accounts)) || typeSelected !== 'None') {
                console.log("Entrou no if");
                this.retrieveFrequencyParam(component,event);	
                this.enableAccountResult(component,event);
            } else {
                this.enableToastAlert(component,event, 'SEARCH');
            }
            
        }
        console.log("Exit <getAccounts>");
    },
    
    // Enable account result. 
    enableAccountResult : function(component,event){
        console.log("Entering <enableAccountResult>");
        component.set("v.searchAccEnable", true)
        console.log("Exit <enableAccountResult>");
    },
    
    // Retrieve account search. 
    retrieveAccountSearch : function(component){
        console.log("Entering <retrieveAccountSearch>");
        var selected 	= component.find("types").get("v.value");
        var segment 	= component.find("segment").get("v.value");
        var subSegment 	= component.find("subSegment").get("v.value");
        var action 		= component.get("c.searchAccounts");
        
        component.set("v.spinnerEnable", true);
        
        console.log("Exit <selected>"+selected);
        console.log("Exit <segment>"+segment);
        console.log("Exit <subSegment>"+subSegment);
        
        action.setParams({ "type" 	 	: selected,
                          "segment" 	: segment,
                          "subSegment"	: subSegment});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.lstAccounts", response.getReturnValue());
                component.set("v.spinnerEnable", false);
            }
        });
        $A.enqueueAction(action);
        console.log("Exit <retrieveAccountSearch>");
    },
    
    // Retrieve the frequency param to be used on opportunity creation. 
    retrieveFrequencyParam : function(component,event){
        console.log("Entering <retrieveFrequencyParam>");
        var action = component.get("c.frequencyOppGeneration");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.lstFrequency", response.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
        console.log("Exit <retrieveFrequencyParam>");
    },
    
    // Enable the toast alert if no record is returned by search account.
    enableToastAlert : function(component,event, stateParam){
        console.log("Entering <enableToastAlert>");
        var toastEvent 	= $A.get("e.force:showToast");
        var typeMsg		= "other";
        var titleMsg	= "none";
        var state		= stateParam;	
        var alertMsg	= "none";
        
        console.log("Valor do state: "+state);
        
        if(state === "SEARCH"){
            console.log("Entrou no if "+state);
            alertMsg 	= "No record was found.";
            typeMsg 	= "info";
            titleMsg	= "Alert!";
        }
        else{
            console.log("Entrou no else"+state);
            alertMsg 	= "The records have been updated successfully.";
            typeMsg 	= "success";
            titleMsg	= "Success!";
        }
        
        toastEvent.setParams({
            "title"		: titleMsg,
            "message"	: alertMsg,
            "duration"	: 2000,
            "type"		: typeMsg
        });
        
        toastEvent.fire();
        $A.get('e.force:refreshView').fire();
        console.log("Exit <enableToastAlert>");
    },
    
    createOpp : function(component, event, helper) {
        console.log("Entering <createOpp>");
        var lstAccounts 	= component.get("v.lstAccounts");
        var oppGenType	 	= component.find("oppGenType").get("v.value");
        var mondayWeek		= component.get("v.mondayWeek");
        var tuesdayWeek		= component.get("v.tuesdayWeek");
        var wednesdayWeek	= component.get("v.wednesdayWeek");
        var thursdayWeek	= component.get("v.thursdayWeek");
        var fridayWeek		= component.get("v.fridayWeek");
        var frequency		= component.find("frequency").get("v.value");
        
        var daysSelected = 0;
        if(mondayWeek !== "none") {
            daysSelected++;
        } 
        if(tuesdayWeek !== "none") {
            daysSelected++;
        }
        if(wednesdayWeek !== "none") {
            daysSelected++;
        }
        if(thursdayWeek !== "none") {
            daysSelected++;
        }
        if(fridayWeek !== "none") {
            daysSelected++;
        }
        
        component.set('v.spinnerEnable',true);
        
        if(($A.util.isEmpty(lstAccounts) || $A.util.isUndefined(lstAccounts)) ||
           (frequency === $A.get("$Label.c.TEL_Biweekly") && daysSelected > 1) ||
           (frequency === $A.get("$Label.c.TEL_Monthly") && daysSelected > 1)) 
        {
            var toastEvent 	= $A.get("e.force:showToast");
            toastEvent.setParams({
                "title"		: "Alert!",
                "message"	: "For Biweekly or Monthly options, only one weekday must be selected.",
                "duration"	: 5000,
                "type"		: "warning"
            });
            toastEvent.fire();
            
            component.set('v.spinnerEnable', false);
        } else {
            var action 		= component.get("c.createOpp");
            var accounts	= JSON.stringify(lstAccounts);
            
            action.setParams({
                accSelected : accounts, 
                monday		: mondayWeek,
                tuesday		: tuesdayWeek, 
                wednesday	: wednesdayWeek, 
                thursday	: thursdayWeek,
                friday		: fridayWeek,
                frequency	: frequency,
                oppGenType 	: oppGenType
            });
            
            action.setCallback(this, function(response){
                var state 	= response.getState();
                if(state === "SUCCESS"){
                    component.set('v.showAlert', false);	
                    component.set('v.spinnerEnable',false);
                    $A.get('e.force:refreshView').fire();
                }
            });
            $A.enqueueAction(action);
            this.enableToastAlert(component, 'OPPORTUNITY');
        }
        
        console.log("Exit <createOpp>");
    },
    
    onCheckWeek : function(component, event, helper, week) {
        console.log("Entering <onCheck>");
        var check 		= week;
        var monday 		= component.get("v.mondayWeek");
        var tuesday 	= component.get("v.tuesdayWeek");
        var wednesday 	= component.get("v.wednesdayWeek");
        var thursday 	= component.get("v.thursdayWeek");
        var friday 		= component.get("v.fridayWeek");
        component.set('v.spinnerEnable',true);
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
                component.set('v.spinnerEnable',false);
            }else{
                component.set("v.wednesdayWeek", check);
                component.set('v.spinnerEnable',false);
            };            
        };
        if(check === "thursday"){
            if(thursday === "thursday"){
                component.set("v.thursdayWeek", "none");
                component.set('v.spinnerEnable',false);
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
        console.log("Exit <onCheck>");
    },
    
    // Select all products to be associated to opportunity. 
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