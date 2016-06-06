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
                if(response.getReturnValue() == null || response.getReturnValue() == undefined)
                	component.set("v.ApprovalHistoryLength",response.getReturnValue().ApprovalHistory.length);
            	console.log('@@@output--------'+ response.getReturnValue());
                if(component.get("v.ApprovalDetail")[0].ApproverStatus == 'Rejected' || component.get("v.ApprovalDetail")[0].ApproverAction == 'REJC'
                        || component.get("v.ApprovalDetail")[0].ApproverStatus == 'Approved' || component.get("v.ApprovalDetail")[0].ApproverAction == 'APPR'
                        || component.get("v.ApprovalDetail")[0].ApproverStatus == 'Rework' || component.get("v.ApprovalDetail")[0].ApproverAction == 'REWO'){
                	component.set("v.showApprove",false); 
                    component.set("v.showReject",false);
                    component.set("v.showReWork",false);
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
    goToProjectFinance : function(component, event, helper) { 
        var PreTripDetails= component.get("v.ApprovalDetail")[0].PreTripDetails;
        alert(PreTripDetails.PassengerInfo);
        var PassengerInfo = [];
        for(var i=0; i<1; i++)
        {
           // PassengerInfo.push(PreTripDetails.PassengerInfo.split(,)[i]);
            alert(PassengerInfo);
        }
        var selectEvent = $A.get("e.c:CORE_CA_SubDetailEvent");
        selectEvent.setParams({ "compName":  "ClaritySubDetail", "subDivision": "ProjectFinance", "ApprovalDetail":component.get("v.ApprovalDetail"),"sourcePage":component.get("v.sourcePage"),"filterValue": component.get("v.filterValue")}).fire();
},
    goToFincBenefit : function(component, event, helper) {
       var selectEvent = $A.get("e.c:CORE_CA_SubDetailEvent");
        selectEvent.setParams({ "compName":  "ClaritySubDetail", "subDivision": "FincBenefit", "ApprovalDetail":component.get("v.ApprovalDetail"),"sourcePage":component.get("v.sourcePage"),"filterValue": component.get("v.filterValue")}).fire();
},
    goToKeyIndc : function(component, event, helper) { 
       var selectEvent = $A.get("e.c:CORE_CA_SubDetailEvent");
       selectEvent.setParams({ "compName":  "ClaritySubDetail", "subDivision": "KeyIndc","ApprovalDetail":component.get("v.ApprovalDetail"),"sourcePage":component.get("v.sourcePage"),"filterValue": component.get("v.filterValue")}).fire();
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
    rework : function(component, event, helper) {
        helper.scrollToLocation(component, "top");
        component.set("v.actTaken",'Rework'); 
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