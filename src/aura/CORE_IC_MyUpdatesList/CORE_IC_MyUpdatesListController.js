({ 
	getMyUpdatesData : function(component, event, helper) {
     var action = component.get("c.getMyUpdatesList");
      action.setParams({
            "myUpdatesLimit": "5"
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {    
                if(response.getReturnValue().MyUpdates.length>0){
                    component.set("v.myUpdatesList",response.getReturnValue().MyUpdates);
                    component.set("v.UpdateTitle","My Updates");
                    component.set("v.showspinner",false);
             }  	 
	          else {
              	 component.set("v.displayErrorMessage",true);
                } 	 component.set("v.showspinner",false);
	       }      	                   
        });
        $A.enqueueAction(action);
    },
    navigateToFaq: function(component, event, helper) { 
        var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaFaqs","pannelType":component.get("v.pannelType")}).fire();
    }
   
})