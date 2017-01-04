({
   
    showFilterMenu : function(component, event, helper) {      
        component.set("v.showFilter",true); //
        component.set("v.showSort",false); 
        $("#filterOptions").toggle();
        event.stopPropagation();
	},
    showSortMenu : function(component, event, helper) {      
        component.set("v.showFilter",false); //
        component.set("v.showSort",true); 
        $("#sortOptions").toggle();
        event.stopPropagation();
	},
    
    gotoDetail: function(component, event, helper) {
      
        var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_UpcomingDetail"}).fire();
    },
    gotoRecurring:function(component, event, helper) {
      
        var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_RecurringDetail"}).fire();
    },
})