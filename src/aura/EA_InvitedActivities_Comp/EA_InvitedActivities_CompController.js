({
	gotoDetail : function(component, event, helper) {
       var actvity=component.get("v.activity");
        var id=actvity.acivityId; 
        var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
        detailpageEvent.setParams({"actvityid":id});
        detailpageEvent.fire();
	},
})