({
   landingPageDate : function(component, event, helper) {     
   	var agentReportDetail = component.get("v.objReport");  
    agentReportDetail.timeToDisplay = helper.postCurrentTime(agentReportDetail.currentTime,agentReportDetail.createdTime);;   
    component.set("v.objReport",agentReportDetail);
    var agentReportDetail = component.get("v.objReport");
       if(agentReportDetail.UserLike  == 'true')
           agentReportDetail.UserLike = 'true';          
       else
           agentReportDetail.UserLike = 'false';
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
    
    
    
    likeUpdate : function(component, event, helper){
        var reportId = component.find("recordId").get("v.value");
        var agentReportDetail = component.get("v.objReport");
        var action = component.get("c.getupdateLikeCount");       
        action.setParams({ "AgentReportId" : reportId});
        action.setCallback(this, function(a) {
            var responseData = a.getReturnValue();
            var count= agentReportDetail.LikeCount;
            count=count+1; 
            if(responseData ==  true)
            	agentReportDetail.UserLike = 'true';
            else
                agentReportDetail.UserLike = 'false';
            agentReportDetail.LikeCount = count;
            component.set("v.objReport",agentReportDetail);
        });
        $A.enqueueAction(action);
    },
    
     unlikeUpdate : function(component, event, helper){
         
         var reportId = component.find("recordId").get("v.value");
         var agentReportDetail = component.get("v.objReport");
         if(agentReportDetail.LikeCount> 0){
            var action = component.get("c.getupdateUnlikeCount");       
            action.setParams({ "AgentReportId" : reportId});
            action.setCallback(this, function(a) {
                var responseData = a.getReturnValue();
                var count= agentReportDetail.LikeCount;
                count=count-1; 
                if(responseData ==  true)
            		agentReportDetail.UserLike = 'true';
           	    else
                	agentReportDetail.UserLike = 'false';
                agentReportDetail.LikeCount = count;
                component.set("v.objReport",agentReportDetail);
            });
            $A.enqueueAction(action);
        }     
    },
})