({
	//On page load bind the default/previously selected filter option
    updateFilterSelection : function(component, event, helper) {
        var filterStyle = component.find("showAll");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("showCategories");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("showInnovation");
        $A.util.addClass(filterStyle, "inactiveFilterOption"); 
        filterStyle = component.find("showLeadership");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("showMarketplace");
        $A.util.addClass(filterStyle, "inactiveFilterOption"); 
        filterStyle = component.find("showPeople");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("showPerformance");
        $A.util.addClass(filterStyle, "inactiveFilterOption"); 
        filterStyle = component.find("showSustainable");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
                        
        document.body.scrollTop = document.documentElement.scrollTop = 0;
        setTimeout(window.scrollTo(0,0),100);
        
        var FilterType=component.get("v.selectedFilter");
        component.set("v.newSelectedFilter",FilterType);
        filterStyle = component.find(FilterType);
        $A.util.addClass(filterStyle, "activeFilterOption");                 
	},      
	//make the All Topics filter option as selected and deselect the previous selected filter option
    showAllActive: function(component, event, helper) {
        var FilterType=component.get("v.newSelectedFilter");
        var filterStyle = component.find(FilterType);
        $A.util.removeClass(filterStyle, "activeFilterOption");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("showAll");
        $A.util.removeClass(filterStyle, "inactiveFilterOption");
        $A.util.addClass(filterStyle, "activeFilterOption");
        component.set("v.newSelectedFilter","showAll");
    },  
	//make the Show Categories filter option as selected and deselect the previous selected filter option
    showCategoriesActive: function(component, event, helper) {
        var FilterType=component.get("v.newSelectedFilter");
        var filterStyle = component.find(FilterType);
        $A.util.removeClass(filterStyle, "activeFilterOption");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("showCategories");
        $A.util.removeClass(filterStyle, "inactiveFilterOption");
        $A.util.addClass(filterStyle, "activeFilterOption");
        component.set("v.newSelectedFilter","showCategories");
    },     
	//make the Innovation filter option as selected and deselect the previous selected filter option
    showInnovationActive: function(component, event, helper) {
        var FilterType=component.get("v.newSelectedFilter");
        var filterStyle = component.find(FilterType);
        $A.util.removeClass(filterStyle, "activeFilterOption");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("showInnovation");
        $A.util.removeClass(filterStyle, "inactiveFilterOption");
        $A.util.addClass(filterStyle, "activeFilterOption");
        component.set("v.newSelectedFilter","showInnovation");
    },     
	//make the Leadership filter option as selected and deselect the previous selected filter option
    showLeadershipActive: function(component, event, helper) {
        var FilterType=component.get("v.newSelectedFilter");
        var filterStyle = component.find(FilterType);
        $A.util.removeClass(filterStyle, "activeFilterOption");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("showLeadership");
        $A.util.removeClass(filterStyle, "inactiveFilterOption");
        $A.util.addClass(filterStyle, "activeFilterOption");
        component.set("v.newSelectedFilter","showLeadership");
    }, 
	//make the Market Place filter option as selected and deselect the previous selected filter option
    showMarketplaceActive: function(component, event, helper) {
        var FilterType=component.get("v.newSelectedFilter");
        var filterStyle = component.find(FilterType);
        $A.util.removeClass(filterStyle, "activeFilterOption");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("showMarketplace");
        $A.util.removeClass(filterStyle, "inactiveFilterOption");
        $A.util.addClass(filterStyle, "activeFilterOption");
        component.set("v.newSelectedFilter","showMarketplace");
    }, 
	//make the People filter option as selected and deselect the previous selected filter option
    showPeopleActive: function(component, event, helper) {
        var FilterType=component.get("v.newSelectedFilter");
        var filterStyle = component.find(FilterType);
        $A.util.removeClass(filterStyle, "activeFilterOption");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("showPeople");
        $A.util.removeClass(filterStyle, "inactiveFilterOption");
        $A.util.addClass(filterStyle, "activeFilterOption");
        component.set("v.newSelectedFilter","showPeople");
    },     
	//make the Performance filter option as selected and deselect the previous selected filter option     
    showPerformanceActive: function(component, event, helper) {
        var FilterType=component.get("v.newSelectedFilter");
        var filterStyle = component.find(FilterType);
        $A.util.removeClass(filterStyle, "activeFilterOption");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("showPerformance");
        $A.util.removeClass(filterStyle, "inactiveFilterOption");
        $A.util.addClass(filterStyle, "activeFilterOption");
        component.set("v.newSelectedFilter","showPerformance");
    }, 
	//make the Sustainable filter option as selected and deselect the previous selected filter option
    showSustainableActive: function(component, event, helper) {
        var FilterType=component.get("v.newSelectedFilter");
        var filterStyle = component.find(FilterType);
        $A.util.removeClass(filterStyle, "activeFilterOption");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("showSustainable");
        $A.util.removeClass(filterStyle, "inactiveFilterOption");
        $A.util.addClass(filterStyle, "activeFilterOption");
        component.set("v.newSelectedFilter","showSustainable");
    },    
	//aplly the selected filter on global news page of home page and redirect into that page    
    applyFilter: function(component, event, helper) {
        var newFilterType=component.get("v.newSelectedFilter");
        console.log('-----------filter----------'+newFilterType);
        var selectEvent = $A.get("e.c:CORE_NC_FilterEvent");
        selectEvent.setParams({"selectedFilter": newFilterType,"displayFilterPage":false }).fire();
    },      
	//aplly the selected filter which is already selected in the previous time and apply that filter option on global news page, redirect into that page 
    cancelFilter: function(component, event, helper) {
        var FilterType=component.get("v.selectedFilter");
        var selectEvent = $A.get("e.c:CORE_NC_FilterEvent");
        selectEvent.setParams({"selectedFilter": FilterType,"displayFilterPage":false }).fire();
    },
})