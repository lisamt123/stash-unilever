({
	gotoDetail : function(component, event, helper) {
         
       var actvity=component.get("v.activity");
         var rating;
        var id=actvity.acivityId; ;
        var num=actvity.participant_rating;
      
        var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
        var acceptdecline=$A.get("e.c:EA_AcceptDec_comp");
        
        detailpageEvent.setParams({"actvityid":id,"member_Id":actvity.member_Id,"participant_rating":num,"showcontent":true});
      detailpageEvent.fire();
     
          
		
	},
    
    doInit :function(component, event, helper) {
          
          var actvity=component.get("v.activity");
          console.log(actvity.Activity_Due_Date);
         var  today= new Date();
       console.log(actvity.invitation_status);
        var date = today.toISOString(); 
          console.log(date);
        
          //if(actvity.Due_Date < currentDate)
        if(actvity.invitation_status ==='Self' && (actvity.Activity_Due_Date == date || actvity.Activity_Due_Date < date) && (actvity.participant_rating < 0 || actvity.participant_rating ===undefined)){
            component.set("v.showfeedback",true);
          
           
            
        }
         
       if(actvity.invitation_status ==='Invited'){
            component.set("v.showInvitation",true);
        } 
        
        
               
       
    },
    
    gotoInvitation :function(cmp, event, helper) {
        
        var member=cmp.get("v.activity");       
        var feedbackevent=$A.get("e.c:EA_Accept_Event");
        feedbackevent.setParams({"activityId":member.acivityId,"teamId":member.member_Id});
        feedbackevent.fire();
        
    },
    gotofeedback : function(component, event, helper) {
       
        var member=component.get("v.activity");
        var feedbackevent=$A.get("e.c:EA_Feedback_Event");
        feedbackevent.setParams({"activityId":member.acivityId,"team_memberid":member.member_Id,"participant_rating":member.participant_rating});
        feedbackevent.fire();
    }
   
})