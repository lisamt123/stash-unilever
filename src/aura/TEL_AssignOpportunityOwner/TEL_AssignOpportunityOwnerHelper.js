({
	// Retrieve the search param. 
    changeOwner : function(component, event, helper){
        console.log("Entering <changeOwner>");
        var action 			= component.get("c.assignOppOwner");
        var opportunityId 	= component.get("v.recordId");
        var urlEvent = $A.get("e.force:navigateToURL");

        // Set params. 
        action.setParams({paramOppId : opportunityId});
        
        // Create a callback that is executed after the server-side action returns 
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                urlEvent.setParams({"url": "/"+opportunityId});
                urlEvent.fire();
            }
        });
        $A.enqueueAction(action);
        console.log("Exit <changeOwner>");
    }
})