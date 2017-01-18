({    
    getFaqListData : function(component, event, helper) {
		console.log('------------entry----------------');
        var action = component.get("c.getFaqList");
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {       
                component.set("v.faqList",response.getReturnValue().FAQ);
                var faqList = response.getReturnValue();
                console.log('------------entry------1----------'+faqList);
                console.log('------------entry------2----------'+faqList.FAQ);
                console.log('------------entry------3----------'+faqList.FAQ);
                console.log('------------entry------4----------');
            }   
              component.set("v.showspinner","false"); 
        });
        $A.enqueueAction(action);
	},
     navigateToIdeaHome : function(component, event, helper) {
    	var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaTemplate","pannelType":component.get("v.pannelType")}).fire();
    },
})