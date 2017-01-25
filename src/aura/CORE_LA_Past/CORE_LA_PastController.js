({
	openCreateEventPopup : function(component) {
		component.set("v.isCreateEventPopup", true);
	},
    handleCloseCreatePopupEvent : function(component, event, helper) {
        console.log("handler for " + event.getName())
        if(event.getParam('isCreateEventPopup') === false){
        	component.set("v.isCreateEventPopup", false);
        }
    },
/*    handleOpenCreateEventLandingPage : function(component, event, helper) {
        console.log("handler for " + event.getName())
        if(event.getParam('eventId') !== ''){
        	//component.set("v.isCreateEventPopup", false);
        }
    },
*/    
})