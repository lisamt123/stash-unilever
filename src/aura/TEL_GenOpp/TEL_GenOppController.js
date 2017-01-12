({
    doInit : function(component, event, helper){
    	console.log("Entering <doInit>");
        helper.getSearchParam(component, event, helper);
        console.log("Exit <doInit>");
    },
    
	searchAccount : function(component, event, helper) {
        console.log("Entering searchAccount");
		helper.getAccounts(component, event, helper);
        console.log("Exit searchAccount");
	}, 
    
    sendAccounts : function(component, event, helper) {
        console.log("Entering sendAccounts");
        helper.createOpp(component, event, helper);
        console.log("Exit sendAccounts");
    },
    
    enableMonday : function (component, event, helper) {
        console.log("Entering enableMonday");
        helper.onCheckWeek(component, event, helper, 'monday');
        console.log("Exit enableMonday");
    },
    enableTuesday : function (component, event, helper) {
        console.log("Entering enableTuesday");
        helper.onCheckWeek(component, event, helper, 'tuesday');
        console.log("Exit enableTuesday");
    },
    enableWednesday : function (component, event, helper) {
        console.log("Entering enableWednesday");
        helper.onCheckWeek(component, event, helper, 'wednesday');
        console.log("Exit enableWednesday");
    },
    enableThursday : function (component, event, helper) {
        console.log("Entering enableThursday");
        helper.onCheckWeek(component, event, helper, 'thursday');
        console.log("Exit enableThursday");
    },
    enableFriday : function (component, event, helper) {
        console.log("Entering enableFriday");
        helper.onCheckWeek(component, event, helper, 'friday');
        console.log("Exit enableFriday");
    },
    changeSelectAll : function(component, event, helper){
		console.log("Entering changeSelectAll");
    	helper.selectAllAccounts(component, helper);
        console.log("Exit changeSelectAll");
	}
})