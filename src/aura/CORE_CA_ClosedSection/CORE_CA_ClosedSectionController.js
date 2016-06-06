({
	navigateToDetail : function(component, event, helper) {
        var RequestId = component.find("reqlId").get("v.value");
        var ApproverId = component.find("appId").get("v.value");
        var Sourcesystem = component.find("srcId").get("v.value");
        
        var selectEvent = $A.get("e.c:CORE_CA_DetailsEvent");
        selectEvent.setParams({"RequestId":  RequestId,
                               "ApproverId": ApproverId,
                               "Sourcesystem": Sourcesystem,
                               "sourcePage": "closed",
                               "filterValue": component.get("v.retainfilterValue")}).fire();
	} 
 
})