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
    menuClose : function(component,event,helper){
        console.log('Entering <menuClose>');
        helper.closeButton(component,event); 
        console.log('Exit <menuClose>');
    },
    changeCheckBox : function(component, event, helper) {
        console.log('Entering <changeCheckBox>');
        helper.changeCheck(component,event,"checkbox"); 
        console.log('Exit <changeCheckBox>');
    },
    solicitation : function(component, event, helper) {
        console.log('Entering <solicitation>');
        var indexContact = component.get("v.indexContact");
        var listContact = component.get("v.listContacts");
        if(!listContact[indexContact].isDisabled){
            helper.createOpportunity(component, event);
            location.reload(true);
        }
        console.log('Exit <solicitation>');
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
    },
    updatedPriceBook : function(component, event, helper) { 
		console.log('Entering <updatedPriceBook>'); 
        var indexContact = component.get("v.indexContact");
        var listContact = component.get("v.listContacts");
        if(!listContact[indexContact].isDisabled){
            helper.oppItemUpdate(component);
            location.reload(true);
        }
        console.log('Exit <updatedPriceBook>');
    }
})