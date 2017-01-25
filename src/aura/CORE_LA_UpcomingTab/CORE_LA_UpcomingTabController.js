({
    /*var toggleFilterPopUp = component.find("filterPopUp");
        $A.util.toggleClass(toggleFilterPopUp, "toggle");
        var toggleSortPopUp = component.find("sortPopUp");
        $A.util.addClass(toggleSortPopUp, "toggle");
    */
    
    showFilterMenu : function(component, event, helper) {      
        component.set("v.showFilter",true); 
        component.set("v.showSort",false); 
        var toggleFilterPopUp = component.find("filterOptions");
        $A.util.toggleClass(toggleFilterPopUp, "toggle");
        var toggleSortPopUp = component.find("sortOptions");
        $A.util.addClass(toggleSortPopUp, "toggle");
    },
    showSortMenu : function(component, event, helper) {      
        component.set("v.showFilter",false); 
        component.set("v.showSort",true); 
        var toggleFilterPopUp = component.find("sortOptions");
        $A.util.toggleClass(toggleFilterPopUp, "toggle");
        var toggleSortPopUp = component.find("filterOptions");
        $A.util.addClass(toggleSortPopUp, "toggle");
    },
    getAllEvents: function(component, event, helper) {
        component.set("v.limitRecords",2);
        component.set("v.offsetValue",0);
        component.set("v.filterType","All Events");
        var toggleFilterPopUp = component.find("filterOptions");
        //$A.util.toggleClass(toggleFilterPopUp, "toggle");
        $A.util.addClass(toggleFilterPopUp, "toggle");
        $A.util.addClass(component.find("allEvents"),"events-bold");
        $A.util.removeClass(component.find("recurring"),"events-bold");
        $A.util.removeClass(component.find("nonRecurring"),"events-bold");
        $A.util.removeClass(component.find("registered"),"events-bold");
        $A.util.removeClass(component.find("saved"),"events-bold");
        helper.getEventDetailsHelper(component,event, helper );
    },
    getRecurringEvents: function(component, event, helper) {
        component.set("v.limitRecords",2);
        component.set("v.offsetValue",0);
        component.set("v.filterType","Recurring");
        var toggleFilterPopUp = component.find("filterOptions");
        $A.util.addClass(toggleFilterPopUp, "toggle");
        $A.util.addClass(component.find("recurring"),"events-bold");
        $A.util.removeClass(component.find("allEvents"),"events-bold");
        $A.util.removeClass(component.find("nonRecurring"),"events-bold");
        $A.util.removeClass(component.find("registered"),"events-bold");
        $A.util.removeClass(component.find("saved"),"events-bold");
        helper.getEventDetailsHelper(component,event, helper );
    },
    getNonRecurringEvents: function(component, event, helper) {
        component.set("v.limitRecords",2);
        component.set("v.offsetValue",0);
        component.set("v.filterType","Non-Recurring");
        var toggleFilterPopUp = component.find("filterOptions");
        $A.util.addClass(toggleFilterPopUp, "toggle");
        $A.util.addClass(component.find("nonRecurring"),"events-bold");
        $A.util.removeClass(component.find("allEvents"),"events-bold");
        $A.util.removeClass(component.find("recurring"),"events-bold");
        $A.util.removeClass(component.find("registered"),"events-bold");
        $A.util.removeClass(component.find("saved"),"events-bold");
        helper.getEventDetailsHelper(component,event, helper );
    },
    getRegisteredEvents: function(component, event, helper) {
        component.set("v.limitRecords",2);
        component.set("v.offsetValue",0);
        component.set("v.filterType","Registered");
        var toggleFilterPopUp = component.find("filterOptions");
        $A.util.addClass(toggleFilterPopUp, "toggle");
        $A.util.addClass(component.find("registered"),"events-bold");
        $A.util.removeClass(component.find("allEvents"),"events-bold");
        $A.util.removeClass(component.find("nonRecurring"),"events-bold");
        $A.util.removeClass(component.find("recurring"),"events-bold");
        $A.util.removeClass(component.find("saved"),"events-bold");
        helper.getEventDetailsHelper(component,event, helper );
    },
    getSavedEvents: function(component, event, helper) {
        component.set("v.limitRecords",2);
        component.set("v.offsetValue",0);
        component.set("v.filterType","Saved");
        var toggleSortPopUp = component.find("filterOptions");
        $A.util.addClass(toggleSortPopUp, "toggle");
        $A.util.addClass(component.find("saved"),"events-bold");
        $A.util.removeClass(component.find("allEvents"),"events-bold");
        $A.util.removeClass(component.find("nonRecurring"),"events-bold");
        $A.util.removeClass(component.find("registered"),"events-bold");
        $A.util.removeClass(component.find("recurring"),"events-bold");
        helper.getEventDetailsHelper(component,event, helper );
    },
    getDateSortEvents: function(component, event, helper) {
        var totalLimitRecords=component.get("v.limitRecords")+component.get("v.offsetValue");
        component.set("v.limitRecords",totalLimitRecords);
        component.set("v.offsetValue",0);
        component.set("v.sortType","Date");
        var toggleSortPopUp = component.find("sortOptions");
        $A.util.addClass(toggleSortPopUp, "toggle");
        $A.util.addClass(component.find("dateSort"),"events-bold");
        $A.util.removeClass(component.find("eventNameSort"),"events-bold");
        helper.getEventDetailsHelper(component,event, helper );
    },
    getNameSortEvents: function(component, event, helper) {
        var totalLimitRecords=component.get("v.limitRecords")+component.get("v.offsetValue");
        component.set("v.limitRecords",totalLimitRecords);
        component.set("v.offsetValue",0);
        component.set("v.sortType","Name");
        var toggleSortPopUp = component.find("sortOptions");
        $A.util.addClass(toggleSortPopUp, "toggle");
        $A.util.addClass(component.find("eventNameSort"),"events-bold");
        $A.util.removeClass(component.find("dateSort"),"events-bold");
        helper.getEventDetailsHelper(component,event, helper );
    },    
    /* gotoDetail: function(component, event, helper) {
      
        var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_UpcomingDetail"}).fire();
    },
    gotoRecurring:function(component, event, helper) {
      
        var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_RecurringDetail"}).fire();
    },*/
})