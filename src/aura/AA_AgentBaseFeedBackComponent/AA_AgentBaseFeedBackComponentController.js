({
    doInit : function(component, event, helper) {
        var action=component.get("c.findFeedbacks");
        action.setParams({"appName":component.get("v.agentApp")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
                var response=response.getReturnValue();
                if(response === true){
                    var destination = "c:CORE_FB_Feedback";
                    var contentFeedBack = component.find("content");
                    $A.createComponent(destination,
                                       {
                                           Appname:component.get("v.agentApp"),
                                           Pagename:component.get("v.Pagename"),
                                           EventName:"AA_Feedback_Evt",
                                           showTranslation:true},
                                       function(cmp) {
                                           contentFeedBack.set("v.body", [cmp]);
                                       }); 
                }
                if(response === false ){
                    var cmpEvent = component.getEvent("LandingPageEventFeedBack");
                    cmpEvent.setParams({
                        showLandingPage:true});
                    cmpEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
    },
    gotoApp :function(component, event, helper){
        var cmpEvent = component.getEvent("LandingPageEventFeedBack");
        cmpEvent.setParams({
            showLandingPage:true});
        cmpEvent.fire();
    }
})