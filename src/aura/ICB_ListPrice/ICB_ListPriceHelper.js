({
	load : function(component) {
        console.log("Entering <load>");
        var action = component.get("c.getProducts");
        action.setCallback(this, function(data) {
            component.set("v.products", data.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    increaseSP : function(component, event) {
        console.log("Entering <increaseSP>");
        var selectedItem 	= event.currentTarget; // Get the target object      
        var index 			= selectedItem.dataset.record; // Get its value i.e. the index
        var list 			= component.get("v.products");
        var selectedStore 	= component.get("v.products")[index];  
        selectedStore.UnitPrice +=1.00;
        component.set("v.products",list);
        
    },
    
    decreaseSP : function(component, event) {
        console.log("Entering <decreaseSP>");
        var selectedItem = event.currentTarget; // Get the target object
        var index = selectedItem.dataset.record; // Get its value i.e. the index
        var list = component.get("v.products");
        var selectedStore = component.get("v.products")[index];
        
        if (selectedStore.UnitPrice > 0.99){
            selectedStore.UnitPrice -= 1.00;
        } else {
             if (selectedStore.UnitPrice <= 0.99 & selectedStore.UnitPrice >= 0.01){
             	selectedStore.UnitPrice -= 0.01;
             }
        }
        
        component.set("v.products",list);
    },
    
    addPurchase : function (component, event){
        console.log("Entering <increasePurchase>: "+event);
        var selectedItem 	= event.currentTarget; // Get the target object
        var index 			= selectedItem.dataset.record; // Get its value i.e. the index
        var list 			= component.get("v.products");
        var selectedStore 	= component.get("v.products")[index];
        console.log("Entering <selectedStore>: "+selectedStore);
        selectedStore.ICB_Purchase_Price__c +=1.00;
        component.set("v.products",list);
    },
    
    cutPurchase : function (component, event){
        console.log("Entering <cutPurchase>");
        var selectedItem 	= event.currentTarget; // Get the target object
        var index 			= selectedItem.dataset.record; // Get its value i.e. the index
        var list 			= component.get("v.products");
        var selectedStore 	= component.get("v.products")[index];

       if (selectedStore.ICB_Purchase_Price__c > 0.99){
            selectedStore.ICB_Purchase_Price__c -= 1.00;
        } else {
             if (selectedStore.ICB_Purchase_Price__c < 0.99 & selectedStore.ICB_Purchase_Price__c > 0.01){
             	selectedStore.ICB_Purchase_Price__c -= 0.01;
             }
        }
        component.set("v.products",list);
    },
    
    addManufacture : function (component, event){
        console.log("Entering <addManufacture>: "+event);
        var selectedItem 	= event.currentTarget; // Get the target object
        var index 			= selectedItem.dataset.record; // Get its value i.e. the index
        var list 			= component.get("v.products");
        var selectedStore 	= component.get("v.products")[index];
        console.log("Entering <selectedStore>: "+selectedStore);
        selectedStore.ICB_Manufacture_Price__c +=1.00;
        component.set("v.products",list);
    },
    
    decreaseManufacture : function (component, event){
        console.log("Entering <decreaseManufacture>");
        var selectedItem 	= event.currentTarget; // Get the target object
        var index 			= selectedItem.dataset.record; // Get its value i.e. the index
        var list 			= component.get("v.products");
        var selectedStore 	= component.get("v.products")[index];

        if (selectedStore.ICB_Manufacture_Price__c > 0.99){
            selectedStore.ICB_Manufacture_Price__c -= 1.00;
        } else {
             if (selectedStore.ICB_Manufacture_Price__c < 0.99 & selectedStore.ICB_Manufacture_Price__c > 0.01){
             	selectedStore.ICB_Manufacture_Price__c -= 0.01;
             }
        }
        component.set("v.products",list);
    }
})