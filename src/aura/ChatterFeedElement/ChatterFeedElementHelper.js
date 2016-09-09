({
    
		doAddComment: function(component) {
        this.showSpinner(component);
   		var feedElementId = component.get("v.feedElementId");
        var textComment = component.get("v.textComment");
 
        var action = component.get("c.postCommentToFeedElement");
        
        action.setParams({
              "feedElementId": feedElementId,
              "text": textComment,
            });
        //Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult) {
            	component.set("v.textComment", "");
				component.set("v.element", actionResult.getReturnValue());
                this.hideSpinner(component);
        });
        $A.enqueueAction(action);
        
  } ,
    
     doLikeFeedElement: function(component) {
		this.showSpinner(component);
        var feedElementId = component.get("v.feedElementId");
        var isAlreadyLiked = component.get("v.element.isLikedByCurrentUser");
		
        var action ;
         if(isAlreadyLiked) {
             action = component.get("c.unlikeFeedElement");
         } else {
             action = component.get("c.likeFeedElement");
         }     
        action.setParams({
              "feedElementId": feedElementId
            });
        //Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult) {
              component.set("v.element", actionResult.getReturnValue());
              this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    
    showSpinner : function (component) {
        var spinner = component.find('FeedElementSpinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();    
    },
    hideSpinner : function (component) {
        var spinner = component.find('FeedElementSpinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire();    
    }
    
    

})