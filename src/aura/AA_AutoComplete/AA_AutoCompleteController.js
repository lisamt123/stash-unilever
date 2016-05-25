({
	  /**
     * Search an SObject for a match
     */
    search : function(component, event, helper) {
        var lookupListItems = component.find("lookuplist-items");
        lookupListItems.set('v.body',[]);
        helper.doSearch(component);        
    },
 
    /**
     * Select an SObject from a list
     */
    select: function(component, event, helper) {
        helper.handleSelection(component, event);
    },
     
    /**
     * Clear the currently selected SObject
     */
    handleIdClear: function(component, event, helper) {
        component.set("v.wrongBrandName", true);
         var searchString = event.getParam("searchString");
 			console.log("searchString value after clear is==>"+searchString);
        // Set the Id bound to the View
        component.set('v.searchString', searchString); 
        
    }
   
    
})