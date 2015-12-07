({
    chatterfeeditem1 :function(component, event, helper) {
        
        var activity=component.get("v.activityDetail");
        var aid=activity.Id;
        console.log(aid);
        var label1=$A.get("$Label.c.EA_Chatter1");
        
        var label2=$A.get("$Label.c.EA_Chatter2"); 
        var label3=$A.get("$Label.c.EA_Chatter3");
        
        var label4=$A.get("$Label.c.EA_Chatter4");
        
        var body = label1 +  activity.Name + label2 +'\n'+activity.Description__c + label3 + label4;   
    
        var action=component.get("c.chatterfeeditem");
        action.setParams({"postbody" : body});
 
        action.setCallback(this, function(response) {
            var state = response.getState();
            /*if (state === "SUCCESS" && response.getReturnValue()!=='') {

			}*/
        });
        $A.enqueueAction(action);
        
        var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
        detailpageEvent.setParams({"actvityid":aid});
        detailpageEvent.fire();
        alert("Your activity has been shared on your chatter wall");
        
    },
    
    doInit :function(component, event, helper) {
        
        var activity=component.get("v.activityDetail");
        var label1=$A.get("$Label.c.EA_ShareEmail1");
        
        var label2=$A.get("$Label.c.EA_ShareEmail2"); 
        var label3=$A.get("$Label.c.EA_ShareEmail3");
        
        var label4=$A.get("$Label.c.EA_ShareEmail4");
        
        var label5=$A.get("$Label.c.EA_ShareEmail5");
        var label6=$A.get("$Label.c.EA_ShareEmail6");
        var label7=$A.get("$Label.c.EA_ShareEmail7");
        component.set("v.MailToBody1",label3);
         component.set("v.MailToBody2",label4);
         component.set("v.MailToBody3",label5);
         component.set("v.MailToBody4",label6);
        component.set("v.MailToBody5",label7);
        var subject=label1 +'  ' + activity.Name +'  ' +label2;
        component.set("v.MailSubject",subject);
        //var body=label3+' '+activity.Name+' '+label4.replace(/\n/g,'<br/>')+ ' ' + activity.Description__c +' '+' '+ label5;
        
        
        
       // component.set("v.MailToBody",body);
        
    },
    
    cancelShare :function(component, event, helper) {
        var actvity=component.get("v.activityDetail");
        
        var id=actvity.Id; ;
        var num=actvity.participant_rating;
        
        var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");

        detailpageEvent.setParams({"actvityid":id,"member_Id":actvity.member_Id,"participant_rating":num,"showcontent":true});
        detailpageEvent.fire();
    },
    
    showdetail : function(cmp,event,helper){
        var id=event.getParam("activityId");
        
        cmp.set("v.EAactivityid",id);
        
    },
    
    gotoDetail : function(component, event, helper) {
              var actvity=component.get("v.activityDetail");
                var id=actvity.Id; 
        var num=actvity.participant_rating;
        
        var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");

        detailpageEvent.setParams({"actvityid":id,"member_Id":actvity.member_Id,"participant_rating":num,"showcontent":true});
        detailpageEvent.fire();
    },
    
    
})