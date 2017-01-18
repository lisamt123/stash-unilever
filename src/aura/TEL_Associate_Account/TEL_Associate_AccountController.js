({
    doInit: function(component, event, helper){
        console.log("Entering doInit");
    	helper.getSearchParam(component, helper);    
        console.log("Exit doInit");
    },
    
	searchAccount : function(component, event, helper) {
		helper.getAccounts(component, event, helper);
	}, 
    
    sendAccounts : function(component, event, helper) {
        helper.createOpp(component, event, helper);
    },
    
    enableMonday : function (component, event, helper) {
        helper.onCheckWeek(component, event, helper, 'monday');
    },
    enableTuesday : function (component, event, helper) {
        helper.onCheckWeek(component, event, helper, 'tuesday');
    },
    enableWednesday : function (component, event, helper) {
        helper.onCheckWeek(component, event, helper, 'wednesday');
    },
    enableThursday : function (component, event, helper) {
        helper.onCheckWeek(component, event, helper, 'thursday');
    },
    enableFriday : function (component, event, helper) {
        helper.onCheckWeek(component, event, helper, 'friday');
    },
    changeSelectAll : function(component, event, helper){
		console.log("Entering changeSelectAll");
    	helper.selectAllAccounts(component, helper);
        console.log("Exit changeSelectAll");
	}
})