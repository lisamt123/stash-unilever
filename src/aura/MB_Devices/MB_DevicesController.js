({ 
    //Pageload method gets total usage of current user 
    doinit:function(component, event, helper) {
        //Getting current Month and Year
        console.log("in devices"+component.get("v.selectedMonth"));
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
                console.log("image url"+result.length );
                if(result.length > 0){
                    console.log("image url"+result[0].deviceImageUrl);
                   component.set("v.showDevice",true);
                   component.set("v.Device_Details",response.getReturnValue());
                   component.set("v.userName",result[0].userName);
                   component.set("v.localCurrency",result[0].userCurrency);
                   var usertotalUsage=0;
                   for(var i=0;i<result.length;i++)
                    {
                      usertotalUsage=usertotalUsage+result[i].totalUsage;
                    }
                    usertotalUsage=Number(usertotalUsage).toFixed(2);
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
            component.set("v.showspinner","false"); 
          });
       $A.enqueueAction(action);
        var action2 = component.get("c.getGAID");
        action2.setCallback(this, function(response) {
            var state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue()!=='') {
                         (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                                m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
                                                })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
                        
                        ga('create',response.getReturnValue(), 'auto');
                        ga('send', 'pageview');
                    }                  
        });
        $A.enqueueAction(action2);
 
    },
    
    //This method redirects selected device's spend details page
    gotoDetailSummary:function(component, event, helper){
        //var dataid = document.getElementById("outerdiv");
        //var datavalue = dataid.getAttribute("data-deviceId");
       //var devicename=dataid.getAttribute("data-deviceName")
        var index = event.target.dataset.index;
        console.log("index"+index);
        var data=component.get("v.Device_Details");
        var dataList=[];
        for(var i=0; i<data.length; i++)
        {            
            dataList.push(data[i]);             
        }
        
        var datavalue=dataList[index].deviceId;
        var devicename=dataList[index].deviceName;
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