({
	getIdeaDetailData : function(component, event, helper) {
        console.log('----------------IdeaDetail--'+component.get("v.recordDetail").IdeaId);
        var selectedIdeaId=component.get("v.recordDetail.IdeaId");
	    var action = component.get("c.getIdeaDetail");
        action.setParams({
			"ideaId": selectedIdeaId
		});
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS" && response.getReturnValue()!=='') {
               
               component.set("v.recordDetail",response.getReturnValue().IdeaDetails); 
               component.set("v.commentListItem",response.getReturnValue().IdeaComments);
                var count=  component.get("v.recordDetail.CommentCount");
                if(count===0){
                    component.set("v.commentCount","true"); 
                }
               component.set("v.showspinner","false"); 
          
        }
        });
        $A.enqueueAction(action);
    
    },
    
     navigateToAllIdea : function(component, event, helper) {
    	var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaTemplate","pannelType":component.get("v.pannelType")}).fire();
    },
     
    submitComment :function(component, event, helper) {
         var selectedIdeaId=component.get("v.recordDetail.IdeaId");
		 var comments = component.find("comments").get("v.value");
	     var action= component.get("c.postCommentAnIdea");
		     action.setParams({
			"ideaId": selectedIdeaId,
			"commentBody": comments
		});
		 action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS" && response.getReturnValue()!=='') {
                  component.set("v.commentListItem",response.getReturnValue().IdeaComments); 
                  component.set("v.commentCount","false");
                 
                }
        	
        });
        $A.enqueueAction(action);
        
        var action2 = component.get("c.getIdeaDetail");
         action2.setParams({
			"ideaId": selectedIdeaId
		});
        action2.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS" && response.getReturnValue()!=='') {
              
                  component.set("v.recordDetail.CommentCount",response.getReturnValue().IdeaDetails.CommentCount);
              
        	}
        });
        $A.enqueueAction(action2);
        
    },
     showIdeaVoted : function(component, event, helper) {  
        var IdeaIdList=component.get("v.recordDetail").IdeaId;
         var action = component.get("c.postVoteForIdea");
        action.setParams({
			"ideaId": IdeaIdList
		});
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS"  && response.getReturnValue()!=='') {
                
                   component.set("v.recordDetail.VoteCount",response.getReturnValue().VoteCount); 
                   component.set("v.recordDetail.Voted","True"); 
  
        	}
        });
        $A.enqueueAction(action);
       
    },
    
        navigateToFaq: function(component, event, helper) { 
        var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaFaqs","pannelType":component.get("v.pannelType")}).fire();
    },
})