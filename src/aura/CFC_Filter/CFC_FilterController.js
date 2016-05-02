({
	//On page load bind the default/previously selected filter option
    updateFilterSelection : function(component, event, helper) {
        var filterStyle = component.find("showAll");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("showIT");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("showConsumer");
        $A.util.addClass(filterStyle, "inactiveFilterOption"); 
        filterStyle = component.find("showDigital");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("showMobile");
        $A.util.addClass(filterStyle, "inactiveFilterOption"); 
        filterStyle = component.find("showRND");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("showInnovation");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
                        
        document.body.scrollTop = document.documentElement.scrollTop = 0;
        setTimeout(window.scrollTo(0,0),100);
        
        var FilterType=component.get("v.filterTopic");
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
    showITActive: function(component, event, helper) {
        var FilterType=component.get("v.newSelectedFilter");
        var filterStyle = component.find(FilterType);
        $A.util.removeClass(filterStyle, "activeFilterOption");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("showIT");
        $A.util.removeClass(filterStyle, "inactiveFilterOption");
        $A.util.addClass(filterStyle, "activeFilterOption");
        component.set("v.newSelectedFilter","showIT");
    },     
	//make the Innovation filter option as selected and deselect the previous selected filter option
    showConsumerActive: function(component, event, helper) {
        var FilterType=component.get("v.newSelectedFilter");
        var filterStyle = component.find(FilterType);
        $A.util.removeClass(filterStyle, "activeFilterOption");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("showConsumer");
        $A.util.removeClass(filterStyle, "inactiveFilterOption");
        $A.util.addClass(filterStyle, "activeFilterOption");
        component.set("v.newSelectedFilter","showConsumer");
    },     
	//make the Leadership filter option as selected and deselect the previous selected filter option
    showDigitalActive: function(component, event, helper) {
        var FilterType=component.get("v.newSelectedFilter");
        var filterStyle = component.find(FilterType);
        $A.util.removeClass(filterStyle, "activeFilterOption");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("showDigital");
        $A.util.removeClass(filterStyle, "inactiveFilterOption");
        $A.util.addClass(filterStyle, "activeFilterOption");
        component.set("v.newSelectedFilter","showDigital");
    }, 
	//make the Market Place filter option as selected and deselect the previous selected filter option
    showMobileActive: function(component, event, helper) {
        var FilterType=component.get("v.newSelectedFilter");
        var filterStyle = component.find(FilterType);
        $A.util.removeClass(filterStyle, "activeFilterOption");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("showMobile");
        $A.util.removeClass(filterStyle, "inactiveFilterOption");
        $A.util.addClass(filterStyle, "activeFilterOption");
        component.set("v.newSelectedFilter","showMobile");
    }, 
	//make the People filter option as selected and deselect the previous selected filter option
    showRNDActive: function(component, event, helper) {
        var FilterType=component.get("v.newSelectedFilter");
        var filterStyle = component.find(FilterType);
        $A.util.removeClass(filterStyle, "activeFilterOption");
        $A.util.addClass(filterStyle, "inactiveFilterOption");
        filterStyle = component.find("showRND");
        $A.util.removeClass(filterStyle, "inactiveFilterOption");
        $A.util.addClass(filterStyle, "activeFilterOption");
        component.set("v.newSelectedFilter","showRND");
    },     
	//make the Performance filter option as selected and deselect the previous selected filter option     
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
	//aplly the selected filter on global news page of home page and redirect into that page    
    applyFilter: function(component, event, helper) {
        var newFilterType=component.get("v.newSelectedFilter");
        console.log('-----------filter----------'+newFilterType);
        var selectEvent = $A.get("e.c:CFC_HandleEvent");
        selectEvent.setParams({"componentName":"CFC_EventList","filterType":newFilterType,"sortType":component.get("v.sortTopic")}).fire();
    },      
	//aplly the selected filter which is already selected in the previous time and apply that filter option on global news page, redirect into that page 
    cancelFilter: function(component, event, helper) {
        var selectEvent = $A.get("e.c:CFC_HandleEvent");
        selectEvent.setParams({"componentName":"CFC_EventList","filterType":component.get("v.filterTopic"),"sortType":component.get("v.sortTopic")}).fire();
    },
})