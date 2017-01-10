({
    
    defaultAboutSection:function(component,event,helper){
        var defaultTab=component.find('tab-feed');
        $A.util.addClass(defaultTab,'slds-active')
        var defaultDivDisplay = component.find('feedContent');
        $A.util.addClass(defaultDivDisplay, 'slds-show');
        
    },
    gotoShare:function(component,event,helper){
       var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_share"}).fire();
    },
    gotoHomePage : function(component,event,helper){
       var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_Home"}).fire();
     },
    gotoRegistraion: function(component,event,helper){
        /*
        var selectEvent= $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_Registration"}).fire();
        */
        component.set("v.isRegistrationPopup",true); 
        
    },
     navigateTrainerDetails:function(component,event,helper){
        var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_TrainerProfile"}).fire();
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
            var defaultTab=component.find('tab-feed');
           $A.util.removeClass(defaultTab,'slds-active');
           var cmpTarget = component.find('upcomingTabContent');
           $A.util.addClass(cmpTarget,'slds-show');
      
	},
    showDiv : function(component, event, helper) {
        var toggleText = component.find("text");
        component.set("v.showDiv",true); 
        $A.util.toggleClass(toggleText, "slds-hide");
        var img=component.find("myimg1");
        $A.util.toggleClass(img, "slds-hide");
        var img2=component.find("myimg2");
        $A.util.toggleClass(img2, "slds-show");
    },
    showDiv1 : function(component, event, helper) {
        var toggleText = component.find("text1");
        component.set("v.showDiv1",true); 
        $A.util.toggleClass(toggleText, "slds-hide");
        var img=component.find("myimg3");
        $A.util.toggleClass(img, "slds-hide");
        var img2=component.find("myimg4");
        $A.util.toggleClass(img2, "slds-show");
    },
    showDiv2 : function(component, event, helper) {
        var toggleText = component.find("text2");
        component.set("v.showDiv2",true); 
        $A.util.toggleClass(toggleText, "slds-hide");
        var img=component.find("myimg5");
        $A.util.toggleClass(img, "slds-hide");
        var img2=component.find("myimg6");
        $A.util.toggleClass(img2, "slds-show");
    },
    showDiv3 : function(component, event, helper) {
        var toggleText = component.find("text3");
        component.set("v.showDiv3",true); 
        $A.util.toggleClass(toggleText, "slds-hide");
        var img=component.find("myimg7");
        $A.util.toggleClass(img, "slds-hide");
        var img2=component.find("myimg8");
        $A.util.toggleClass(img2, "slds-show");
    },
    showDiv4 : function(component, event, helper) {
        var toggleText = component.find("text4");
        component.set("v.showDiv4",true); 
        $A.util.toggleClass(toggleText, "slds-hide");
        var img=component.find("myimg9");
        $A.util.toggleClass(img, "slds-hide");
        var img2=component.find("myimg10");
        $A.util.toggleClass(img2, "slds-show");
    },
    
})