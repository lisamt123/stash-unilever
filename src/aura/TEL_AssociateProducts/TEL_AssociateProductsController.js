({  
	searchProducts : function(component, event, helper) {
        console.log("Entering searchProducts");
		helper.getProducts(component, event, helper);
        console.log("Exit searchProducts");
	},
    
    createProducts : function(component, event, helper) {
        console.log("Entering createProducts");
		helper.associateAccount(component, helper);
        console.log("Exit createProducts");
	}, 
    
    changeSelectAll : function(component, event, helper){
		console.log("Initiating changeSelectAll");
    	helper.selectAllProducts(component, helper);
        console.log("Exit changeSelectAll");
	}
})