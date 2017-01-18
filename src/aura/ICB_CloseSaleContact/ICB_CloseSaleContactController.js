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
        console.log('Exit <changeCheckBox>');
    }
})