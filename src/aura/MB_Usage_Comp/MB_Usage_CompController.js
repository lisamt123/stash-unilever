({
	doInit : function(component, event, helper) { 
       var action = component.get("c.getUsageDetails");
       action.setParams({ month : component.get("v.CurrentMonth")});
       action.setCallback(this, function(response){
           var state = response.getState(); 
           console.log("result"+response.getReturnValue());
           console.log();
            if (component.isValid() && state === "SUCCESS" ) {
                res= response.getReturnValue(); 
                 
                if(res !==null ){
                    component.set("v.usageData",res);
                    var totalUsage=Number(res.totalUsage).toFixed(2);
                     component.set("v.totalSpend",totalUsage);
                    component.set("v.showDetails",true);
                    component.set("v.userName",res.userName);
                     
                }
                
                   if(res ==null ){
                    console.log("coming in else part");
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
           component.set("v.showspinner","false"); 
         });
       $A.enqueueAction(action); 
    },
})