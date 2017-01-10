({
	registration : function(component, event, helper) {
        /*
        var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_Confirm"}).fire();
        */
        component.set("v.isRegistrationConfirmationPopup",true); 
     },
    cancel : function(component, event, helper) {
        var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_UpcomingDetail"}).fire();
     },
	
})