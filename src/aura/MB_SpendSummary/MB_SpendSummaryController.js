({
    doInit : function(component, event, helper) { 
       var action = component.get("c.getSpendDetails");
      
        action.setParams({"deviceId":component.get("v.deviceId"),"month":component.get("v.CurrentMonth")});
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

	gotoSummary_charts : function(component, event, helper) {
        //alert('2'+component.get("ServiceName"));
        var detailedTextEcent=$A.get("e.c:MB_gotoSummary_charts_Event");
        console.log("month-->"+component.get("v.CurrentMonth"));
        detailedTextEcent.setParams({"ServiceName":component.get("v.ServiceName"),"CurrentMonth":component.get("v.CurrentMonth"),"deviceName":component.get("v.deviceName"),"deviceId":component.get("v.deviceId")}).fire();
        	 
	},
    //This method redirects to device tab 
      gotoDevices:function(component, event, helper) {
        var backEvent=$A.get("e.c:MB_Back_Evt");
        backEvent.setParams({"ServiceName":component.get("v.ServiceName"),"month":component.get("v.CurrentMonth"),"pagename":"MB_SpendSummary_Charts","deviceId":component.get("v.deviceId"),"deviceName":component.get("v.deviceName")}).fire();
                                                    
    },
    gotoDetailSummaryCalls:function(component, event, helper) {
        var summaryEvent=$A.get("e.c:MB_UsageTypeSummary_Event");
        console.log("month-->"+component.get("v.CurrentMonth")+component.get("v.deviceId"));
        summaryEvent.setParams({"ServiceName":component.get("v.ServiceName"),"month":component.get("v.CurrentMonth"),"deviceId":component.get("v.deviceId"),"usageType":"Calls","deviceName":component.get("v.deviceName")});
        summaryEvent.fire();
    },

    gotoDetailSummaryData:function(component, event, helper) {
        var summaryEvent=$A.get("e.c:MB_UsageTypeSummary_Event"); 
        summaryEvent.setParams({"ServiceName":component.get("v.ServiceName"),"month":component.get("v.CurrentMonth"),"deviceId":component.get("v.deviceId"),"usageType":"Data","deviceName":component.get("v.deviceName")}).fire();
    },
    
    gotoDetailSummaryMessage:function(component, event, helper) {
        var summaryEvent=$A.get("e.c:MB_UsageTypeSummary_Event"); 
        summaryEvent.setParams({"ServiceName":component.get("v.ServiceName"),"month":component.get("v.CurrentMonth"),"deviceId":component.get("v.deviceId"),"usageType":"Messaging","deviceName":component.get("v.deviceName")}).fire();
    },
    
    gotoDetailSummaryIpass:function(component, event, helper) {
        var summaryEvent=$A.get("e.c:MB_UsageTypeSummary_Event"); 
        summaryEvent.setParams({"ServiceName":component.get("v.ServiceName"),"month":component.get("v.CurrentMonth"),"deviceId":component.get("v.deviceId"),"usageType":"iPass","deviceName":component.get("v.deviceName")}).fire();
    },
    
    gotoDetailSummarynonUsage:function(component, event, helper) {
        var summaryEvent=$A.get("e.c:MB_UsageTypeSummary_Event"); 
        summaryEvent.setParams({"ServiceName":component.get("v.ServiceName"),"month":component.get("v.CurrentMonth"),"deviceId":component.get("v.deviceId"),"usageType":"NonUsage","deviceName":component.get("v.deviceName")}).fire();
    },
    
})