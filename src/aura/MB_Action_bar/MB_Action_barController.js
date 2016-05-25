({
	 gotoFeedback :function(component, event, helper) {
        //helper.scrollToLocation(component, "top");
        var feedbackevt=$A.get("e.c:Feedback_Event");
         feedbackevt.setParams({"appName":"TEM Feedback","Pagename":"MB_Devices","isFeedback":true}).fire();
    },
})