({
	chatterfeeditem1 :function(component, event, helper) {
        
         var activity=component.get("v.activityDetail");
        var aid=component.get("v.activityId");
        
         var label1=$A.get("$Label.c.EA_Chatter1");
         
         var label2=$A.get("$Label.c.EA_Chatter2"); 
         var label3=$A.get("$Label.c.EA_Chatter3");
        
         var label4=$A.get("$Label.c.EA_Chatter4");
        
       var body = label1 +  activity.Name + label2 + activity.Description__c + label3 + label4; 

       
        
       // var chatter = component.get("v.UserId");
        var action=component.get("c.chatterfeeditem");
        action.setParams({"postbody" : body});
      
        
      //  var share=component.find("txt").get("v.value");
         //alert("coming");
        // alert(share); 
        //action.setParams({"comment":share});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()!=''){
                    //alert("success");
                    
                    
                }
            }
        });
        $A.enqueueAction(action);
        
         var detailpageEvent=$A.get("e.c:EA_Detailpage_Event");
                    detailpageEvent.setParams({"actvityid":aid});
                   detailpageEvent.fire();
        
},
    
    doInit :function(component, event, helper) {
      
        var activity=component.get("v.activityDetail");
        var label1=$A.get("$Label.c.EA_ShareEmail1");
         
         var label2=$A.get("$Label.c.EA_ShareEmail2"); 
         var label3=$A.get("$Label.c.EA_ShareEmail3");
        
         var label4=$A.get("$Label.c.EA_ShareEmail4");
        
         var label5=$A.get("$Label.c.EA_ShareEmail5");
        
        var subject=label1+ activity.Name + label2;
        component.set("v.MailSubject",subject);
       var body=label3+activity.Name+label4+' '+activity.Description__c +' '+' '+ label5;

       
      
       component.set("v.MailToBody",body);

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
   
    
})