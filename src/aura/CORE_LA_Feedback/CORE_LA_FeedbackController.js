({
	rateLater : function(component, event, helper) {
        
       var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_Home", "isFromFeedback":true}).fire();
		
	},
   submit :function(component, event, helper) {
       if(document.querySelector('input[name="star"]:checked')){
            var starRating=document.querySelector('input[name="star"]:checked').value;
            var comment=document.getElementById("textarea-input-02").value;
            if(starRating>0){ 
                var action=component.get("c.insertFeedback");
             //   action.setParams({"eventId":component.get("v.eventId"),"rating":starRating,"comment":comment});
             	   action.setParams({"eventId":'aDkV00000004L3oKAE',"rating":starRating,"comment":comment});
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS" && response.getReturnValue()!=='') {
                        var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
    					selectEvent.setParams({"componentName":"c:CORE_LA_Home", "isFromFeedback":true}).fire();
                    }
                });
                
                $A.enqueueAction(action); 
            }        
            
        }
        else{ 
            component.set("v.showError",true);
        }
    
		
	},
   
})