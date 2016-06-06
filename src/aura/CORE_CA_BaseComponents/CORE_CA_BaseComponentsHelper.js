({
    navigateToDetailMethod : function(component, event, type) {
        var sourceSystem = event.getParam("Sourcesystem");
        if(type == 'onclick'){
            var sourceSystem = event.getParam("Sourcesystem");
            var RequestId = event.getParam("RequestId");
            var ApproverId = event.getParam("ApproverId"); 
            var sourcePage = event.getParam("sourcePage");
            var filterValue = event.getParam("filterValue");
        }
        if(type == 'onload'){      
            var sourceSystem = component.get("v.Sourcesystem");         
            var RequestId = component.get("v.RequestId");
            var ApproverId = component.get("v.ApproverId"); 
            var sourcePage ='Pending';
            var filterValue ='All';
        }
        var destination;
        if(sourceSystem == 'Purchase Request' || sourceSystem == 'Ariba') { 
            destination = "markup://c:CORE_CA_AribaDetail";}
        if(sourceSystem == 'Expense' || sourceSystem == 'GTES')
            destination = "markup://c:CORE_CA_GTESDetail";
        if(sourceSystem == 'Clarity')
            destination = "markup://c:CORE_CA_ClarityDetail";
        if(sourceSystem == 'Invoice')
            destination = "markup://c:CORE_CA_InvoiceDetail";
        
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("content");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
                values: {
                    RequestId : RequestId,
                    ApproverId : ApproverId,
                    sourcePage : sourcePage,
                    filterValue : filterValue
                }
            }
        }, component);
    },
    /*
    feedBackMethod : function(component, event) {  
        
        var action=component.get("c.findFeedbacks");         
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
                var response=response.getReturnValue();
                var RequestId = component.get("v.RequestId");
                var ApproverId = component.get("v.ApproverId");
                var destination = "markup://c:CORE_CA_Pending";
                alert(response);    
                if(RequestId == null && ApproverId== null){  
                    $A.componentService.newComponentAsync(this, function(view) {
                        var content = component.find("content");
                        content.set("v.body", view);
                    }, {
                        componentDef: destination,
                        attributes: {
                            values: {
                                "isFeedBackPopup" : response
                            }
                        }
                    }, component);
                } 
                else{
                    this.navigateToDetailMethod(component,event,'onload');    
                }    
            }
        });
        $A.enqueueAction(action);
    }  */ 
})