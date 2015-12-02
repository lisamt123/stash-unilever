({
    doInit : function(component, event, helper) {
        component.get("v.selectedUsers",[]);
        var activityid=component.get("v.activityId");
        var action=component.get("c.getactivitydetail");
        action.setParams({"ActivityID":activityid});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()!=''){
                    var items = response.getReturnValue();
                    component.set("v.activity",items[0]);
                    
                    var rectype=component.get("v.themerecordtype");
                    var actionColor=component.get("v.themeColors");
                    for (var prop in actionColor) {
                        if(prop == rectype){
                            component.set("v.themecolor", actionColor[prop]);
                        }
                    }
                    helper.getToDoTimeline(component);
                }
            }
        });
        $A.enqueueAction(action);  
    },
   
    skipToDoActivity : function(component, event, helper) {
        var act = component.get("v.activity");
        var action = component.get("c.insertteamrecord");
        action.setParams({"ActivityID" : act[0].Id});
        action.setCallback(this,function(response){
            if (response.getState() === "SUCCESS"){
                component.set("v.detailpage",true);
                var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
                detailpageEvent.setParams({"actvityid":act[0].Id});
                detailpageEvent.fire();
            }
        } );
        $A.enqueueAction(action);  
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
                break;
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
        //helper.callToDoSubmitAction(cmp,actTimeField.value,selUserCmp);
        helper.callToDoSubmitAction(cmp,event);
    },
    onSelecteChange : function(cmp,event,helper){
        var selOpt = cmp.find('activityTime');
    	cmp.set('v.activityTimeToComplete',selOpt.get('v.value'));
        console.log("onchage:"+ selOpt.get('v.value'));
    }
    
    
})