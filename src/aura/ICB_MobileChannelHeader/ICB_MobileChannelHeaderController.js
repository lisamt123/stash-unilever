({
    // Retrieve the line items from event. 
	handleInventoryList : function(component, event) {
		helper.handleInventoryList(component, event);
	},
    
    // Updated the inventory operator based a list line item list.
    updateList : function(component, event){
        helper.updateList(component, event);
	},
    
    // Updated the list price operator based a list line item.
    updateListPrice : function(component, event, helper) {
    	helper.updateListPrice(component, event);
    } 
})