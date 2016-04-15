({
	//On page load bind the default/previously selected filter option
    updateFilterSelection : function(component, event, helper) {
        var filterStyle = component.find("ASC");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("DES");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        
        var FilterType=component.get("v.sortTopic"); 
        component.set("v.newSelectedFilter",FilterType);
        filterStyle = component.find(FilterType);
        $A.util.addClass(filterStyle, "activeFilterOption"); 
	},      
	//make the All Topics filter option as selected and deselect the previous selected filter option
    sortByAscending: function(component, event, helper) {
        var FilterType=component.get("v.newSelectedFilter");
        var filterStyle = component.find(FilterType);
        $A.util.removeClass(filterStyle, "activeFilterOption");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("ASC");
        $A.util.removeClass(filterStyle, "inactiveFilterOption");
        $A.util.addClass(filterStyle, "activeFilterOption");
        component.set("v.newSelectedFilter","ASC"); 
    },  
	//make the Show Categories filter option as selected and deselect the previous selected filter option
    sortByDescending: function(component, event, helper) {
        var FilterType=component.get("v.newSelectedFilter");
        var filterStyle = component.find(FilterType);
        $A.util.removeClass(filterStyle, "activeFilterOption");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("DES");
        $A.util.removeClass(filterStyle, "inactiveFilterOption");
        $A.util.addClass(filterStyle, "activeFilterOption");
        component.set("v.newSelectedFilter","DES"); 
    },    
	//aplly the selected filter on global news page of home page and redirect into that page    
    applyFilter: function(component, event, helper) {
        var newFilterType=component.get("v.newSelectedFilter");
        console.log('-----------filter----------'+newFilterType);
        var selectEvent = $A.get("e.c:CFC_HandleEvent");
        selectEvent.setParams({"componentName":"CFC_EventList","filterType":component.get("v.filterTopic"),"sortType":newFilterType}).fire();
    },      
	//aplly the selected filter which is already selected in the previous time and apply that filter option on global news page, redirect into that page 
    cancelFilter: function(component, event, helper) {
        var selectEvent = $A.get("e.c:CFC_HandleEvent");
        selectEvent.setParams({"componentName":"CFC_EventList","filterType":component.get("v.filterTopic"),"sortType":component.get("v.sortTopic")}).fire(); 
    },
})