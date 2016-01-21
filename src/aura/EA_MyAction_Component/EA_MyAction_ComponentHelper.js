({
	getUsersInvitedActivities1 : function(component) {
        var action=component.get("c.getUsersInvitedActivities");
        action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue()!='' ) {
                    var items=response.getReturnValue();
                    if(items.length>0){
                     component.set("v.invitedActivities", response.getReturnValue());
                   }
                    else{
                        component.set("v.showmessage",true);
                    }
                }
                });
            $A.enqueueAction(action);

	}
})