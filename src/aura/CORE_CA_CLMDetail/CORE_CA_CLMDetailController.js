({
		doInit : function(component, event, helper) { 
        var action = component.get("c.getUIThemeDescription");
        var response;
        action.setCallback(this, function(response) { 
            response=response.getReturnValue();   
                component.set("v.isDesktop",response);
        });    
        $A.enqueueAction(action); 
            
        component.set("v.spinnercompClm",true);
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
                var lineItemCount = component.set("v.lineItemCount",component.get("v.Detail").length);
                var LastComment=[];
                var approvalHistoryCount =0;
                for(var i=0; i<response.getReturnValue().ApprovalHistory.length; i++)
                {
                    if((response.getReturnValue().ApprovalHistory[i].Comment != null) || (response.getReturnValue().ApprovalHistory[i].Comment != undefined))
                    {
                        approvalHistoryCount++;
                        LastComment.push(response.getReturnValue().ApprovalHistory[i].Comment);
                    }
                }
                component.set("v.LastComment",LastComment[0]);
                component.set("v.approvalHistoryCount",approvalHistoryCount);
                if(component.get("v.ApprovalDetail")[0].ApproverStatus == 'Approved' || component.get("v.ApprovalDetail")[0].ApproverStatus == 'Rejected' || component.get("v.ApprovalDetail")[0].ApproverAction == 'APPR' || component.get("v.ApprovalDetail")[0].ApproverAction == 'REJC'){
                	component.set("v.showApprove",false); 
                    component.set("v.showReject",false);
                }
                component.set("v.spinnercompClm",false);
                
            }
        });
        $A.enqueueAction(action);  
    },
    
    navigateToFeed : function(component, event, helper) { 
        component.set("v.spinnercompClm",false);
        $A.util.addClass(component.find('item2'), 'tab-default-2__item');
        $A.util.removeClass(component.find('item1'), 'tab-default-2__item');                
    component.set("v.isFeed",true);
    component.set("v.isDetail",false);
},
    navigateToDetail : function(component, event, helper) {  
        component.set("v.spinnercompClm",false);
        $A.util.removeClass(component.find('item2'), 'tab-default-2__item');
    if(component.get("v.isDesktop") != 'Lightning Experience'){
            helper.scrollToLocation(component, "top");
    } 
    component.set("v.isFeed",false);
    component.set("v.isDetail",true);
},
    goToHomePage : function(component, event, helper) {       
        component.set("v.showspinner",true);
        var selectEvent = $A.get("e.c:CORE_CA_HomeEvent");
        var sourcePage=component.get("v.sourcePage");
        component.set("v.spinnercompClm",false);
        if(sourcePage == 'Pending'){
            selectEvent.setParams({"closednavigation": "CORE_CA_Pending","filterValue": component.get("v.filterValue")}).fire();}  
        if(sourcePage == 'closed'){
            selectEvent.setParams({"closednavigation": "CORE_CA_Closed","filterValue": component.get("v.filterValue")}).fire();}              
},
    approveAction : function(component, event, helper) {
        if(component.get("v.isDesktop") != 'Lightning Experience'){
            helper.scrollToLocation(component, "top");
        } 
        component.set("v.actTaken",'Approve'); 
        component.set("v.isActionPopup",true); 
        component.set("v.spinnercompClm",false);
    },
    
    rejectAction : function(component, event, helper) {
        if(component.get("v.isDesktop") != 'Lightning Experience'){
            helper.scrollToLocation(component, "top");
        }
        component.set("v.actTaken",'Reject'); 
        component.set("v.isActionPopup",true); 
        component.set("v.spinnercompClm",false);
    },  
    gotoApp :function(component, event, helper){      
            component.set("v.spinnercompClm",true); 
            var selectEvent = $A.get("e.c:CORE_CA_HomeEvent");
            selectEvent.setParams({"closednavigation": "CORE_CA_Closed","filterValue": component.get("v.filterValue")}).fire();       
	},
    gotoFeedback: function(component, event, helper) { 
        if(component.get("v.isDesktop") != 'Lightning Experience'){
            helper.scrollToLocation(component, "top");
        } 
        component.set("v.isFeedBack",true);
        component.set("v.spinnercompClm",false);
    },
    showHide : function(component, event, helper) {
        if(event.srcElement.id != "up" && event.srcElement.id != "down")
        {
            var idd =event.srcElement.id+"2";
            var iid =event.srcElement.id+"3";
            var id =event.srcElement.id+"1";
            var elem = document.getElementById(id);
            var curiid = document.getElementById(iid);
            var curidd = document.getElementById(idd);
            
            if(typeof elem !== 'undefined' && elem !== null && curiid !== 'undefined' && curiid !== null && curidd !== 'undefined' && curidd !== null)
            {
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
        }
    },
})