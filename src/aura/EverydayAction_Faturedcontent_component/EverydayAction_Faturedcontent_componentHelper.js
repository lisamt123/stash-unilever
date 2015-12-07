({
	getComments : function(component) {
        
      var activityid=component.get("v.EAactivityid");
     
      var action=component.get("c.getcommentDetail")
      action.setParams({"ActivityID":activityid});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!='') {
                    var items = response.getReturnValue();
                    component.set("v.comments",response.getReturnValue());
                     if(items.length == 0){
                        component.set("v.showmessage",true);
                    }
            }
        });
        $A.enqueueAction(action);
  }
	
})