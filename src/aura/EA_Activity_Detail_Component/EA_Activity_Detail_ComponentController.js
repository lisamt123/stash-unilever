({
    getThemeColor : function(component, event, helper){
        var action =component.get("c.getThemeColor");
        action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue()!== '') {
                     var items=response.getReturnValue();
                        console.log(items);
                     	component.set("v.themecolor", response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
 	}, 
  	doInit: function(component, event, helper) {
        var cont=component.get("v.showcontent");
        var aid=component.get("v.activity");
        var action=component.get("c.getbooleanvalue");
     	action.setParams({"actID":aid.Id});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!== '') {
                    var items = response.getReturnValue();
                    if(items === true){
                     //alert(items);
                    component.set("v.check_image",true);
                    }else{
                         component.set("v.check_image",false);
                    }
            }
        });
        $A.enqueueAction(action);
      var rectype=component.get("v.themerecordtype");
        var action=component.get("v.themeColors");
         for (var prop in action) {
             if(prop === rectype){
                console.log("Key:" + prop);
                console.log("Value:" + action[prop]);
                 component.set("v.themecolor", action[prop]);
             }
            }
      	var actvity=component.get("v.activity");
    	var numbers = [];
        for (var i = 0; i < actvity.Rating__c; i++) {
          numbers.push({
            value: i
          });
        }
          var remain = [];
          for (var i = 0; i < 5-actvity.Rating__c; i++) {
          remain.push({
            value: i
          });
      }
    component.set("v.numbers", numbers); 
    component.set("v.remain", remain);
    },
     getbooleanvalue1 :function(component, event, helper) {
          	var aid=component.get("v.EAactivityid");
        	var action=component.get("c.getbooleanvalue");
     		action.setParams({"actID":aid});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!== '') {
                    var items = response.getReturnValue();
                    if(items ===false){
                    component.set("v.check_image",true);
                    }
            }
        });
        $A.enqueueAction(action);
        
    },
 	chatterfeeditem1 :function(component, event, helper) {
        var action=component.get("c.chatterfeeditem");
        action.setCallback(this, function(response) {
            var state = response.getState();
        });
        $A.enqueueAction(action);
	},
   insertteamrecord1 : function(component, event, helper) {
        var activityid = component.get("v.activity");
      //alert(activityid.Id);
        var action = component.get("c.insertteamrecord");
        action.setParams({"ActivityID" : activityid.Id});
        action.setCallback(this,function(response){
        } );
        $A.enqueueAction(action);
   },
        showdetail : function(cmp,event,helper){
        var id=event.getParam("activityId");
        cmp.set("v.EAactivityid",id);
    },
      commentspage2 :function(component, event, helper) {
          var activity = component.get("v.activity");
          var shareEvent=$A.get("e.c:EA_Showshare_Event");
          shareEvent.setParams({"activity":activity});
          shareEvent.fire();
     
    },
    callfeedback:function(cmp,event,helper){
        var activity = cmp.get("v.activity");
        var feedbacevent=$A.get("e.c:EA_Feedback_Event");
        feedbacevent.setParams({"activityId":activity.Id});
        feedbacevent.fire();
    },
     calltodoactivity:function(cmp,event,helper){
        var activity = cmp.get("v.activity");
        var callactivity=$A.get("e.c:EA_ToDoActivity_Event");
        callactivity.setParams({"activityId":activity.Id});
        callactivity.fire();
    },
    callShowDetailCard:function(cmp,event,helper){
        cmp.set("v.showcontent",true);
        cmp.set("v.themeName", false);
    },
    showsummaryCard:function(cmp,event,helper){
        cmp.set("v.showcontent",false);
  		   cmp.set("v.themeName", true);
    },
	gotoDetail : function(component, event, helper) {
        cmp.set("v.themeName", false);
       var actvity=component.get("v.activity");
         var rating;
        var id=actvity.acivityId; ;
        var num=actvity.participant_rating;
        var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
        detailpageEvent.setParams({"actvityid":id,"member_Id":actvity.member_Id,"participant_rating":num,"showcontent":true});
      detailpageEvent.fire();
	}
    })