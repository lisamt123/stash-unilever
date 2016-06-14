({
	 gotoFeedback :function(component, event, helper) {
        helper.scrollToLocation(component, "top");
        console.log("In action bar"+component.get("v.componentName"));
        var feedbackevt=$A.get("e.c:Feedback_Event");
         feedbackevt.setParams({"appName":"TEM Feedback","Pagename":component.get("v.componentName"),"eventName":"MB_Feedback_Event","showTranslation":true,"selectedMonth":component.get("v.selectedMonth")}).fire();
    },
    gotoFaq :function(component, event, helper) {
        console.log("in action"+component.get("v.selectedMonth"));
        helper.scrollToLocation(component, "top");
        var feedbackevt=$A.get("e.c:MB_Faq_Event");
         feedbackevt.setParams({"Pagename":component.get("v.componentName"),"selectedMonth":component.get("v.selectedMonth")}).fire();
    },

})