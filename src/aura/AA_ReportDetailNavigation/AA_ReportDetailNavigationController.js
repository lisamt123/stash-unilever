({
    landingPageDate : function(component, event, helper) { 
        if(navigator.userAgent.match(/Android/i)
           || navigator.userAgent.match(/webOS/i)
           || navigator.userAgent.match(/iPhone/i)
           || navigator.userAgent.match(/iPad/i)){
            helper.checkImageUpload(component, event, helper);
        }
        if(navigator.userAgent.match(/iPod/i)
           || navigator.userAgent.match(/BlackBerry/i)
           || navigator.userAgent.match(/Windows Phone/i)){
            helper.checkImageUpload(component, event, helper);
        }
    	
        var likeBtn = component.find("like");
        $A.util.removeClass(likeBtn,"slds-button--neutral");
        var unlikeBtn = component.find("unlike");
        $A.util.removeClass(unlikeBtn, "slds-button--neutral");
        var agentReportDetail = component.get("v.objReport");  
        agentReportDetail.timeToDisplay = helper.postCurrentTime(agentReportDetail.currentTime,agentReportDetail.createdTime);   
        component.set("v.objReport",agentReportDetail);
        var agentReportDetail = component.get("v.objReport");
        if(agentReportDetail.UserLike  == 'true'){
            agentReportDetail.UserLike = 'true';  
        }
        else{
            agentReportDetail.UserLike = 'false';
        }
        
    },
    openReport : function(component, event, helper) {  
        var reportId = component.find("recordId").get("v.value");
        var navToSObjEvt = $A.get("e.force:navigateToSObject");
        navToSObjEvt.setParams({
            recordId: reportId,
            slideDevName: "detail"
        }); 
        navToSObjEvt.fire();      
    },
    doInit : function(component, event, helper) {  
        var reportId = component.find("recordId").get("v.value");
        var navToSObjEvt = $A.get("e.force:navigateToSObject");
        navToSObjEvt.setParams({
            recordId: reportId,
            slideDevName: "detail"
        }); 
        navToSObjEvt.fire();      
    },
    likeUnlikeUpdate: function(component, event, helper) {
        var agentReportDetail = component.get("v.objReport");
        component.set("v.enableLike",true);
        component.set("v.disableLike",true);
        // var count= agentReportDetail.LikeCount;
        if(agentReportDetail.UserLike  === 'true'){
            helper.unlikeUpdate(component);
        }
        else{
            helper.likeUpdate(component); 
        }
    },
})