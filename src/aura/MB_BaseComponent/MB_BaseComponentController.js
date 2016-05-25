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
        helper.scrollToLocation(component, "top");
     if(event.getParam("isFeedback")===true)
     {
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
                                    Pagename:component.get("v.Pagename"),
                                }
                            }
                        }, component);
        component.set("v.showspinner",false);
      }
        if(event.getParam("isFeedback")===false){
            var destination = "markup://c:"+event.getParam("Pagename");
            $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("content");
            content.set("v.body", view);
            }, {
            componentDef: destination,
            attributes: {
            }
         }, component);
        }  
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
         //alert(event.getParam("deviceName"));
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
    MB_gotoSummary_chart: function(component, event, helper) {
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
})