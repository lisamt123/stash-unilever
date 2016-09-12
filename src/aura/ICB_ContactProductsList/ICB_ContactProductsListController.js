({
    doInit : function(component, event, helper) {
        console.log('Entering <doInit>');
        helper.getProducts(component);
        console.log('Exit <doInit>');
    }
})