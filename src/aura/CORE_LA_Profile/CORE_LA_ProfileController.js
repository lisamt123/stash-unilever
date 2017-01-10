({
    defaultContent :function(component, event, helper)  {
            var defaultSubTab=component.find('tab-upcoming');
            $A.util.addClass(defaultSubTab,'slds-active');
            var cmpTarget = component.find('upcomingTabContent');
            $A.util.addClass(cmpTarget,'slds-show');
        
    } ,
    doInit : function(component, event, helper) {  
       // var reportId = component.find("recordId").get("v.value");
        var navToSObjEvt = $A.get("e.force:navigateToSObject");
        navToSObjEvt.setParams({
            recordId: "005V0000003PpCBIA0",
            slideDevName: "detail"
        }); 
        navToSObjEvt.fire();      
    },
    
})