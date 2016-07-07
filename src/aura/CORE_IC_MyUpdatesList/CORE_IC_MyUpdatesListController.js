({ 
	getMyUpdatesData : function(component, event, helper) {        
        //component.set("v.displayIdeasFlag",false);   
        //component.set("v.showspinner",false);
        //component.set("v.displayErrorMessage",true);
        component.set("v.showspinner",true);
        component.set("v.displayIdeasFlag",true);   
        console.log('-----------my update Entry-----------');
        var action = component.get("c.getMyUpdatesList");
        action.setParams({
            "myUpdatesLimit": "5"
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
        	console.log('-----------my update Flag-----------'+state);
            if (state === "SUCCESS") {    
                 component.set("v.myUpdatesData",response.getReturnValue());
                if(response.getReturnValue().MyUpdates.length>0){
                    component.set("v.myUpdatesList",response.getReturnValue().MyUpdates);
                    component.set("v.UpdateTitle","My Updates");
                    component.set("v.showspinner",false);
             	} else {
              	 	component.set("v.displayErrorMessage",true);
              	 	component.set("v.displayIdeasFlag",false);                  
                } 	
                component.set("v.showspinner",false);
        		console.log('-----------my update Data-----------'+component.get("v.myUpdatesList"));
            } else {
                component.set("v.displayIdeasFlag",false);   
                component.set("v.showspinner",false);
            }     	                   
        });
        $A.enqueueAction(action);
    },
    navigateToFaq: function(component, event, helper) { 
        var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaFaqs","pannelType":component.get("v.pannelType")}).fire();
    },
    navigateToFeedback: function(component, event, helper) { 
        var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaTemplate","Pagename":"CORE_FB_Feedback","pannelType":component.get("v.pannelType"),"componentName":"IdeaHome"}).fire();
    },
   
})