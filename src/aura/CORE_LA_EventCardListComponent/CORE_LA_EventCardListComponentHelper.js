({
    getEventDetailsHelper : function(component, event, helper) {
        var action = component.get("c.retriveAllEvents");
        action.setParams({ filterType :component.get("v.filterType") ,
                          sortType :component.get("v.sortType"),
                          limitRecords:component.get("v.limitRecords") ,
                          offsetValue: component.get("v.offsetValue"),
                          trainerId:null});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("Response Object: "+JSON.stringify(response.getReturnValue()));
                component.set("v.eventList",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
})