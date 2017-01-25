({
	getEventDetail : function(component, event, helper) {
        console.log('eventid'+ component.get("v.event").eventId);
        var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_UpcomingDetail","event":component.get("v.event")}).fire();
   },
})