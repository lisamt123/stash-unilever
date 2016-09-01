({
    
    updateList : function(component, event, helper) {
        var action = component.get("c.updateValues");
        var productUpdate = component.get('v.productList');
        action.setParams({ listProduct : productUpdate });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();        
        });
        
        $A.enqueueAction(action);
        location.reload(true);
    } 
}
 })