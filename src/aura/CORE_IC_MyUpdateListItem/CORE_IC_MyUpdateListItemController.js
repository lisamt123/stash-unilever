({
	getUpdatesIdeaDetailData: function(component, event, helper) {
         console.log('----------------IdeaUpdateDetail--'+component.get("v.myUpdatesListItem").IdeaId);
        var selectedIdeaId=component.get("v.myUpdatesListItem.IdeaId");
	    var action = component.get("c.getIdeaDetail");
        action.setParams({
			"ideaId": selectedIdeaId
		});
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {
                if(response.getReturnValue()!==''){
                   
                  component.set("v.myUpdatesListItem2",response.getReturnValue().IdeaDetails); 
                      //console.log('----------------IdeaUpdateDetail--'+component.get("v.myUpdatesListItem").IdeaId);
                }
               
                   component.set("v.showspinner","false");   
        	}
        });
        $A.enqueueAction(action);
    
    },
    
    
    gotoIdeaDetailPage: function(component, event, helper) { 
      var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
   selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaDetail","recordType":"Idea","recordDetail":component.get("v.myUpdatesListItem2"),"pannelType":component.get("v.pannelType")}).fire();  
       
    },
})