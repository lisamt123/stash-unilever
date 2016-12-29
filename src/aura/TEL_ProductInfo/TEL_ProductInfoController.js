({
    doInit : function(component, event, helper) {
        console.log("Initiating doInit");
        
        helper.retrieveProducts(component); 
        
        console.log("Exiting doInit");
    },
    
    getSelectedProducts : function(component, event, helper) {
        console.log("Initiating getSelectedProducts");
        
        helper.retrieveSelectedItemsList(component, event);
        
        console.log("Exiting getSelectedProducts");
    },
    
    sendOrder : function(component, event, helper) {
        console.log("Initiating saveOrder");
        
        helper.saveOrder(component);
        
        console.log("Exiting saveOrder");
    },
    
    checkAllProducts : function(component, event, helper) {
        console.log("Initiating checkAllProducts");
        
        helper.selectAllProducts(component, event);
        
        console.log("Exiting checkAllProducts");
    },
    
    addProduct : function(component, event, helper) {
        console.log("Initiating addProduct");
        
        helper.addSelectedProduct(component, event, helper);
        
        console.log("Exiting addProduct");
    },
    
    searchKeyChange : function(component, event, helper) {
        console.log("Initiating searchKeyChange");
        
        helper.searchBoxEvent(component, event, helper);
        
        console.log("Exiting searchKeyChange");
    },
    
    diminishQuantity : function(component, event, helper) {
        console.log('Entering diminishQuantity');
        
        helper.diminishAmount(component, event);
        
        console.log('Exiting diminishQuantity');
    },
    
    addQuantity : function(component, event, helper) {
        console.log('Entering addQuantity>');
        
        helper.addAmount(component, event);
        
        console.log('Exiting addQuantity');
    }
    
})