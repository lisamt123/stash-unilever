({
	gotoIdeaDetail : function(component, event, helper) {
        console.log('---------go detail------');
        var selectEvent = $A.get("e.c:CORE_IC_IdeaTemplateEvent");
        selectEvent.setParams({"componentName":"markup://c:CORE_IC_IdeaDetail","recordType":"Idea","recordDetail":component.get("v.leader"),"pannelType":component.get("v.pannelType")}).fire();
	}
})