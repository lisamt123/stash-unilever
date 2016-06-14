({
	SubmitMethod : function(component, event,comment,approvalDetail) {
		var action = component.get("c.updateApprovalAction");
        var isVisible = 'false'; 
        var checkCmp = component.find("taskCheckBox");
        if(checkCmp != undefined || checkCmp != null){
        	isVisible= checkCmp.get("v.value");
        }    
            action.setParams({
                "action": component.get("v.actionTaken"),
                "comment" : comment,
                "isVisibletoSupplier": isVisible,
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