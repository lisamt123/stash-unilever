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
            if(component.isValid() && state === "SUCCESS"){
                location.reload(true);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
        location.reload(true);
        console.log("Exit <updateList>");
	},
    
    // Updated the list price operator based a list line item.
    updateListPrice : function(component, event, helper) {
        console.log("Entering <updateListPrice>");
        var action = component.get("c.updateValues");
        var productUpdate = component.get('v.productList');
        for(var i=0; i < productUpdate.length; i++){
            if(productUpdate[i].UnitPrice < 0){
                productUpdate[i].UnitPrice = 0;
            }
            if(productUpdate[i].ICB_Purchase_Price__c < 0){
                productUpdate[i].ICB_Purchase_Price__c = 0;
            }
            if(productUpdate[i].ICB_Manufacture_Price__c < 0){
                productUpdate[i].ICB_Manufacture_Price__c = 0;
            }
        }
        action.setParams({ listProduct : productUpdate });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
                location.reload(true);
            }
        });
        
        $A.enqueueAction(action);
        console.log("Exit <updateListPrice>");
    } 
})