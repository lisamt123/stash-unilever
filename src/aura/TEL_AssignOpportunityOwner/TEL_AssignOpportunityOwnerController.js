({
	doInit: function(component, event, helper){
        console.log("Entering doInit");
    	helper.changeOwner(component, helper);    
        console.log("Exit doInit");
    },
})