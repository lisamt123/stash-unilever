({
    setSearchedProducts : function(component, event) {
        console.log("Initiating setSearchedProducts ");
        
        var searchKey = event.getParam("searchKey");
        var fullProdList = component.get("v.fullWrapperProductsList");
        var searchedProdList = [];
        
        for(var counter = 0; counter < fullProdList.length; counter++) {
            var prodName = "" + fullProdList[counter].name;
            if(prodName.toLowerCase().indexOf(searchKey.toLowerCase()) !== -1) {
                searchedProdList.push(fullProdList[counter]);
            }
        }
        
        component.set("v.searchedProductsList", searchedProdList);
        
        console.log("Exiting setSearchedProducts ");
    }, 
    
    setAddProductEvent : function(component, event) {
        console.log("Initiating setAddProductEvent ");
        
        var fireEvent = component.getEvent("addProduct");
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        var list = component.get("v.searchedProductsList");
        
        fireEvent.setParams({
            "productSelected" : list[index]
        });
        
        fireEvent.fire();
        
        console.log("Exiting setAddProductEvent ");
    }
})