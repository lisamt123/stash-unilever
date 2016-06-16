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
                    var hours;
                    var min;
                    if(res.totalCallUsage>60){
                      hours=parseInt(res.totalCallUsage/60);
                        if(hours < 10){
                            hours="0"+hours;
                        }
                        
                      min=parseInt(res.totalCallUsage%60);
                         if(min < 10){
                            min="0"+min;
                        }
                    }
                    else {
                      hours="0"+"0";
                       min=res.totalCallUsage;
                    }
                        component.set("v.hours",hours);
                        component.set("v.minutes",min);
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