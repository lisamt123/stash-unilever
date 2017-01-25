({
	getDetailsExternal: function(component) {
        
        var emailIdReceived=component.get("v.externalEmail");
        var action=component.get("c.getTrainerWrapper");
        alert("Email Id Clicked"+emailIdReceived);
        action.setParams({
            "eventId":emailIdReceived   //pass email id of ExternalTrainer         
        });
        action.setCallback(this, function(response) {
            
            component.set("v.externalInfo", response.getReturnValue()[0]);	
           
        });
        var hideInternalTrainerDiv = component.find('InternalTrainerSpecific');
        $A.util.addClass(hideInternalTrainerDiv, 'slds-hide');
        
         $A.enqueueAction(action);
	}
})