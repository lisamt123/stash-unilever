({
    registration : function(component, event, helper) {
        component.set("v.isRequired1",false);
        component.set("v.isRequired2",false);
        var question1;
        var question2;
        var comment1;
        var comment2;
        
        if(component.find("levels1") != undefined)
        {
            question1 = component.find("levels1").get("v.value");
            if(question1 == "Yes")
            {
                var comment1=document.getElementById("comment1").value;
                if(comment1== ''){
                    document.getElementById("comment1").style.borderColor="red";
                    component.set("v.isRequired1",true);
                }
            }
        }
        if(component.find("levels2") != undefined)
        {
            question2 = component.find("levels2").get("v.value");
            if(question2 == "Yes")
            {
                var comment2=document.getElementById("comment2").value;
                if(comment2== ''){
                    document.getElementById("comment2").style.borderColor="red";
                    component.set("v.isRequired2",true);
                }
            }
        }
        if(component.get("v.isRequired1") == false && component.get("v.isRequired1") == false)
        {
            var action=component.get("c.register");
            //   action.setParams({"eventId":component.get("v.eventId"),"rating":starRating,"comment":comment});
            action.setParams({"eventId":'aDkV00000004L3oKAE',"question1":question1,"question2":question2,"comment1":comment1,"comment2":comment2});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue()!=='') {
                    component.set("v.isRegistrationConfirmationPopup",true); 
                }
            });
            
            $A.enqueueAction(action); 
        }
        /*
        var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_Confirm"}).fire();
        */
        
    },
    cancel : function(component, event, helper) {
        var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_UpcomingDetail"}).fire();
    },
    
    
})