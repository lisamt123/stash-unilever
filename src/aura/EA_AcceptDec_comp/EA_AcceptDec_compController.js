({ 	
	getactivities2 : function(component, event, helper) { 
         var aid=component.get("v.activityId");
         var teamid=component.get("v.teamid");
         var action=component.get("c.getuserimage");
         action.setParams({"activityId":aid, "teamid":teamid});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()!==''){
                    var items=response.getReturnValue();
                    var participant_rating = items[0].participant_rating;
                    component.set("v.activityid",items[0].Id);
                    component.set("v.activity", response.getReturnValue());
                }
                    var numbers = [];
                    for (var i = 0; i < participant_rating; i++) {
                    numbers.push({
                    value: i
                  });
                }
                      var remain = [];
                      for (var i = 0; i < 5-participant_rating; i++) {
                      remain.push({
                      value: i
                     });
                   }
                      component.set("v.numbers", numbers); 
                      component.set("v.remain", remain);
                            }
                        });
                        $A.enqueueAction(action);
                    },
    Acceptmethod1: function(component, event, helper) {
          var aid=component.get("v.activityId");
          var teamid=component.get("v.teamid");
          var action=component.get("c.inviteResponseNofitification");
          action.setParams({"teamid" :teamid,"activityId":aid,responseText:'Accepted'});
           action.setCallback(this,function(response){
                if (response.getState() === "SUCCESS"){
                     var detailpageEvent=$A.get("e.c:EA_Decline");
                    detailpageEvent.setParams({"showmyactions":true});
                   detailpageEvent.fire();
         component.set("v.showInvitation", false);
                    }
                  });
        $A.enqueueAction(action);
      },
    declinemethod1: function(component, event, helper) {
          var aid=component.get("v.activityId");
          var teamid=component.get("v.teamid");
          var action=component.get("c.inviteResponseNofitification");
          action.setParams({"teamid":teamid,"activityId":aid,responseText:'Declined'});
          action.setCallback(this,function(response){
                if (response.getState() === "SUCCESS"){
                var detailpageEvent=$A.get("e.c:EA_Decline");
                    detailpageEvent.setParams({"showmyactions":true});
                   detailpageEvent.fire();
         component.set("v.showInvitation", false);
                }
        });
        $A.enqueueAction(action);
   },
     redirect:function(component, event, helper) {       
             var detailpageEvent=$A.get("e.c:EA_Decline");
             detailpageEvent.setParams({"showmyactions":true});
             detailpageEvent.fire();
             component.set("v.showInvitation", false);
         },
            showdetail : function(cmp,event,helper){
            var id=event.getParam("activityId");
            cmp.set("v.EAactivityid",id);
         },
    })