({
	getEventDetail : function(component, event, helper) {
        console.log('eventid'+ component.get("v.event").eventId);
        var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_UpcomingDetail","event":component.get("v.event")}).fire();
   },
    
       navigateToCreatePage : function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:CORE_LA_event_creation",
            componentAttributes: {
               "event":component.get("v.event")
            }
        });
        evt.fire();
    }
})