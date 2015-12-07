({
  doInit: function(component, event, helper) {
      var activityid=component.get("v.activityId");
      var rating= component.get("v.participant_rating");
      var action=component.get("c.getactivitydetail");
      action.setParams({"ActivityID":activityid});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
                     var items = response.getReturnValue();
                     component.set("v.activity",items[0]);
                     component.set("v.activityForRating",items[0]);
                     var memberId= component.get("v.team_memberId");
                     var rating= component.get("v.participant_rating");
                     if( memberId !==undefined && (rating === undefined || rating === 0)){ 
                         component.set("v.showrating", true);
                }
            }
        });
        $A.enqueueAction(action);
  },
    submitFeedback1 : function(cmp,event,helper){
        var activity=cmp.get("v.activity");
        var  actid=cmp.get("v.activityId");
        var rating=cmp.get("v.participant_rating");
        var teamid=cmp.get("v.team_memberId");
        var mytextvalue = document.getElementById("commentText").value;
        if(mytextvalue !=='undefined' && mytextvalue !==''){
          var action=cmp.get("c.submitFeedback");
          action.setParams({"activityId":actid,
                          "feedbackText":mytextvalue,
                          "rating":rating,
                          "teamId":teamid,
                         });
             action.setCallback(this, function(response) {
             var state = response.getState();
             if (state === "SUCCESS" && response.getReturnValue()!=='') {
                                     var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
                    detailpageEvent.setParams({"actvityid":actid});
                   detailpageEvent.fire();
             }
           });
         $A.enqueueAction(action);
         }
        else 
        {
            cmp.set("v.showError",true);
        }
    },
    imageClick:function(cmp,event,helper,val){
        document.getElementById("btn").disabled = true;
         var numbers = [];
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
                      cmp.set("v.participant_rating",items[0].Rating__c);   
                      cmp.set("v.activity",act);
                      cmp.set("v.activityForRating",items[0]);
                      cmp.set("v.index",0);
                      var previous=cmp.get("v.participant_rating");
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
    gotoDetail :function(cmp,event,helper){
        var  actid=cmp.get("v.activityId");
        var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
         detailpageEvent.setParams({"actvityid":actid});
        detailpageEvent.fire();
    }
 })