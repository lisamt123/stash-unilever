({
    //Method to submit rating
    submitFeedback : function(component, event, helper) {
        if(document.querySelector('input[name="star"]:checked')){
            starRating=document.querySelector('input[name="star"]:checked').value;
            var comment=document.getElementById("textarea-input-02").value;
            var action=component.get("c.insertFeedback");
            action.setParams({"appName":component.get("v.Appname"),"rating":starRating,"comment":comment});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue()!=='') {
                    component.set("v.success_toast",true);
                }
            });
            
            $A.enqueueAction(action); 
        }        
        else{   
            component.set("v.showError",true);
        }
    },
  //Method to rate later
    rateLater : function(component, event, helper) {
        var action=component.get("c.insertFeedback");
        action.setParams({"appName":component.get("v.Appname")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
                var backEvent=$A.get("e.c:Feedback_Event");
                backEvent.setParams({"Pagename":component.get("v.Pagename"),"isFeedback":false});
                backEvent.fire();
            }
        });        
        $A.enqueueAction(action); 
    },
     //Method to close the feedback popup
    close:function(component, event, helper){
        var backEvent=$A.get("e.c:Feedback_Event");
        backEvent.setParams({"Pagename":component.get("v.Pagename"),"isFeedback":false});
        backEvent.fire(); 
    },
    //Method to close the Error popup
    closeError:function(component, event, helper){
        document.getElementsByClassName('slds-modal slds-modal--prompt slds-fade-in-open')[0].style.visibility='hidden';
        document.getElementsByClassName('slds-backdrop--open')[0].style.visibility='hidden';
        component.set("v.showError",false);
    },
})