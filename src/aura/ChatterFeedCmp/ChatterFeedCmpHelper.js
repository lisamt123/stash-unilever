({
   //Fetch the accounts from the Apex controller
  getFeed: function(component) {
    var subjectId  = component.get("v.subjectId");
    var feedType  = component.get("v.feedType");
    var action = component.get("c.getFeedElements");
	action.setParams({
          "subjectId": subjectId,
          "feedType" : feedType
        });
    //Set up the callback
    var self = this;
    action.setCallback(this, function(actionResult) {
        component.set("v.feedElements", actionResult.getReturnValue());            
    });
    $A.enqueueAction(action);
  } 
    
        
})