({
    doInit: function(component, event, helper) {
        var activityid=component.get("v.activityId");
        var rating= component.get("v.participant_rating");
       // helper.scrollToLocation(component, "top");
          if(rating !== undefined)
          {
           component.set("v.userPreviousRating",rating);
          }
         if(rating === undefined || rating === 0)
          {
              component.set("v.showrating", true);
           component.set("v.userPreviousRating",0);
          }
        var pageIndex = component.get("v.pageIndex");
        console.log("Init pageIndex:"+ pageIndex);
        var action=component.get("c.getactivitydetail");
        
        action.setParams({"ActivityID":activityid});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
                
                var items = response.getReturnValue();
                component.set("v.activity",items[0]);
                component.set("v.activityForRating",items[0]);
                
            }
        });
        action.setExclusive();
        $A.enqueueAction(action);
        var memberId= component.get("v.team_memberId");
        var rating= component.get("v.participant_rating");
        if( memberId !==undefined && (rating === undefined || rating === 0)){ 
            component.set("v.showrating", true);
        }
        
        if( memberId === undefined ){ 
           
            var action=component.get("c.getActivityRating");
             action.setParams({"ActivityID":activityid});
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
                
                items=response.getReturnValue();
                
                 var numbers = [];
                 var remain = [];
               
                if(items !==undefined)
                {
                     component.set("v.showrating", true);
                     component.set("v.userPreviousRating",items);
                    
                      
                    for (var i = 0; i < items; i++) {
                    numbers.push({
                        value: i
                    });
                    }
                    
             
                for (var i = 0; i < 5-items; i++) {
                    
                    remain.push({
                        value: i
                    });
                   
                  }
                  
                   component.set("v.numbers", numbers); 
                   component.set("v.remain", remain);
              
                }
                
                if(items === null || items ===0)
                {
                 
                    component.set("v.showrating", true);
                }
            
              }
        });
       $A.enqueueAction(action);   
        }
    },
    submitFeedback1 : function(cmp,event,helper){
        
        cmp.set("v.showLoading",false);
        var activity=cmp.get("v.activity");
        var  actid=cmp.get("v.activityId");
        var rating=cmp.get("v.userPreviousRating");
        var teamid=cmp.get("v.team_memberId");
        var mytextvalue = document.getElementById("commentText").value;
    
        if(rating !==0 && rating>=1){
            
            var action=cmp.get("c.submitFeedback");
            action.setParams({"activityId":actid,
                              "feedbackText":mytextvalue,
                              "rating":rating,
                              "teamId":teamid,
                             });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue()!=='') {
                    cmp.set("v.showmessage",true);
                    var pagename=cmp.get("v.pagename");
                }
            });
            $A.enqueueAction(action);
            var pageIndex=cmp.get("v.pageIndex");
            var actvity=cmp.get("v.activityId");
            var id=actvity.Id;
      
            console.log("PageIndex"+pageIndex);
            var pagename=cmp.get("v.pagename");
            var index=cmp.get("v.index");
            var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
            detailpageEvent.setParams({"actvityid":actvity,"showcontent":true,"index":index,"pagename":pagename,"navigatePageIndex":pageIndex});
            detailpageEvent.fire();
        }
        else 
        {
            cmp.set("v.showError",true);
        }
    },
    emptyImageClick : function(cmp,event,helper,val){
       // document.getElementById("btn").disabled = true;
          cmp.set("v.showError",false);
        var numbers = [];
        var indVal = event.target.attributes.getNamedItem("data-index").value;
        var index =parseInt(event.target.attributes.getNamedItem("data-index").value);
     
        index=index+1;
        var rating=cmp.get("v.userPreviousRating");
      
        index=rating+index;
      
       
      
        var activityid=cmp.get("v.activityId");
        var action=cmp.get("c.provideRating");
        action.setParams({"ActivityID":activityid,"rating":index});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
                var items = response.getReturnValue();
                
                var act= cmp.get("v.activity");
                cmp.set("v.pagename",'MyAction');
                cmp.set("v.userPreviousRating",items[0].Rating__c);   
                cmp.set("v.activity",act);
                cmp.set("v.activityForRating",items[0]);
                cmp.set("v.index",0);
                var previous=cmp.get("v.userPreviousRating");
                if(previous < 5){
                    cmp.set("v.rateStars",previous);
                }
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
                cmp.set("v.numbers", numbers); 
                cmp.set("v.remain", remain);
            }
        });
        $A.enqueueAction(action);
        document.getElementById("btn").disabled = false; 
    },
    
    imageClick:function(cmp,event,helper,val){
       // document.getElementById("btn").disabled = true;
         cmp.set("v.showError",false);
        var numbers = [];
        var indVal = event.target.attributes.getNamedItem("data-index").value;
        var index =parseInt(event.target.attributes.getNamedItem("data-index").value);
     
        index =index+1;
      
        var activityid=cmp.get("v.activityId");
        var action=cmp.get("c.provideRating");
        action.setParams({"ActivityID":activityid,"rating":index});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
                var items = response.getReturnValue();
                
                var act= cmp.get("v.activity");
                cmp.set("v.pagename",'MyAction');
                cmp.set("v.userPreviousRating",items[0].Rating__c); 
                
                cmp.set("v.activity",act);
                cmp.set("v.activityForRating",items[0]);
                cmp.set("v.index",0);
                var previous=cmp.get("v.userPreviousRating");
                //if(previous < 5){
                   // cmp.set("v.rateStars",previous);
               // }
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
                cmp.set("v.numbers", numbers); 
                cmp.set("v.remain", remain);
            }
        });
        $A.enqueueAction(action);
        document.getElementById("btn").disabled = false; 
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
    }
},
 
 })