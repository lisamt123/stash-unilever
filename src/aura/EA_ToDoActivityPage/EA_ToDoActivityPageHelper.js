({
	getRecentItem : function(cmp){
       var action = cmp.get("c.getRecentlyWorkedWithUsers");
        console.log("Before calling action");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                console.log("Success");
                if(response.getReturnValue()!=''){
            		var items = response.getReturnValue();
                    console.log("Items"+items);
                    cmp.set('v.recentItem',items);
                }
            }
        });
          $A.enqueueAction(action);
    },
    getToDoTimeline : function (cmp){
        console.log("test");
      var action = cmp.get("c.getToDoTimeline");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                console.log("Success");
                if(response.getReturnValue()!=''){
            		var items = response.getReturnValue();
                    console.log("Items"+items);
                    cmp.set('v.todoTime',items);
                     console.log(cmp.get('v.todoTime'));
                   
                }
            }
        });
          $A.enqueueAction(action);
    },
    callToDoSubmitAction : function (cmp,event){
        var actTimeField = cmp.find('activityTime').getElement();
        var selUserCmp = $A.util.json.encode(cmp.get("v.selectedUsers"));
        var act = cmp.get("v.activity");
        var action = cmp.get("c.callSubmitToDoAction");
        action.setParams({"activityId" : act[0].Id,"json" : selUserCmp,"activityTime":actTimeField.value});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                if(response.getReturnValue() != ''){
                    console.log("callToDoSubmitAction Success");
                    cmp.set("v.detailpage",true);
                    var act = cmp.get("v.activity");
                    var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
                    detailpageEvent.setParams({"actvityid":act[0].Id});
                    detailpageEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
	},
    getPrticipantCount : function(cmp){
        var act = cmp.get("v.activity");
  		var action = cmp.get("c.getActivityParticipantCount");
        action.setParams({"Activityid" : act[0].Id});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                if(response.getReturnValue() != ''){
                    console.log("getParticipantCount Success"+response.getReturnValue());
                    cmp.set("v.participantCount",response.getReturnValue());
                }
            }
        });
        $A.enqueueAction(action);      
        
    }
    
    
})