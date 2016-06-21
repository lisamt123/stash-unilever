({
	doInit : function(component, event, helper) {
        console.log("app name==>"+component.get("v.agentApp"));
		var action=component.get("c.findFeedbacks");
       action.setParams({"appName":component.get("v.agentApp")});
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
                var response=response.getReturnValue();
                if(response === true){
                     console.log("inside response true");
                    // var destination ="markup://c:Feedback";
                    var destination = "c:Feedback";
                    var contentFeedBack = component.find("content");
                    $A.createComponent(destination,
                                       {
                                           Appname:component.get("v.agentApp"),
                                           Pagename:component.get("v.Pagename"),
                                           EventName:"AA_Feedback_Evt",
                                           // If your application should be displayed in users language set the following attribute to true or else set to false
                                           showTranslation:true},
                                       function(cmp) {
                                           contentFeedBack.set("v.body", [cmp]);
                                       }); 
                    
                    
                    
                   /*  $A.componentService.newComponentAsync(this, function(view) {
                     var content = component.find("content");
                     content.set("v.body", view);
                        }, {
                            componentDef: destination,
                            attributes: {
                                values: {
                                    Appname:component.get("v.agentApp"),
                                    Pagename:component.get("v.Pagename"),
                                    EventName:"AA_Feedback_Evt",
                             // If your application should be displayed in users language set the following attribute to true or else set to false
                                    showTranslation:true
                                }
                            }
                        }, component);*/
                    
                    
                 }
                 if(response === false ){
                     console.log("Inside response False");
                     var cmpEvent = component.getEvent("LandingPageEvent");
                     cmpEvent.setParams({
                         showLandingPage:true});
                     cmpEvent.fire();
                     console.log("event fired ");
                   
                     
                     
                     /*var destination = component.get("v.Pagename");
                      
                    var contentFeedBack = component.find("content");
                    $A.createComponent(destination,
                                       {
                                          },
                                       function(cmp) {
                                           contentFeedBack.set("v.body", [cmp]);
                                       }); 
                     
                  /*  $A.componentService.newComponentAsync(this, function(view) {
                    var content = component.find("content");
                    content.set("v.body", view);
                    }, {
                        componentDef: destination,
                        attributes: {
                        }
                    }, component);*/
                 }
              }
         });
       $A.enqueueAction(action);
	},
    
    gotoApp :function(component, event, helper){
        var cmpEvent = component.getEvent("LandingPageEvent");
        cmpEvent.setParams({
            showLandingPage:true});
        cmpEvent.fire();
        console.log("event fired ");
        
        /* var destination = "markup://"+event.getParam("Pagename");
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("content");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
                
            }
        }, component);*/
    }

})