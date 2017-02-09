({
	  
    getAttendeeRatingDetails: function(component) {
       
         var EventDetails=component.get("v.event");
        //pass value from event fired here
         component.set("v.eventIdneeded","aDjV00000004D2BKAU");
        
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
               // alert(response.getReturnValue()[0].Role__c);
        //      for (var i = 0; i < response.getReturnValue().length; i++) { 
           //            If(response.getReturnValue()[0].Role__c==='Attendee')
             //      }
               
            }
        });
        $A.enqueueAction(actionAttendeList);
   
	},
})