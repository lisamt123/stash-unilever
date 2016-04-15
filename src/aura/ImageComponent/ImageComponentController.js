({
    getUsersPics : function(component, event, helper) {
        var actId = component.get("v.recentactivityid");
        var action=component.get("c.getuserList");
        action.setParams({"recentactivityid":actId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
                var items=response.getReturnValue(); 
                console.log(items.length);
               if(items.length !==undefined)
                {
                      
                   component.set("v.users", response.getReturnValue());
                    component.set("v.showrecentUsers",true);
                }
              if(items.length ===undefined || items.length === 0){
                     console.log("coming");
                component.set("v.showmessage",true);
              }
            }
        });
        action.setExclusive();
        $A.enqueueAction(action);
    }
})