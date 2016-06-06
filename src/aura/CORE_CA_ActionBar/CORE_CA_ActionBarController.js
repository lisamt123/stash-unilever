({ 
    doInit:function(component, event, helper) {
        
        var approvalDetail = component.get("v.detailVal");
        component.set("v.showApprove", true);
        component.set("v.showReject", true);
        component.set("v.showFeed", true);
        component.set("v.showReWork", false);
        component.set("v.showQwv", false);
        component.set("v.showRtap", false);
    
        
        if (approvalDetail.RequestType == "Clarity") { 
            component.set("v.showReWork", true);
        }
        if (approvalDetail.RequestType == "Invoice") {
            component.set("v.showQwv",true);
            component.set("v.showRtap",true);
            component.set("v.showReject",false);
            component.set("v.showFeed", false);
        }
        if (approvalDetail.hasPermSet == true) {  
            component.set("v.showApprove",false);
            component.set("v.showReject",false);
            component.set("v.showFeed",false);
        } else if (approvalDetail.RequestType == "Expense" && (approvalDetail.ApproverStatus == 'Approved' || approvalDetail.ApproverStatus == 'Rejected' || approvalDetail.ApproverAction == 'APPR' || approvalDetail.ApproverAction == 'REJC' || approvalDetail.ApproverAction == 'COPY' || approvalDetail.isRecalled == true)) {
            component.set("v.showApprove",false);
            component.set("v.showReject",false);
        } else if (approvalDetail.RequestType == "Purchase Request" && (approvalDetail.IsActive == "false")) {
            component.set("v.showApprove",false);
            component.set("v.showReject",false);
        } else if (approvalDetail.RequestType == "Purchase Request" && (approvalDetail.ApproverStatus == 'Rejected' || approvalDetail.ApproverAction == 'REJC')) {
            component.set("v.showReject",false);
        } else if (approvalDetail.RequestType == "Purchase Request" && (approvalDetail.ApproverStatus == 'Approved' || approvalDetail.ApproverAction == 'APPR')) {
            component.set("v.showApprove",false);
            component.set("v.showReject",false);
        } else if (approvalDetail.RequestType == "Clarity" && (approvalDetail.ApproverStatus == 'Approved' || approvalDetail.ApproverStatus == 'Rejected' || approvalDetail.ApproverStatus == 'Rework' || approvalDetail.ApproverAction == 'APPR' || approvalDetail.ApproverAction == 'REJC' || approvalDetail.ApproverAction == 'REWO')) {
            component.set("v.showApprove",false);
            component.set("v.showReject",false);
            component.set("v.showReWork",false);
        } else if (approvalDetail.RequestType == "Invoice" && (approvalDetail.ApproverStatus == 'Query with Vendor' || approvalDetail.ApproverAction == 'QUER')) {
            component.set("v.showApprove",true);
            component.set("v.showRtap",true);
            component.set("v.showQwv",true);
            component.set("v.showReject",false);
        }else if (approvalDetail.RequestType == "Invoice" && (approvalDetail.ApproverStatus == 'Approved' || approvalDetail.ApproverStatus == 'Return to AP' )) {
            component.set("v.showApprove",false);
            component.set("v.showRtap",false);
            component.set("v.showQwv",false);
            component.set("v.showReject",false);
        }
    },
    gotoFeedback: function(component, event, helper) { 
        helper.scrollToLocation(component, "top");
        var feedbackevt=$A.get("e.c:Feedback_Event");
        feedbackevt.setParams({"appName":"Approval","Pagename":"CORE_CA_Pending","eventName":"CORE_CA_FeedbackEvent", "showTranslation":true}).fire();
    },
    ApproveScreen : function(component, event, helper) {
       var selectEvent = $A.get("e.c:CORE_CA_ActionBarEvent");
        selectEvent.setParams({"ApproveScreen": "Core_CA_Approve"}).fire();
	},
    /*
    ApproveScreen : function(component, event, helper) {
       var selectEvent = $A.get("e.c:CORE_CA_ActionBarEvent");
        selectEvent.setParams({"ApproveScreen": "Core_CA_Approve"}).fire();
	},
    
    doInit:function(component, event, helper) {
         
    },
    ApproveScreen1:function(component, event, helper) {
        

    },
	gotoFeedback: function(component, event, helper) {
       var feedbackevt=$A.get("e.c:Feedback_Event");
	   feedbackevt.setParams({"appName":"Approval","Pagename":"CORE_CA_Pending","eventName":"CORE_CA_FeedbackEvent", "showTranslation":true}).fire();
	},
    
    return1 : function(component, event, helper) {
       var selectEvent = $A.get("e.c:CORE_CA_ActionBarEvent");
        selectEvent.setParams({"ApproveScreen": "Core_CA_ReturnToVendor"}).fire();
	},
    returntoAP : function(component, event, helper) {
       var selectEvent = $A.get("e.c:CORE_CA_ActionBarEvent");
        selectEvent.setParams({"ApproveScreen": "Core_CA_ReturnToAP"}).fire();
	},
     reWork1 : function(component, event, helper) {
       var selectEvent = $A.get("e.c:CORE_CA_ActionBarEvent");
        selectEvent.setParams({"ApproveScreen": "Core_CA_Rework"}).fire();
	}*/
})