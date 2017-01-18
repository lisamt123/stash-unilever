({ 
    doInit : function(component, event, helper) { 
        $A.util.addClass(component.find('all'), 'filterSelected');
        $A.util.removeClass(component.find('gtes'), 'filterSelected');
        $A.util.removeClass(component.find('ariba'), 'filterSelected');
        $A.util.removeClass(component.find('clarity'), 'filterSelected');
        $A.util.removeClass(component.find('invoice'), 'filterSelected');
        $A.util.removeClass(component.find('contracts'), 'filterSelected');
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
        /* winter'17 fix for 'title' of markup://ltng:require not visible to component start */
        var filter;
        var x= filterOption.toString();
        filter="Show All";
        if(event.getName()==='press'){
            filter=filterOption.get("v.buttonTitle");
        }
        /*   winter'17 fix for 'title' of markup://ltng:require not visible to component end */
        var filteroptions;
        if(filter== "Show All")
        {  
            filteroptions="All";
            document.getElementById('icon').classList.remove('icon-LockedState');
            document.getElementById('icon').classList.remove('icon-currentState');
            $A.util.addClass(component.find('all'), 'filterSelected');
            component.set("v.showMoreCount",true); 
        }
        else if(filter== "Show Only Expenses")
        {
            filteroptions="Expense";
            document.getElementById('icon').classList.add('icon-LockedState');
            $A.util.addClass(component.find('gtes'), 'filterSelected');
            component.set("v.showMoreCount",true);
            
        }
            else if(filter== "Show Only Purchase Requests")
            {
                filteroptions="Purchase Request";
                document.getElementById('icon').classList.add('icon-LockedState');
                $A.util.addClass(component.find('ariba'), 'filterSelected');
                component.set("v.showMoreCount",true); 
            }
                else if(filter== "Show only Project Approval")
                {
                    filteroptions="Clarity";
                    document.getElementById('icon').classList.add('icon-LockedState');
                    $A.util.addClass(component.find('clarity'), 'filterSelected');
                    component.set("v.showMoreCount",true); 
                }
                    else if(filter== "Show only Invoices")
                    {
                        filteroptions="Invoice";
                        document.getElementById('icon').classList.add('icon-LockedState');
                        $A.util.addClass(component.find('invoice'), 'filterSelected');
                        component.set("v.showMoreCount",true); 
                    }
                        else if(filter== "Show Only Contracts")
                        {
                            filteroptions="CLM";
                            document.getElementById('icon').classList.add('icon-LockedState');
                            $A.util.addClass(component.find('contracts'), 'filterSelected');
                            component.set("v.showMoreCount",true); 
                        }
        component.set("v.filteroptions",filteroptions);
        var action = component.get("c.getApprovalHomeScreenData");
        action.setCallback(this, function(response) {
            component.set("v.pendingData",response.getReturnValue().PendingApprovals);
            component.set("v.filterview", false);
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
                $A.util.removeClass(component.find('contracts'), 'filterSelected');
                
            }
            else if(filteroptions=="Expense")
            {
                
                document.getElementById('icon').classList.add('icon-LockedState');
                $A.util.removeClass(component.find('all'), 'filterSelected');
                $A.util.addClass(component.find('gtes'), 'filterSelected');
                $A.util.removeClass(component.find('ariba'), 'filterSelected');
                $A.util.removeClass(component.find('clarity'), 'filterSelected');
                $A.util.removeClass(component.find('invoice'), 'filterSelected');
                $A.util.removeClass(component.find('contracts'), 'filterSelected');
            }
                else if(filteroptions=="Purchase Request")
                {
                    document.getElementById('icon').classList.add('icon-LockedState');
                    $A.util.removeClass(component.find('all'), 'filterSelected');
                    $A.util.removeClass(component.find('gtes'), 'filterSelected');
                    $A.util.addClass(component.find('ariba'), 'filterSelected');
                    $A.util.removeClass(component.find('clarity'), 'filterSelected');
                    $A.util.removeClass(component.find('invoice'), 'filterSelected');
                    $A.util.removeClass(component.find('contracts'), 'filterSelected');
                }
                    else if(filteroptions=="Clarity")
                    {
                        
                        document.getElementById('icon').classList.add('icon-LockedState');
                        $A.util.removeClass(component.find('all'), 'filterSelected');
                        $A.util.removeClass(component.find('gtes'), 'filterSelected');
                        $A.util.removeClass(component.find('ariba'), 'filterSelected');
                        $A.util.addClass(component.find('clarity'), 'filterSelected');
                        $A.util.removeClass(component.find('invoice'), 'filterSelected');
                        $A.util.removeClass(component.find('contracts'), 'filterSelected');
                    }
                        else if(filteroptions=="Invoice")
                        {
                            
                            document.getElementById('icon').classList.add('icon-LockedState');
                            $A.util.removeClass(component.find('all'), 'filterSelected');
                            $A.util.removeClass(component.find('gtes'), 'filterSelected');
                            $A.util.removeClass(component.find('ariba'), 'filterSelected');
                            $A.util.removeClass(component.find('clarity'), 'filterSelected');
                            $A.util.addClass(component.find('invoice'), 'filterSelected');
                            $A.util.removeClass(component.find('contracts'), 'filterSelected');
                        }
                            else if(filteroptions=="CLM")
                            {
                                
                                document.getElementById('icon').classList.add('icon-LockedState');
                                $A.util.removeClass(component.find('all'), 'filterSelected');
                                $A.util.removeClass(component.find('gtes'), 'filterSelected');
                                $A.util.removeClass(component.find('ariba'), 'filterSelected');
                                $A.util.removeClass(component.find('clarity'), 'filterSelected');
                                $A.util.removeClass(component.find('invoice'), 'filterSelected');
                                $A.util.addClass(component.find('contracts'), 'filterSelected');
                            }
            document.getElementById('icon').classList.add('icon-currentState');	
        }
        
        else{
            component.set("v.filterview", false);
            document.getElementById('icon').classList.remove('icon-currentState');	
        }
        
    },
    
    ShowMoreSelection : function(component, event, helper) {
        component.set("v.spinnercomp",true); 
        helper.loadMore(component,component.get("v.pendingData"));
    },
    gotoApp : function(component, event, helper) { 
        component.set("v.isFeedBackPopup",false);    
    },
    
})