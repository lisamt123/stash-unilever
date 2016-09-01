({
	// Retrieve related products and inventory based Account user. 
    doInit: function(component, event, helper) {
        
        var action = component.get("c.getProducts");
        console.log("Entering <action>: " + action);
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.Inventory", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    }, 
    
    setButtonValue : function(component, event, helper){
    	var whichOne	= event.getSource().getLocalId();
        component.set("v.buttonValue", whichOne);
        console.log("Entering <setButtonValue>: ");
	},
    
    // Add quantity product by product line item. 
    addQuantity : function(component, event){
       
        console.log("Entering <addQuantity>: ");
        var selectedItem 	= event.currentTarget; // Get the target object
        var index 			= selectedItem.dataset.record; // Get its value i.e. the index
        var list 			= component.get("v.Inventory");
        var selectedStore 	= component.get("v.Inventory")[index];
        
        // Add +1 to the quantity related product. 
        selectedStore.ICB_Quantity_ToBe_Updated__c  += 1;
        component.set("v.Inventory",list);  
    
    	// Add line item list to event component. 
    	var cmpEvent = component.getEvent("lineItemList");
    	cmpEvent.setParams({
    		"Inventory": "v.Inventory"
		});
		cmpEvent.fire();
    }
})