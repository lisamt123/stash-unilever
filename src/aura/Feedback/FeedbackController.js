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
                console.log('-------------------------------'+state);
                if (state === "SUCCESS" && response.getReturnValue()!=='') {
                    console.log("coming");
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
        console.log(component.get("v.selectedMonth"));
        action.setParams({"appName":component.get("v.Appname")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
             if(component.get("v.Appname") === 'Approval' ){ 
            	helper.gotoApproval(component);      
       	     }    
             else if(component.get("v.tabName") !==undefined || component.get("v.recordId") !==undefined ){
            helper.gotoIdeas(component);
           
       }    
        else if(component.get("v.selectedMonth") !==undefined){ 
           console.log(component.get("v.selectedMonth"));
           helper.gotoTEM(component);
           
        }   
            else{
                helper.gotoApp(component);
             }
           }
        });        
        $A.enqueueAction(action); 
    },
    
     //Method to close the feedback popup
    close:function(component, event, helper){
        if(component.get("v.Appname") === 'Approval' ){ 
            helper.gotoApproval(component);      
       } 
         
        else if(component.get("v.tabName") !==undefined || component.get("v.recordId") !==undefined ){
            helper.gotoIdeas(component);
           
       }    
        else if(component.get("v.selectedMonth") !==undefined){ 
           helper.gotoTEM(component);
           
        }  
     
             else{
                helper.gotoApp(component);
             }
            
    },
    //Method to close the Error popup
    closeError:function(component, event, helper){
        document.getElementsByClassName('slds-modal slds-modal--prompt slds-fade-in-open')[0].style.visibility='hidden';
        document.getElementsByClassName('slds-backdrop--open')[0].style.visibility='hidden';
        component.set("v.showError",false);
    },
})