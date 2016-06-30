({
    doInit : function(component, event, helper) {  
        var action = component.get("c.getUIThemeDescription");
        var response;
        action.setCallback(this, function(response) { 
            response=response.getReturnValue();        	
                component.set("v.isDesktop",response);
        });    
        $A.enqueueAction(action); 
        
        component.set("v.spinnercompClarity",true);
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
                component.set("v.ApprovalHistoryLength",response.getReturnValue().ApprovalHistory.length);
                component.set("v.accessStatus",component.get("v.ApprovalDetail")[0].accessStatus);
                console.log('@@@output--------'+ response.getReturnValue());
                if(component.get("v.ApprovalDetail")[0].ApproverStatus == 'Rejected' || component.get("v.ApprovalDetail")[0].ApproverAction == 'REJC'
                   || component.get("v.ApprovalDetail")[0].ApproverStatus == 'Approved' || component.get("v.ApprovalDetail")[0].ApproverAction == 'APPR'
                   || component.get("v.ApprovalDetail")[0].ApproverStatus == 'Rework' || component.get("v.ApprovalDetail")[0].ApproverAction == 'REWO'){
                    component.set("v.showApprove",false); 
                    component.set("v.showReject",false);
                    component.set("v.showReWork",false);
                }
                component.set("v.spinnercompClarity",false);
            }
        });
        $A.enqueueAction(action);  
    },
    
    NavigateToFeed : function(component, event, helper) { 
        component.set("v.spinnercompClarity",false);
        $A.util.addClass(component.find('item2'), 'tab-default-2__item');
        $A.util.removeClass(component.find('item1'), 'tab-default-2__item');
        component.set("v.isFeed",true);
        component.set("v.isDetail",false);
    },
    NavigateToDetail : function(component, event, helper) {
        component.set("v.spinnercompClarity",false);
        $A.util.removeClass(component.find('item2'), 'tab-default-2__item');
        component.set("v.isFeed",false);
        component.set("v.isDetail",true);
    },
    goToProjectFinance : function(component, event, helper) { 
        component.set("v.spinnercompClarity",true);
        if(component.get("v.isDesktop") != 'Lightning Experience'){
            helper.scrollToLocation(component, "top");
        } 
        var selectEvent = $A.get("e.c:CORE_CA_SubDetailEvent");
        component.set("v.spinnercompClarity",true);
        selectEvent.setParams({ "compName":  "ClaritySubDetail", "subDivision": "ProjectFinance", "ApprovalDetail":component.get("v.ApprovalDetail"),"sourcePage":component.get("v.sourcePage"),"filterValue": component.get("v.filterValue")}).fire();
    },
    goToFincBenefit : function(component, event, helper) {
        component.set("v.spinnercompClarity",true);
        if(component.get("v.isDesktop") != 'Lightning Experience'){
            helper.scrollToLocation(component, "top");
        } 
        var selectEvent = $A.get("e.c:CORE_CA_SubDetailEvent");
        component.set("v.spinnercompClarity",true);
        selectEvent.setParams({ "compName":  "ClaritySubDetail", "subDivision": "FincBenefit", "ApprovalDetail":component.get("v.ApprovalDetail"),"sourcePage":component.get("v.sourcePage"),"filterValue": component.get("v.filterValue")}).fire();
    },
    goToKeyIndc : function(component, event, helper) { 
        component.set("v.spinnercompClarity",true);
        if(component.get("v.isDesktop") != 'Lightning Experience'){
            helper.scrollToLocation(component, "top");
        } 
        var selectEvent = $A.get("e.c:CORE_CA_SubDetailEvent");
        component.set("v.spinnercompClarity",true);
        selectEvent.setParams({ "compName":  "ClaritySubDetail", "subDivision": "KeyIndc","ApprovalDetail":component.get("v.ApprovalDetail"),"sourcePage":component.get("v.sourcePage"),"filterValue": component.get("v.filterValue")}).fire();
    },
    goToDatesAndComents : function(component, event, helper) { 
        component.set("v.spinnercompClarity",true);
        if(component.get("v.isDesktop") != 'Lightning Experience'){
            helper.scrollToLocation(component, "top");
        } 
        var selectEvent = $A.get("e.c:CORE_CA_SubDetailEvent");
        component.set("v.spinnercompClarity",true);
        selectEvent.setParams({ "compName":  "ClaritySubDetail", "subDivision": "DatesComents","ApprovalDetail":component.get("v.ApprovalDetail"),"sourcePage":component.get("v.sourcePage"),"filterValue": component.get("v.filterValue")}).fire();
    },
    goToHomePage : function(component, event, helper) {
        component.set("v.showspinner",true);
        var selectEvent = $A.get("e.c:CORE_CA_HomeEvent");
        var sourcePage=component.get("v.sourcePage");
        if(sourcePage == 'Pending'){  
            selectEvent.setParams({"closednavigation": "CORE_CA_Pending","filterValue": component.get("v.filterValue")}).fire(); }
        if(sourcePage == 'closed'){
            selectEvent.setParams({"closednavigation": "CORE_CA_Closed","filterValue": component.get("v.filterValue")}).fire();  }           
    },    
    ApproveAction : function(component, event, helper) {
        component.set("v.spinnercompClarity",true);
        if(component.get("v.isDesktop") != 'Lightning Experience'){
            helper.scrollToLocation(component, "top");
        } 
        component.set("v.actTaken",'Approve'); 
        component.set("v.isActionPopup",true); 
        component.set("v.spinnercompClarity",false);
    },
    RejectAction : function(component, event, helper) {
        component.set("v.spinnercompClarity",true);
        if(component.get("v.isDesktop") != 'Lightning Experience'){
            helper.scrollToLocation(component, "top");
        } 
        component.set("v.actTaken",'Reject'); 
        component.set("v.isActionPopup",true); 
        component.set("v.spinnercompClarity",false);
    },
    rework : function(component, event, helper) {
        component.set("v.spinnercompClarity",true);
        if(component.get("v.isDesktop") != 'Lightning Experience'){
            helper.scrollToLocation(component, "top");
        } 
        component.set("v.actTaken",'Rework'); 
        component.set("v.isActionPopup",true); 
        component.set("v.spinnercompClarity",false);
    },
    gotoFeedback: function(component, event, helper) { 
        component.set("v.spinnercompClarity",true);
        if(component.get("v.isDesktop") != 'Lightning Experience'){
            helper.scrollToLocation(component, "top");
        } 
        component.set("v.isFeedBack",true);
        component.set("v.spinnercompClarity",false);
    },
    gotoApp :function(component, event, helper){       
        if(event.getParam("Pagename") == "Detail"){
            component.set("v.isFeedBack",false);}
        else if(event.getParam("Pagename") == "Home"){
            component.set("v.showspinner",true); 
            var selectEvent = $A.get("e.c:CORE_CA_HomeEvent");
            selectEvent.setParams({"closednavigation": "CORE_CA_Pending","filterValue": component.get("v.filterValue")}).fire(); 
        }       
    },
    showHide : function(component, event, helper) {
        if(event.srcElement.id != "up" && event.srcElement.id != "down")
        {
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
        }
    },
    NavigateToFeedViaComment : function(component, event, helper) { 
        component.set("v.spinnercompClarity",false);
        $A.util.addClass(component.find('item2'), 'tab-default-2__item');
        $A.util.removeClass(component.find('item1'), 'tab-default-2__item');
        if(component.get("v.isDesktop") != 'Lightning Experience'){
            helper.scrollToLocation(component, "top");
        } 
        component.set("v.isFeed",true);
        component.set("v.isDetail",false);
    },
})