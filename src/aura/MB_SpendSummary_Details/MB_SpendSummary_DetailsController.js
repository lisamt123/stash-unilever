({
	doinit : function(component, event, helper) {
        component.set("v.showspinner","true");
		 var action = component.get("c.getSpendDetailsforChargelist");
        action.setParams({"deviceId":component.get("v.deviceId"), "month":component.get("v.month"),"usagetype" : component.get("v.usageType")});
        action.setCallback(this, function(response){
            var state = response.getState();  
            if (component.isValid() && state === "SUCCESS") {
                var res= response.getReturnValue(); 
 
                component.set("v.AllData",res);
                
            } 
        });
        $A.enqueueAction(action);
        /*------------------------------------------------------------*/
        var action1 = component.get("c.getUsageTotalAmount");
        action1.setParams({"deviceId":component.get("v.deviceId"), "month":component.get("v.month"),"usagetype" : component.get("v.usageType")});
        action1.setCallback(this, function(response){
            var state = response.getState(); 
            if (component.isValid() && state === "SUCCESS") {
                var res1= response.getReturnValue();  
             //alert(res1.UsageCurrentAmount);
             component.set("v.AllHeadData",res1);
            } 
            component.set("v.showspinner","false");
        });
        $A.enqueueAction(action1); 
	},
    gotoSummarySpend:function(component, event, helper) {
    var summaryEvent=$A.get("e.c:MB_SummarySpend_Event"); 
        summaryEvent.setParams({"ServiceName":component.get("v.ServiceName"),"month":component.get("v.month"),"deviceId":component.get("v.deviceId"),"deviceName":component.get("v.deviceName")}).fire();

    }
})