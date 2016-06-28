({
doInit:function(component, event, helper) {
       component.set("v.showspinner",true);
       var action=component.get("c.findFeedbacks");
       action.setParams({"appName":component.get("v.Appname")});
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
   
                var response=response.getReturnValue();
                if(response === true){
                     component.set("v.showspinner",false); 
                     var destination ="markup://c:Feedback";
                     $A.componentService.newComponentAsync(this, function(view) {
                     var content = component.find("content");
                     content.set("v.body", view);
                        }, {
                            componentDef: destination,
                            attributes: {
                                values: {
                                    Appname:component.get("v.Appname"),
                                    Pagename:component.get("v.Pagename"),
                                    EventName:"MB_Feedback_Event"
                                }
                            }
                        }, component);
                 }
                if(response === false ){
                    component.set("v.showspinner",false); 
                    var destination = "markup://c:MB_Devices";
                    $A.componentService.newComponentAsync(this, function(view) {
                    var content = component.find("content");
                    content.set("v.body", view);
                    }, {
                        componentDef: destination,
                        attributes: {
                        }
                    }, component); 
                 }
              }
         });
      
    $A.enqueueAction(action);   
    component.set("v.showspinner",false); 
       
},
getDetail:function(component, event, helper) {
        helper.scrollToLocation(component, "top");
        console.log("***"+event.getParam("MBNavigate"));
        var destination = "markup://c:" + event.getParam("MBNavigate");
        var month=event.getParam("month").split(" ");
        var selectedmonth=month[0];
        //alert(selectedmonth);
        $A.componentService.newComponentAsync(this, function(view) { 
        var content = component.find("content"); 
        content.set("v.body", view); 
        }, {
            componentDef: destination,
            attributes: {
                values:{
                    CurrentMonth:event.getParam("month"),
                    deviceId:event.getParam("deviceId"),
                    selectedMonth:selectedmonth
                }
            }
        }, component);
   
},
    gotoLandingpage: function(component, event, helper) {
        helper.scrollToLocation(component, "top");
        var destination = "markup://c:"+event.getParam("Pagename");
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("content");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
            }
        }, component); 
       
    },
    handleFeedback : function(component, event, helper) {
        //helper.scrollToLocation(component, "top");
        console.log("in base"+event.getParam("Pagename"));
        component.set("v.showspinner",true);
        var destination ="markup://c:Feedback";
                     $A.componentService.newComponentAsync(this, function(view) {
                     var content = component.find("content");
                     content.set("v.body", view);
                        }, {
                            componentDef: destination,
                            attributes: {
                                values: {
                                    Appname:component.get("v.Appname"),
                                    Pagename:event.getParam("Pagename"),
                                    EventName:event.getParam("eventName"),
                                    showTranslation:event.getParam("showTranslation"),
                                    selectedMonth:event.getParam("selectedMonth"),
                                }
                            }
                        }, component);
        component.set("v.showspinner",false);
        
    },
    showDetail_charts : function(component, event, helper) {
        helper.scrollToLocation(component, "top");
		var destination = "markup://c:MB_SpendSummary_Charts";
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("content");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
                values:{
                    CurrentMonth:event.getParam("month"),
                    deviceId:event.getParam("deviceId"),
                    deviceName:event.getParam("deviceName")
                }
            }
        }, component);
         
	},
    showDetail_Text: function(component, event, helper) {
        helper.scrollToLocation(component, "top");
		var destination = "markup://c:MB_SpendSummary";
        //alert(event.getParam("CurrentMonth"));
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("content");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
                values:{
                    CurrentMonth:event.getParam("CurrentMonth"),
                    deviceId:event.getParam("deviceId"),
                    deviceName:event.getParam("deviceName")
                }
            }
        }, component);
         
	},
    MB_gotoSummary_chart: function(component, event, helper) {
        //helper.scrollToLocation(component, "top");
		var destination = "markup://c:MB_SpendSummary_Charts";
        
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("content");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
                values:{
                    CurrentMonth:event.getParam("CurrentMonth"),
                    deviceId:event.getParam("deviceId"),
                    deviceName:event.getParam("deviceName") 
                }
            }
        }, component);
         
	},
    
    //Method is used to change the month
    changeMonth :function(component, event, helper){
        //helper.scrollToLocation(component, "top");
        var month=event.getParam("month");
        console.log(month);
        if(month =='undefined' || month==undefined || month==' '){
             var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
             var d = new Date();
             var currentmnth=d.getMonth()-1;
             var monthname=monthNames[currentmnth];
             var year=d.getFullYear();
             var currentMonth=monthname+" "+year;
             month=currentMonth;
        }
        var destination = "markup://c:"+event.getParam("pagename");
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("content");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
                values:{
                    CurrentMonth:month,
                    selectedMonth:event.getParam("selectedMonth")
                }
            }
        }, component);
    },
    //This method handles the back functionality
    handlebackButton:function(component, event, helper){
        console.log("in back"+event.getParam("month"));
        var destination = "markup://c:"+event.getParam("pagename");
        var month=event.getParam("month").split(" ");
        var selectedmonth=month[0];
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("content");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
                values:{
                    CurrentMonth:event.getParam("month"),
                    selectedMonth:selectedmonth
                }
            }
        }, component);
    },
    
    //This method redirects to Native app from feedback app
    gotoApp :function(component, event, helper){
        var destination = "markup://c:"+event.getParam("Pagename");
        console.log(event.getParam("Pagename"));
          var selectedmonth;
        if(event.getParam("selectedMonth") !==undefined){
        var month=event.getParam("selectedMonth").split(" ");
        selectedmonth=month[0];
        }
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("content");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
                values:{
                    selectedMonth:selectedmonth,
                    CurrentMonth:event.getParam("selectedMonth")
                }
                
            }
        }, component);
    },
    gotoFaqPage :function(component, event, helper){
        helper.scrollToLocation(component, "top");
        var destination = "markup://c:MB_Faq_Main";
        console.log("in base"+event.getParam("selectedMonth"));
        $A.componentService.newComponentAsync(this, function(view) {
        var content = component.find("content");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
                values:{
                  CurrentMonth:event.getParam("selectedMonth"),  
                    Pagename:event.getParam("Pagename")
                }
                
            }
        }, component);
    },
    
    gotoUsageTypeDetail:function(component, event, helper){
        helper.scrollToLocation(component, "top");
        var destination = "markup://c:MB_SpendSummary_Details";
        $A.componentService.newComponentAsync(this, function(view) {
           console.log(event.getParam("deviceName")+"-->"+event.getParam("usageType"));
            var content = component.find("content");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
                values:{
                    deviceId:event.getParam("deviceId"),
                    month:event.getParam("month"),
                    usageType:event.getParam("usageType") ,
                    deviceName:event.getParam("deviceName")
                }
            }
        }, component);
    },
    gotoSummarySpend:function(component, event, helper){
        helper.scrollToLocation(component, "top");
        console.log(event.getParam("deviceId")+"88"+event.getParam("month"));
        var destination = "markup://c:MB_SpendSummary";
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("content");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
                values:{
                    deviceId:event.getParam("deviceId"),
                    CurrentMonth:event.getParam("month"),
                    deviceName:event.getParam("deviceName")
                }
            }
        }, component);
    }
})