({
	SubmitMethod : function(component, event,comment,approvalDetail) {
		var action = component.get("c.updateApprovalAction");
            action.setParams({
                "action": component.get("v.actionTaken"),
                "comment" : comment,
                "isVisibletoSupplier": component.get("v.isVisible"),
                "ApproverId": approvalDetail.ApproverId,
            }); 
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.success_toast",true);
                }
            });
            $A.enqueueAction(action);
	}
})