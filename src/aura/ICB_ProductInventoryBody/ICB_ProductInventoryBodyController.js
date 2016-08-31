({
    // Load Products from Salesforce
    doInit: function(component, event, helper) {
        // Create the action
        var action = component.get("c.getProducts");
        console.log("Entering <action>: " + action);
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            var numberProduct;
            var title;
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.Inventory", response.getReturnValue());
                component.get("v.Inventory")
                numberProduct = component.get("v.Inventory");
                component.set("v.count",numberProduct.length); 
                if(numberProduct.length > 1){
                    console.log("numberProduct: " + numberProduct.length) ;
                    title = $A.get("$Label.c.ICB_INVENTORY_HEADER_SUB_TITLE");
                    component.set("v.HeaderTitle",title);
                    
                }else{
                    title = $A.get("$Label.c.ICB_INVENTORY_HEADER_SUB_TITLES");
                    component.set("v.HeaderTitle",title);
                }
                
            }else {
                console.log("Failed with state: " + state);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    posiviteAdd : function(component, event, helper){
        var selectedItem = event.currentTarget; // Get the target object
        var index = selectedItem.dataset.record; // Get its value i.e. the index
        var list = component.get("v.Inventory");
        var selectedStore = component.get("v.Inventory")[index];
        selectedStore.ICB_Quantity_Unit__c +=1;
        
        component.set("v.Inventory",list);
        
    },
    
    negativeAdd : function(component, event, helper){
        
        var selectedItem = event.currentTarget; // Get the target object
        var index = selectedItem.dataset.record; // Get its value i.e. the index
        console.log("entrou aki Index: " + index);
        var list = component.get("v.Inventory");
        var selectedStore = component.get("v.Inventory")[index];
        if (selectedStore.ICB_Quantity_Unit__c > 0){
            selectedStore.ICB_Quantity_Unit__c -=1;
        }
        component.set("v.Inventory",list);
    },
    
    whatButton : function(component, event, helper){
        var whichOne = event.getSource().getLocalId();
        console.log(whichOne);    
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
	}
})