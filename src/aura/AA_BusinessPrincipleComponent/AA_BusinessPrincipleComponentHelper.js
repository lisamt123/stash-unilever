({
	updateTermAndCondition : function(component) {
		console.log("Submit Action :");
        var action = component.get("c.getUpdateIsAcceptedTermsAndCondition");

        action.setParams({
            isAcceptedTermsCondition : component.get("v.businessPrincipleFlag")
        });
    
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var bunessPrincipleObj = a.getReturnValue();
                console.log("Principle flag:==>"+ bunessPrincipleObj.Is_Accepted_Terms_Condition__c);
                component.set("v.businessPrincipleFlag", bunessPrincipleObj.Is_Accepted_Terms_Condition__c);
                var compEvent = component.getEvent("businessPrincipleEvent");
                // Optional: set some data for the event (also known as event shape)
                compEvent.setParams({"bpFlag" : bunessPrincipleObj.Is_Accepted_Terms_Condition__c });
                compEvent.fire();
            } else if (a.getState() === "ERROR") {
                $A.log("Errors", a.getError());
            }
        });
    
        $A.enqueueAction(action);
	}
})