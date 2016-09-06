({
   //On page load display article name and share links informations of the news article along with that get group names list
   init : function(component, event, helper) {
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
       
   		var newsArticle = component.get("v.NewsDetail");
        var NewsType=component.get("v.NewsType");
        component.set("v.LinkName", newsArticle.Name);
     	component.set("v.LinkURL", newsArticle.SharepointURL);
        component.set("v.SelectedRadioButton", "myFollowers");
            
        if(NewsType=="PaulsBlog"){
        	component.set("v.LinkPost", "Pauls Blog that may interest you:");
        } else {
            component.set("v.LinkPost", "News article that may interest you:");
        }
        
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
    //got to news article detail page
   BackButton:function(component, event, helper) {
        var newsArticle = component.get("v.NewsDetail");
        var NewsType=component.get("v.NewsType");
        var selectEvent = $A.get("e.c:Core_ShareCancelButton");
        selectEvent.setParams({"NewsId": newsArticle.NewsId,"NewsType": NewsType }).fire();
   },
    //submit the chatter share detail of the news article
   submitShare:function(component, event, helper) {
       var Selected=component.get("v.SelectedRadioButton");
       var newsArticle = component.get("v.NewsDetail");
       var NewsType=component.get("v.NewsType");
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
        			var selectEvent = $A.get("e.c:Core_ShareCancelButton");
        			selectEvent.setParams({"NewsId": newsArticle.NewsId,"NewsType": NewsType }).fire();
                }
                else {
                    component.set("v.ErrorMessageFlag", true);
                }
        	}
            else {
                component.set("v.ErrorMessageFlag", true);
            }
        });
       
       component.set("v.UserGroupFlag",false);
       if(Selected=="group" && slectedGroupNameList==''){
            component.set("v.UserGroupFlag",true);
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
    }
})