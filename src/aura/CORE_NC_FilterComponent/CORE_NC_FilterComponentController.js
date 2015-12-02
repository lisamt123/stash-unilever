({
	
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
    
    applyFilter: function(component, event, helper) {
        var newFilterType=component.get("v.newSelectedFilter");
        console.log('-----------filter----------'+newFilterType);
        var selectEvent = $A.get("e.c:CORE_NC_FilterEvent");
        selectEvent.setParams({"selectedFilter": newFilterType,"displayFilterPage":false }).fire();
    },      
    cancelFilter: function(component, event, helper) {
        var FilterType=component.get("v.selectedFilter");
        var selectEvent = $A.get("e.c:CORE_NC_FilterEvent");
        selectEvent.setParams({"selectedFilter": FilterType,"displayFilterPage":false }).fire();
    },
      
    doneRendering: function(component, event, helper) {
       
        //document.body.scrollTop = document.documentElement.scrollTop = 0;
        //setTimeout(window.scrollTo(0,0),2000);
        window.scrollTo(0,0);
        document.getElementById("test").focus();
        //alert("Hello"+document.getElementById("test"));
        
    }
})