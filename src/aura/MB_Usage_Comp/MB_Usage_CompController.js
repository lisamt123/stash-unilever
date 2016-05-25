({
	doInit : function(component, event, helper) { 
       var action = component.get("c.getUsageDetails");
      
       action.setParams({ month : component.get("v.CurrentMonth")});
       action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                res= response.getReturnValue(); 
                 
                if(res !==null ){
                 
                    component.set("v.usageData",res);
                    component.set("v.showDetails",true);
                    component.set("v.userName",res.userName);
                }
                
                else{
                    var action1=component.get("c.getUserName");
                    action1.setCallback(this, function(response) {
                       var state = response.getState();
                       if (state === "SUCCESS" && response.getReturnValue()!=='') {
                          
                           component.set("v.userName",response.getReturnValue());
                           component.set("v.showDetails",false);
                           
                       }
                     });
                   $A.enqueueAction(action1);  
                  }
             }
         });
       $A.enqueueAction(action); 
    },
})