({
	postCurrentTime : function(currentTime,createdTime) {
       
		var postTimeTodisplay = '';
			var strtdt = this.dateObjectToConvert(createdTime);
			var enddt = this.dateObjectToConvert(currentTime);
			var seconds = Math.floor((enddt - (strtdt))/1000);
			var minutes = Math.floor(seconds/60);
			var hours = Math.floor(minutes/60);
			var days = Math.floor(hours/24);

			hours = hours-(days*24);
			minutes = minutes-(days*24*60)-(hours*60);
			seconds = seconds-(days*24*60*60)-(hours*60*60)-(minutes*60);
			
			if(days > 0){
			 postTimeTodisplay = this.GetFormattedDate(createdTime);
				//postTimeTodisplay = postTimeTodisplay + days + " day ago";
			}else if( hours > 0){
				postTimeTodisplay = postTimeTodisplay + hours + " hours ago";
			}else if( minutes > 0){
				postTimeTodisplay = postTimeTodisplay + minutes + " minutes ago";
			}else if( seconds > 0){
				postTimeTodisplay = postTimeTodisplay + seconds + " seconds ago";
			}
        
			return postTimeTodisplay;
	},
    
    GetFormattedDate : function(createdTime){
       
            var dateString = createdTime;
			var reggie = /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/;
			var dateArray = reggie.exec(dateString); 
			var dtString =  'on' + ' '+ (dateArray[2]) + "/" + (dateArray[3]) + "/" + (dateArray[1]);
			return dtString;
		},
    dateObjectToConvert : function(dObject){
            var dateString = dObject;
			var reggie = /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/;
			var dateArray = reggie.exec(dateString); 
			var dateObject = new Date(
				(+dateArray[1]),
				(+dateArray[2])-1, // Careful, month starts at 0!
				(+dateArray[3]),
				(+dateArray[4]),
				(+dateArray[5]),
				(+dateArray[6])
			);
			return dateObject;   
    },
     likeUpdate : function(component, event, helper){
       
         var reportId = component.find("recordId").get("v.value");
         console.log("ReportId=====>"+reportId);
         var agentReportDetail = component.get("v.objReport");
         var action = component.get("c.getupdateLikeCount");       
         action.setParams({ "AgentReportId" : reportId});
         action.setCallback(this, function(a) {
             var responseData = a.getReturnValue();
             var count= agentReportDetail.LikeCount;
              
              console.log("Response Data-->"+responseData);
          
             component.set("v.enableLike",false);
             component.set("v.disableLike",false);
                 count=count+1;
                 agentReportDetail.UserLike = 'true';
                 agentReportDetail.LikeCount = count;        
                 component.set("v.objReport",agentReportDetail);
            
            //alert(agentReportDetail.UserLike);
        });
        $A.enqueueAction(action);
         
    },
    
    unlikeUpdate : function(component, event, helper){
         //alert("hello");
         var reportId = component.find("recordId").get("v.value");
        console.log("ReportId=====>"+reportId);
         var agentReportDetail = component.get("v.objReport");
         if(agentReportDetail.LikeCount> 0){
            var action = component.get("c.getupdateUnlikeCount");       
            action.setParams({ "AgentReportId" : reportId});
             action.setCallback(this, function(a) {
                 var state = a.getState();
                 if (state === "SUCCESS") {
                     var responseData = a.getReturnValue();
                     var count= agentReportDetail.LikeCount;
                     console.log("Response Data-->"+responseData);
                     
                     component.set("v.enableLike",false);
                     component.set("v.disableLike",false);
                     count=count-1;
                     agentReportDetail.UserLike = 'false';
                     agentReportDetail.LikeCount = count;        
                     component.set("v.objReport",agentReportDetail);
                     
                 }
             });
             $A.enqueueAction(action);
                    
         }     
    },
    
       
})