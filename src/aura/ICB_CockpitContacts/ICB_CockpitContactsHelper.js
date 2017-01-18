({
    getContacts : function(component) 
    {
        console.log('Entering Helper <getContacts>' );
        var action = component.get("c.getContacts");
         action.setParams({
            "isClosed" : false
        });
        action.setCallback(this,function(response){
            var contactsList = response.getReturnValue();
            var state = response.getState();
            if((contactsList != null) && (contactsList.length > 0) && (component.isValid() && state === "SUCCESS")){
                component.set("v.listContacts", contactsList);
            }
        });
        $A.enqueueAction(action);
       
        console.log('Exit Helper <getContacts>: ' + component.get("v.listContacts"));
    },
    getProducts : function(component,indexContact,accountName,idContact,list) 
    {
        console.log('Entering Helper <getProducts>');
        var action = component.get("c.getInventories");
        action.setParams({
            "accountName" : accountName,
            "operation" : "open",
            "idContact" : idContact
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            var listInventory = response.getReturnValue();
            if((listInventory != null) && (listInventory.length > 0) && (component.isValid() && state === "SUCCESS")){
                component.set("v.inventoryList",listInventory);
                for(var i=0; i < listInventory.length; i++){
                    if(listInventory[i].quantityMin > 0){
                        list[indexContact].isDisabled = false;
                    }
                }
            }
            //list[indexContact].spinnerShow = false;
            component.set("v.listContacts",list);
        });
        $A.enqueueAction(action);
        console.log('Exit Helper <getProducts>');
    },
    changeButton : function(component,event, checkBox){
        
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        var indexOld = component.get("v.indexOld");
        var list = component.get("v.listContacts");
        var priceList = component.get("v.inventoryList");
        var selectedStore = list[index];
        //list[index].spinnerShow = true;
        //component.set("v.listContacts",list);
        if(priceList != null){
            if(selectedStore.checkButton){
                selectedStore.checkButton = false;
                component.set("v.listContacts",list);
            }else{
                selectedStore.checkButton = true;
                if(indexOld != index){
                    list[indexOld].checkButton = false;
                    component.set("v.indexOld",index);
                }
                this.getProducts(component,index,selectedStore.contactItem.Account.Name,selectedStore.contactItem.Id,list); 
            }
            component.set("v.indexContact", index);
        }
        //if(!selectedStore.checkButton){
          //  list[index].spinnerShow = false;
        //}
    },
    changeCheck : function(component,event, checkBox){
        console.log('Entering Helper <changeCheck>');
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        var indexOld = component.get("v.indexOld");
        var list = component.get("v.listContacts");
        var priceList = component.get("v.inventoryList");
        var selectedStore = component.get("v.listContacts")[index];
        var mapIvt = {};
        
        if(priceList != null){
            if(selectedStore.oppItem.StageName == "Pending"){
                selectedStore.oppItem.StageName = "Available";
                selectedStore.check = true;
                for(var i=0; i < priceList.length; i++){
                    mapIvt[i] = priceList[i].quantity;
                    component.set("v.mapInventory", mapIvt);
                    priceList[i].quantity = 0;
                }
            }else{
                selectedStore.oppItem.StageName = "Pending";
                selectedStore.check = false;
                var mapIvtAtt = component.get("v.mapInventory");
                for(var i=0; i < priceList.length; i++){
                    priceList[i].quantity = mapIvtAtt[i];
                }        
            }
            var action = component.get("c.updateOpportunity");
            action.setParams({
                "opp" : selectedStore.oppItem,
                "listJson" : "",
                "isClosed" : false
            });
            $A.enqueueAction(action);
        } 
        component.set("v.listContacts",list); 
        //}
       console.log('Exit Helper <changeCheck>');
    },
    createOpportunity : function(component,event){
        console.log('Entering Helper <createOpportunity>');
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        var selectedStore = component.get("v.listContacts")[index];
        var list = component.get("v.inventoryList");
        var action = component.get("c.createOpportunity");
        var listJSON=JSON.stringify(list);
        action.setParams({
            "idContact" : selectedStore.contactItem.Id,
            "oppName" : selectedStore.contactItem.Name,
            "accountName" : selectedStore.contactItem.Account.Name,
            "idAccount" : selectedStore.contactItem.AccountId,
            "inventoryList" : listJSON
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
                location.reload(true);
            }
        });
        $A.enqueueAction(action);
        console.log('Exit Helper <createOpportunity>');
    },
    oppItemUpdate : function(component,event,idContact){
        console.log('Entering Helper <oppItemUpdate>');
        var list = component.get("v.inventoryList");
        var listJSON=JSON.stringify(list);
        var action = component.get("c.updateOppItem");
        action.setParams({
            "inventoryList" : listJSON,
            "operation" : "open",
            "idContact" : idContact
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
                location.reload(true);
            }
        });
        $A.enqueueAction(action);
        console.log('Exit Helper <oppItemUpdate>');
    }
})