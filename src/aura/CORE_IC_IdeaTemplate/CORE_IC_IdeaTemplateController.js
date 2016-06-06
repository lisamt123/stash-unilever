({
	loadIdeaHome : function(component, event, helper) {
        $A.get('e.force:refreshView'); 
         component.set("v.showspinner",true);
         var action=component.get("c.findFeedbacks");
         action.setParams({"appName":component.get("v.appName")});
         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
                var response=response.getReturnValue();
                if(response === true){                    
                    component.set("v.showspinner",false); 
                    helper.loadFeedBack(component,"markup://c:Feedback",component.get("v.pannelType"));
                 }
                if(response === false ){
                    component.set("v.showspinner",false); 
                    var destination = "markup://c:CORE_IC_IdeaHome"; 
                    $A.componentService.newComponentAsync(this, function(view) {
                        var content = component.find("IdeasPannel");
                        content.set("v.body", view);
                    }, {
                        componentDef: destination,
                        attributes: {
                            values: {
                                pannelType: component.get("v.pannelType")
                            }
                        }
                    }, component);         
                 }
              }
         });      
    	$A.enqueueAction(action);   
    	component.set("v.showspinner",false); 
	},
    navigateWithinComponent: function(component, event, helper) {
        //helper.scrollToLocation(component, "top"); 
        $A.get('e.force:refreshView'); 
        //helper.scrollToLocation(component, "top");  
        console.log('-------template---------'+event.getParam("pannelType"));
        if(event.getParam("recordType")=="Campaign" || event.getParam("recordType")=="Idea"){
            $A.componentService.newComponentAsync(this, function(view) {
                var content = component.find("IdeasPannel");
                content.set("v.body", view);
            }, {
                componentDef: event.getParam("componentName"),
                attributes: {
                    values: {
                        recordDetail: event.getParam("recordDetail"),
                        recordType: event.getParam("recordType"),
                        pannelType: event.getParam("pannelType")
                    }
                }
            }, component);
        } else if(event.getParam("Pagename")=="CORE_IC_IdeaHome") {
            helper.loadNewComponent(component,"markup://c:CORE_IC_IdeaHome",event.getParam("pannelType"));    
        } else if(event.getParam("Pagename")=="Feedback") {
            helper.loadFeedBack(component,"markup://c:"+event.getParam("Pagename"),event.getParam("pannelType"));
            /*if(event.getParam("componentName")=='IdeaHome' ){
                helper.loadFeedBack(component,"markup://c:"+event.getParam("Pagename"),event.getParam("pannelType"));
            } else {
                var destination ="markup://c:"+event.getParam("Pagename");
                $A.componentService.newComponentAsync(this, function(view) {
                    var content = component.find("IdeasPannel");
                    content.set("v.body", view);
                }, {
                    componentDef: destination,
                    attributes: {
                        values: {
                            Appname:component.get("v.appName"),
                            Pagename:event.getParam("componentName"),
                            EventName: "CORE_IC_IdeaTemplateEvent",
                            recordId:event.getParam("recordId"),
                            showTranslation: false
                        }
                    }
                }, component);
            }*/
            
        } else {
            helper.loadNewComponent(component,event.getParam("componentName"),event.getParam("pannelType"));
        }        
    },
    
})