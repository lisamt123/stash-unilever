({
    // Load Products from Salesforce
    doInit: function(component, event, helper) {
      helper.doInit(component,event);
        
    },
    posiviteAdd : function(component, event, helper){
        helper.positiveAdd(component,event);
     },
    
    negativeAdd : function(component, event, helper){
    	helper.negativeAdd(component,event);
    },
    
    whatButton : function(component, event, helper){
        var whichOne = event.getSource().getLocalId();
        console.log(whichOne); 
        
    },
    
    // Updated the inventory operator based a list line item list.
    updateList : function(component, event, helper){
       helper.updateList(component,event);
        
    },
    Onfocus : function(component, event, helper){
		var test = $A.get('e.ui:updateSize');
      	test.fire();
    }
    
})