({
	doInit : function(component, event, helper) { 
       var action = component.get("c.getIpassSpendDetails");
        action.setParams({"month":component.get("v.CurrentMonth")});
       action.setCallback(this, function(response){
            var state = response.getState();
          
           console.log(state);
            if (component.isValid() && state === "SUCCESS" ) {
                res= response.getReturnValue(); 
                component.set("v.spendDetails",res);
                  component.set("v.deviceDetails",response.getReturnValue().objdeviceWrapper);
                }
           component.set("v.showspinner","false");
              });
           $A.enqueueAction(action);    
   },
    gotoDevices:function(component, event, helper) {
        var backEvent=$A.get("e.c:MB_Back_Evt");
        backEvent.setParams({"month":component.get("v.CurrentMonth"),"pagename":"MB_Devices"}).fire();
                                                    
    },
    iPass_charts: function(component, event, helper) {
        var detailedTextEcent=$A.get("e.c:MB_iPass_charts_Event");
        detailedTextEcent.setParams({"CurrentMonth":component.get("v.CurrentMonth")}).fire();
    },
    gotoDetailSummaryIpass:function(component, event, helper) {
        var summaryEvent=$A.get("e.c:MB_iPassUsageVarience_Event"); 
        summaryEvent.setParams({"CurrentMonth":component.get("v.CurrentMonth"),"usageType":"iPass"}).fire();
    },
})