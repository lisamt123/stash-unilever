({
    doInit : function(component, event, helper) {
        var pagename=component.get("v.pagename");
        console.log("todo"+pagename);
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
                    if(prop == rectype){
                        component.set("v.themecolor", actionColor[prop]);
                    }
                }
                helper.getToDoTimeline(component);
                helper.getPrticipantCount(component);
            }
        });
        $A.enqueueAction(action);  
    },
   
    skipToDoActivity : function(component, event, helper) {
       var pagename=component.get("v.pagename");
        console.log(pagename);
        var index=component.get("v.index");
      
            var actvity=component.get("v.activityId");
            var id=actvity.Id;
          
            var pagename=component.get("v.pagename");
            var index=component.get("v.index");
              console.log(pagename);
            var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
            detailpageEvent.setParams({"actvityid":actvity,"showcontent":true,"index":index,"pagename":pagename});
    	    detailpageEvent.fire();
        
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
             if (toDoActivityUser[i] == itemId) {
                 console.log("handleIdUpdate#User:"+ itemId +" already exist");
                 return;	 
             }
        }
        toDoActivityUser.push(itemId);
        
        cmp.set('v.selectedUsers', toDoActivityUser);
        console.log("handleIdUpdate#User:"+ toDoActivityUser);
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