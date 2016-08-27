({
   
    doInit: function(component, event, helper) {
        // Create the action
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
        helper.load(component);
    }, 
    
    increaseValue : function(component, event, helper) {
		helper.increase(component, event);
       
    },
    
    decreaseValue : function(component, event, helper){        
        helper.decrease(component, event);
        
    }
    
})