({ 
    doInit : function(component, event, helper) {
       /* var action=component.get("c.findFeedbacks");  
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
        
        var retainfilter =component.get("v.filterValue")
        if(retainfilter == null || retainfilter == undefined)
        {
            filteroptions="All";
        }
        else
        {
            filteroptions = retainfilter;
        }
        component.set("v.showspinnerclosed",true);
        var filterOption = event.getSource();
        var filter=filterOption.get("v.title");
        var filteroptions;
        if(filter== "Show All")
        {
            filteroptions="All";
            document.getElementById('icon').classList.remove('icon-LockedState');
            document.getElementById('icon').classList.remove('icon-currentState');
            $A.util.addClass(component.find('all'), 'filterSelected');
            $A.util.removeClass(component.find('gtes'), 'filterSelected');
            $A.util.removeClass(component.find('ariba'), 'filterSelected');
            $A.util.removeClass(component.find('clarity'), 'filterSelected');
            $A.util.removeClass(component.find('invoice'), 'filterSelected');
        	component.set("v.showMoreCount",true); 
        }
        else if(filter== "Show Only Expenses")
        {
            filteroptions="Expense";
            document.getElementById('icon').classList.add('icon-LockedState');
            $A.util.removeClass(component.find('all'), 'filterSelected');
            $A.util.addClass(component.find('gtes'), 'filterSelected');
            $A.util.removeClass(component.find('ariba'), 'filterSelected');
            $A.util.removeClass(component.find('clarity'), 'filterSelected');
            $A.util.removeClass(component.find('invoice'), 'filterSelected');
        	component.set("v.showMoreCount",true); 
        }
        else if(filter== "Show Only Purchase Requests")
        {
            filteroptions="Purchase Request";
            document.getElementById('icon').classList.add('icon-LockedState');
            $A.util.removeClass(component.find('all'), 'filterSelected');
                $A.util.removeClass(component.find('gtes'), 'filterSelected');
                $A.util.addClass(component.find('ariba'), 'filterSelected');
                $A.util.removeClass(component.find('clarity'), 'filterSelected');
                $A.util.removeClass(component.find('invoice'), 'filterSelected');
                component.set("v.showMoreCount",true); 
        }
        else if(filter== "Show only Project Approval")
        {
            filteroptions="Clarity";
            document.getElementById('icon').classList.add('icon-LockedState');
            $A.util.removeClass(component.find('all'), 'filterSelected');
                    $A.util.removeClass(component.find('gtes'), 'filterSelected');
                    $A.util.removeClass(component.find('ariba'), 'filterSelected');
                    $A.util.addClass(component.find('clarity'), 'filterSelected');
                    $A.util.removeClass(component.find('invoice'), 'filterSelected');
                    component.set("v.showMoreCount",true); 
        }
        else if(filter== "Show only Invoices")
        {
            filteroptions="Invoice";
            document.getElementById('icon').classList.add('icon-LockedState');
            $A.util.removeClass(component.find('all'), 'filterSelected');
                        $A.util.removeClass(component.find('gtes'), 'filterSelected');
                        $A.util.removeClass(component.find('ariba'), 'filterSelected');
                        $A.util.removeClass(component.find('clarity'), 'filterSelected');
                        $A.util.addClass(component.find('invoice'), 'filterSelected');
                        component.set("v.showMoreCount",true); 
        }
        component.set("v.filteroptions",filteroptions);
        var action = component.get("c.getApprovalHomeScreenData");
        action.setCallback(this, function(response) {
            component.set("v.closedData",response.getReturnValue().ClosedApprovals);
            component.set("v.filterview", false);
            helper.loadMore(component,response.getReturnValue().ClosedApprovals);
            
        });
        $A.enqueueAction(action);  
       // component.set("v.showspinnerclosed",false);
    },
    /*
    
     showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt= spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();    
    },
    
    hideSpinner : function (component, event, helper) {
       var spinner = component.find('spinner');
       var evt=spinner.get("e.toggle");
       evt.setParams({ isVisible : false });
       evt.fire();     
    },*/
    PendingDetails : function(component, event, helper) {
        component.set("v.showspinnerclosed",true);
        var selectEvent = $A.get("e.c:CORE_CA_HomeEvent");
        selectEvent.setParams({"closednavigation": "CORE_CA_Pending","filterValue": component.get("v.filterValue")}).fire();
        
    },
    
    goToFiltercomp : function(component, event, helper) {
        
        
        if(component.get("v.filterview")==false || component.get("v.filterview")=='' || component.get("v.filterview")==null){       
            
            component.set("v.filterview", true);
            var retainfilter =component.get("v.filteroptions");
        if(retainfilter == null || retainfilter == undefined)
        {
            filteroptions="All";
        }
        else
        {
            filteroptions = retainfilter;
        }
        var filteroptions;
        if(filteroptions=="All")
        {  
            
            document.getElementById('icon').classList.remove('icon-LockedState');
            document.getElementById('icon').classList.remove('icon-currentState');
            $A.util.addClass(component.find('all'), 'filterSelected');
            $A.util.removeClass(component.find('gtes'), 'filterSelected');
            $A.util.removeClass(component.find('ariba'), 'filterSelected');
            $A.util.removeClass(component.find('clarity'), 'filterSelected');
            $A.util.removeClass(component.find('invoice'), 'filterSelected');

        }
        else if(filteroptions=="Expense")
        {
            
            document.getElementById('icon').classList.add('icon-LockedState');
			$A.util.removeClass(component.find('all'), 'filterSelected');
            $A.util.addClass(component.find('gtes'), 'filterSelected');
            $A.util.removeClass(component.find('ariba'), 'filterSelected');
            $A.util.removeClass(component.find('clarity'), 'filterSelected');
            $A.util.removeClass(component.find('invoice'), 'filterSelected');

        }
            else if(filteroptions=="Purchase Request")
            {
                document.getElementById('icon').classList.add('icon-LockedState');
                $A.util.removeClass(component.find('all'), 'filterSelected');
                $A.util.removeClass(component.find('gtes'), 'filterSelected');
                $A.util.addClass(component.find('ariba'), 'filterSelected');
                $A.util.removeClass(component.find('clarity'), 'filterSelected');
                $A.util.removeClass(component.find('invoice'), 'filterSelected');
            }
                else if(filteroptions=="Clarity")
                {
                    
                    document.getElementById('icon').classList.add('icon-LockedState');
                    $A.util.removeClass(component.find('all'), 'filterSelected');
                    $A.util.removeClass(component.find('gtes'), 'filterSelected');
                    $A.util.removeClass(component.find('ariba'), 'filterSelected');
                    $A.util.addClass(component.find('clarity'), 'filterSelected');
                    $A.util.removeClass(component.find('invoice'), 'filterSelected');
                }
                    else if(filteroptions=="Invoice")
                    {
                        
                        document.getElementById('icon').classList.add('icon-LockedState');
                        $A.util.removeClass(component.find('all'), 'filterSelected');
                        $A.util.removeClass(component.find('gtes'), 'filterSelected');
                        $A.util.removeClass(component.find('ariba'), 'filterSelected');
                        $A.util.removeClass(component.find('clarity'), 'filterSelected');
                        $A.util.addClass(component.find('invoice'), 'filterSelected');
                    }
            document.getElementById('icon').classList.add('icon-currentState');	
        }
        
        else{
            component.set("v.filterview", false);
            document.getElementById('icon').classList.remove('icon-currentState');	
        }
        
    },
    ShowMoreSelection : function(component, event, helper) {
        helper.loadMore(component,component.get("v.closedData"));
    },
    gotoApp : function(component, event, helper) { 
		component.set("v.isFeedBackPopup",false);    
	},
})