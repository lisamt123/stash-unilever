({
   landingPageDate : function(component, event, helper) {     
   	var agentReportDetail = component.get("v.objReport");  
    agentReportDetail.timeToDisplay = helper.postCurrentTime(agentReportDetail.currentTime,agentReportDetail.createdTime);   
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
    /*updateCount : function(component, event, helper) {
        //var agentReportDetail = component.get("v.objReport.LikeCount");
        var agentReportDetail = component.get("v.objReport");
        var count= agentReportDetail.LikeCount;
        if(agentReportDetail.UserLike  == 'true'){
          helper.unlikeUpdate(component);
                }
        else{
           helper.likeUpdate(component); 
            
        }
        
    } */
    
   /* likeUpdate : function(component, event, helper){
        //alert("hi");
        //var obj= document.getElementById('Like')
        //var obj=event.srcElement.id;
        //alert(obj);
        //var msglist = document.getElementById("div1");
        //alert(msglist);
       //var show = msglist.getAttribute("data-name");
        //alert(show);
        //document.getElementById("myBtn").disabled = true; 
        //obj.style.visibility = 'hidden';
        
        //var removeId=event.currentTarget.dataset.record;
        //document.getElementById("Like").disabled = true; 
        //var button = component.find("Like");
        //$A.util.addClass(button.getElement(), 'invisible');
       

        //component.set("v.isCount",false);
       


        var reportId = component.find("recordId").get("v.value");
        var agentReportDetail = component.get("v.objReport");
        var action = component.get("c.getupdateLikeCount");       
        action.setParams({ "agentReportId " : reportId});
        action.setCallback(this, function(a) {
            var responseData = a.getReturnValue();
            var count= agentReportDetail.LikeCount;
            alert(agentReportDetail.UserLike);
            alert(responseData);
            count=count+1; 
            if(responseData ==  true)
            	agentReportDetail.UserLike = 'true';
            else
            agentReportDetail.UserLike = 'false';
            agentReportDetail.LikeCount = count;
            component.set("v.objReport",agentReportDetail);
            alert(agentReportDetail.UserLike);
        });
        $A.enqueueAction(action);
    },
    
     unlikeUpdate : function(component, event, helper){
         //alert("hello");
         var reportId = component.find("recordId").get("v.value");
         var agentReportDetail = component.get("v.objReport");
         if(agentReportDetail.LikeCount> 0){
            var action = component.get("c.getupdateUnlikeCount");       
            action.setParams({ "agentReportId" : reportId});
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
    },*/
    
    likeUnlikeUpdate: function(component, event, helper) {
        //var agentReportDetail = component.get("v.objReport.LikeCount");
        var agentReportDetail = component.get("v.objReport");
        // var recordId=event.currentTarget.dataset.record;
       // console.log("recordId Button===>"+recordId);
        console.log("Like/Unlike==>"+agentReportDetail.UserLike);
        component.set("v.enableLike",true);
        component.set("v.disableLike",true);
        
  // var count= agentReportDetail.LikeCount;
       if(agentReportDetail.UserLike  == 'true'){
            console.log("calling Unlike func");
          helper.unlikeUpdate(component);
                }
        else{
            console.log("calling like func");
            helper.likeUpdate(component); 
        }
    },
    
})