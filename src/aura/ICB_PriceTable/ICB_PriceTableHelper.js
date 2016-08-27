({
    load : function(component) {
        var action = component.get("c.getProducts");
        action.setCallback(this, function(data) {
            component.set("v.products", data.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    increase : function(component, event) {
        var selectedItem = event.currentTarget; // Get the target object      
        var index = selectedItem.dataset.record; // Get its value i.e. the index
        var list = component.get("v.products");
        var selectedStore = component.get("v.products")[index];
        selectedStore.UnitPrice += 1;
        component.set("v.products",list);
        
    },
    
    decrease : function(component, event) {
        
        var selectedItem = event.currentTarget; // Get the target object
        var index = selectedItem.dataset.record; // Get its value i.e. the index
        var list = component.get("v.products");
        var selectedStore = component.get("v.products")[index];
        if(selectedStore.UnitPrice >= 1 || selectedStore.UnitPrice == null) {
            selectedStore.UnitPrice = selectedStore.UnitPrice - 1.0;
        }
        
        component.set("v.products",list);
    }
    
})