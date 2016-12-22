({   
    // Retrieve the active products based on search param. 
    getProducts : function(component, event, helper) {
        console.log("Entering <getProducts>");
        var family	 	= component.find("family").get("v.value");
        var action 		= component.get("c.retrieveProducts");
        var campaign 	= component.get("v.recordId");
        component.set('v.spinnerEnable',true);
        action.setParams({ 
            "family" : family,
            "campaignId" : campaign
        });
        
        // Create a callback that is executed after the server-side action returns 
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.showNoRelatedProducts", true);
                component.set("v.lstProducts", response.getReturnValue());
                component.set('v.spinnerEnable', false);
                component.set('v.produtsSeleted', response.getReturnValue().length);
            }
        });
        $A.enqueueAction(action);
        console.log("Exit <getProducts>");
    },
    
    // Associate selected product to campaign.     
    associateAccount : function(component, helper){
        console.log("Entering <associateAccount>");
        var lstProducts 	= component.get("v.lstProducts");
        var campaign		= component.get("v.recordId");
        
        if(!$A.util.isEmpty(lstProducts) && !$A.util.isUndefined(lstProducts)){
            var action 		= component.get("c.createPrdCampaign");
            var products	= JSON.stringify(lstProducts);
            
            action.setParams({
                prdSelected : products, 
                campaignId	: campaign
            });
            
            action.setCallback(this, function(response){
                var state 	= response.getState();
                if(state === "SUCCESS"){
                    component.set("v.showNoRelatedProducts", true);
                    component.set('v.spinnerEnable',false);
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                }
            });
        }
        $A.enqueueAction(action);
        console.log("Exit <associateAccount>");
    },
    
    // Select all products to be associated to campaign. 
    selectAllProducts : function(component) {
        console.log("Initiating selectAllProducts");
        var selected 	= component.find("selectAll").get("v.value");
        var lstProducts = component.get("v.lstProducts");
        
        console.log("Valor do selected: "+selected);
        
        if(selected === true) {
            for(var counter = 0; counter < lstProducts.length; counter++) {
                if(lstProducts[counter].isSelected === false) {
                    lstProducts[counter].isSelected = true;
                    component.set('v.selectedAll', true);
                }
            }
        } else {
            for(var counter = 0; counter < lstProducts.length; counter++) {
                lstProducts[counter].isSelected = false;
                component.set('v.selectedAll', false);
            }
        }
        
        component.set("v.lstProducts", lstProducts);
        
        console.log("Exiting selectAllProducts");
    }
})