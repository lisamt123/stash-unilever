({
    doInit : function(component, event, helper) {
        var ids=[];
        ids=component.get("v.booleanValue");
        for(var i=0;i<ids.length;i++)
        {
            
            if(ids[i] === component.get("v.activityId"))
            {
                component.set("v.check_image",true);
            }
        }
        var pagename=component.get("v.pagename");
        component.get("v.selectedUsers",[]);
        var activityid=component.get("v.activityId");
        var action=component.get("c.getactivitydetail");
        action.setParams({"ActivityID":activityid});
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
                var items = response.getReturnValue();
                component.set("v.activity",items[0]);
                component.set("v.maxLimit",items[0].Participants_Required__c);
                var rectype=component.get("v.themerecordtype");
                var actionColor=component.get("v.themeColors");
                for (var prop in actionColor) {
                    if(prop === rectype){
                        component.set("v.themecolor", actionColor[prop]);
                    }
                }
                helper.getToDoTimeline(component);
                helper.getPrticipantCount(component);
                var numbers = [];
                for (var i = 0; i < items[0].Rating__c; i++) {
                    numbers.push({
                        value: i
                    });
                }
                var remain = [];
                for (var i = 0; i < 5-items[0].Rating__c; i++) {
                    remain.push({
                        value: i
                    });
                }
                component.set("v.rating_value",items[0].Rating__c);
                component.set("v.numbers", numbers);
                component.set("v.remain", remain);
            }
        });
        $A.enqueueAction(action);
    },
    skipToDoActivity : function(component, event, helper) {
        var pagename=component.get("v.pagename");
        var index=component.get("v.index");
        var pageIndex = component.get("v.pageIndex");
        if(pagename ==='swipe')
        {
            var detailpageEvent=$A.get("e.c:EA_Back_Event");
            detailpageEvent.setParams({"pagename":pagename,"index":index,"navigatePageIndex":pageIndex});
            detailpageEvent.fire();
        }else{
            var actvity=component.get("v.activityId");
            var id=actvity.Id;
            var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
            detailpageEvent.setParams({"actvityid":actvity,"showcontent":true,"index":index,"pagename":pagename,"navigatePageIndex":pageIndex});
            detailpageEvent.fire();
        }
    }, 
    /**
     * Handler for receiving the updateLookupIdEvent event
     */
    handleIdUpdate : function(cmp, event, helper) {
        // Get the Id from the Event
        var itemId = event.getParam("sObjectId");
        // Set user list for to do activity
        var toDoActivityUser = cmp.get("v.selectedUsers");
        for (var i=0;i<toDoActivityUser.length;i++) {
            if (toDoActivityUser[i] === itemId) {
                console.log("handleIdUpdate#User:"+ itemId +" already exist");
                return;
            }
        }
        toDoActivityUser.push(itemId);
        cmp.set('v.selectedUsers', toDoActivityUser);
        // Set the Id bound to the View
        cmp.set('v.recordId', itemId);
    },
    /**
     * Handler for receiving the clearLookupIdEvent event
     */
    handleIdClear : function(cmp, event, helper) {
        // Clear the selected user bound to the View
        cmp.set('v.selectedUsers', null);
        cmp.set('v.recordId', null);
    },
    callSubmitToDoActivity: function(cmp, event, helper) {
        helper.callToDoSubmitAction(cmp,event);
    },
    onSelecteChange : function(cmp,event,helper){
        var selOpt = cmp.find('activityTime');
        cmp.set('v.activityTimeToComplete',selOpt.get('v.value'));
    }
})