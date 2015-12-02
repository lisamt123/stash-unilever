({
	
  
  doInit: function(component, event, helper) {
  	     
         var activityid=component.get("v.EAactivityid");
     
      var action=component.get("c.getcontentdetail")
      action.setParams({"ActivityID":activityid});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()!=''){
                    var items = response.getReturnValue();
                   helper.getComments(component);
                
                    if(items.length === 0){
                       
                        component.set("v.showmessage",true);
                    }
                    component.set("v.content",items[0]);
                    
                }
            }
        });
        $A.enqueueAction(action);
      helper.getComments(component);
  }
    })