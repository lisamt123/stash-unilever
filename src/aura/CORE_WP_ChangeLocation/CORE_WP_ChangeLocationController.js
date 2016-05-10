({	
    gotoPreviousPage: function(component, event, helper) {         
        var workplaceLocationId=component.get("v.workplaceLocationId");
        var selectEvent = $A.get("e.c:CORE_WP_WorkplaceEvent");
        selectEvent.setParams({"selectedWrokplaceId": workplaceLocationId,"WorkplacePannelType":"CORE_WP_WorkplaceHome"}).fire();
    },
    loadKingstonWorkspace: function(component, event, helper) {     
        var action = component.get("c.getWorkplaceIdByName");
        action.setParams({
            "workPlaceName": "Kingston"
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!='')   {
                var workplaceLocationId=response.getReturnValue();
                var selectEvent = $A.get("e.c:CORE_WP_WorkplaceEvent");
                selectEvent.setParams({"selectedWrokplaceId": workplaceLocationId,"WorkplacePannelType":"CORE_WP_WorkplaceHome"}).fire();               
            }
           
        });
        $A.enqueueAction(action);        
    },
    load100VEWorkspace: function(component, event, helper) {         
        var action = component.get("c.getWorkplaceIdByName");
        action.setParams({
            "workPlaceName": "100VE"
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {      
                if(response.getReturnValue()!='')   {
                    var workplaceLocationId=response.getReturnValue();
                    var selectEvent = $A.get("e.c:CORE_WP_WorkplaceEvent");
                    selectEvent.setParams({"selectedWrokplaceId": workplaceLocationId,"WorkplacePannelType":"CORE_WP_WorkplaceHome"}).fire();
                }
            }    
        });
        $A.enqueueAction(action);        
    },
})