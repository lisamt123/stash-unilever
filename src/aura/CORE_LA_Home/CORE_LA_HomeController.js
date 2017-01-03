({

    defaultPanel: function(component, event, helper) {
         var defaultPrimaryTab=component.find('tab-default');
           $A.util.addClass(defaultPrimaryTab,'slds-active');
        var defaultDivDisplay = component.find('upcomingContent');
        $A.util.addClass(defaultDivDisplay, 'slds-show');
        var cmpTarget = component.find('upcomingTabContent');
        $A.util.addClass(cmpTarget,'slds-show');
     
      
      

    },

    profileDisplay: function(component, event, helper) {
         var defaultSubTab=component.find('tab-upcoming');
        $A.util.addClass(defaultSubTab,'slds-active');
        var defaultTarget = component.find('tab-default');
        $A.util.removeClass(defaultTarget, 'slds-active');
        var removeTarget1 = component.find('upcomingContent');
        var removeTarget2 = component.find('pastContent');
        $A.util.removeClass(removeTarget1, 'slds-show');
        $A.util.removeClass(removeTarget2, 'slds-show');
        var cmpTarget = component.find('profileContent');
        $A.util.addClass(cmpTarget, 'slds-show');

    },
    upcomingDisplay: function(component, event, helper) {

        var removeTarget1 = component.find('profileContent');
        var removeTarget2 = component.find('pastContent');
        $A.util.removeClass(removeTarget1, 'slds-show');
        $A.util.removeClass(removeTarget2, 'slds-show');
        var removeProfileactive=component.find('tab-profile');
        $A.util.removeClass(removeProfileactive,'slds-active');
        var cmpTarget = component.find('upcomingContent');
        $A.util.addClass(cmpTarget, 'slds-show');

    },

    pastDisplay: function(component, event, helper) {
        var defaultTarget = component.find('tab-default');
        $A.util.removeClass(defaultTarget, 'slds-active');
        var removeTarget1 = component.find('upcomingContent');
        var removeTarget2 = component.find('profileContent');
        $A.util.removeClass(removeTarget1, 'slds-show');
        $A.util.removeClass(removeTarget2, 'slds-show');
        var cmpTarget = component.find('pastContent');
        $A.util.addClass(cmpTarget, 'slds-show');
        var removeProfileactive=component.find('tab-profile');
        $A.util.removeClass(removeProfileactive,'slds-active');

    },
    
      feedDisplay : function(component, event, helper) { 
          var defaultTarget = component.find('tab-upcoming');
           $A.util.removeClass(defaultTarget,'slds-active');
          var defaultProfiletab=component.find('tab-profile');
           $A.util.addClass(defaultProfiletab,'slds-active');
           var removeTarget1=component.find('upcomingTabContent');
           $A.util.removeClass(removeTarget1,'slds-show');
           var cmpTarget = component.find('feedContent');
           $A.util.addClass(cmpTarget,'slds-show');
      
	},
    
       upcomingEventDisplay : function(component, event, helper) { 
           var removeTarget1=component.find('feedContent');
           $A.util.removeClass(removeTarget1,'slds-show');
           var defaultProfiletab=component.find('tab-profile');
           $A.util.addClass(defaultProfiletab,'slds-active');
           var cmpTarget = component.find('upcomingTabContent');
           $A.util.addClass(cmpTarget,'slds-show');
      
	},
    


})