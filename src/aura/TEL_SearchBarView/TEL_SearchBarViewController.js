({
    doInit : function(component, event) {
        console.log("Initiating SearchBarView doInit ");
        
        component.set("v.searchedProductsList", "v.fullWrapperProductsList");
        
        console.log("Exiting SearchBarView doInit");
    },
    
    searchKeyChange1 : function(component, event, helper) {
        console.log("Initiating searchKeyChange");
        
        helper.setSearchedProducts(component, event);
        
        console.log("Exiting searchKeyChange");
    },
    
    addProduct : function(component, event, helper) {
        console.log("Initiating searchKeyChange");
        
        helper.setAddProductEvent(component, event); 
        
        console.log("Exiting searchKeyChange");
    }
})