({
    doInit : function(component, event, helper) {
        
       var action = component.get("c.getCafeteriaMenuDetails");
       var workPlaceId = component.get("v.workplaceLocationId");
        action.setParams({
			"workPlaceId": workPlaceId
		});
       action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {
                if(response.getReturnValue()!=''){
        			component.set("v.cafeteriaMenuDetail", response.getReturnValue());	
                    console.log('---------------------'+response.getReturnValue());
                }
                else 
                    component.set("v.noDataErrorMessage", true);
        	}                  
        });
        $A.enqueueAction(action);
	},    
    gotoPreviousPage: function(component, event, helper) {         
        var workplaceLocationId=component.get("v.workplaceLocationId");
        var selectEvent = $A.get("e.c:CORE_WP_WorkplaceEvent");
        selectEvent.setParams({"selectedWrokplaceId": workplaceLocationId,"WorkplacePannelType":"CORE_WP_WorkplaceHome"}).fire();
    },
})