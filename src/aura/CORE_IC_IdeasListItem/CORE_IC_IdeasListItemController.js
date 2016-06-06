({	    
    ideaShare : function(component, event, helper) {   	
         var subject=$A.get("$Label.c.CORE_IC_IdeaSubject");
         var label1=$A.get("$Label.c.CORE_IC_IdeaBody");
         var label2=$A.get("$Label.c.CORE_IC_IdeaSubBody");
         var label3=encodeURIComponent(window.location.origin+"/apex/CORE_IC_NavigateToApp?articleId="+component.get("v.ideasListItem").IdeaId+"&articleType=Idea");
         component.set("v.MailSubjectIdea",subject);
         component.set("v.MailToBody3",label1);
         component.set("v.MailToBody4",label2);
         component.set("v.MailToBody5",label3);
        component.set("v.shareIdea",true);
        $("#showideaOptions").toggle(function(){
            component.set("v.shareIdea",false);
        });
        event.stopPropagation();
   
	},
    navigateToChatter : function(component, event, helper) {
    	var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_ChatterShare","recordType":"Idea","recordDetail":component.get("v.ideasListItem"),"pannelType":component.get("v.pannelType")}).fire();
    },
    
     hideIdeaChatterShare : function(component, event, helper) {
        component.set("v.shareIdea",false);       
    },
    
    showIdeaVoted : function(component, event, helper) {  
        var IdeaIdList=component.get("v.ideasListItem").IdeaId;
         var action = component.get("c.postVoteForIdea");
        action.setParams({
			"ideaId": IdeaIdList
		});
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS" && response.getReturnValue()!==''){
                component.set("v.ideasListItem.VoteCount",response.getReturnValue().VoteCount); 
                component.set("v.ideasListItem.Voted","True"); 
                var selectEvent = $A.get("e.c:CORE_IC_IdeaListEvent");
                selectEvent.setParams({"recordId":IdeaIdList,"recordCommentCount":response.getReturnValue().VoteCount,"selectedSortType":component.get("v.selectedSortType")}).fire(); 
            }
        });
        $A.enqueueAction(action);
       
    },
     displayIdeaDetails: function(component, event, helper) { 
        var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
           selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaDetail","recordType":"Idea","recordDetail":component.get("v.ideasListItem"),"pannelType":component.get("v.pannelType")}).fire();
    },
    
})