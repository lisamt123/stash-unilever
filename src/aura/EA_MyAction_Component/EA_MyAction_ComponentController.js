({
	doInit : function(component, event, helper) {
      
       var action=component.get("c.getUserActivities");
        
        
        action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                       
                    if(response.getReturnValue()!=''){
                        var items=response.getReturnValue();
                     
                        if(items.length === 0){
                            alert("message");
                            
                        }
                      
                     component.set("v.acivities", response.getReturnValue());
                                             
                       
                   }
                    else
                        component.set("v.showmessage",true);
                }
                });
            $A.enqueueAction(action);

		
	},
		
	
})