({
	update : function(component, event, helper) {
    	var itemId = component.get("v.itemId"); 
        var itemName = component.get("v.itemName"); 
        var rLoadEvent = $A.get("e.c:EA_RecentPill_Event");
        rLoadEvent.setParams({"item": itemId, "item_name":itemName});
        rLoadEvent.fire();
        return;
    },
    handlePillUpdate : function(component, event, helper) {
    	helper.getItemResponse(component, event, helper);   
	}
})