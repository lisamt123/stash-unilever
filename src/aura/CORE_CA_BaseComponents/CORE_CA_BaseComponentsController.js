({
    doInit:function(component, event, helper) {  
        /*  helper.feedBackMethod(component,event); */
       var action=component.get("c.findFeedbacks");
       var response; 
       action.setParams({"appName": "Approval"}); 
       action.setCallback(this, function(response) {  
                response=response.getReturnValue();
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
                                ApproverId: "{!v.ApproverId}",
                                isFeedBackPopup : response
                            }
                        }
                    }, component);
                } 
                else{ 
                    helper.navigateToDetailMethod(component,event,'onload',response);    
                }
        });
       $A.enqueueAction(action);    
        
        /*Sonar Explanation:
         "https://www.google-analytics.com/analytics.js" is used for Google Analytics functionlaity.
          below code snippet is provided by Google analtics and cannot do modification in the code.
        */
        var action = component.get("c.getGAID");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                if(response.getReturnValue()!=''){                                         
                    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                        (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                            m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
                                            })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
                    
                    ga('create', action, 'auto');
                    ga('send', 'pageview');
                }
                else {
                    component.set("v.ErrorMessageFlag", true);
                }
            }                   
        });
        $A.enqueueAction(action);
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
    /*
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
    
    */
    
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