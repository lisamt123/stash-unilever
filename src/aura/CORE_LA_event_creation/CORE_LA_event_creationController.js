({
	doInit : function(component, event, helper) {
		var action = component.get("c.getEventById");
        action.setParams({ eId : component.get("v.recordId")});
		action.setCallback(this, function(response) {
			var state = response.getState();
            if (state === "SUCCESS") {
                console.log("From server: " + JSON.stringify(response.getReturnValue()));
                var result = response.getReturnValue();
                var resultData = result[0];
                component.set("v.eventRecordDetails", resultData);
               
                if(!$A.util.isUndefined(resultData)){
                    if((!$A.util.isEmpty(resultData.Name)) && (!$A.util.isEmpty(resultData.From_Date__c)) && (!$A.util.isEmpty(resultData.To_Date__c)) ){
                        var cmpEventDetailsItem = cmp.find('eventDetailTap');
        				$A.util.addClass(cmpEventDetailsItem, 'status-completed');
                    }
                }
			}
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
	},
    callEventDetailPage : function(component, event, helper) {
        var compEvent = component.getEvent("openCreateEventLandingPage");
        compEvent.setParams({
            "targetAction" : 'CREATE_EVENT_DETAILS',
            "recordId" : component.get("v.recordId"),
            "componentName": 'c:CORE_LA_EventDetails',
        });
        compEvent.fire();
    	//console.log(JSON.stringify(event.getSource()));
    	//console.log(JSON.stringify(event.getSource()));
	},
    callEventVenuePage : function(component, event, helper) {
    	//console.log(JSON.stringify(event.getSource()));
    	console.log(JSON.stringify(event.getSource()));
	},
    callEventAddAdminPage : function(component, event, helper) {
    	//console.log(JSON.stringify(event.getSource()));
    	console.log(JSON.stringify(event.getSource()));
	},
    callEventFacilityPage : function(component, event, helper) {
    	//console.log(JSON.stringify(event.getSource()));
    	console.log(JSON.stringify(event.getSource()));
	},
    callEventAttendeePage : function(component, event, helper) {
    	//console.log(JSON.stringify(event.getSource()));
    	console.log(JSON.stringify(event.getSource()));
	},
    callEventPrerequistePage : function(component, event, helper) {
    	//console.log(JSON.stringify(event.getSource()));
    	console.log(JSON.stringify(event.getSource()));
	},
 
})