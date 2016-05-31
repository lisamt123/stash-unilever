({
    getCampaignDetailData : function(component, event, helper) {
         var selectedIdeaThemeId=component.get("v.recordDetail.IdeaThemeId");
           var action = component.get("c.getCampaignDetail");
        action.setParams({
			"ideaThemeId": selectedIdeaThemeId,
            "latestIdeasLimit" :"4"
		});
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {
                if(response.getReturnValue()!==''){
                  //component.set("v.recordDetail",response.getReturnValue().Categories);
                  component.set("v.FeaturedCampaignsItems",response.getReturnValue().FeaturedCampaigns); 
                  component.set("v.leaderBoardItems",response.getReturnValue().LeaderBoard);
                  component.set("v.showspinner","false");
                }                  
        	}
        });
        $A.enqueueAction(action);
     
    },
    showShare : function(component, event, helper) {
        //alert("share");
       //component.set("v.url", window.location.pathname);
         var subject=$A.get("$Label.c.CORE_IC_ShareEmail1");
         var label1=$A.get("$Label.c.CORE_IC_ShareEmail2");
         var label2=$A.get("$Label.c.CORE_IC_ShareEmail3");
         var label3=encodeURIComponent(window.location.origin+"/apex/CORE_IC_NavigateToApp?articleId="+component.get("v.FeaturedCampaignsItems").IdeaThemeId+"&articleType=Campaign");
         component.set("v.MailSubject",subject);
         component.set("v.MailToBody1",label1);
         component.set("v.MailToBody2",label2);
         component.set("v.MailToBody3",label3);
        //component.set("v.share",!component.get("v.share"));
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
    },
    navigateToAllCampaigns : function(component, event, helper) {
    	var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaTemplate","pannelType":component.get("v.pannelType")}).fire();
    },
	
})