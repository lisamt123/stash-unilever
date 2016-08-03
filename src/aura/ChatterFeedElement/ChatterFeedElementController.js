({
	doAddComment : function(component, event, helper) {
		helper.doAddComment(component);
	},
    
    handleCommentPublisherStyling : function(component, event) {
        var feedElementId = component.get('v.feedElementId');
        $('.unique111').focus();
        if (!jQuery("."+feedElementId).hasClass("slds-is-active")) {
		  jQuery("."+feedElementId).addClass("slds-is-active");
            $('.unique111').focus();
		}
        
    },
    
    doLikeFeedElement : function(component, event, helper) {
		helper.doLikeFeedElement(component);
        
    }
    

   
})