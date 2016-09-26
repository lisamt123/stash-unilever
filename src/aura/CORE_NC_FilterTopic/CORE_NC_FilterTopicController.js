({
	sendSelectedTopic : function(component, event, helper) {
        var selectEvent = $A.get("e.c:CORE_NC_FilterTopicEvent");
        selectEvent.setParams({"selectedTopic": component.get("v.topicName")}).fire();
	}
})