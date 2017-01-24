({
    doInit : function(component, event, helper) {
        console.log('Entering <doInit>');
        helper.getContacts(component);
        console.log('Exit <doInit>');
    },
    menuOpenClose : function(component, event, helper) {
        console.log('Entering <menuOpenClose>');
        //component.set("v.spinnerShow", true);
        helper.changeButton(component,event,"button"); 
        console.log('Exit <menuOpenClose>');
        
    },
    changeCheckBox : function(component, event, helper) {
        console.log('Entering <changeCheckBox>');
        helper.changeCheck(component,event,"checkbox"); 
        location.reload(true);
        console.log('Exit <changeCheckBox>');
    },
    solicitation : function(component, event, helper) {
        console.log('Entering <solicitation>');
        //var indexContact = component.get("v.indexContact");
        //var listContact = component.get("v.listContacts");
       //if(!listContact[indexContact].isDisabled){
        component.set("v.isDisabled",true);
        helper.createOpportunity(component, event);
        //}
        console.log('Exit <solicitation>');
    },
    updatedItem : function(component, event, helper) { 
		console.log('Entering <updatedItem>'); 
        var indexContact = component.get("v.indexContact");
        var listContact = component.get("v.listContacts");
        //if(!listContact[indexContact].isDisabled && listContact[indexContact].oppLineItem != null){
            helper.oppItemUpdate(component,event,listContact[indexContact].contactItem.Id);
            
        //}
        console.log('Exit <updatedItem>');
    },
    reload : function(component){
        location.reload(true);
    }
})