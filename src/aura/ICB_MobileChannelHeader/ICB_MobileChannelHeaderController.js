({
    // Retrieve the line items from event. 
	handleInventoryList : function(component, event, helper) {
		console.log("Entering <callUpdateInventory>");
      	var list = event.getParam("inventory");
        component.set("Inventory", list);
        console.log("Exit <callUpdateInventory>");
	},
    
    // Updated the inventory operator based a list line item list.
    updateList : function(component, event, helper){
        console.log("Entering <updateList>");
    	var action = component.get("c.updateOperatorInventory");
        var inventoryToBeUpdate = component.get('v.Inventory');
        console.log("inventoryToBeUpdate <List>"+ inventoryToBeUpdate);
        var listJSON=JSON.stringify(inventoryToBeUpdate);
        console.log("listJSON"+ listJSON);
        action.setParams({ "listJson" : listJSON });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
        location.reload(true);
        console.log("Exit <updateList>");
	},
    updateListPrice : function(component, event, helper) {
        console.log("Entering <updateListPrice>");
        var action = component.get("c.updateValues");
        var productUpdate = component.get('v.productList');
        action.setParams({ listProduct : productUpdate });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();        
        });
        
        $A.enqueueAction(action);
        location.reload(true);
        console.log("Exit <updateListPrice>");
    } 
}
})