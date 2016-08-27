({
    doInit: function(component, event, helper) {
        // Create the action
        console.log("doInit: " + component);
        var action = component.get("c.getProductPrice");
        var numberProduct;
        var title;
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.products", response.getReturnValue());
                numberProduct = component.get("v.products");
                component.set("v.listSize", numberProduct.length); 
                
                if(numberProduct.length > 1){
                    title = $A.get("$Label.c.ICB_PRICELIST_HEADER_SUB_TITLES");
                    component.set("v.HeaderTitle", title);
                    
                }else{
                    title = $A.get("$Label.c.ICB_PRICELIST_HEADER_SUB_TITLE");
                    component.set("v.HeaderTitle", title);
                }
                
            }else {
                console.log("Failed with state: " + state);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    loadProducts : function(component, event, helper) {
        console.log("loadProducts: " + component);
        helper.load(component);
    }, 
    
    increaseSalesPrice : function(component, event, helper) {
        console.log("increaseSalesPrice: " + component);
        helper.increaseSP(component, event);
        
    },
    
    decreaseSalesPrice : function(component, event, helper){
        console.log("decreaseSalesPrice: " + component);
        helper.decreaseSP(component, event);
        
    },
    
    increasePurchase : function(component, event, helper) {
        console.log("increasePurchase: " + component);
        helper.addPurchase(component, event);
    },
    
    decreasePurchase : function(component, event, helper) {
        console.log("decreasePurchase: " + component);
        helper.cutPurchase(component, event);
    },
    
    increaseManufacturePrice : function(component, event, helper) {
        console.log("increaseManufacturePrice: " + component);
        helper.addManufacture(component, event);
    },
    
    decreaseManufacturePrice : function(component, event, helper) {
        console.log("decreaseManufacturePrice: " + component);
        helper.decreaseManufacture(component, event);
    }
})