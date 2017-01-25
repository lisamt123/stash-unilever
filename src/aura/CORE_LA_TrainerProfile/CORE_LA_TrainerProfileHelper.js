({
	getDetails: function(component) {
//Get Trainer List
        //value from See All :EventId
         var EventDetails=component.get("v.event");
        //pass value from event fired here
         component.set("v.eventIdneeded",EventDetails.eventId);
         var actionTrainerList = component.get("c.getTrainerWrapper");
            actionTrainerList.setParams({
                "eventId":component.get("v.eventIdneeded")
               
            });
        actionTrainerList.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.trainers", response.getReturnValue());
            }
             else if (state === "ERROR") {
                $A.log("Errors", a.getError());
            }
        });
        $A.enqueueAction(actionTrainerList);
     
 //Get Attendee List
        var actionAttendeList=component.get("c.getAttendeList");
         actionAttendeList.setParams({
              "eventId"    :  component.get("v.eventIdneeded"),
             "limitRecords": component.get("v.limitAttendeeRecords"),
             "OffsetLimit" : component.get("v.OffsetLimitAttendee")
               
            });
        
            actionAttendeList.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.attendees", response.getReturnValue());   
            }
        });
        $A.enqueueAction(actionAttendeList);
   
	}
})