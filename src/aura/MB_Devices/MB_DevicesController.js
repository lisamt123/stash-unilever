({ 
    //Pageload method gets total usage of current user 
    doinit:function(component, event, helper) {
        //Getting current Month and Year
        
        var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        
        var d;
        var month;
        var list=[];
        
           
          if(component.get("v.CurrentMonth") == undefined ){
              
             var d = new Date();
             var month=d.getMonth();
             var currentmonthName=monthNames[month];
             var prviousmonth=monthNames[month-1];
              if(currentmonthName =='January'){
                   var year=d.getFullYear()-1;
               }
              var year=d.getFullYear();
             var cuurentmonth=prviousmonth+" "+year;
             component.set("v.CurrentMonth",cuurentmonth);
          }
         
        //Calls apex class to get user data
        var action=component.get("c.deviceSpendDetailsForUser");
        action.setParams({"month":component.get("v.CurrentMonth")});
        //action.setParams({"month":"November 2015"});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
                var result=response.getReturnValue();
                if(result.length > 0){
                   component.set("v.showDevice",true);
                   component.set("v.Device_Details",response.getReturnValue());
                   component.set("v.userName",result[0].userName);
                   component.set("v.localCurrency",result[0].userCurrency);
                   var usertotalUsage=0;
                   for(var i=0;i<result.length;i++)
                    {
                      usertotalUsage=usertotalUsage+result[i].totalUsage;
                    }
                   component.set("v.totalUsage",usertotalUsage);
                }
                
                //Get the current username if the current user does not have any spend for current month
                else{
                    var action1=component.get("c.getUserName");
                    action1.setCallback(this, function(response) {
                       var state = response.getState();
                       if (state === "SUCCESS" && response.getReturnValue()!=='') {
                           component.set("v.showDevice",false);
                           component.set("v.userName",response.getReturnValue());
                       }
                    });
                  $A.enqueueAction(action1);  
               }
            }
          });
       $A.enqueueAction(action);
                
    },
    
    //This method redirects selected device's spend details page
    gotoDetailSummary:function(component, event, helper){
        var dataid = document.getElementById("outerdiv");
        var datavalue = dataid.getAttribute("data-deviceId");
        var devicename=dataid.getAttribute("data-deviceName")
        var detailpage_event=$A.get("e.c:MB_DetailSummary_Event");   
        detailpage_event.setParams({"deviceId":datavalue,"month":component.get("v.CurrentMonth"),"deviceName":devicename}).fire();
    },
   
    //This method handles change of month from dropdown
    changeMonth :function(component, event, helper){
        var month=event.getParam("month");
        var month=month+" "+new Date().getFullYear();
        component.set("v.CurrentMonth",month);
        var details=component.get("v.Device_Details")
        details.splice(0,details.length);
        component.set("v.Device_Details",details);
        var action=component.get("c.deviceSpendDetailsForUser");
        action.setParams({"month":month});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
                var result=response.getReturnValue();
                if(result.length > 0){
                   component.set("v.showDevice",true);
                   component.set("v.Device_Details",response.getReturnValue());
                   component.set("v.userName",result[0].userName);
                   component.set("v.localCurrency",result[0].userCurrency);
                   var usertotalUsage=0;
                   for(var i=0;i<result.length;i++)
                    {
                      usertotalUsage=usertotalUsage+result[i].totalUsage;
                    }
                   component.set("v.totalUsage",usertotalUsage);
                }
                else{
                   component.set("v.showDevice",false); 
                }
            }
          });
       $A.enqueueAction(action);
    }
})