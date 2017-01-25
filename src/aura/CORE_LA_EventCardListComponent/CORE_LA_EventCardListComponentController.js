({
	doInit : function(component, event, helper) {
        helper.getEventDetailsHelper(component,event, helper );
    },
    showMoreEvents: function(component, event, helper) {
        var offsetvalueShowMore= component.get("v.offsetValue")+component.get("v.limitRecords");
        component.set("v.offsetValue",offsetvalueShowMore);
        var action = component.get("c.retriveAllEvents");
        action.setParams({ filterType :component.get("v.filterType") ,
                          sortType :component.get("v.sortType") ,
                          limitRecords:component.get("v.limitRecords") ,
                          offsetValue: component.get("v.offsetValue"),
                          trainerId:null});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("Response Object: "+JSON.stringify(response.getReturnValue()));
                var eventList=component.get("v.eventList");
                var upDatedEventList=response.getReturnValue();
                for (var evt in upDatedEventList) {
                    if (upDatedEventList.hasOwnProperty(evt)) {
                        var ob=upDatedEventList[evt]
                        var singleObj=[];
                        //singleObj.CORE_LA_EventWrapperClass.Event=ob
                        singleObj=ob;
                        eventList.push(singleObj);
                    }}
                component.set("v.eventList",eventList);
                console.log("Event List: "+eventList);
            }
        });
        $A.enqueueAction(action);
    },
})