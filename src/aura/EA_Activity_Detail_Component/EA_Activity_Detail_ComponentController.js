({
    doInit: function(component, event, helper) {
        var ids=[];
        ids=component.get("v.booleanValue");
        var activity=component.get("v.activity");
        for(var i=0;i<ids.length;i++)
        {
            if(ids[i] === activity.activityId)
            {
                component.set("v.check_image",true);
            }
        }
        var currentSlide = $('.carousel').slick('slickCurrentSlide');
        component.set("v.pageIndex",currentSlide);
        var pageindex=component.get("v.index");
        var cont=component.get("v.showcontent");
        var aid=component.get("v.activity");
        
        /*start*/  
        var actual_para=aid.description;
        var max_len = 150;  
        var trunc = actual_para;
        if (trunc.length > max_len) {  
            trunc = trunc.substring(0, max_len);
            trunc = trunc.replace(/\w+$/, '');
            trunc += '...';
            //console.log(trunc);
        }
        component.set("v.ActivityDesc",trunc);
        /*end*/ 
        
        var rectype=component.get("v.themerecordtype");
        var action=component.get("v.themeColors");
        for (var prop in action) {
            if(prop === rectype){
                component.set("v.themecolor", action[prop]);
            }
        }
        var actvity=component.get("v.activity");
        console.log(actvity.activityRating);
        var numbers = [];
        for (var i = 0; i < actvity.activityRating; i++) {
            numbers.push({
                value: i
            });
        }
        var remain = [];
        for (var i = 0; i < 5-actvity.activityRating; i++) {
            remain.push({
                value: i
            });
        }
        component.set("v.rating_value",actvity.activityRating);
        component.set("v.numbers", numbers);
        component.set("v.remain", remain);
        setTimeout( "jQuery('.outer_sec').show();",1000 );
    },
   /* getThemeColor : function(component, event, helper){
        var action =component.get("c.getThemeColor");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!== '') {
                var items=response.getReturnValue();
                component.set("v.themecolor", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },*/
  /*  getbooleanvalue1 :function(component, event, helper) {
        var aid=component.get("v.activity");
        var action=component.get("c.getbooleanvalue");
        action.setParams({"actID":aid.activityId});
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
    },*/
   /* chatterfeeditem1 :function(component, event, helper) {
        var action=component.get("c.chatterfeeditem");
        action.setCallback(this, function(response) {
            var state = response.getState();
        });
        $A.enqueueAction(action);
    },
    insertteamrecord1 : function(component, event, helper) {
        var activityid = component.get("v.activity");
        var action = component.get("c.insertteamrecord");
        action.setParams({"ActivityID" : activityid.activityId});
        action.setCallback(this,function(response){
        });
        $A.enqueueAction(action);
    },
    showdetail : function(cmp,event,helper){
        var id=event.getParam("activityId");
        cmp.set("v.EAactivityid",id);
    },*/
    
    callShowDetailCard:function(cmp,event,helper){
        var actvity=cmp.get("v.activity");
        var id=actvity.activityId;
        var page='swipe';
        // var index = 0;
        // Get the current slide
        var currentSlide = $('.carousel').slick('slickCurrentSlide');
        cmp.set("v.pageIndex",currentSlide);
        console.log("Current Slide Index:"+ currentSlide);
        console.log("comin in detail");
        //var num=actvity.participant_rating;
        var detailevent=cmp.get("v.activity");
        var detailevent=$A.get("e.c:EA_Detailpage_Event");
        
        detailevent.setParams({"actvityid":id,"pagename":page,"navigatePageIndex":currentSlide});
        detailevent.fire();
    },
 /*   showsummaryCard:function(cmp,event,helper){
        cmp.set("v.showcontent",false);
        cmp.set("v.themeName", true);
    },*/
  /*  gotoDetail : function(component, event, helper) {
        var actvity=component.get("v.activity");
        var id=actvity.activityId;
        var index=component.get("v.index");
        var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
        detailpageEvent.setParams({"actvityid":id,"showcontent":true,"index":index});
        detailpageEvent.fire();
        
    }*/
})