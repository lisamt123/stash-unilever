({
	loadIdeaHome : function(component, event, helper) {
        $A.get('e.force:refreshView'); 
        component.set("v.showspinner",true);
        var action=component.get("c.findFeedbacks");
        action.setParams({"appName":component.get("v.appName")});
        action.setCallback(this, function(response) {              
             var state = response.getState();
             if (state === "SUCCESS" && response.getReturnValue()!=='') {
                var response=response.getReturnValue();
                if(response === true){                    
                    component.set("v.showspinner",false); 
                    helper.loadFeedBack(component,"markup://c:Feedback",component.get("v.pannelType"));
                 }
                if(response === false ){
                    component.set("v.showspinner",false); 
                    helper.loadNewComponent(component,"markup://c:CORE_IC_IdeaHome",component.get("v.pannelType"));        
                 }
              }
         });    
        if(component.get("v.articleId")!=undefined){
        	console.log(component.get("v.articleType")+'---------------2--------------'+component.get("v.articleId"));
        	var componentName;
            if(component.get("v.articleType")==="Idea"){
                componentName="markup://c:CORE_IC_IdeaDetail";
            } else {
                componentName="markup://c:CORE_IC_CampaignDetail";
            }
            helper.loadDetailPageComponent(component,componentName,'','','',component.get("v.pannelType"),component.get("v.articleId"));
        } else {
    		$A.enqueueAction(action);              
        } 
    	component.set("v.showspinner",false); 
	},
    navigateWithinComponent: function(component, event, helper) {
        //helper.scrollToLocation(component, "top"); 
        $A.get('e.force:refreshView'); 
        console.log('-------template---------'+event.getParam("pannelType"));
        if(event.getParam("recordType")=="Campaign" || event.getParam("recordType")=="Idea"){
            helper.loadDetailPageComponent(component, event.getParam("componentName"),event.getParam("recordDetail"),event.getParam("recordType"),event.getParam("ParentPageDetail"),event.getParam("pannelType"),'');
        } else if(event.getParam("Pagename")=="CORE_IC_IdeaHome") {
            helper.loadNewComponent(component,"markup://c:CORE_IC_IdeaHome",event.getParam("pannelType"));    
        } else if(event.getParam("Pagename")=="Feedback") {
            helper.loadFeedBack(component,"markup://c:"+event.getParam("Pagename"),event.getParam("pannelType"));            
        } else if(event.getParam("Pagename")=="campaignIdea") {
            console.log('-------main---------'+event.getParam("componentName"));
            $A.componentService.newComponentAsync(this, function(view) {
                var content = component.find("IdeasPannel");
                content.set("v.body", view);
            }, {
                componentDef: event.getParam("componentName"),
                attributes: {
                    values: {
                        recordDetail: event.getParam("recordDetail"),
                        pannelType: event.getParam("pannelType"),
                        displayCampaignIdea: event.getParam("displayCampaignIdea")
                    }
                }
            }, component);
        }   else {
            helper.loadNewComponent(component,event.getParam("componentName"),event.getParam("pannelType"));
        }        
    },
    
})