({
	doAddComment : function(component, event, helper) {
		helper.doAddComment(component);
	},
    
    handleCommentPublisherStyling : function(component, event) {
        var feedElementId = component.get('v.feedElementId');
        
        if (!jQuery("."+feedElementId).hasClass("slds-is-active")) {
		  jQuery("."+feedElementId).addClass("slds-is-active");
		}
        
    },
    
    doLikeFeedElement : function(component, event, helper) {
		helper.doLikeFeedElement(component);
        
    },
    
   
    

   
})