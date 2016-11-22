({
    
    doInit : function(component, event, helper) {
     var action = component.get("c.defaultChatterValue");
		action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state == "SUCCESS" && response.getReturnValue()!='') {
               // if(response.getReturnValue()!=''){ 
                   //based on the attribute value chatter post and Email in old format will be enabled
                    component.set("v.chatterValue", response.getReturnValue()); 
				//}
			}	
       });
        $A.enqueueAction(action);
        
   }, 
	showShare : function(component, event, helper) {
        	//component.set("v.url", window.location.pathname);
         var subject=$A.get("$Label.c.CORE_IC_CampaignSubject");
         var label1=$A.get("$Label.c.CORE_IC_CampaignBody");
         var label2=$A.get("$Label.c.CORE_IC_CampaignSubBody");
         var label3=encodeURIComponent(window.location.origin+"/apex/CORE_IC_NavigateToApp?articleId="+component.get("v.campaignsListItem").IdeaThemeId+"&articleType=Campaign");
         var label4=$A.get("$Label.c.CORE_IC_CampaignText");
         component.set("v.MailSubject",subject);
         component.set("v.MailToBody1",label1);
         component.set("v.MailToBody2",label2);
         component.set("v.MailToBody3",label3);
         component.set("v.MailToBody4",label4);
         component.set("v.share",!component.get("v.share"));
         var toggleView = component.find("showOptions");
         component.set("v.shareCampaign",true);
         $A.util.toggleClass(toggleView, "slds-hide");
    	/*$("#showOptions").toggle(function(){
            component.set("v.shareCampaign",false);
        });
        event.stopPropagation();*/
   
	},
    navigateToChatter : function(component, event, helper) {
    	var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_ChatterShare","recordType":"Campaign","recordDetail":component.get("v.campaignsListItem"),"pannelType":component.get("v.pannelType")}).fire();
    },
    hideChatterShare : function(component, event, helper) {
        component.set("v.shareCampaign",false);       
    },
    gotoCampaignDetail : function(component, event, helper) {
        var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_CampaignDetail","recordType":"Campaign","recordDetail":component.get("v.campaignsListItem"),"pannelType":component.get("v.pannelType")}).fire(); 
    },
    gotoSubmitIdea : function(component, event, helper) {
       var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
       selectEvent.setParams({"componentName":"markup://c:CORE_IC_SubmitIdea","recordType":"Campaign","recordDetail":component.get("v.campaignsListItem"),"pannelType":component.get("v.pannelType")}).fire(); 
    },
    
})