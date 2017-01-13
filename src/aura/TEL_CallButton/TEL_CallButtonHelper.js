({
    // Retrieve the call number and set param. 
    retrieveCallNumber : function(component, event, helper){
        console.log("Initiating retrieveCallNumber");
        var opportunity 	= component.get("v.recordId");
		var action 			= component.get("c.getCallNumber");
        action.setParams({paraOppId : opportunity});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.callNumber", "Tel:"+response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        console.log("Exit retrieveCallNumber");
    }
})