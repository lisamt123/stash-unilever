({
	 gotoUpcomingDetail: function(component,event,helper){
        var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_UpcomingDetail"}).fire();
     },
     nextPage: function(component, event, helper) {  
         
       // var reportId = component.find("recordId").get("v.value");
        var navToSObjEvt = $A.get("e.force:navigateToSObject");
        navToSObjEvt.setParams({
            recordId: "005V0000003PpCBIA0",
            slideDevName: "detail"
        }); 
        navToSObjEvt.fire();      
    },
    doInit1 : function(component, event, helper) {  
       // var reportId = component.find("recordId").get("v.value");
        var navToSObjEvt = $A.get("e.force:navigateToSObject");
        navToSObjEvt.setParams({
            recordId: "005E0000007NRvyIAG",
            slideDevName: "detail"
        }); 
        navToSObjEvt.fire();      
    },
    doInit2 : function(component, event, helper) {  
       // var reportId = component.find("recordId").get("v.value");
        var navToSObjEvt = $A.get("e.force:navigateToSObject");
        navToSObjEvt.setParams({
            recordId: "005E0000007NRvxIAG",
            slideDevName: "detail"
        }); 
        navToSObjEvt.fire();      
    },
    
    
})