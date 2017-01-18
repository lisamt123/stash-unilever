({
    search : function(component, event, helper) {
        var lookupListItems = component.find("lookuplist-items");
        lookupListItems.set('v.body',[]);
        helper.doSearch(component, event, helper);        
    },
    select: function(component, event, helper) {
        helper.handleSelection(component, event);
    },
    handleIdClear: function(component, event, helper) {
        var searchString = event.getParam("searchString");
        component.set('v.searchString', searchString); 
    },
    handleSearchString: function(component, event, helper) {
        var searchString=event.getParam("searchString");
        component.set('v.searchString', searchString);
    },
})