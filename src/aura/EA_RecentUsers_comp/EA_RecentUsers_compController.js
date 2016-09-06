({
    getUsersPics : function(component, event, helper) {
        
        var action =component.get("c.getuserList");
        action.setParams({"recentactivityid":component.get("v.recentactivityid")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!== '') {
                var items=response.getReturnValue();
                if(items.length>0 && items.length !==undefined){
                component.set("v.users", items);
                 component.set("v.showrecentUsers", true);
                }
            
            else
             {
               component.set("v.showmessage", true); 
             }  
            }
        
        });
        $A.enqueueAction(action);
        },
    
 
})