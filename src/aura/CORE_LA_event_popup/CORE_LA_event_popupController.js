({
	closeCreateEventPopup : function(component, event, helper) {
        component.set("v.isCreateEventPopup", false);
        var compEvent = component.getEvent("closeCreateEventPopup");
        compEvent.setParams({
            "isCreateEventPopup" : component.get("v.isCreateEventPopup"),
            "targetAction" : "CLOSE_CREATE_POPUP"});
        compEvent.fire();
	},
    submitEvent : function(component, event, helper) {
        var inputCmp = component.find("eventName");
        var eventName = inputCmp.get("v.value");
        if ($A.util.isUndefined(eventName)) {
            inputCmp.set("v.errors", [{message:"Please enter event name."}]);
        } else {
            inputCmp.set("v.errors", null);
            var action = component.get("c.createCustomEvent");
            action.setParams({eventName:eventName});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue() !== null){
                        console.log('Response ===>'+ response.getReturnValue());
                        var compEvent = component.getEvent("openCreateEventLandingPage");
                        compEvent.setParams({
                            "recordId" : response.getReturnValue(),
                            "componentName": 'c:CORE_LA_event_creation',
                        });
                        compEvent.fire();
                    }
                }else if (state === "ERROR") {
                	var errors = response.getError();
                	if (errors) {
                    	if (errors[0] && errors[0].message) {
                        	console.log("Error message: " + errors[0].message);
                    	}
                	} else {
                    console.log("Unknown error");
                	}
                }
           
            });
            $A.enqueueAction(action);
        }
	},
})