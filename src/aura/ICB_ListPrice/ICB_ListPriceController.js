({
    doInit: function(component, event, helper) {
        helper.doInit(component,event);
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