({
    getContacts : function(component) 
    {
        console.log('Entering Helper <getContacts>');
        var action = component.get("c.getContacts");
        action.setParams({
            "isClosed" : true
        });
        action.setCallback(this,function(response){
            var contactsList = response.getReturnValue();
            var state = response.getState();
            if((contactsList != null)&&(contactsList.length > 0) && (component.isValid() && state === "SUCCESS"))
            {
                component.set("v.listContacts", contactsList);        
            }
        });
        $A.enqueueAction(action);
        console.log('Exit Helper <getContacts>');
    },
    getProducts : function(component,accountName,idContact,list) 
    {
        console.log('Entering Helper <getProducts>');
        var action = component.get("c.getInventories");
        action.setParams({
            "accountName" : accountName,
            "operation" : "closed",
            "idContact" : idContact
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            var listPricebook = response.getReturnValue();
            if((listPricebook != null) && (listPricebook.length > 0) && (component.isValid() && state === "SUCCESS"))
            {
                component.set("v.inventoryList",listPricebook);
            }
            component.set("v.listContacts",list);
        });
        $A.enqueueAction(action);
        console.log('Exit Helper <getProducts>');
    },
    changeCheck : function(component,event, checkBox){
        console.log('Entering Helper <changeCheck>');
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        var indexOld = component.get("v.indexOld");
        var list = component.get("v.listContacts");
        var priceList = component.get("v.inventoryList");
        var selectedStore = component.get("v.listContacts")[index];
        
        if(priceList != null){
            if(checkBox == "button"){
                if(selectedStore.checkButton){
                    selectedStore.checkButton = false;
                    component.set("v.listContacts",list);
                }else{
                    selectedStore.checkButton = true;
                    if(indexOld != index){
                        list[indexOld].checkButton = false;
                        component.set("v.indexOld",index);
                    }
                    this.getProducts(component,selectedStore.contactItem.Account.Name,selectedStore.contactItem.Id,list);        
                }
            }else{
                if(selectedStore.oppItem.StageName == "Available"){
                    selectedStore.oppItem.StageName = "Closed"; 
                    selectedStore.check = true;
                    this.getProducts(component,selectedStore.contactItem.Account.Name,selectedStore.contactItem.Id,list);  
                    this.oppItemUpdate(component,selectedStore.contactItem.Id);
                }                
                var listJSON=JSON.stringify(priceList);
                var action = component.get("c.updateOpportunity");
                action.setParams({
                    "opp" : selectedStore.oppItem,
                    "listJson" : listJSON,
                    "isClosed" : true
                });
                action.setCallback(this,function(response){
                    var state = response.getState();
                    if(component.isValid() && state === "SUCCESS"){
                        location.reload(true);
                    }
                });
                $A.enqueueAction(action);
            }
            //component.set("v.listContacts",list);
        }
        console.log('Exit Helper <changeCheck>');
    },
    oppItemUpdate : function(component,idContact){
        console.log('Entering Helper <oppItemUpdate>');
        var listIvt = component.get("v.inventoryList");
        var listJSON=JSON.stringify(listIvt);
        var action = component.get("c.updateOppItem");
        
        action.setParams({
            "inventoryList" : listJSON,
            "operation" : "closed",
            "idContact" : idContact
        });
        
        
        $A.enqueueAction(action);
        console.log('Exit Helper <oppItemUpdate>');
    }
})