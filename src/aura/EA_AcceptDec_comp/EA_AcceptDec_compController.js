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
        
        var action=component.get("c.getUserDetail"); 
        action.setCallback(this, function(response) {
                var state = response.getState();
               if (state === "SUCCESS" && response.getReturnValue()!=='') {
                        var items=response.getReturnValue();
                     component.set("v.userDetail", response.getReturnValue());
                        if(items[0].badgeprogress_color == 'newbee' ){
                            component.set("v.shownewbee1",true);
                             component.set("v.NewBee_badge",true);  
                        }
                       else  if(items[0].badgeprogress_color == 'newbee1' ){
                            component.set("v.shownewbee2",true);
                            component.set("v.NewBee_badge",true); 
                        }
                     else  if(items[0].badgeprogress_color == 'bronz1' ){
                        component.set("v.showbronz1",true);
                        component.set("v.Bronze_badge",true); 
                        }
                       else  if(items[0].badgeprogress_color == 'bronz2' ){
                            component.set("v.showbronz2",true);  
                             component.set("v.Bronze_badge",true); 
                        }
                         else if(items[0].badgeprogress_color == 'silver1'){
                             component.set("v.showsilver1",true); 
                             component.set("v.Silver_badge",true);                        
                        }
                       else  if(items[0].badgeprogress_color == 'silver2' ){
                           
                            component.set("v.showsilver2",true);
                           
                            component.set("v.shownewbee2",false);
                            component.set("v.showbronz2",false); 
                           component.set("v.Silver_badge",true); 
                        }
                           else  if(items[0].badgeprogress_color == 'gold'){
                               
                               component.set("v.showgold",true);
                               component.set("v.Gold_badge",true); 
                                }
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