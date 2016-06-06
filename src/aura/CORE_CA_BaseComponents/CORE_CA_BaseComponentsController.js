({
	doInit:function(component, event, helper) { 
      /*  helper.feedBackMethod(component,event); */
       var RequestId = component.get("v.RequestId");
        var ApproverId = component.get("v.ApproverId");
        if(RequestId == null && ApproverId== null){  
            var destination = "markup://c:CORE_CA_Pending";
            $A.componentService.newComponentAsync(this, function(view) {
                var content = component.find("content");
                content.set("v.body", view);
            }, {
                componentDef: destination,
                attributes: {
                    values: {
                        message: "{!v.message}",
                        RequestId: "{!v.RequestId}",
                        ApproverId: "{!v.ApproverId}"
                        
                    }
                }
            }, component);
        } 
        else{ 
        	helper.navigateToDetailMethod(component,event,'onload');    
        }
},

    getClosed:function(component, event, helper) {
      //  alert(event.getParam("filterValue"));
        var destination = "markup://c:" + event.getParam("closednavigation");
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("content");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
                values: {
                	filterValue : event.getParam("filterValue")       
                }
            }
        }, component); 
},
    
    getDetail:function(component, event, helper) {
        helper.navigateToDetailMethod(component,event,'onclick');
}, 
    getSubDetail :function(component, event, helper) {
        var destination = "markup://c:CORE_CA_" + event.getParam("compName") ;
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("content");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
                values: {
                     subDivision : event.getParam("subDivision"),
                     ApprovalDetail : event.getParam("ApprovalDetail"),
                     lineItemId : event.getParam("lineItemId"),
                     sourcePage : event.getParam("sourcePage"),
                     filterValue : event.getParam("filterValue")
                    }
            }
        }, component); 
},
      
    /*
    getDetail :function(component, event, helper) {
         var destination = "markup://c:Core_CA_Approval_Home";
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("content");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
                values: {
                filteroptions : event.getParam("filterTopic")
                }
            }
        }, component); 
       
    },*/
    ApproveScreen1 :function(component, event, helper) {
    
        var destination = "markup://c:"+ event.getParam("ApproveScreen");
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("content");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
              
            }
        }, component);

    
},
    
   

    /*ReturntoVendor :function(component, event, helper) {
                    var destination = "markup://c:"+ event.getParam("ReturntoVendorScreen");
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("content");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
              
            }
        }, component);
    },
    ReturntoAP3 :function(component, event, helper) {
                    var destination = "markup://c:"+ event.getParam("ReturntoAPScreen");
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("content");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
              
            }
        }, component);
    },
    ReworkScreen3 :function(component, event, helper) {
                    var destination = "markup://c:"+ event.getParam("ReworkScreen");
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("content");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
              
            }
        }, component);
    }
   */
/*gotoApp :function(component, event, helper){ alert('hi');
        //helper.navigateToDetailMethod(component,event,'onclick');
        component.set("v.showspinner",true); 
        var selectEvent = $A.get("e.c:CORE_CA_HomeEvent");
        selectEvent.setParams({"closednavigation": "CORE_CA_Pending","filterValue": component.get("v.filterValue")}).fire(); 
},
 handleFeedback : function(component, event, helper) {
                    var destination ="markup://c:Feedback";
                     $A.componentService.newComponentAsync(this, function(view) {
                     var content = component.find("content");
                     content.set("v.body", view);
                        }, {
                            componentDef: destination,
                            attributes: {
                                values: {
                                    Appname:component.get("v.Appname"),
                                    Pagename:component.get("v.Pagename"),
                                    EventName: "CORE_CA_FeedbackEvent" ,
                                    showTranslation: true

                                }
                            }
                        }, component);
     
    },*/
   
})