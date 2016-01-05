({
    getUsersPics : function(component, event, helper) {
        var actId = component.get("v.recentactivityid");
        var action=component.get("c.getuserList");
        action.setParams({"recentactivityid":actId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
                var items=response.getReturnValue();
                component.set("v.users", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})