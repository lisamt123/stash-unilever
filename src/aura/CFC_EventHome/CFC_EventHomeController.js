({
	eventDemoPageLoad : function(component, event, helper) {
        var destination = "markup://c:CFC_EventList"; 
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("eventDisplayPannel");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
                values: {
                    filterTopic: "showAll",
                    sortTopic: "ASC"
                }
            }
        }, component);
	},
    navigateWithinComponent: function(component, event, helper) {   
        if(event.getParam("componentName")=="Standard Page"){
            var urlEvent = $A.get("e.force:navigateToSObject");
            urlEvent.setParams({"recordId": event.getParam("eventId")});
            urlEvent.fire(); 
        } else if(event.getParam("componentName")=="Create New") {
            var createRecordEvent = $A.get("e.force:createRecord");
            createRecordEvent.setParams({
                "entityApiName": "CFC_Events__c",
                "recordTypeId": event.getParam("DefaultRecordTypeId")
            });
            createRecordEvent.fire();           
        } else { 
            helper.scrollToLocation(component, "top");
            var destination = "markup://c:"+event.getParam("componentName"); 
            $A.componentService.newComponentAsync(this, function(view) {
                var content = component.find("eventDisplayPannel");
                content.set("v.body", view);
            }, {
                componentDef: destination,
                attributes: {
                    values: {
                        filterTopic: event.getParam("filterType"),
                        sortTopic: event.getParam("sortType")
                    }
                }
            }, component);
        }
	}
})