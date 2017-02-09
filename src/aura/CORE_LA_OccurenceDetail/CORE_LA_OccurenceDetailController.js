({
    detailPageLoad: function(component, event, helper) {
      var occurenceDetailId=component.get("v.occurenceId");
        //alert(occurenceDetailId);
        var action = component.get("c.getEventDetail");
        action.setParams({
            "eventId": occurenceDetailId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue() !== '') {
                component.set("v.event", response.getReturnValue()[0]);
            }
        });
        $A.enqueueAction(action);
        var occurenceDetailId=component.get("v.occurenceId");
        var actionTrainerList = component.get("c.getTrainerWrapper");
        actionTrainerList.setParams({
            "eventId": occurenceDetailId
            
        });
        actionTrainerList.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.trainers", response.getReturnValue());
                
                
            }
        });
        $A.enqueueAction(actionTrainerList);
        var EventId = component.get("v.event");
            var agendaListValue = component.get("c.getAgendaList");
            agendaListValue.setParams({
                "eventId":EventId.eventId
            });
            agendaListValue.setCallback(this, function(response) {
                
                var state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue() !== '') {
                    var agendaListData=component.get("v.agendaList");
                    var newAgendaListData=response.getReturnValue();
                    for (var atnd in newAgendaListData) {
                        if (newAgendaListData.hasOwnProperty(atnd)) {
                            var ob=newAgendaListData[atnd]
                            var singleObj=[];
                            singleObj=ob;
                            agendaListData.push(singleObj);
                        }}
                    component.set("v.agendaList", agendaListData);          
                }
            });
            $A.enqueueAction(agendaListValue);
        var defaultTab = component.find('tab-feed');
        $A.util.addClass(defaultTab, 'slds-active')
        var defaultDivDisplay = component.find('feedContent');
        $A.util.addClass(defaultDivDisplay, 'slds-show');
    },
    
    
    gotoShare: function(component, event, helper) {
        /*
       var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_share"}).fire();
        */
        component.set("v.isSharePopup", true);
    },
    gotoHomePage: function(component, event, helper) {
        var occurenceDetailId=component.get("v.occurenceId");
        var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_ViewOccurence","event":component.get("v.event")}).fire();
        // selectEvent.setParams({
        //  "componentName": "c:CORE_LA_ViewOccurence"
        // }).fire();
    },
    gotoRegistraion: function(component, event, helper) {
        /*
        var selectEvent= $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_Registration"}).fire();
        */
        component.set("v.isRegistrationPopup", true);
        
    },
    navigateTrainerDetails: function(component, event, helper) {
        var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({
            "componentName": "c:CORE_LA_TrainerProfile",
            "event": component.get("v.event")
        }).fire();
        
    },
    feedDisplay: function(component, event, helper) {
        var defaultTarget = component.find('tab-upcoming');
        $A.util.removeClass(defaultTarget, 'slds-active');
        var defaultProfiletab = component.find('tab-profile');
        $A.util.addClass(defaultProfiletab, 'slds-active');
        var removeTarget1 = component.find('upcomingTabContent');
        $A.util.removeClass(removeTarget1, 'slds-show');
        var cmpTarget = component.find('feedContent');
        $A.util.addClass(cmpTarget, 'slds-show');
        
    },
    
    upcomingEventDisplay: function(component, event, helper) {
        var occurenceDetailId=component.get("v.occurenceId");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": occurenceDetailId,
            "slideDevName": "related"
        });
        navEvt.fire();
    },
    prerequisiteDiv: function(component, event, helper) {
        var toggleText = component.find("text");
        component.set("v.prerequisiteDiv", true);
        $A.util.toggleClass(toggleText, "slds-hide");
        var img = component.find("myimg1");
        $A.util.toggleClass(img, "slds-hide");
        var img2 = component.find("myimg2");
        $A.util.toggleClass(img2, "slds-show");
    },
    
    agendaDiv: function(component, event, helper) {
        var toggleText = component.find("text2");
        component.set("v.agendaDiv", true);
        $A.util.toggleClass(toggleText, "slds-hide");
        var img = component.find("myimg5");
        $A.util.toggleClass(img, "slds-hide");
        var img2 = component.find("myimg6");
        $A.util.toggleClass(img2, "slds-show");
    },
    facilitiesDiv: function(component, event, helper) {
        var toggleText = component.find("text3");
        component.set("v.facilitiesDiv", true);
        $A.util.toggleClass(toggleText, "slds-hide");
        var img = component.find("myimg7");
        $A.util.toggleClass(img, "slds-hide");
        var img2 = component.find("myimg8");
        $A.util.toggleClass(img2, "slds-show");
    },
    floorPlanDiv: function(component, event, helper) {
        var toggleText = component.find("text4");
        component.set("v.floorPlanDiv", true);
        $A.util.toggleClass(toggleText, "slds-hide");
        var img = component.find("myimg9");
        $A.util.toggleClass(img, "slds-hide");
        var img2 = component.find("myimg10");
        $A.util.toggleClass(img2, "slds-show");
    },
    getOccurenceDetail : function(component, event, helper) {
        var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({
            "componentName": "c:CORE_LA_ViewOccurence",
            "event": component.get("v.event")
        }).fire();
    },
    Poll : function (component, event, helper) {
        var occurenceDetailId=component.get("v.occurenceId");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": occurenceDetailId,
            "slideDevName": "related"
        });
        navEvt.fire();
    },
    goToTrainerDetail : function(component, event, helper) { 
        var trainerId=event.currentTarget.dataset.record;
        var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_TrainerDetail","trainerId":trainerId,"previousPage": "eventDetailPage","trainers":component.get("v.trainers"),"event":component.get("v.event")}).fire();
    },
    goToTrainerExternalDetail : function(component, event, helper) { 
        var trainerEmail=event.currentTarget.dataset.record;
        var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        //lectEvent.setParams({"componentName":"c:CORE_LA_TrainerDetail","externalEmail":trainerEmail,"trainers":component.get("v.trainers"),"event":component.get("v.event")}).fire();
        selectEvent.setParams({"componentName":"c:CORE_LA_TrainerDetail","externalEmail":trainerEmail,"trainers":component.get("v.trainers"),"event":component.get("v.event")}).fire();
    },

})