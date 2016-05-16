({
	gotoDetail : function(component, event, helper) {
        //helper.scrollToLocation(component, "top"); 
        var actvity=component.get("v.activity");
        var id=actvity.acivityId; 
        var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
        detailpageEvent.setParams({"actvityid":id});
        detailpageEvent.fire();
	},
    
     gotoInvitation :function(component, event, helper) {
         //helper.scrollToLocation(component, "top");
        var member=component.get("v.activity");       
        var feedbackevent=$A.get("e.c:EA_Accept_Event");
        feedbackevent.setParams({"activityId":member.acivityId,"teamId":member.member_Id});
        feedbackevent.fire();
    },
    
    myAction :function(component, event, helper){
        var act=component.get("v.activity");
        
        
    }
})