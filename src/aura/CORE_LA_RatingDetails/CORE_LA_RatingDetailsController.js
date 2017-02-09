({

    getAttendeeRatingDetails: function(component) { 
         var EventDetails=component.get("v.event");
        //pass value from event fired here
         component.set("v.eventIdneeded",EventDetails.eventId);
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
   
	},
    
     goToHomePage: function(component,event,helper){  
       var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_Home"}).fire();
        
     },
    
     
   
    
    
})