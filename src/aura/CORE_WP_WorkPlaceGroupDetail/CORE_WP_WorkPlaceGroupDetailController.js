({
	navigateToGroupDetailPage : function(component, event, helper) {
        var GroupId=component.get("v.workplaceGroupDetail.Id");
        var urlEvent = $A.get("e.force:navigateToSObject");
        urlEvent.setParams({"recordId": GroupId,"slideDevName": "related"}).fire();
    },
   /* gotoPreviousPage: function(component, event, helper) {         
        var workplaceLocationId=component.get("v.workplaceLocationId");
        var selectEvent = $A.get("e.c:CORE_WP_WorkplaceEvent");
        selectEvent.setParams({"selectedWrokplaceId": workplaceLocationId,"WorkplacePannelType":"CORE_WP_WorkplaceHome"}).fire();
    }, */
})