({
    unRegisterEventNotifi : function(component, event, helper) {
        var ParticipantId = component.get("v.eventDetail").IdofParticicpant;
		var action=component.get("c.Unregister");
            action.setParams({"ParticipantId":ParticipantId});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue() == true) {
                    component.set("v.isUnRegisterPopup",true); 
                }
                else
                {
                    component.set("v.isFailurePopup",true); 
                }
            });
            
            $A.enqueueAction(action); 
	},
    
    saveEventNotifi : function(component, event, helper) {
        var ParticipantId = component.get("v.eventDetail").IdofParticicpant;
		var action=component.get("c.saveEvent");
            action.setParams({"ParticipantId":ParticipantId});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue() == true) {
                    component.set("v.isSavePopup",true); 
                }
                else
                {
                    component.set("v.isFailurePopup",true); 
                }
            });
            
            $A.enqueueAction(action); 
	},
    
    unSaveEventNotifi : function(component, event, helper) {
        var ParticipantId = component.get("v.eventDetail").IdofParticicpant;
		var action=component.get("c.unSaveEvent");
            action.setParams({"ParticipantId":ParticipantId});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue() == true) {
                    component.set("v.isUnSavePopup",true); 
                }
                else
                {
                    component.set("v.isFailurePopup",true); 
                }
            });
            
            $A.enqueueAction(action); 
	},
    close : function(component, event, helper) {
        var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        if(component.get("v.sourcePage") == "UpcomingDetail")
        {
            selectEvent.setParams({"componentName":"c:CORE_LA_UpcomingDetail", "event":component.get("v.eventDetail")}).fire();
        }
        if(component.get("v.sourcePage") == "EventCard")
        {
            selectEvent.setParams({"componentName":"c:CORE_LA_Home"}).fire();
        }
        if(component.get("v.sourcePage") == "occuranceDetail")
        {
            selectEvent.setParams({"componentName":"c:CORE_LA_UpcomingDetail", "event":component.get("v.eventDetail")}).fire();
        }
        
    },
})