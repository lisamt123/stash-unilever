({
    
    onSubmit : function(component, event, helper) {   
        var approvalDetail = component.get("v.ApprovalDetail");
        var RequestType = approvalDetail.RequestType; 
        var action= component.get("v.actionTaken"); 
        var comment ='';
        commentbox = document.getElementById("textarea-input-02");                                                 
        if(commentbox != undefined || commentbox != null ){  
           comment= document.getElementById("textarea-input-02").value; 
           
           if(comment== '' && (RequestType == 'Expense' && action == 'Reject')){
                document.getElementById("textarea-input-02").style.borderColor="red";
           }
           if(comment== '' && (RequestType == 'Purchase Request' && action == 'Reject')){
                document.getElementById("textarea-input-02").style.borderColor="red";
           }
           if(comment== '' && (RequestType == 'Clarity' && (action == 'Rework' || action == 'Reject'))){
                document.getElementById("textarea-input-02").style.borderColor="red";
           }
           if(comment== '' && (RequestType == 'Invoice' && (action == 'RTAP' || action == 'QWV'))){
                document.getElementById("textarea-input-02").style.borderColor="red";
           }
            
            else{
                 helper.SubmitMethod(component, event,comment,approvalDetail);                                              
            }                                               
        }
        else{
            if(RequestType == 'Expense' && action == 'Approve'){
               helper.SubmitMethod(component, event,comment,approvalDetail);    
            }                                            
        }                                           
        
        
        //if(component.find("textarea-input-02").get("v.value") != null && component.find("textarea-input-02").get("v.value") != undefined && RequestType == "Purchase Request" && action=="Approve"){
            /*var action = component.get("c.updateApprovalAction");
            action.setParams({
                "action": component.get("v.actionTaken"),
                "comment" : comment,
                "isVisibletoSupplier": component.get("v.isVisible"),
                "ApproverId": approvalDetail.ApproverId,
            }); 
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.success_toast",true);
                }
            });
            $A.enqueueAction(action); */
        /*}
        else{ 	
            component.set("v.comment_mand",true);                
        }*/
    },
    
    onCancel : function(component, event, helper) { 
        var approvalDetail = component.get("v.ApprovalDetail"); 
        var selectEvent = $A.get("e.c:CORE_CA_DetailsEvent");   
        selectEvent.setParams({"RequestId": approvalDetail.RequestId,
                               "ApproverId": approvalDetail.ApproverId,
                               "Sourcesystem": approvalDetail.RequestType,
                               "sourcePage": component.get("v.sourcePage"),
                               "filterValue": component.get("v.filterValue")}).fire();   
    },
    goToHomePage : function(component, event, helper) {      
        component.set("v.showspinner",true); 
        var selectEvent = $A.get("e.c:CORE_CA_HomeEvent");
        selectEvent.setParams({"closednavigation": "CORE_CA_Closed","filterValue": component.get("v.filterValue")}).fire();              
    }, 
    isVisibleMethod : function(component, event, helper) {
        if(component.get("v.isVisible") == true ){ component.set("v.isVisible",false); }
        else if(component.get("v.isVisible") == false ){ component.set("v.isVisible",true); }
    },
    handleCheckTask : function(cmp, event, helper) {
            var checkCmp = cmp.find("taskCheckBox");
           // alert("value : " + checkCmp.get("v.value"));
            console.log("value : " + checkCmp.get("v.value"))
    },
    
})