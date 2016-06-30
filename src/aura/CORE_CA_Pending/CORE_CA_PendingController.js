({ 
    doInit : function(component, event, helper) { 
       /*var action=component.get("c.findFeedbacks");  
       action.setParams({"appName": "Approval"}); 
        action.setCallback(this, function(response) { 
            var state = response.getState(); 
            if (state === "SUCCESS" && response.getReturnValue()!=='') { 
                var response=response.getReturnValue();       
                if(response === true){ 
                    component.set("v.isFeedBackPopup",true);
                }             
            }
        });
       $A.enqueueAction(action);*/ 
       
       
        var retainfilter =component.get("v.filterValue");                                     
        if(retainfilter == null || retainfilter == undefined)
        {
            filteroptions="All";
        }
        else
        {
            filteroptions = retainfilter;
        }
        component.set("v.spinnercomp",true);
        var filterOption = event.getSource();
        var filter=filterOption.get("v.title");
        var filteroptions;
        if(filter== "Show All")
        {  
            filteroptions="All";
            document.getElementById('icon').classList.remove('icon-LockedState');
            document.getElementById('icon').classList.remove('icon-currentState');
            document.getElementById('all').classList.add('filterSelected');
        }
        else if(filter== "Show Only Expenses")
        {
            filteroptions="Expense";
            document.getElementById('icon').classList.add('icon-LockedState');


        }
            else if(filter== "Show Only Purchase Requests")
            {
                filteroptions="Purchase Request";
                document.getElementById('icon').classList.add('icon-LockedState');
            }
                else if(filter== "Show only Project Approval")
                {
                    filteroptions="Clarity";
                    document.getElementById('icon').classList.add('icon-LockedState');
                }
                    else if(filter== "Show only Invoices")
                    {
                        filteroptions="Invoice";
                        document.getElementById('icon').classList.add('icon-LockedState');
                    }
        component.set("v.filteroptions",filteroptions);
        var action = component.get("c.getApprovalHomeScreenData");
        action.setCallback(this, function(response) {
            component.set("v.pendingData",response.getReturnValue().PendingApprovals);
            
            
            helper.loadMore(component,response.getReturnValue().PendingApprovals);
            
        });
        $A.enqueueAction(action);
       //  component.set("v.spinnercomp",false);  
       
    },
    
    
    GetClosedDetails : function(component, event, helper) { 
        component.set("v.spinnercomp",true);
        var selectEvent = $A.get("e.c:CORE_CA_HomeEvent");
        selectEvent.setParams({"closednavigation": "CORE_CA_Closed"}).fire();
    },
    
    goToFiltercomp : function(component, event, helper) {
        
        
        if(component.get("v.filterview")==false || component.get("v.filterview")=='' || component.get("v.filterview")==null){       
            
            component.set("v.filterview", true);
            document.getElementById('icon').classList.add('icon-currentState');	
        }
        
        else{
            component.set("v.filterview", false);
            document.getElementById('icon').classList.remove('icon-currentState');	
        }
        
    },
    HideSelection : function(component, event, helper) {
        
        component.set("v.filterview", false);
        component.set("v.showMoreCount",true);        
    },
    
    ShowMoreSelection : function(component, event, helper) {
        component.set("v.spinnercomp",true); 
        helper.loadMore(component,component.get("v.pendingData"));
    },
    gotoApp : function(component, event, helper) { 
		component.set("v.isFeedBackPopup",false);    
	},
 
})