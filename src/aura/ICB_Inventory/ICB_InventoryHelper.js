({
    incrementValueOpen : function(component,event){
        console.log('Entering Helper <incrementValueOpen>');
        var inventory = component.get("v.inventory");
        if(inventory.quantity  < (inventory.invetoryItem.ICB_Quantity_Unit__c + inventory.quantityMin)){
            //if(inventory.quantity < (inventory.invetoryItem.ICB_Quantity_Unit__c + inventory.quantityMin)){
                inventory.quantity +=1; 
            //}
        }
        component.set("v.inventory",inventory); 
        console.log('Exit Helper <incrementValueOpen>');
    },
    decrementValueOpen : function(component,event){
        console.log('Entering Helper <decrementValueOpen>');
        var inventory = component.get("v.inventory");
        if(inventory.quantity > 0 ){
            if(inventory.quantityMin > 0){
                if(inventory.quantity > inventory.quantityMin){
                    inventory.quantity -=1; 
                }
            }else{
                inventory.quantity -=1; 
            }
        }
        component.set("v.inventory",inventory); 
        console.log('Exit Helper <decrementValueOpen>');
    },
    incrementValueClosed : function(component,event){
        console.log('Entering Helper <incrementValueClosed>');
        var inventory = component.get("v.inventory");
        if(inventory.quantityReturned > inventory.quantity){
            inventory.quantity +=1; 
            component.set("v.inventory",inventory); 
        }
        console.log('Exit Helper <incrementValueClosed>');
    },
    decrementValueClosed : function(component,event){
        console.log('Entering Helper <decrementValueClosed>');
        var inventory = component.get("v.inventory");
        if(inventory.quantity > 0){
            inventory.quantity -=1;
            component.set("v.inventory",inventory); 
        }
        
        console.log('Exit Helper <decrementValueClosed>');
    }
    
})