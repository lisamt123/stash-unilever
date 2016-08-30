({
    doInit : function(component, event, helper) {
        console.log('Entering <doInit>');
        helper.getContacts(component);
        console.log('Exit <doInit>');
    },
    menuOpenClose : function(component, event, helper) {
        console.log('Entering <menuOpenClose>');
        helper.changeCheck(component,event,"button");
        console.log('Exit <menuOpenClose>');
    },
    changeCheckBox : function(component, event, helper) {
        console.log('Entering <changeCheckBox>');
        helper.changeCheck(component,event,"checkbox"); 
        location.reload(true);
        console.log('Exit <changeCheckBox>');
    },
    decrementValue : function(component, event, helper) {
        console.log('Entering <decrementValue>');
        helper.ascDescValue(component,event,"decrement");
        console.log('Exit <decrementValue>');
    },
    incrementValue : function(component, event, helper) {
        console.log('Entering <incrementValue>');
        helper.ascDescValue(component,event,"increment");
        console.log('Exit <incrementValue>');
    }
})