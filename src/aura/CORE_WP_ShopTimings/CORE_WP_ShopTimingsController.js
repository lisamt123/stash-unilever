({
	doInit : function(component, event, helper) {         
        var workPlaceId=component.get("v.workplaceLocationId");
        var action = component.get("c.getShopTimingsDetails");
        action.setParams({
			"workPlaceId": workPlaceId
			});
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {
                if(response.getReturnValue()!=''){
                    var str = response.getReturnValue();
                    var res = str.replace(/http:,mailto/g, "tel");
                    component.set("v.shopTimings",res);                    
                }
                else {
                    component.set("v.noDataErrorMessage", true);
                }
        	}                               
        });
        $A.enqueueAction(action);
    },
    gotoPreviousPage: function(component, event, helper) {         
        var workplaceLocationId=component.get("v.workplaceLocationId");
        var selectEvent = $A.get("e.c:CORE_WP_WorkplaceEvent");
        selectEvent.setParams({"selectedWrokplaceId": workplaceLocationId,"displayWorkplaceHome":true,"WorkplacePannelType":"CORE_WP_WorkplaceHome"}).fire();
    },
})