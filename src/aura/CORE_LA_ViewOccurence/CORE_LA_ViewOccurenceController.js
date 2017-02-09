({
        occurenceDetailPage: function(component, event, helper) {
            var EventId = component.get("v.event");
            var action = component.get("c.getOccurenceList");
            action.setParams({
                "eventId":EventId.eventId
            });
            action.setCallback(this, function(response) {
                
                var state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue() !== '') {
                    var occurenceList=component.get("v.occurences");
                    var newOccurenceList=response.getReturnValue();
                    for (var atnd in newOccurenceList) {
                        if (newOccurenceList.hasOwnProperty(atnd)) {
                            var ob=newOccurenceList[atnd]
                            var singleObj=[];
                            singleObj=ob;
                            occurenceList.push(singleObj);
                        }}
                    component.set("v.occurences", occurenceList);          
                }
            });
            $A.enqueueAction(action);
            var EventId = component.get("v.event");
            var actionEventDetail = component.get("c.getEventDetail");
            
            actionEventDetail.setParams({
                "eventId": EventId.eventId
            });
            actionEventDetail.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue() !== '') {
                    
                    component.set("v.event", response.getReturnValue()[0]);
                    
                }
                
            });
            $A.enqueueAction(actionEventDetail);
            
            var EventId = component.get("v.event");
            var actionPast = component.get("c.getPastOccurenceList");
            actionPast.setParams({
                "eventId":EventId.eventId
            });
            actionPast.setCallback(this, function(response) {
                
                var state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue() !== '') {
                    var occurencePastList=component.get("v.occurencesPast");
                    var newOccurencePastList=response.getReturnValue();
                    for (var atnd in newOccurencePastList) {
                        if (newOccurencePastList.hasOwnProperty(atnd)) {
                            var ob=newOccurencePastList[atnd]
                            var singleObj=[];
                            singleObj=ob;
                            occurencePastList.push(singleObj);
                        }}
                    component.set("v.occurencesPast", occurencePastList);          
                }
            });
            $A.enqueueAction(actionPast);
        },
       
        //Back Button
        gotoPreviousPage: function(component, event, helper) {
            var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
            selectEvent.setParams({"componentName":"c:CORE_LA_UpcomingDetail","event":component.get("v.event")}).fire();
            
        },
        //go to occurence detail page
        goToOccurenceDetail: function(component,event,helper){
            var occurenceId=event.currentTarget.dataset.record;
            // console.log('eventid'+ component.get("v.event").eventId);
            var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
            selectEvent.setParams({"componentName":"c:CORE_LA_OccurenceDetail","occurenceId":occurenceId ,"event":component.get("v.event")}).fire();
        },
        
        
    })