({
	navigateToGroupDetailPage : function(component, event, helper) {
        var GroupId=component.get("v.workplaceGroupDetail.Id");
        var urlEvent = $A.get("e.force:navigateToSObject");
        urlEvent.setParams({"recordId": GroupId,"slideDevName": "related"}).fire();
    }
})