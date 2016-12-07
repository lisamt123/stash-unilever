({
    getToDoTimeline : function (cmp){
        var action = cmp.get("c.getToDoTimeline");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS' && response.getReturnValue() !==''){
                var items = response.getReturnValue();
                cmp.set('v.todoTime',items);
                
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
            if (state === "SUCCESS" && response.getReturnValue()!==''){
                var act = cmp.get("v.activity");
                var pagename=cmp.get("v.pagename");
                var index=cmp.get("v.index");
                var pageIndex=cmp.get("v.pageIndex");
                if(pagename ==='swipe'){
                    var detailpageEvent=$A.get("e.c:EA_Back_Event");
                    detailpageEvent.setParams({"pagename":pagename,"index":index,"navigatePageIndex":pageIndex});
                    detailpageEvent.fire();
                }
                if(pagename ==='MyAction' || pagename ==='swipeDetailcard'){
                    var actvity=cmp.get("v.activityId");
                    var pagename=cmp.get("v.pagename");
                    var index=cmp.get("v.index");
                    var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
                    detailpageEvent.setParams({"actvityid":actvity,"showcontent":true,"index":index,"pagename":pagename});
                    detailpageEvent.fire();
                };
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
            if (state === "SUCCESS" && response.getReturnValue()!==''){
                cmp.set("v.participantCount",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})