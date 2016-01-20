({
	update : function(cmp, event, helper) {
    	var itemId = cmp.get("v.itemId"); 
        var itemName = cmp.get("v.itemName"); 
        var rLoadEvent = $A.get("e.c:EA_RecentPill_Event");
        rLoadEvent.setParams({"item": itemId, "item_name":itemName});
        rLoadEvent.fire();
        return;
    },
})