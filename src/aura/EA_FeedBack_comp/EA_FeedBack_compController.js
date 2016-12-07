({
    doInit: function(component, event, helper) {
        var activityid=component.get("v.activityId");
        component.set("v.showrating", true);
        component.set("v.userPreviousRating",'0');
        //Get the average rating of the Activity for header section of the comment
        var action=component.get("c.getactivitydetail");        
        action.setParams({"ActivityID":activityid});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!=='') {                
                var items = response.getReturnValue();
                component.set("v.activity",items[0]);
                component.set("v.activityForRating",items[0]);                
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
                component.set("v.numberfound", numbers);
                component.set("v.remainfound", remain); 
            }
            
        });
        action.setExclusive();
        $A.enqueueAction(action);
        
         component.set("v.showrating", true)
         //Get the previous rating of the user    
            var action=component.get("c.getActivityRating");
             action.setParams({"ActivityID":activityid});
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!=='') {                
                items=response.getReturnValue();
                 var numbers = [];
                 var remain = [];
                 if(items !==undefined && items !== null){
                     component.set("v.userPreviousRating",items);
                     var star = "star-"+items;
                     document.getElementById(star).checked="checked";
                }
              }
        });
       $A.enqueueAction(action);  
    },
    
    gotoDetail :function(component,event,helper){
        var pagename=component.get("v.pagename");
        if(pagename ==='swipe')
        {
            var index=component.get("v.index");
            var pageIndex = component.get("v.pageIndex");
            var detailpageEvent=$A.get("e.c:EA_Back_Event");
            detailpageEvent.setParams({"pagename":pagename,"index":index,"navigatePageIndex":pageIndex});
            detailpageEvent.fire();
        }else{
            var actvity=component.get("v.activityId");
            var id=actvity.Id;
            var pagename=component.get("v.pagename");
            var index=component.get("v.index");
            // Get pageIndex for Backbutton
            var pageIndex = component.get("v.pageIndex");
            var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
            detailpageEvent.setParams({"actvityid":actvity,"showcontent":true,"index":index,"pagename":pagename,"navigatePageIndex":pageIndex});
            detailpageEvent.fire();
        }
},
 //Method to submit rating
    submitFeedback1 : function(component, event, helper) {
        helper.scrollToLocation(component,"top");
       // var Previousrating=component.get("v.userPreviousRating");
        //alert (Previousrating);
         //var activity=component.get("v.activity");
        var  actid=component.get("v.activityId");
         var teamid=component.get("v.team_memberId");
        if(document.querySelector('input[name="star"]:checked')){
            starRating=document.querySelector('input[name="star"]:checked').value; 
            var comment=document.getElementById("textarea-input-02").value;  
            var action=component.get("c.submitFeedback");
            action.setParams({"activityId":actid,
                              "feedbackText":comment,
                              "rating":starRating,
                              "teamId":teamid,
                             });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue()!=='') {
                    component.set("v.showmessage",true);
                    var pagename=component.get("v.pagename");
                }
            });
            $A.enqueueAction(action); 
            var pageIndex=component.get("v.pageIndex");
            var actvity=component.get("v.activityId");
            var id=actvity.Id;
            var pagename=component.get("v.pagename");
            var index=component.get("v.index");
            var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
            detailpageEvent.setParams({"actvityid":actvity,"showcontent":true,"index":index,"pagename":pagename,"navigatePageIndex":pageIndex});
            detailpageEvent.fire();
        }        
        else{   
            component.set("v.showError",true);
        }
    },
 })