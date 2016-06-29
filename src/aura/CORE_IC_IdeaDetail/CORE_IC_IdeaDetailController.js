({
	getIdeaDetailData : function(component, event, helper) {
        console.log('-----------------idea detail--------------------');
        
         console.log('------------detail entry----------------'+component.get("v.parentRecordDetail"));
         component.set("v.commentPostSpinner","false"); 
        var selectedIdeaId;
        if(component.get("v.articleId")!=''){
            selectedIdeaId=component.get("v.articleId");
        } else {
            selectedIdeaId=component.get("v.recordDetail.IdeaId");
        }
	    var action = component.get("c.getIdeaDetail");
        action.setParams({
			"ideaId": selectedIdeaId
		});
        action.setCallback(this, function(response) {
        	var state = response.getState();  console.log('test1'+response.getState());
        	if (state === "SUCCESS" && response.getReturnValue()!=='') { 
              
               component.set("v.recordDetail",response.getReturnValue().IdeaDetails); 
               component.set("v.commentListItem",response.getReturnValue().IdeaComments);
               component.set("v.statusCampaign",response.getReturnValue().CampaignStatus);
                var count=  component.get("v.recordDetail.CommentCount");
                if(count===0){
                    component.set("v.commentCount","true"); 
                }
               component.set("v.showspinner","false"); 
        	}
        });
        $A.enqueueAction(action);    
     },    
     navigateToAllIdea : function(component, event, helper) {
         var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
         console.log('------------detail back----------------'+component.get("v.parentRecordDetail"));
         if(component.get("v.parentRecordDetail")!=undefined && component.get("v.parentRecordDetail")!=''){
        	selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeasList","Pagename":"campaignIdea","recordDetail":component.get("v.parentRecordDetail"),"pannelType":component.get("v.pannelType"),"displayCampaignIdea":true}).fire();
         } else {
       		 selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaTemplate","pannelType":component.get("v.pannelType")}).fire();
         }
     },
     
    submitComment :function(component, event, helper) {
          component.set("v.commentPostSpinner","true"); 
         var selectedIdeaId=component.get("v.recordDetail.IdeaId");
		 var comments = component.find("comments").get("v.value");
          if(comments){
            
             var action= component.get("c.postCommentAnIdea");
		     action.setParams({
			"ideaId": selectedIdeaId,
			"commentBody": comments
		   });
               action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS" && response.getReturnValue()!=='') {
                  component.set("v.commentListItem",response.getReturnValue().IdeaComments); 
                  component.set("v.commentCount","false");  
                  component.find("comments").set("v.value", "") ;
                   component.set("v.commentPostSpinner","false"); 
                 component.set("v.commentTextcheck","false"); 
                }
        	
        });
             $A.enqueueAction(action);
            
           }
        else {
             component.set("v.commentTextcheck","true"); 
             component.set("v.commentPostSpinner","false"); 
        }
	   
             var action2 = component.get("c.getIdeaDetail");
             action2.setParams({
			"ideaId": selectedIdeaId
		 });
               action2.setCallback(this, function(response) {
        	   var state = response.getState();
        	   if (state === "SUCCESS" && response.getReturnValue()!=='') {
                  component.set("v.recordDetail.CommentCount",response.getReturnValue().IdeaDetails.CommentCount);
        	}
        });
               $A.enqueueAction(action2);  
    },
    
     showIdeaVoted : function(component, event, helper) {  
         var IdeaIdList=component.get("v.recordDetail").IdeaId;
         var action = component.get("c.postVoteForIdea");
        action.setParams({
			"ideaId": IdeaIdList
		});
            action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS"  && response.getReturnValue()!=='') {
                   component.set("v.recordDetail.VoteCount",response.getReturnValue().VoteCount); 
                   component.set("v.recordDetail.Voted","True"); 
        	}
        });
        $A.enqueueAction(action);
       
    },
    
    navigateToFaq: function(component, event, helper) { 
        var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaFaqs","pannelType":component.get("v.pannelType")}).fire();
    },
    
    
     hideIdeaChatterShare : function(component, event, helper) {
        component.set("v.shareIdea",false);       
    },
    
    ideaShare : function(component, event, helper) {   	
         var subject=$A.get("$Label.c.CORE_IC_IdeaSubject");
         var label1=$A.get("$Label.c.CORE_IC_IdeaBody");
         var label2=$A.get("$Label.c.CORE_IC_IdeaSubBody");
         var label3=encodeURIComponent(window.location.origin+"/apex/CORE_IC_NavigateToApp?articleId="+component.get("v.recordDetail").IdeaId+"&articleType=Idea");
         component.set("v.MailSubjectIdea",subject);
         component.set("v.MailToBody3",label1);
         component.set("v.MailToBody4",label2);
         component.set("v.MailToBody5",label3);
         var toggleView = component.find("showideaOptions");
         component.set("v.shareIdea",true);
         $A.util.toggleClass(toggleView, "slds-hide");
   
	},
    navigateToChatter : function(component, event, helper) {
    	var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_ChatterShare","recordType":"Idea","recordDetail":component.get("v.recordDetail"),"pannelType":component.get("v.pannelType")}).fire();
    },
     navigateToFeedback: function(component, event, helper) { 
        var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaTemplate","Pagename":"CORE_FB_Feedback","pannelType":component.get("v.pannelType"),"componentName":"IdeaHome"}).fire();
    },
    
})