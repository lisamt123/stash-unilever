({
    chatterfeeditem1 :function(cmp, event, helper) {
        var activity=cmp.get("v.activityDetail");;
        var label1=$A.get("$Label.c.EA_Chatter1");
        var label2=$A.get("$Label.c.EA_Chatter2"); 
        var label3=$A.get("$Label.c.EA_Chatter3");
        var label4=$A.get("$Label.c.EA_Chatter4");
       
        var body = label1+ ' \" ' + activity.Name+' \" '+ label2;
        var action=cmp.get("c.chatterfeeditem");
        action.setParams({"postbody" : body});
        action.setCallback(this, function(response) {
            var state = response.getState();
            alert("Your chatter post has been submitted successfully");
        });
        $A.enqueueAction(action);
        alert("Your chatter post has been submitted successfully");
        var pagename=cmp.get("v.pagename");
        var index=cmp.get("v.index");
        var pageIndex=cmp.get("v.pageIndex");
        var actvity=cmp.get("v.activityDetail");
        var id=actvity.Id;
        if(pagename ==='swipe')
        {
            var detailpageEvent=$A.get("e.c:EA_Back_Event");
            detailpageEvent.setParams({"pagename":pagename,"index":index,"navigatePageIndex":pageIndex});
            detailpageEvent.fire();
        }else{
            var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
            detailpageEvent.setParams({"actvityid":id,"showcontent":true,"index":index,"pagename":pagename,"navigatePageIndex":pageIndex});
            detailpageEvent.fire();
        }
    },
    doInit :function(component, event, helper) {
        
        var aid=component.get("v.activityId");
        
        var action=component.get("c.getactivitydetail");
        action.setParams({"ActivityID":aid});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
             
            if (state === "SUCCESS" && response.getReturnValue()!== '') {
               
                items = response.getReturnValue();
                
                component.set("v.activityDetail",items[0]);
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
                var subject=label1 +' \" ' + items[0].Name +' \" ' +label2;
                component.set("v.MailSubject",subject);
            }
        });
        action.setExclusive();
        $A.enqueueAction(action); 
    },
    
    cancelShare :function(cmp, event, helper) {
        var pagename=cmp.get("v.pagename");
        var index=cmp.get("v.index");
        // Get pageIndex for Backbutton
        var pageIndex = cmp.get("v.pageIndex");
        console.log("Share Page Index:"+pageIndex);         
        if(pagename ==='swipe')
        {
            var detailpageEvent=$A.get("e.c:EA_Back_Event");
            detailpageEvent.setParams({"pagename":pagename,"index":index,"navigatePageIndex":pageIndex});
            detailpageEvent.fire();
        }else{
            var actvity=cmp.get("v.activityDetail");
            var id=actvity.Id;
            var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
            detailpageEvent.setParams({"actvityid":id,"showcontent":true,"index":index,"pagename":pagename,"navigatePageIndex":pageIndex});
            detailpageEvent.fire();
        }     
    },
    
    showdetail : function(cmp,event,helper){
        var id=event.getParam("activityId");
        cmp.set("v.EAactivityid",id);
    },
    
    gotoDetail : function(cmp, event, helper) {
        var actvity=cmp.get("v.activityDetail");
        var id=actvity.Id;
        console.log(actvity);
        var pagename=cmp.get("v.pagename");
        var index=cmp.get("v.index");
        // Get pageIndex for Backbutton
        var pageIndex = cmp.get("v.pageIndex");
        console.log("Share Page Index:"+pageIndex);         
        if(pagename ==='swipe')
        {
            var detailpageEvent=$A.get("e.c:EA_Back_Event");
            detailpageEvent.setParams({"pagename":pagename,"index":index,"navigatePageIndex":pageIndex});
            detailpageEvent.fire();
        }else{
            var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
            detailpageEvent.setParams({"actvityid":id,"showcontent":true,"index":index,"pagename":pagename,"navigatePageIndex":pageIndex});
            detailpageEvent.fire();
        }
    }
},
 
 
 })