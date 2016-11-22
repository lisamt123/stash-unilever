({
    // Retrieve the line items from event. 
	handleInventoryList : function(component, event, helper) {
		
        console.log("Entering <callUpdateInventory>");
      	var list = event.getParam("inventory");
        component.set("Inventory", list);
	},
    
    // Updated the inventory operator based a list line item list.
    updateList : function(component, event, helper){
    
    	console.log("Entering <updateList>: ");
    	var action = component.get("c.updateOperatorInventory");
        console.log("aaa:"+ component.get('v.Inventory'));
    	var inventoryToBeUpdate = component.get('v.Inventory');
        console.log("inventoryToBeUpdate:"+ inventoryToBeUpdate);
    	action.setParams({ lineItems : inventoryToBeUpdate });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            
        });
        
        // Send action off to be executed
        
        $A.enqueueAction(action);
        location.reload(true);
	} 
})