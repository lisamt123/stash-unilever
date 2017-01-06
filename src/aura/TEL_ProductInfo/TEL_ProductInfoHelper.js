({
    //Retrieves Opportunity
    retrieveProducts : function(component) {
        console.log("Initiating retrieveProducts");
        
        var oppId  = component.get("v.recordId");
        var action = component.get("c.getOpportunity");
        
        action.setParams({
            "oppId" : oppId
        });
        
        component.set("v.enableSpinner", true);
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var opp = response.getReturnValue();
                this.retrieveWrapperProducts(component, opp);
            }
        });
        $A.enqueueAction(action);
        
        console.log("Exiting retrieveProducts");
    },
    
    //Forwards to right retrieval method based on Opportunity Status
    retrieveWrapperProducts : function(component, opp) {
        console.log("Initiating retrieveWrapperProducts");
        
        if(opp.StageName === $A.get("$Label.c.TEL_OppStagePendingCall") || 
           opp.StageName === $A.get("$Label.c.TEL_OppStageScheduled")) 
        {
            var action = component.get("c.getFullProductsList");
            
            action.setParams({
                "oppId" : opp.Id 
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    var fullProdList = response.getReturnValue();
                    this.retrieveOpenProductOrder(component, opp, fullProdList);
                }
            });
            $A.enqueueAction(action);
        } else if(opp.StageName === $A.get("$Label.c.TEL_OppStageReleased") || 
                  opp.StageName === $A.get("$Label.c.TEL_OppStageTransmitted") ||
                  opp.StageName === $A.get("$Label.c.TEL_OppStageCanceled")) 
        {
            this.retrieveClosedProductOrder(component, opp);
        } else if(opp.StageName === $A.get("$Label.c.TEL_OppStageClosedLost")) {
            this.retrieveLostProductOrder(component);
        }
        
        console.log("Exiting retrieveWrapperProducts");
    },
    
    //Retrieves open order products
    retrieveOpenProductOrder : function(component, opp, fullProdList) {
        console.log("Initiating retrieveOpenProductOrder");
        
        var action = component.get("c.getOpenOrderProducts");
        
        action.setParams({
            "oppObjParam" : opp
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var productsList = response.getReturnValue();
                
                
                    for(var prod = 0; prod < productsList.length; prod++) {
                        for(var fullProd = 0; fullProd < fullProdList.length; fullProd++) {
                            if(productsList[prod].productId === fullProdList[fullProd].productId) {
                                fullProdList.splice(fullProd, 1);
                            }
                        }
                    }
                
                
                component.set("v.wrapperProductsList", productsList);
                component.set("v.fullWrapperProductsList", fullProdList);
                component.set("v.renderOpenOrderView", true);
                component.set("v.renderClosedOrderView", false);
                component.set("v.enableSearchBar", true);
                component.set("v.enableSpinner", false);
                
                if(productsList.length === 0) {    
                    component.set("v.showWarning", true);  
                }
            }
        });
        $A.enqueueAction(action);
        
        console.log("Exiting retrieveOpenProductOrder");
    },
    
    //Retrieves released/transmitted opportunity products
    retrieveClosedProductOrder : function(component, opp) {
        console.log("Initiating retrieveClosedProductOrder");
        
        var action = component.get("c.getClosedOrderProducts");     
        action.setParams({
            "oppObjParam" : opp
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var productsList = response.getReturnValue();
            if(state === "SUCCESS" && productsList.length > 0) { 
                component.set("v.wrapperProductsList", productsList);
                component.set("v.renderOpenOrderView", false);
                component.set("v.renderClosedOrderView", true);
                component.set("v.enableSpinner", false);
            }
        });
        $A.enqueueAction(action);
        
        console.log("Exiting retrieveClosedProductOrder");
    },
    
    //Retrieves closed lost message
    retrieveLostProductOrder : function(component) {
        console.log("Initiating retrieveLostProductOrder");
        
        var action = component.get("c.getLostOrderProducts");     
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var productsList = response.getReturnValue();
                component.set("v.wrapperProductsList", productsList);
                component.set("v.renderOpenOrderView", false);
                component.set("v.renderClosedOrderView", false);
                component.set("v.enableSpinner", false);
            }
        });
        $A.enqueueAction(action);
        
        console.log("Exiting retrieveLostProductOrder");
    },
    
    //Retrieves selected products list to show on summary
    retrieveSelectedItemsList : function(component, event) {
        console.log("Initiating retrieveSelectedItemsList");
        
        var action = component.get("c.getSelectedItems");
        var productsList = component.get("v.wrapperProductsList");
        var productsJSON = JSON.stringify(productsList);
        
        action.setParams({
            "productsJSONList" : productsJSON
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var wrapperProductsList = response.getReturnValue();
                
                for(var counter = 0; counter < wrapperProductsList.length; counter++) {
                    if(wrapperProductsList[counter].opportunityId === null || wrapperProductsList[counter].opportunityId === "") {
                        wrapperProductsList[counter].opportunityId = component.get("v.recordId");
                    }
                }
                
                component.set("v.selectedProductsList", wrapperProductsList);
                component.set("v.renderSummaryTable", true);
                component.set("v.disableSummarizeButton", true);
                component.set("v.disableSendOrderButton", false);
                component.set("v.enableSearchBar", false);
            }
        });
        $A.enqueueAction(action);
        
        console.log("Exiting retrieveSelectedItemsList");
    },
    
    //Creates the ordered products on the current Opportunity
    saveOrder : function(component) {
        console.log("Initiating saveOrder");
        
        component.set("v.enableSpinner", true);
        
        var action = component.get("c.createOrder");
        var orderedProductsList = component.get("v.selectedProductsList");
        var orderedProductsJSON = JSON.stringify(orderedProductsList);
        
        action.setParams({
            "orderedProductsJSONList" : orderedProductsJSON
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.renderSummaryTable", false);
                component.set("v.renderOrderTable", true);
                component.set("v.disableSendOrderButton", true);
                component.set("v.enableSpinner", false);
            }
        });
        $A.enqueueAction(action);        
        $A.get('e.force:refreshView').fire();
        
        console.log("Exiting saveOrder");
    },
    
    //Select all products on current list 
    selectAllProducts : function(component, event) {
        console.log("Initiating selectAllProducts");
        
        var productsList = component.get("v.wrapperProductsList");
        if(component.find("selectAll").get("v.value") === true) {
            for(var counter = 0; counter < productsList.length; counter++) {
                productsList[counter].isSelected = true;
            }
        } else {
            for(var counter = 0; counter < productsList.length; counter++) {
                productsList[counter].isSelected = false;
            }
        }
        component.set("v.wrapperProductsList", productsList);
        
        console.log("Exiting selectAllProducts");
    },
    
    //Adds product selected on search bar to current list
    addSelectedProduct : function(component, event, helper) {
        console.log("Initiating addSelectedProduct");
        
        var product = event.getParam("productSelected");
        var openProductsList = component.get("v.wrapperProductsList");
        
        var duplicate = false;
        for(var counter = 0; counter < openProductsList.length; counter++) {
            if(product.productId === openProductsList[counter].productId) {
                duplicate = true;
            }
        }
        
        if(!duplicate) {
            product.isSelected = true;
            openProductsList.push(product);        
            component.set("v.wrapperProductsList", openProductsList);
            component.find("searchBox").set("v.value", "");
            component.set("v.showProductsList", false);
            component.set("v.showWarning", false);
        }
        
        console.log("Exiting addSelectedProduct");
    },
    
    //Fires search bar typíng event
    searchBoxEvent : function(component, event, helper) {
        console.log("Initiating searchBoxEvent");
        
        var text = component.find("searchBox").get("v.value");
        
        if(text.length < 3) {
            component.set("v.showProductsList", false); 
        } else {
            var myEvent = $A.get("e.c:TEL_SearchKeyChange");
            
            myEvent.setParams({
                "searchKey" : text
            });
            
            myEvent.fire(); 
            component.set("v.showProductsList", true);
        }
        
        console.log("Exiting searchBoxEvent");
    },
    
    //Subtracts product amount
    diminishAmount : function(component, event) {
        console.log("Entering diminishAmount");
        
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        var productsList;
        
        if(!component.get("v.renderSummaryTable")) {
            productsList = component.get("v.wrapperProductsList");   
            if(productsList[index].amount > 0) {
                productsList[index].amount -= 1; 
            }
            component.set("v.wrapperProductsList", productsList);
        } else {
            productsList = component.get("v.selectedProductsList");
            if(productsList[index].amount > 0) {
                productsList[index].amount -= 1; 
            }
            component.set("v.selectedProductsList", productsList);
        }
        
        console.log("Exiting diminishAmount");
    },
    
    //Add product amount
    addAmount : function(component, event) {
        console.log("Entering addAmount");
        
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        var productsList;
        
        if(!component.get("v.renderSummaryTable")) {
            productsList = component.get("v.wrapperProductsList"); 
            productsList[index].amount += 1; 
            component.set("v.wrapperProductsList", productsList);
        } else {
            productsList = component.get("v.selectedProductsList");
            productsList[index].amount += 1; 
            component.set("v.selectedProductsList", productsList);
        }
        
        console.log("Exiting addAmount");
    }
    
})