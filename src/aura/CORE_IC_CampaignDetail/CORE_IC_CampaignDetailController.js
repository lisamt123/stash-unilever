({
    getCampaignDetailData : function(component, event, helper) {
        var selectedIdeaThemeId;
        var selectedIdeaThemeId;
        if(component.get("v.articleId")!=''){
            selectedIdeaThemeId=component.get("v.articleId");
        } else {
            selectedIdeaThemeId=component.get("v.recordDetail.IdeaThemeId");
        }        
        var action = component.get("c.getCampaignDetail");
        action.setParams({
            "ideaThemeId": selectedIdeaThemeId,
            "latestIdeasLimit" :"4"
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
                component.set("v.recordDetail",response.getReturnValue());
                component.set("v.FeaturedCampaignsItems",response.getReturnValue().FeaturedCampaigns); 
                component.set("v.leaderBoardItems",response.getReturnValue().LeaderBoard);
                component.set("v.latestIdeaItems",response.getReturnValue().IdeasOfTheWeek);
                component.set("v.campaignAllIdeaData",response.getReturnValue().IdeasOfTheWeek);
                var count=  component.get("v.FeaturedCampaignsItems.IdeaCount");
                if(count===0){
                    component.set("v.IdeaCount","true"); 
                }                
                component.set("v.showspinner","false");                
            }
        });
        $A.enqueueAction(action);
   },
    showShare : function(component, event, helper) {
         var subject=$A.get("$Label.c.CORE_IC_CampaignSubject");
        var label1=$A.get("$Label.c.CORE_IC_CampaignBody");
         var label2=$A.get("$Label.c.CORE_IC_CampaignSubBody");
         var label3=encodeURIComponent(window.location.origin+"/apex/CORE_IC_NavigateToApp?articleId="+component.get("v.FeaturedCampaignsItems").IdeaThemeId+"&articleType=Campaign");
         component.set("v.MailSubject",subject);
         component.set("v.MailToBody1",label1);
         component.set("v.MailToBody2",label2);
         component.set("v.MailToBody3",label3);
        component.set("v.share",true);
        $("#showOptions").toggle(function(){
            component.set("v.share",false);
        });
        event.stopPropagation();
   },
    navigateToChatter : function(component, event, helper) {
        var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_ChatterShare","recordType":"Campaign","recordDetail":component.get("v.FeaturedCampaignsItems"),"pannelType":component.get("v.pannelType")}).fire();
    },
    hideChatterShare : function(component, event, helper) {
        component.set("v.share",false); 
        component.set("v.shareIdea",false); 
    },
    navigateToAllCampaigns : function(component, event, helper) {
        var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaTemplate","pannelType":component.get("v.pannelType")}).fire();
    },
    gotoSubmitIdea : function(component, event, helper) {
       var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
       selectEvent.setParams({"componentName":"markup://c:CORE_IC_SubmitIdea","recordType":"Campaign","recordDetail":component.get("v.campaignsListItem"),"pannelType":component.get("v.pannelType")}).fire(); 
    },
    
    gotoIdeaListPage: function(component, event, helper) { 
        var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeasList","Pagename":"campaignIdea","recordDetail":component.get("v.recordDetail"),"pannelType":component.get("v.pannelType"),"displayCampaignIdea":true}).fire();
    },
    
    showIdeaVoted : function(component, event, helper) {
        var IdeaIdList=component.get("v.latestIdeaItems");
         var action = component.get("c.postVoteForIdea");
        action.setParams({
            "ideaId": IdeaIdList[0].IdeaId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"  && response.getReturnValue()!=='') {
                component.set("v.latestIdeaItems[0].VoteCount",response.getReturnValue().VoteCount); 
                component.set("v.latestIdeaItems[0].Voted","True"); 
            }
        });
        $A.enqueueAction(action);
    },
    navigateToFeedback: function(component, event, helper) { 
        var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaTemplate","Pagename":"Feedback","pannelType":component.get("v.pannelType"),"componentName":"IdeaHome"}).fire();
    },
    navigateToFaq: function(component, event, helper) { 
        var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaFaqs","pannelType":component.get("v.pannelType")}).fire();
    },
    ideaShare : function(component, event, helper) {         
         var subject=$A.get("$Label.c.CORE_IC_IdeaSubject");
         var label4=$A.get("$Label.c.CORE_IC_IdeaBody");
         var label5=$A.get("$Label.c.CORE_IC_IdeaSubBody");
         var label6=encodeURIComponent(window.location.origin+"/apex/CORE_IC_NavigateToApp?articleId="+component.get("v.latestIdeaItems[0]").IdeaId+"&articleType=Idea");
         component.set("v.MailSubjectIdea",subject);
         component.set("v.MailToBody3",label4);
         component.set("v.MailToBody4",label5);
         component.set("v.MailToBody5",label6);
         component.set("v.shareIdea",true);
        $("#showideaOptions").toggle(function(){
            component.set("v.shareIdea",false);
        });
        event.stopPropagation();
   
    },                
    navigateToChatterForLatestIdea : function(component, event, helper) {
        var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_ChatterShare","recordType":"Idea","recordDetail":component.get("v.latestIdeaItems[0]"),"pannelType":component.get("v.pannelType")}).fire();
    },
    gotoIdeaDetailPage: function(component, event, helper) { 
      var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
   selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaDetail","recordType":"Idea","recordDetail":component.get("v.latestIdeaItems[0]"),"pannelType":component.get("v.pannelType")}).fire();  
       
    },
   
})