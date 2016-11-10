({
	openSObject : function(component, event, helper) {  
        
        var sObjectEvent = $A.get("e.force:navigateToSObject");
        var refId = component.get("v.refId");
        sObjectEvent.setParams({
       		 "recordId": refId,
        	"slideDevName": "detail"
        })
        sObjectEvent.fire();
    }
})