({
		doInit : function(component, event, helper) { 
        component.set("v.spinnercompInvoice",true);
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
                var approvalDetailList =[];
                var approvalDetail= component.get("v.ApprovalDetail");
                component.set("v.accessStatus",component.get("v.ApprovalDetail")[0].accessStatus);
                  
                for(var i=0; i<approvalDetail.length; i++){            
            		approvalDetailList.push(approvalDetail[i]);             
                }
            	component.set("v.Detail",response.getReturnValue().LineItems);
                var LastComment=[];
                for(var i=0; i<response.getReturnValue().ApprovalHistory.length; i++)
                {
                    LastComment.push(response.getReturnValue().ApprovalHistory[i].Comment);
                }
                component.set("v.LastComment",LastComment[0]);
                if(component.get("v.ApprovalDetail")[0].ApproverStatus == 'Approved' || component.get("v.ApprovalDetail")[0].ApproverStatus == 'Return to AP'){
                	component.set("v.showApprove",false); 
                    component.set("v.showRtap",false);
                    component.set("v.showQwv",false);
                }
                component.set("v.spinnercompInvoice",false);
                
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
        helper.scrollToLocation(component, "top");
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
        selectEvent.setParams({ "compName": "LineItemDetail","subDivision":"Invoice","lineItemId":LineItemId,"ApprovalDetail":component.get("v.ApprovalDetail"),"sourcePage":component.get("v.sourcePage"),"filterValue": component.get("v.filterValue")}).fire();
},
    goToDocHistory : function(component, event, helper) { 
       var selectEvent = $A.get("e.c:CORE_CA_SubDetailEvent");
       selectEvent.setParams({ "compName":  "InvoiceSubDetail", "subDivision": "DocHistory","ApprovalDetail":component.get("v.ApprovalDetail"),"sourcePage":component.get("v.sourcePage"),"filterValue": component.get("v.filterValue")}).fire();
},
    goToHomePage : function(component, event, helper) {       
        component.set("v.showspinner",true);
        var selectEvent = $A.get("e.c:CORE_CA_HomeEvent");
        var sourcePage=component.get("v.sourcePage");
        if(sourcePage == 'Pending'){
            selectEvent.setParams({"closednavigation": "CORE_CA_Pending","filterValue": component.get("v.filterValue")}).fire();}  
        if(sourcePage == 'closed'){
            selectEvent.setParams({"closednavigation": "CORE_CA_Closed","filterValue": component.get("v.filterValue")}).fire();}              
},
    ApproveAction : function(component, event, helper) {
        helper.scrollToLocation(component, "top");
        component.set("v.actTaken",'Approve'); 
        component.set("v.isActionPopup",true); 
    },
    querywithvendor : function(component, event, helper) {
    	helper.scrollToLocation(component, "top");
        component.set("v.actTaken",'QWV'); 
        component.set("v.isActionPopup",true);    
    },
    returnToAP : function(component, event, helper) {
    	helper.scrollToLocation(component, "top");
        component.set("v.actTaken",'RTAP'); 
        component.set("v.isActionPopup",true);    
    },    
    gotoApp :function(component, event, helper){      
            component.set("v.showspinner",true); 
            var selectEvent = $A.get("e.c:CORE_CA_HomeEvent");
            selectEvent.setParams({"closednavigation": "CORE_CA_Closed","filterValue": component.get("v.filterValue")}).fire();       
	},
    gotoFeedback: function(component, event, helper) { 
        helper.scrollToLocation(component, "top"); 
        component.set("v.isFeedBack",true);
    },
    showHide : function(component, event, helper) {
        var idd =event.srcElement.id+"2";
        var iid =event.srcElement.id+"3";
        var id =event.srcElement.id+"1";
        if(document.getElementById(id).style.display == "none")
        {	
            document.getElementById(id).style.display = "block";
            document.getElementById(iid).style.display = "none";
            document.getElementById(idd).style.display = "block";
        }
        else
        {
            document.getElementById(id).style.display = "none";
            document.getElementById(iid).style.display = "block";
            document.getElementById(idd).style.display = "none";
        }
    },
})