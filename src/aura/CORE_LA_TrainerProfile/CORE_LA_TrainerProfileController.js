({
	 
    defaultSection: function(component,event,helper){  
        //helper called for Trainer and Attendee Details
     helper.getDetails(component);

    },
    //Load More Implementation
    showMoreAttendees: function(component,event,helper){
        var offsetvalueShowMore= component.get("v.OffsetLimitAttendee")+component.get("v.limitAttendeeRecords");
        component.set("v.OffsetLimitAttendee",offsetvalueShowMore);
        var actionAttendeList=component.get("c.getAttendeList");
         actionAttendeList.setParams({
              "eventId"    :  component.get("v.eventIdneeded"),
             "limitRecords": component.get("v.limitAttendeeRecords"),
             "OffsetLimit" : component.get("v.OffsetLimitAttendee")
               
            });
            actionAttendeList.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                 var attendeeList=component.get("v.attendees");
                var newAttendeeList=response.getReturnValue();
                for (var atnd in newAttendeeList) {
                    if (newAttendeeList.hasOwnProperty(atnd)) {
                        var ob=newAttendeeList[atnd]
                        var singleObj=[];
                        singleObj=ob;
                        attendeeList.push(singleObj);
                    }}
                component.set("v.attendees", attendeeList);   
            }
                
                else if (state === "ERROR") {
                $A.log("Errors", a.getError());
            }
        });
        $A.enqueueAction(actionAttendeList);
    },
    
    //Back Button 
    goToEventDetail: function(component,event,helper){
       var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
         selectEvent.setParams({"componentName":"c:CORE_LA_UpcomingDetail","event":component.get("v.event")}).fire();
     },
   //Detail pages callouts 
    goToTrainerDetail : function(component, event, helper) { 
        var trainerId=event.currentTarget.dataset.record;
        var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_TrainerDetail","trainerId":trainerId,"trainers":component.get("v.trainers"),"event":component.get("v.event")}).fire();
    },
    
     goToTrainerExternalDetail : function(component, event, helper) { 
        var trainerEmail=event.currentTarget.dataset.record;
        var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_TrainerDetail","externalEmail":trainerEmail,"trainers":component.get("v.trainers"),"event":component.get("v.event")}).fire();
    },
    
})