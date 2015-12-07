({
	doInit : function(component, event, helper) {
        var action=component.get("c.getUserActivities");
        var actvity=[];
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
                var items=response.getReturnValue();
                if(items.length>0){
                    component.set("v.acivities", response.getReturnValue());
                }
                else{
                    component.set("v.showmessage",true);
                }
            }
        });
        $A.enqueueAction(action);
    },
})