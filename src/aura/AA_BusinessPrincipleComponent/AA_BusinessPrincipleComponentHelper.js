({
    updateTermAndCondition:function(component){
        var action = component.get("c.getUpdateIsAcceptedTermsAndCondition");
        action.setParams({
            isAcceptedTermsCondition : component.get("v.businessPrincipleFlag")
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var bunessPrincipleObj = a.getReturnValue();
                component.set("v.businessPrincipleFlag", bunessPrincipleObj.Is_Accepted_Terms_Condition__c);
                var compEvent = component.getEvent("businessPrincipleEvent");
                compEvent.setParams({"bpFlag" : bunessPrincipleObj.Is_Accepted_Terms_Condition__c,"showLandingPage":component.get("v.islandingPageFlagDisplay")});
                compEvent.fire();
            } else if (a.getState() === "ERROR") {
                $A.log("Errors", a.getError());
            }
        });
        $A.enqueueAction(action);
    }
})