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
         var toggleText = component.find("showideaOptions");
         component.set("v.shareIdea",true);
         $A.util.toggleClass(toggleText, "slds-hide");
  
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
        var IdeaIdLis2t=component.get("v.ideasListItem").IdeaThemeId;
        var action = component.get("c.postVoteForIdea");
        action.setParams({
            "ideaId": IdeaIdList
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!==''){
                component.set("v.ideasListItem.VoteCount",response.getReturnValue().VoteCount); 
                component.set("v.ideasListItem.Voted","True"); 
                var updateLikeCount=true;
                if(component.get("v.displayCampaignIdea")){
                    updateLikeCount=false;
                }
             
                if(updateLikeCount){  
                    var selectEvent = $A.get("e.c:CORE_IC_IdeaListEvent");
                	selectEvent.setParams({"recordId":IdeaIdList,"recordCommentCount":response.getReturnValue().VoteCount,"selectedSortType":component.get("v.selectedSortType")}).fire(); 
                }
            }
        });
        $A.enqueueAction(action);    
       
    },
     displayIdeaDetails: function(component, event, helper) { 
         if(component.get("v.displayCampaignIdea")){
             var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
             selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaDetail","recordType":"Idea","recordDetail":component.get("v.ideasListItem"),"pannelType":component.get("v.pannelType"),"ParentPageDetail":component.get("v.campaignItem")}).fire();
        
            //"componentName":"markup://c:CORE_IC_IdeasList",
            //"Pagename":"campaignIdea",
            //"displayCampaignIdea":true,
            //"recordDetail":component.get("v.campaignItem"),
            //"pannelType":component.get("v.pannelType"),
         } else {
             var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
             selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaDetail","recordType":"Idea","recordDetail":component.get("v.ideasListItem"),"pannelType":component.get("v.pannelType")}).fire();
         }
    },
    
    displayCampaignDetails: function(component, event, helper) {
         var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
             selectEvent.setParams({"componentName":"markup://c:CORE_IC_CampaignDetail","recordType":"Campaign","recordDetail":component.get("v.ideasListItem"),"pannelType":component.get("v.pannelType")}).fire();
        
    },
    
})