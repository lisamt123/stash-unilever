({
    navigateToDetail : function(component, event, helper) { 
        var action = component.get("c.getUIThemeDescription");
        action.setCallback(this, function(response) {
            component.set("v.isDesktop",response.getReturnValue());
            if(response.getReturnValue() != 'Lightning Experience'){ 
                helper.scrollToLocation(component, "top");
            }
            var RequestId = component.find("reqlId").get("v.value");
            var ApproverId = component.find("appId").get("v.value");
            var Sourcesystem = component.find("srcId").get("v.value");
            
            var selectEvent = $A.get("e.c:CORE_CA_DetailsEvent");
            selectEvent.setParams({"RequestId":  RequestId,
                                   "ApproverId": ApproverId,
                                   "Sourcesystem": Sourcesystem,
                                   "sourcePage": "Pending",
                                   "filterValue": component.get("v.retainfilterValue")}).fire();
        });    
        $A.enqueueAction(action);
        
    }, 
    /*gotoApp : function(component, event, helper) { 
		component.set("v.isFeedBackPopup",false);    
	},
    doInit : function(component, event, helper) {  
		var action=component.get("c.findFeedbacks");         
        action.setCallback(this, function(response) { 
            var state = response.getState(); 
            if (state === "SUCCESS" && response.getReturnValue()!=='') { 
                var response=response.getReturnValue();       
                if(response === true){ alert(response);
                    //component.set("v.isFeedBackPopup",true);
                }             
            }
        });
       $A.enqueueAction(action);   
	},*/
})