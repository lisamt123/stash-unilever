({
		doInit : function(component, event, helper) {   
        var action = component.get("c.getApprovalDetailPageData");
        var RequestId = component.get("v.RequestId");        
        var ApproverId = component.get("v.ApproverId");        
        action.setParams({
			"RequestId": RequestId,
            "ApproverId" : ApproverId
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.ApprovalDetail",response.getReturnValue());
                component.set("v.PreTripDetails",response.getReturnValue().PreTripDetails);
            	component.set("v.Detail",response.getReturnValue().LineItems);
                
                 if(component.get("v.ApprovalDetail")[0].ApproverStatus == 'Rejected' || component.get("v.ApprovalDetail")[0].ApproverAction == 'REJC'
                        || component.get("v.ApprovalDetail")[0].ApproverStatus == 'Approved' || component.get("v.ApprovalDetail")[0].ApproverAction == 'APPR'
                        || component.get("v.ApprovalDetail")[0].ApproverAction == 'COPY' || component.get("v.ApprovalDetail")[0].isRecalled == true){
                	component.set("v.showApprove",false); 
                    component.set("v.showReject",false);    
                }
            }
        });
        $A.enqueueAction(action);  
    },
    
    NavigateToFeed : function(component, event, helper) {  
    component.set("v.isFeed",true);
    component.set("v.isDetail",false);
},
    NavigateToDetail : function(component, event, helper) {  
    component.set("v.isFeed",false);
    component.set("v.isDetail",true);
},
    goToLineItemDetail : function(component, event, helper) { 
        var self = this
        var index = event.target.dataset.index;        
        var approvalDetailList =[];
        var approvalDetail = component.get("v.Detail");
        for(var i=0; i<approvalDetail.length; i++)
        {            
            approvalDetailList.push(approvalDetail[i]);             
        } 
        var LineItemId = approvalDetailList[index].LineItemId;   
        var selectEvent = $A.get("e.c:CORE_CA_SubDetailEvent");
        selectEvent.setParams({ "compName": "LineItemDetail","subDivision":"GTES","lineItemId":LineItemId,"ApprovalDetail":component.get("v.ApprovalDetail"),"sourcePage":component.get("v.sourcePage")}).fire(); 
},
    goToHomePage : function(component, event, helper) {       
        component.set("v.showspinner",true);
        var selectEvent = $A.get("e.c:CORE_CA_HomeEvent");
        var sourcePage=component.get("v.sourcePage");
        if(sourcePage == 'Pending')
            selectEvent.setParams({"closednavigation": "CORE_CA_Pending","filterValue": component.get("v.filterValue")}).fire();  
        if(sourcePage == 'closed')
           selectEvent.setParams({"closednavigation": "CORE_CA_Closed","filterValue": component.get("v.filterValue")}).fire();              
    },
    ApproveAction : function(component, event, helper) {
        helper.scrollToLocation(component, "top");
        component.set("v.actTaken",'Approve'); 
        component.set("v.isActionPopup",true); 
    },
    RejectAction : function(component, event, helper) {
        helper.scrollToLocation(component, "top");
        component.set("v.actTaken",'Reject'); 
        component.set("v.isActionPopup",true); 
    },
    gotoFeedback: function(component, event, helper) { 
        helper.scrollToLocation(component, "top"); 
        component.set("v.isFeedBack",true);
    },
    gotoApp :function(component, event, helper){       
        if(event.getParam("Pagename") == "Detail")
        	component.set("v.isFeedBack",false);
        else if(event.getParam("Pagename") == "Home"){
            component.set("v.showspinner",true); 
            var selectEvent = $A.get("e.c:CORE_CA_HomeEvent");
            selectEvent.setParams({"closednavigation": "CORE_CA_Pending","filterValue": component.get("v.filterValue")}).fire(); 
        }       
	},
})