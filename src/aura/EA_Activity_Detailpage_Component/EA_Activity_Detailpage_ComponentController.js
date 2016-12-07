({
    doInit: function(component, event, helper) {
        var items=[];
        var aid=component.get("v.EAactivityid");
        var index=component.get("v.index");
        var pageIndex=component.get("v.pageIndex");
        var currentactivity;
        var action=component.get("c.getactivitydetail");
        action.setParams({"ActivityID":aid});
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            if (state === "SUCCESS" && response.getReturnValue()!== '') {
                items = response.getReturnValue();
                component.set("v.ShowDetailCard",true);
                var ishomepage=component.get("v.pagename");
                if(ishomepage === 'Myaction')                  
                {
                    component.set("v.isHomepage",true);
                }
                if(ishomepage === 'swipe')                  
                {
                    component.set("v.isHomepage",true);
                    ishomepage=ishomepage+'Detailcard';
                    component.set("v.pagename",ishomepage);
                }
                component.set("v.activity",items[0]);
                var actvity=items[0];
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
            var rectype=items[0].RecordType.Name;
            var action=component.get("v.themeColors");
            for (var prop in action) {
                if(prop === rectype){
                    component.set("v.themecolor", action[prop]);
                }
            }
        });
        action.setExclusive();
        component.set("v.showspinner",true);
        $A.enqueueAction(action);
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
    },
    */
    /*  getbooleanvalue1 :function(component, event, helper) {
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
    },*/
    /* chatterfeeditem1 :function(component, event, helper) {
        var action=component.get("c.chatterfeeditem");
        action.setCallback(this, function(response) {
            var state = response.getState();
        });
        $A.enqueueAction(action);
    },*/
    /* insertteamrecord1 : function(component, event, helper) {
        var activityid = component.get("v.activity");
        var action = component.get("c.insertteamrecord");
        action.setParams({"ActivityID" : activityid.Id});
        action.setCallback(this,function(response){
        });
        $A.enqueueAction(action);
    },*/
    /*  showdetail : function(cmp,event,helper){
        var id=event.getParam("activityId");
        cmp.set("v.EAactivityid",id);
    },*/
    
    /* callShowDetailCard:function(cmp,event,helper){
        cmp.set("v.showcontent",true);
    },
    showsummaryCard:function(cmp,event,helper){
        cmp.set("v.showcontent",false);
        cmp.set("v.themeName", true);
    },
    gotoDetail : function(component, event, helper) {
        var actvity=component.get("v.activity");
        var rating;
        var id=actvity.Id;
        var num=actvity.participant_rating;
        var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
        detailpageEvent.setParams({"actvityid":id,"member_Id":actvity.member_Id,"participant_rating":num,"showcontent":true});
        detailpageEvent.fire();
    },
    */
    gotoPrevious : function(component, event, helper) {
        var pagename=component.get("v.pagename");
        console.log("while coming--> "+pagename);
        if(pagename ==='Detailcard')
        {
            pagename='MyAction';
        }
        if(pagename ==='swipeDetailcard')
        {
            pagename='swipe';
        }
        var index=component.get("v.index");
        var pageIndex = component.get("v.pageIndex");
        var detailpageEvent=$A.get("e.c:EA_Back_Event");
        detailpageEvent.setParams({"pagename":pagename,"index":index,"navigatePageIndex":pageIndex});
        detailpageEvent.fire();
    },
})