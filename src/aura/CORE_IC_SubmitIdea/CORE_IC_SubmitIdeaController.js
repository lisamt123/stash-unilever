({
    submitIdea : function(component, event, helper) {
        component.set("v.showspinner",true);
        var options = document.getElementById('choice').getElementsByTagName('option');
        var selectedCategory  = [];
        for (var count=0; count<options.length; count++) {
            if (options[count].selected) {
                selectedCategory.push(options[count].value);
            }
        }        
        var campaignIndex = document.getElementById("select-01").selectedIndex;
        var selectedCampaignTitle=document.getElementsByTagName("option")[campaignIndex].value; 
        
        component.set("v.ideaTitle",document.getElementById('ideaTitleText').value);
        component.set("v.ideaDescription",document.getElementById('ideaDescriptionText').value);
        
        
        var campaignList = component.get("v.activeCampaignsList");
        var selectedCampaignId;
        for(var count=0, runExecution=true;count<campaignList.length && runExecution;count++){
            if(campaignList[count].CampaignTitle==selectedCampaignTitle){
                selectedCampaignId = campaignList[count].IdeaThemeId;   
                runExecution=false;             
            }
        }          
        
        if(selectedCampaignId!='' && selectedCampaignTitle!='' && component.get("v.ideaTitle")!='' && selectedCategory!='' && component.get("v.ideaDescription")!=''){            
            var fileInput = component.find("file").getElement();
    		var file = fileInput.files[0];             
			console.log('-------------0---------------'+file);
            if(file==undefined || file==''){  
                helper.submitIdea(component,selectedCampaignId,selectedCategory,'','');
            } else {
            	helper.submitIdeaHelper(component,selectedCampaignId,selectedCategory); 
            }            
        } else {
            component.set("v.showspinner",false);
            component.set("v.displayErrorMessage",true);            
        }
    },
    getCampaignDetail:function(component, event, helper) {
        var action = component.get("c.getCampaignList");        
        action.setParams({
			"campaignLimit": "All"
		});
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {    
                if(response.getReturnValue().FeaturedCampaigns!=null){
                    var campaignsList = response.getReturnValue().FeaturedCampaigns;                                 
                    var activeCampaignsArray = [];
                    var campaignNameArray = [];
                    var campaignCategoriesMap = [];        
                    var campaignCategoriesItem = {};
                    for(var count=0;count<campaignsList.length ;count++){
                        if(campaignsList[count].StatusType=="Active"){
                            campaignCategoriesItem = {};
                            campaignCategoriesItem["campaignName"]=campaignsList[count].CampaignTitle;
                            campaignCategoriesItem["campaignCategories"]=campaignsList[count].Categories;
                            campaignCategoriesMap.push(campaignCategoriesItem);                            
                            campaignNameArray.push(campaignsList[count].CampaignTitle);
                            activeCampaignsArray.push(campaignsList[count]);
                        }
                    }
                    console.log('-----------1------'+component.get("v.recordDetail"));
                    if(component.get("v.recordDetail")==null || component.get("v.recordDetail")==''){
                        for (var key in campaignCategoriesMap){
                            if(campaignCategoriesMap[key].campaignName==campaignNameArray[0]){
                                component.set("v.campaignCategoryList",campaignCategoriesMap[key].campaignCategories); 
                            }
                        }
                    } else {                         
                        for(var count=0;count<campaignCategoriesMap.length ;count++){
                            if(component.get("v.recordDetail").CampaignTitle==campaignCategoriesMap[count].campaignName){
                                component.set("v.campaignCategoryList",campaignCategoriesMap[count].campaignCategories);                                 
                            }
                        }
                        for(var count=0;count<campaignNameArray.length ;count++){
                            if(component.get("v.recordDetail").CampaignTitle==campaignNameArray[count]){
                                var temp = campaignNameArray[count];
                                campaignNameArray[count] = campaignNameArray[0];
                                campaignNameArray[0] = temp;
                            }
                        }
                    }
                    component.set("v.activeCampaignsList",activeCampaignsArray);
                    component.set("v.campaignNameList",campaignNameArray);
                    component.set("v.campaignNameMap",campaignCategoriesMap);                    
                }
                component.set("v.showspinner",false);
            } else {
                component.set("v.showspinner",false);
            }     	                   
        });
        $A.enqueueAction(action);
    },
    //got to news article detail page
    cancelButton : function(component, event, helper) {
        var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaHome","pannelType":component.get("v.pannelType")}).fire();
    },
    changeCategoryList : function(component, event, helper) {
        component.set("v.displayErrorMessage",false);  
        var catergoryIndex = document.getElementById("select-01").selectedIndex;
        var selectedCampaign=document.getElementsByTagName("option")[catergoryIndex].value; 
        var campaignCategoriesMap = component.get("v.campaignNameMap");
        for (var key in campaignCategoriesMap){
            if(campaignCategoriesMap[key].campaignName==selectedCampaign){
                component.set("v.campaignCategoryList",campaignCategoriesMap[key].campaignCategories); 
                return;
            }
        }
    },
    okayButton : function(component, event, helper) {
        var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_SubmitIdea","pannelType":component.get("v.pannelType")}).fire();
    } 
  
})