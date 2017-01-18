({
	getProducts : function(component) {
        console.log("entrou no no helper ");
		var action = component.get("c.getPriceBooks");
        action.setParams({
            "accountName" : component.get("v.nameAccount")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            var listPricebook = response.getReturnValue();
            if((listPricebook.length > 0) && (component.isValid() && state === "SUCCESS")){
                component.set("v.pricebookList",listPricebook);
                console.log("entrou no if " json.stringfy(listPricebook));
            }
        });
        $A.enqueueAction(action);
	}
})