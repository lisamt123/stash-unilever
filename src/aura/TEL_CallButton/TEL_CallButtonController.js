({
    doInit: function(component, event, helper){
    	console.log("Entering doInit");
    	helper.retrieveCallNumber(component, event, helper);    
        console.log("Exit doInit");
    }
})