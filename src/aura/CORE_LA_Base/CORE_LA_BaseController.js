({
    homePageLoad: function(component, event, helper) {
         $A.get('e.force:refreshView'); 
        var content = component.find("content");
        $A.createComponent("c:CORE_LA_Home", {},
            function(cmp) {
                content.set("v.body", [cmp]);
            });
             
    },

    navigateWithinComponent: function(component, event, helper) {
        
        $A.get('e.force:refreshView'); 
        var content = component.find("content");
        console.log("trainers in base: "+JSON.stringify(event.getParam("trainers")));
        $A.createComponent(event.getParam("componentName") ,{"isFromFeedback":event.getParam("isFromFeedback"),
       "event":event.getParam("event"),"trainerId":event.getParam("trainerId"),"externalEmail":event.getParam("externalEmail"),
        "trainers":event.getParam("trainers")},
            function(cmp) {
                content.set("v.body", [cmp]);
            });

    },
    
    handleOpenCreateEventLandingPage: function(component, event, helper) {
        var content = component.find("content");
        console.log('handle method handleOpenCreateEventLandingPage');
        if(!$A.util.isEmpty(event.getParam("targetAction"))){
            console.log('-----'+event.getParam("recordId"));
            console.log('handle method handleOpenCreateEventLandingPage inner'+ event.getParam("componentName"));
            $A.createComponent(event.getParam("componentName"),{"recordId":event.getParam("recordId"),},
        	    function(cmp) {content.set("v.body", [cmp]);});
        }else{
            console.log('handle method handleOpenCreateEventLandingPage else');
            if(event.getParam("recordId") !== ''){
                $A.get('e.force:refreshView'); 
                $A.createComponent(event.getParam("componentName"),{"recordId":event.getParam("recordId"),},
                    function(cmp) {content.set("v.body", [cmp]);}
                );
            }            
        }
        
    },
})