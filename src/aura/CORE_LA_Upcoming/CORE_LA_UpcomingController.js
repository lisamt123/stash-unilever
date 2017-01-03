({
    showFilterMenu : function(component, event, helper) {      
        component.set("v.showFilter",true); //
        component.set("v.showSort",false); 
       
       var sortList = component.find('sortOptions');
       $A.util.removeClass(sortList,'slds-show');
       $A.util.addClass(filterList,'slds-hide');
        
       var filterList=component.find('filterOptions');
       $A.util.addClass(filterList,'slds-show');
       $A.util.removeClass(sortList,'slds-hide');
        
       var filterDefault=component.find('filterDefault');
       $A.util.addClass(filterDefault,'slds-active');
       
	},
    showSortMenu : function(component, event, helper) {      
        component.set("v.showFilter",false); //
        component.set("v.showSort",true); 
    
      var sortList = component.find('sortOptions');
       $A.util.addClass(filterList,'slds-show');
       $A.util.removeClass(sortList,'slds-hide');
        
       var filterList=component.find('filterOptions');
       $A.util.removeClass(sortList,'slds-show');
       $A.util.addClass(filterList,'slds-hide');
        
       var sortDefault=component.find('sortDefault');
       $A.util.addClass(sortDefault,'slds-active');
	},
    
    gotoDetail: function(component, event, helper) {
      
        var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_UpcomingDetail"}).fire();
    },

})