({
	showFilterMenu : function(component, event, helper) {      
        component.set("v.showFilter",true); 
        component.set("v.showSort",false); 
        $("#sortOptions").toggle();
        event.stopPropagation();   
        var cmp1=component.find(component.get("v.selectedFilterType"));
        $A.util.addClass(cmp1,'campaign');
	},
    showSortMenu : function(component, event, helper) {  
        component.set("v.showFilter",false);     
        component.set("v.showSort",true);
        $("#filterOptions").toggle();
        event.stopPropagation();    
        var cmp1=component.find(component.get("v.selectedSortType"));
        $A.util.addClass(cmp1,'campaign');
	},
    
    loadIdeasListData : function(component, event, helper) {
        component.set("v.showspinner",true);              
        component.set("v.showFilterSort",true);            
        if(component.get("v.displayCampaignIdea")==true) {           
            var action = component.get("c.getCampaignDetail");
            action.setParams({
                "ideaThemeId":component.get("v.recordDetail.FeaturedCampaigns.IdeaThemeId"), 
                "latestIdeasLimit": "ALL"
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {    
                    if(response.getReturnValue().IdeasOfTheWeek!=null){
                        component.set("v.ideasList",response.getReturnValue().IdeasOfTheWeek);    
                        component.set("v.showspinner",false);              
                    } else {                    
                        component.set("v.displayErrorMessage",true);
                        component.set("v.showspinner",false);
                    }                   
                } else {
                    component.set("v.showspinner",false);
                }     	                   
            });
        	$A.enqueueAction(action);
        } else {               
            var action = component.get("c.getIdeaList");
            action.setParams({
                "ideaLimit": "ALL"
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {    
                    if(response.getReturnValue().IdeasOfTheWeek!=null){    
                        component.set("v.showMoreLimit",response.getReturnValue().ShowMoreLimit);
                        var ideasList = response.getReturnValue().IdeasOfTheWeek; 
                        if(ideasList.length>0) {                            
                            component.set("v.ideaTitle","All Ideas");
                            var activeIdeasArray = [];
                            var closedIdeasArray = [];
                            for(var count=0;count<ideasList.length ;count++){
                                if(ideasList[count].CampaignStatus=="Active"){
                                    activeIdeasArray.push(ideasList[count]);
                                } else {
                                    closedIdeasArray.push(ideasList[count]);
                                }
                            }
                            component.set("v.activeIdeasList",activeIdeasArray);
                            component.set("v.closedIdeasList",closedIdeasArray);
                            component.set("v.campaignStatus",response.getReturnValue().ActiveStatus);
                            if(response.getReturnValue().ActiveStatus==true){
                                helper.displayTrenddingIdeas(component,activeIdeasArray,"openCampaign");  
                                //helper.checkSelectedSort(component,"v.activeIdeasList","mostVotedIdea","openCampaign");
                                //component.set("v.showspinner",false);  
                            } else {
                                helper.checkSelectedSort(component,"v.closedIdeasList","mostVotedIdea","closedCampaign");  
                            }           
                        } else {        
                            helper.defaultOnCancel(component);
                        }          
                    } else {                                   
                        helper.defaultOnCancel(component);
                    }                   
                } else {                    
                    component.set("v.showFilterSort",false);
                    component.set("v.showspinner",false);
                }     	                   
            });
        	$A.enqueueAction(action);
        }
	},    
    loadMoreIdeaList: function(component, event, helper) {        
        if(component.get("v.selectedFilterType")=="openCampaign"){                    
			if(component.get("v.selectedSortType")=="trendingIdea"){	          
                helper.loadMoreIdeasHelper(component,component.get("v.trendingIdeasList"));
            } else {                        
        		helper.loadMoreIdeasHelper(component,component.get("v.activeIdeasList"));
            } 
        } else if(component.get("v.selectedFilterType")=="closedCampaign"){
			helper.loadMoreIdeasHelper(component,component.get("v.closedIdeasList"));            
        } else if(component.get("v.selectedFilterType")=="myIdeas"){
			helper.loadMoreIdeasHelper(component,component.get("v.myUpdatesList"));   
        }
    },        
    displayOpenCampaigns : function(component, event, helper) {  
        $("#sortOptions").toggle();           
        if(component.get("v.selectedFilterType")!="openCampaign"){
        	helper.initializeDefaultValues(component);                     
            $A.util.removeClass(component.find(component.get("v.selectedFilterType")),'campaign');              
            component.set("v.selectedSortType","trendingIdea");
            helper.filterIdeasListOnLoad(component,component.get("v.trendingIdeasList"),"openCampaign");  
        	component.set("v.showspinner",false);            
        }
    },
    displayClosedCampaigns : function(component, event, helper) {     
        $("#sortOptions").toggle();         
        if(component.get("v.selectedFilterType")!="closedCampaign"){		       
        	helper.initializeDefaultValues(component);    
            
        	$A.util.removeClass(component.find(component.get("v.selectedFilterType")),'campaign'); 
            helper.checkSelectedSort(component,"v.closedIdeasList","mostVotedIdea","closedCampaign");  
        	component.set("v.showspinner",false);
        }    
    },
    displayMyIdeas : function(component, event, helper) {   
        $("#sortOptions").toggle();          	 	
        if(component.get("v.selectedFilterType")!="myIdeas"){
            helper.initializeDefaultValues(component);  
            if(component.get("v.getMyUpdateList")==false){		           
                var action = component.get("c.getMyUpdatesList");
                action.setParams({
                    "myUpdatesLimit": "All"
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {       
                        component.set("v.myUpdatesList",response.getReturnValue().IdeasOfTheWeek); 
                        helper.checkSelectedSort(component,"v.myUpdatesList","latestIdea","myIdeas");  
                        /*if(response.getReturnValue().IdeasOfTheWeek.length>0){                           
                        	helper.checkSelectedSort(component,"v.myUpdatesList","latestIdea","myIdeas");  
                        } else {                  
                        	helper.setDefaultSortFilter(component,"latestIdea","myIdeas");         
                            component.set("v.displayErrorMessage",true);
                        } */
                        component.set("v.getMyUpdateList",true);
                        component.set("v.showspinner",false); 	                                   
                    } else {
                        component.set("v.showspinner",false);
                    }  
                });
                $A.enqueueAction(action);
            } else {               
                if(component.get("v.myUpdatesList")==null){
                    component.set("v.displayErrorMessage",true);
                } else {
                	helper.checkSelectedSort(component,"v.myUpdatesList","latestIdea","myIdeas");
                }
                helper.setDefaultSortFilter(component,"latestIdea","myIdeas");
				component.set("v.showspinner",false);                 
            }               
        	$A.util.removeClass(component.find(component.get("v.selectedFilterType")),'campaign'); 
        }
    },
    updateCommentCount : function(component, event, helper) {        
        var ideaListType;
        if(event.getParam("selectedSortType") == "trendingIdea"){
            ideaListType = "v.activeIdeasList";
        } else {
            ideaListType = "v.trendingIdeasList";
        }
        var ideaList = component.get(ideaListType);
        for(var count=0;count<ideaList.length;count++){
            if(ideaList[count].IdeaId==event.getParam("recordId")){
                ideaList[count].VoteCount = event.getParam("recordCommentCount");
                ideaList[count].Voted = "True";
            }
        }
        component.set(ideaListType,ideaList);        
    },
    
    displayLatest : function(component, event, helper) {
        if(component.get("v.selectedSortType")!="latestIdea"){	            
        	component.set("v.displayErrorMessage",false);
        	$("#filterOptions").toggle();
        	$A.util.removeClass(component.find(component.get("v.selectedSortType")),'campaign');   
            helper.checkSelectedFilter(component,"latestIdea");
        }    
        component.set("v.showSort",false); 
    },
    displayMostVoted : function(component, event, helper) {
        if(component.get("v.selectedSortType")!="mostVotedIdea"){	
        	component.set("v.displayErrorMessage",false);	           
        	$("#filterOptions").toggle();
        	$A.util.removeClass(component.find(component.get("v.selectedSortType")),'campaign');    
            helper.checkSelectedFilter(component,"mostVotedIdea");
        }    
        component.set("v.showSort",false); 
    },
    displayMostCommented : function(component, event, helper) {
        if(component.get("v.selectedSortType")!="mostCommentedIdea"){	            
        	component.set("v.displayErrorMessage",false);	           
        	$("#filterOptions").toggle();
        	$A.util.removeClass(component.find(component.get("v.selectedSortType")),'campaign');   
            helper.checkSelectedFilter(component,"mostCommentedIdea"); 
        }    
        component.set("v.showSort",false); 
    },
    displayTrending : function(component, event, helper) {
        if(component.get("v.selectedSortType")!="trendingIdea"){	            
        	component.set("v.displayErrorMessage",false);	           
        	$("#filterOptions").toggle();
        	$A.util.removeClass(component.find(component.get("v.selectedSortType")),'campaign');  
            component.set("v.selectedSortType","trendingIdea");
        	helper.filterIdeasListOnLoad(component,component.get("v.trendingIdeasList"),"openCampaign"); 
        }    
        component.set("v.showSort",false); 
    },
    navigateToFaq : function(component, event, helper) { 
        var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaFaqs","pannelType":component.get("v.pannelType")}).fire();
    },
    navigateToFeedback: function(component, event, helper) { 
        var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaTemplate","Pagename":"CORE_FB_Feedback","pannelType":component.get("v.pannelType"),"componentName":"IdeaHome"}).fire();
    },
    gotoSubmitIdea : function(component, event, helper) { 
        var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_SubmitIdea","pannelType":component.get("v.pannelType")}).fire(); 
    },
    navigateToCampaignsDetail : function(component, event, helper) { 
    	var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_CampaignDetail","recordType":"Campaign","recordDetail":component.get("v.recordDetail.FeaturedCampaigns"),"pannelType":component.get("v.pannelType")}).fire(); 
	},    
})