({
    decrementValue : function(component, event, helper) {
        console.log('Entering <decrementValue>');
        var operation = component.get("v.operation");
        var contact = component.get("v.contact");
        if(operation === "closed"){
            helper.decrementValueClosed(component,event);
        }else{
            helper.decrementValueOpen(component,event);
        }
        console.log('Exit <decrementValue>');
    },
    incrementValue : function(component, event, helper) {
        console.log('Entering <incrementValue>');
        var operation = component.get("v.operation");
        if(operation === "closed"){
            helper.incrementValueClosed(component,event);
        }else{
            helper.incrementValueOpen(component,event);
        }
        console.log('Exit <incrementValue>');
    }
    
})