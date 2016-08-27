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
        selectedStore.ICB_Quantity_ToBe_Updated__c +=1;
        
        component.set("v.Inventory",list);
        
    },
    
    negativeAdd : function(component, event, helper){
        
        var selectedItem = event.currentTarget; // Get the target object
        var index = selectedItem.dataset.record; // Get its value i.e. the index
        console.log("entrou aki Index: " + index);
        var list = component.get("v.Inventory");
        var selectedStore = component.get("v.Inventory")[index];
        if (selectedStore.ICB_Quantity_ToBe_Updated__c > 0){
            selectedStore.ICB_Quantity_ToBe_Updated__c -=1;
        }
        component.set("v.Inventory",list);
    },
    
    whatButton : function(component, event, helper){
        var whichOne = event.getSource().getLocalId();
        console.log(whichOne);    
    }
})