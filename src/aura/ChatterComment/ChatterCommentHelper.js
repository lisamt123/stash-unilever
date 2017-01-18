({
	handleLikeComment : function(component,event) {
        this.showSpinner(component);
		var currentCommentId = component.get("v.currentComment.id");
        var action = component.get("c.likeUnlikeComment");
        action.setParams({
               "commentIdtoHandleLike" : currentCommentId
            });
        action.setCallback(this, function(actionResult) {
            this.hideSpinner(component);
        	});
        $A.enqueueAction(action);
        component.doRefreshComment(currentCommentId);
	} , 
    
    doRefreshComment : function(component,event) {
        this.showSpinner(component);
        var params = event.getParam('arguments');
		if (params) {
			var currentCommentId = params.currentCommentId;
            var action = component.get("c.getCommentById");
            action.setParams({
                   "commentId" : currentCommentId
                });
            action.setCallback(this, function(actionResult) {
                component.set("v.currentComment", actionResult.getReturnValue());
                 this.hideSpinner(component);
                });
            $A.enqueueAction(action);
        }
        
    } ,
    
    showSpinner : function (component) {
        var spinner = component.find('CommentSpinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();    
    },
    hideSpinner : function (component) {
        var spinner = component.find('CommentSpinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire();    
    }
})