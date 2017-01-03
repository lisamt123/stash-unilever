({
    defaultContent :function(component, event, helper)  {
            var defaultSubTab=component.find('tab-upcoming');
            $A.util.addClass(defaultSubTab,'slds-active');
            var cmpTarget = component.find('upcomingTabContent');
            $A.util.addClass(cmpTarget,'slds-show');
        
    } ,
    
    
})