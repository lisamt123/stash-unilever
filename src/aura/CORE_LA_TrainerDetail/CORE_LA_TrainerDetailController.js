({
    
     doInit :function(component, event, helper)  {
       var trainerIdReceived=component.get("v.trainerId");
      
       if(trainerIdReceived!== undefined ){
        //Internal trainer Details 
        // alert(JSON.stringify(trainerIdReceived));
       var trainerIdRequired=trainerIdReceived;//id to be passed for displaying event role is Trainer
       var trainerUserInfo = component.get("c.getTrainerDetails"); 
          trainerUserInfo.setParams({
			"trainerId":trainerIdRequired
		});
        trainerUserInfo.setCallback(this, function(response) {
            component.set("v.trainerInfo", response.getReturnValue());	 
            component.set("v.trainerInfoId",response.getReturnValue().Id);
      
        });
            var hideExternalTrainerDiv = component.find('externalTrainerSpecific');
            $A.util.addClass(hideExternalTrainerDiv, 'slds-hide');
        $A.enqueueAction(trainerUserInfo);
   }
         else{
               //External trainer Details
                  helper.getDetailsExternal(component);  
         }
        
    } , 
//Go Back to Trainer & Attendee List Page for the event
	gotoHomePage : function(component,event,helper){
  
         var trainerIdReceived=component.get("v.trainerId");
        var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_TrainerProfile","trainerId":trainerIdReceived,"trainers":component.get("v.trainers"),"event":component.get("v.event")}).fire();
     },
    
      runningUserStandardDetails: function(component, event, helper) {  
        var navToSObjEvt = $A.get("e.force:navigateToSObject");
        navToSObjEvt.setParams({
            recordId: component.get("v.trainerInfoId"),
            slideDevName: "detail"
        }); 
        navToSObjEvt.fire();      
    },
})