({
    getThemeColor : function(component, event, helper){
        var action =component.get("c.getThemeColor");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!== '') {
                var items=response.getReturnValue();
                component.set("v.themecolor", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
 	},
    doInit: function(component, event, helper) {
        var pageindex=component.get("v.index");
        var cont=component.get("v.showcontent");
        var aid=component.get("v.activity");
     /*start*/   var actual_para=aid.Description__c;
         
        var max_len = 180;  
         
       	var trunc = actual_para;
	  	if (trunc.length > max_len) {  
    		trunc = trunc.substring(0, max_len);
    		trunc = trunc.replace(/\w+$/, '');
 		    trunc += '...';
            //console.log(trunc);
    		
  		}
        
        component.set("v.ActivityDesc",trunc);
        
       /*end*/ 
        var action=component.get("c.getbooleanvalue");
     	action.setParams({"actID":aid.Id});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!== '') {
                var items = response.getReturnValue();
                if(items === true){
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
        var action = component.get("c.insertteamrecord");
        action.setParams({"ActivityID" : activityid.Id});
        action.setCallback(this,function(response){
        });
        $A.enqueueAction(action);
    },
    showdetail : function(cmp,event,helper){
        var id=event.getParam("activityId");
        cmp.set("v.EAactivityid",id);
    },
    commentspage2 :function(component, event, helper) {
        var activity = component.get("v.activity");
        var pagename='swipe';
        var index=component.get("v.index");
        console.log(pagename);
        var shareEvent=$A.get("e.c:EA_Showshare_Event");
        shareEvent.setParams({"activity":activity,"pagename":pagename,"index":index});
        shareEvent.fire();

    },
    callfeedback:function(cmp,event,helper){
        var activity = cmp.get("v.activity");
        var feedbacevent=$A.get("e.c:EA_Feedback_Event");
        var pagename='swipe'; 
        var index = 0;
        // Get the current slide
		var currentSlide = $('.carousel').slick('slickCurrentSlide');
        cmp.set("v.pageIndex",currentSlide);
        console.log("CurrentSlide"+ currentSlide);
        feedbacevent.setParams({"activityId":activity.Id,"pagename":pagename,"index":index,"navigatePageIndex":currentSlide});
        //feedbacevent.setParams({"activityId":activity.Id,"pagename":pagename,"index":pageIndex});
        feedbacevent.fire();
    },
    calltodoactivity:function(cmp,event,helper){
        var page='swipe';
        var activity = cmp.get("v.activity");
        var callactivity=$A.get("e.c:EA_ToDoActivity_Event");
        callactivity.setParams({"activityId":activity.Id,"pagename":page});
        callactivity.fire();
    },
    callShowDetailCard:function(cmp,event,helper){
        var actvity=cmp.get("v.activity");
        var rating;
        var id=actvity.Id;
        var page='swipe';
        var index = 0;
        // Get the current slide
		var currentSlide = $('.carousel').slick('slickCurrentSlide');
        cmp.set("v.pageIndex",currentSlide);
        console.log("Current Slide Index:"+ currentSlide);
       	var num=actvity.participant_rating;
        var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
        detailpageEvent.setParams({"actvityid":id,"pagename":page,"index":index,"navigatePageIndex":currentSlide});
    	detailpageEvent.fire();
    },
    showsummaryCard:function(cmp,event,helper){
        cmp.set("v.showcontent",false);
        cmp.set("v.themeName", true);
    },
	gotoDetail : function(component, event, helper) {
        var actvity=component.get("v.activity");
        var id=actvity.Id;
        var index=component.get("v.index");
        var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
        detailpageEvent.setParams({"actvityid":id,"showcontent":true,"index":index});
    	detailpageEvent.fire();
	}
})