({
   //On page load display article name and share links informations of the news article along with that get group names list
   doInit : function(component, event, helper) {
       console.log('------------Share Component Load----------');
       var action = component.get("c.getGroupNames");
       var autoCompleteSection = component.find("autoCompleteDiv");
       $A.util.addClass(autoCompleteSection, "autoCompleteDivHide");            
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state == "SUCCESS") {
                if(response.getReturnValue()!=''){        			
                    component.set("v.groupNameList", response.getReturnValue());                    
                    console.log('------------onLoad-Entry----------');
                    $(function () {
                        var listGroup = response.getReturnValue();
						var arrayGroup = listGroup.split(',');
                        console.log('------------onLoad-----------'+arrayGroup);
                        $( "#groupNames" ).autocomplete({
                            source: arrayGroup
                        });
                     });
                }
                else {
                    component.set("v.ErrorMessageFlag", true);
                }
        	}                    
        });
        $A.enqueueAction(action);
       
   		var recordDetail = component.get("v.recordDetail");
        if(component.get("v.recordType")=="Campaign"){
     		component.set("v.LinkURL", window.location.origin+"/apex/CORE_IC_NavigateToApp?articleId="+recordDetail.IdeaThemeId+"&articleType="+component.get("v.recordType"));           
        	component.set("v.LinkName", recordDetail.CampaignTitle);
        	component.set("v.LinkPost", "Share ideas for Campaign" );
        } else {
     		component.set("v.LinkURL", window.location.origin+"/apex/CORE_IC_NavigateToApp?articleId="+recordDetail.IdeaId+"&articleType="+component.get("v.recordType"));                    	
        	component.set("v.LinkName", recordDetail.IdeaTitle);
        	component.set("v.LinkPost", "Vote for the Idea" );
        }
        component.set("v.displayLinkURL",window.location.origin+"/apex/CORE_IC_NavigateToApp");
        component.set("v.SelectedRadioButton", "myFollowers"); 
        
   }, 
    //in auto complete section on each key up get the matching key group names
   getGroupName : function(component, event, helper) {   
        $(function () { 
            var groupNameAutoText= document.getElementById('groupNames').value;
            var groupNameList=[];
            var listGroup=component.get("v.groupNameList");
			var arrayGroup = listGroup.split(',');
            for(var index=0;index<arrayGroup.length;index++){
                if((arrayGroup[index].substring(0,groupNameAutoText.length)).toLowerCase() == groupNameAutoText.toLowerCase()){
                     groupNameList.push(arrayGroup[index]);
                }
            }               
            console.log('------------onKeyUp-----------'+groupNameList);
            $("#groupNames").autocomplete({
                 source: groupNameList
            });
        });
   }, 
    //add selectd group name to the selected group name list
   addGroupName : function(component, event, helper) {  
    	component.set("v.ErrorMessageFlag", false);
        component.set("v.UserGroupFlag",false);
        var groupName= document.getElementById('groupNames').value;
        var listGroup=component.get("v.groupNameList");
        var arrayGroup = listGroup.split(',');
        var selectedGroupArray=[];
        if(component.get("v.selectedGroupName")!=''){
        	selectedGroupArray=component.get("v.selectedGroupName"); 
            if(arrayGroup.indexOf(groupName)!=-1 && selectedGroupArray.indexOf(groupName)==-1) {
            	selectedGroupArray.push(groupName);
            }
        } else {
            if(arrayGroup.indexOf(groupName)!=-1) {
            	selectedGroupArray.push(groupName);  
            }          
        }
        component.set("v.selectedGroupName",selectedGroupArray);
        console.log('-----------------------'+component.get("v.selectedGroupName"));
        document.getElementById('groupNames').value='';
        if(component.get("v.selectedGroupName")!='') {
            component.set("v.clearSelectedGroupFlag",true);
        }                     
    }, 
    //got to news previous page
   BackButton:function(component, event, helper) {
       console.log('--------chatter---------');
        var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaHome","pannelType":component.get("v.pannelType")}).fire();
   },
    //submit the chatter share detail of the news article
   submitShare:function(component, event, helper) {
       component.set("v.showspinner",true);
       var Selected=component.get("v.SelectedRadioButton");
       var GrpNames=component.get("v.selectedGroupName");
       var slectedGroupNameList='';
       if(Selected=="group" && component.get("v.selectedGroupName")!=''){
           var selectedGroupNameArray=component.get("v.selectedGroupName");
           for(var index=0;index<selectedGroupNameArray.length;index++){
                slectedGroupNameList+=selectedGroupNameArray[index]+',';
            }
       }
       var action = component.get("c.postNewsToChatter");
        action.setParams({
			"NewsTitle": component.get("v.LinkName"),
            "NewsLink": component.get("v.LinkURL"),
            "FeedBody": component.get("v.LinkPost"),
            "FeedTo": Selected,
            "GroupNames": slectedGroupNameList
		});
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {
                if(response.getReturnValue()!=false){
                    component.set("v.displaySucessNotification",true);
       				component.set("v.showspinner",false);
                }
                else {
                    component.set("v.ErrorMessageFlag", true);
       				component.set("v.showspinner",false);
                }
        	}
            else {
                component.set("v.ErrorMessageFlag", true);
                component.set("v.showspinner",false);
            }
        });
       
      // component.set("v.UserGroupFlag",false);
       if(Selected=="group" && slectedGroupNameList==''){
            component.set("v.UserGroupFlag",true);
           component.set("v.showspinner",false);
            
       } else {
       	    $A.enqueueAction(action);
       }
   },
    //hide the group name selector when user select the my follwers radio button
    myFollowers:function(component, event, helper) {
        component.set("v.SelectedRadioButton", "myFollowers");
    	component.set("v.ErrorMessageFlag", false);
        component.set("v.UserGroupFlag",false);
        var autoCompleteSection = component.find("autoCompleteDiv");
        $A.util.removeClass(autoCompleteSection, "autoCompleteDivDisplay");
        $A.util.addClass(autoCompleteSection, "autoCompleteDivHide");
    },
    //display the group names selector when user click the group name radio button
    group:function(component, event, helper) {
        component.set("v.SelectedRadioButton", "group");  
    	component.set("v.ErrorMessageFlag", false);    
        component.set("v.UserGroupFlag",false);  
        var autoCompleteSection = component.find("autoCompleteDiv");
        $A.util.removeClass(autoCompleteSection, "autoCompleteDivHide");
        $A.util.addClass(autoCompleteSection, "autoCompleteDivDisplay");
    },
    //clear selected group names list
    clearGroupNames :function(component, event, helper) {
        component.set("v.selectedGroupName",'')                      
        component.set("v.clearSelectedGroupFlag",false);
    },
    

})