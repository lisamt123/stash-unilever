({
   doInit :function(component, event, helper)  {
       
   var runningUserInfo = component.get("c.getLoggedInUser"); 
        runningUserInfo.setCallback(this, function(response) {
            component.set("v.runningUserInfo", response.getReturnValue()); 
           component.set("v.runningUserInfoId",response.getReturnValue().Id);

        });
        $A.enqueueAction(runningUserInfo);
        
    } , 
     
    defaultContent :function(component, event, helper)  {
            var defaultSubTab=component.find('tab-upcoming');
            $A.util.addClass(defaultSubTab,'slds-active');
            var cmpTarget = component.find('upcomingTabContent');
            $A.util.addClass(cmpTarget,'slds-show');
        
    } ,
    runningUserStandardDetails : function(component, event, helper) {  
    
        var navToSObjEvt = $A.get("e.force:navigateToSObject");
        navToSObjEvt.setParams({
            recordId: component.get("v.runningUserInfoId"),
            slideDevName: "detail"
        }); 
        navToSObjEvt.fire();      
    },
    
})