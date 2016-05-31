({
	getCampaignsListData : function(component, event, helper) {
        var action = component.get("c.getCampaignList");
        action.setParams({
			"campaignLimit": "All"
		});
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {    
                if(response.getReturnValue().FeaturedCampaigns!=null){
                    //component.set("v.showMoreLimit",2);     
                    component.set("v.showMoreLimit",response.getReturnValue().ShowMoreLimit);
                    var campaignsList = response.getReturnValue().FeaturedCampaigns;                                 
                    var activeCampaignsArray = [];
                    var closedCampaignsArray = [];
                    for(var count=0;count<campaignsList.length ;count++){
                        if(campaignsList[count].StatusType=="Active"){
                            activeCampaignsArray.push(campaignsList[count]);
                        } else {
                            closedCampaignsArray.push(campaignsList[count]);
                        }
                    }
                    component.set("v.activeCampaignsList",activeCampaignsArray);
                    component.set("v.closedCampaignsList",closedCampaignsArray);
                    if(response.getReturnValue().ActiveStatus==true){
                        helper.filterCampaignsListOnLoad(component,activeCampaignsArray,"activeCampaign");
                        component.set("v.campaignTitle","Active Campaigns");
                    } else {
                        helper.filterCampaignsListOnLoad(component,closedCampaignsArray,"closedCampaign"); 
                        component.set("v.campaignTitle","Closed Campaigns");
                    }
                    component.set("v.showspinner",false);
                }else{
                    component.set("v.campaignTitle","All Campaigns");
                    component.set("v.displayErrorMessage",true);
                    component.set("v.showspinner",false);
                }
            } else {
                component.set("v.showspinner",false);
            }     	                   
        });
        $A.enqueueAction(action);
       
	},
    loadMoreCampaignList: function(component, event, helper) {
        if(component.get("v.selectedCampaignFilter")=="activeCampaign"){                                
        	helper.filterCampaignsList(component,component.get("v.activeCampaignsList"));
        } else {
			helper.filterCampaignsList(component,component.get("v.closedCampaignsList"));            
        }
    },
    
    showFilterMenu : function(component, event, helper) { 
        component.set("v.showFilter",true); 
        $("#sortOptions").toggle();
          var cmp1=component.find(component.get("v.selectedCampaignFilter"));
        $A.util.addClass(cmp1,'campaign');
	},
    displayOpenCampaigns : function(component, event, helper) {
        $("#sortOptions").toggle();
        component.set("v.campaignTitle","Active Campaigns");
        $A.util.removeClass(component.find(component.get("v.selectedCampaignFilter")),'campaign');   
        helper.filterCampaignsListOnLoad(component,component.get("v.activeCampaignsList"),"activeCampaign");
        //$A.util.removeClass(component.find('closedCampaign'),'campaign');
        //$A.util.addClass(component.find('activeCampaign'),'campaign');                   
        //component.set("v.selectedCampaignFilter","activeCampaign"); 
    },
   displayClosedCampaigns : function(component, event, helper) {
        $("#sortOptions").toggle();
        component.set("v.campaignTitle","Closed Campaigns");
        $A.util.removeClass(component.find(component.get("v.selectedCampaignFilter")),'campaign');  
        helper.filterCampaignsListOnLoad(component,component.get("v.closedCampaignsList"),"closedCampaign");
        //$A.util.removeClass(component.find('activeCampaign'),'campaign');
        //$A.util.addClass(component.find('closedCampaign'),'campaign');     
        //component.set("v.selectedCampaignFilter","closedCampaign");
    },
    hideFilterMenu : function(component, event, helper) {
        component.set("v.showFilter",false); 
    },
    
    
  /*  showShare : function(component, event, helper) {
         var subject=$A.get("$Label.c.CORE_IC_ShareEmailCampaign1");
         var label1=$A.get("$Label.c.CORE_IC_ShareEmailCampaign2");
         var label2=$A.get("$Label.c.CORE_IC_ShareEmailCampaign3");
         component.set("v.MailSubject",subject);
         component.set("v.MailToBody1",label1);
         component.set("v.MailToBody2",label2);
        component.set("v.share",true);
        $("#showOptions").toggle(function(){
            component.set("v.share",false);
        });
        event.stopPropagation();   
	},
    navigateToChatter : function(component, event, helper) {
    	//var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        //selectEvent.setParams({"componentName":"markup://c:CORE_IC_ChatterShare","recordType":"Campaign","recordDetail":component.get("v.campaignsListItem"),"pannelType":component.get("v.pannelType")}).fire();
    },*/
    hideChatterShare : function(component, event, helper) {
        component.set("v.share",false);
    },
    navigateToFaq: function(component, event, helper) { 
        var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaFaqs","pannelType":component.get("v.pannelType")}).fire();
    },
})