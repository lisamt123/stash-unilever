({
    gotoPreviousPage : function(component, event, helper) {    
        var approvalDetail = component.get("v.ApprovalDetail");     
        var selectEvent = $A.get("e.c:CORE_CA_DetailsEvent");   
        selectEvent.setParams({"RequestId": approvalDetail[0].RequestId,
                               "ApproverId": approvalDetail[0].ApproverId,
                               "Sourcesystem": approvalDetail[0].RequestType,
                               "sourcePage": component.get("v.sourcePage"),
                               "filterValue": component.get("v.filterValue")}).fire();
    }
})