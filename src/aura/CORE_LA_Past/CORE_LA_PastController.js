({
   doinit: function(component, event, helper) {
    
         var defaultPrimaryTab=component.find('tab-posted');
       $A.util.addClass(defaultPrimaryTab,'slds-active');
         var defaultDivDisplay = component.find('POSTED');
       $A.util.addClass(defaultDivDisplay, 'slds-show');
   
      
     },
    
	openCreateEventPopup : function(component) {
		component.set("v.isCreateEventPopup", true);
	},
    handleCloseCreatePopupEvent : function(component, event, helper) {
        console.log("handler for " + event.getName())
        if(event.getParam('isCreateEventPopup') === false){
        	component.set("v.isCreateEventPopup", false);
        }
    },
    
   
    postedDisplay : function(component,event,helper) {
          var secondaryPrimaryTab=component.find('DRAFTS');
       $A.util.removeClass(secondaryPrimaryTab,'slds-show');
		  var activePrimaryPostedTab=component.find('POSTED');
       $A.util.addClass(activePrimaryPostedTab,'slds-show');
          var activeDraftTab=component.find('tab-draft');
       $A.util.removeClass(activeDraftTab,'slds-active');
          var inactivePrimaryTab=component.find('tab-posted');
       $A.util.addClass(inactivePrimaryTab,'slds-active');
	},
    
     draftsDisplay : function(component,event,helper) {
          var inactivePrimaryTab=component.find('tab-posted');
       $A.util.removeClass(inactivePrimaryTab,'slds-active');
          var activeDraftTab=component.find('tab-draft');
       $A.util.addClass(activeDraftTab,'slds-active');
		  var defaultPrimaryTab=component.find('POSTED');
       $A.util.removeClass(defaultPrimaryTab,'slds-show');
          var secondaryPrimaryTab=component.find('DRAFTS');
       $A.util.addClass(secondaryPrimaryTab,'slds-show');
	},
/*    handleOpenCreateEventLandingPage : function(component, event, helper) {
        console.log("handler for " + event.getName())
        if(event.getParam('eventId') !== ''){
        	//component.set("v.isCreateEventPopup", false);
        }
    },
*/   
    
    
    
 
})