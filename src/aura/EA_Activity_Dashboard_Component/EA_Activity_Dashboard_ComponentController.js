({
	gotoDetail : function(component, event, helper) {
        console.log("cancel");
         helper.scrollToLocation(component, "top"); 
       var actvity=component.get("v.activity");
        var page='MyAction';
        var id=actvity.acivityId; ;
        var num=actvity.participant_rating;
        var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
        var acceptdecline=$A.get("e.c:EA_AcceptDec_comp");
        detailpageEvent.setParams({"actvityid":id,"member_Id":actvity.member_Id,"participant_rating":num,"showcontent":true,"pagename":page});
      	detailpageEvent.fire();
	},
    doInit :function(component, event, helper) {
        var actvity=component.get("v.activity");
        var duedate=actvity.Activity_Due_Date;
        console.log(actvity.invitation_status);
       // var tomorrow=duedate.getDate()+1;
        var  today= new Date();
        var date=today.toISOString();
        //component.set("v.showfeedback",false);
        
        if((actvity.invitation_status ==='Self' || actvity.invitation_status ==='Accepted') && (actvity.Activity_Due_Date === date || actvity.Activity_Due_Date < date) && (actvity.participant_rating < 0 || actvity.participant_rating ===undefined)){
            component.set("v.showfeedback",true);
        }
      if(actvity.invitation_status ==='Invited'){
            component.set("v.showInvitation",true);
       } 
    },
    
    gotoInvitation :function(cmp, event, helper) {
        helper.scrollToLocation(cmp, "top"); 
        var member=cmp.get("v.activity");       
        var feedbackevent=$A.get("e.c:EA_Accept_Event");
        feedbackevent.setParams({"activityId":member.acivityId,"teamId":member.member_Id});
        feedbackevent.fire();
    },
    gotofeedback : function(component, event, helper) {
        helper.scrollToLocation(component, "top"); 
        console.log("feedback");
        var member=component.get("v.activity");
        var feedbackevent=$A.get("e.c:EA_Feedback_Event");
        feedbackevent.setParams({"activityId":member.acivityId,"team_memberid":member.member_Id,"participant_rating":member.participant_rating});
        feedbackevent.fire();
    }
})