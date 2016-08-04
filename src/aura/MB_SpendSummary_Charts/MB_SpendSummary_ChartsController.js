({  
    doinit : function(component, event, helper) {
        
        var Domestic= $A.get("$Label.c.MB_Domestic");
        var International= $A.get("$Label.c.MB_International");
        var You= $A.get("$Label.c.MB_You");
        var Colleague= $A.get("$Label.c.MB_Your_Colle");
        var res;
        var action = component.get("c.getChargeType");
        action.setParams({ "month" : component.get("v.CurrentMonth"),"deviceId" : component.get("v.deviceId")});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                res= response.getReturnValue(); 
                component.set("v.result",res);
            } 
            /*This code is for charts and graphs*/
            helper.helperMethodforpieCharts(component,res);
            helper.helperMethodforpieCharts1(component,res);
            helper.helperMethodforpieCharts2(component,res);
            helper.helperMethodforpieCharts3(component,res);
        });
        $A.enqueueAction(action);
        var action1 = component.get("c.getyourCollegueChargeType");
        action1.setParams({"month" : component.get("v.CurrentMonth"),"deviceId" : component.get("v.deviceId")});
        action1.setCallback(this, function(response){
            var res1;
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
               res1= response.getReturnValue(); 
                component.set("v.Avgresult",res1);
            } 
            helper.helperMethodforpieChartsColumn(component,res1);
            helper.helperMethodforpieChartsColumn1(component,res1);
            helper.helperMethodforpieChartsColumn2(component,res1);
            helper.helperMethodforpieChartsColumn3(component,res1);
           });
        $A.enqueueAction(action1);
        setTimeout(function() {
            $A.run(function() {
                $('.carousel').slick({            
                    dots: true,
                    arrows: false,
                    infinite: false,
                }); 
                $('.carousel').focusout(); 
            });
        });
        setTimeout(function() {
            $A.run(function() {
                $('.carousel_column').slick({            
                    dots: true,
                    arrows: false,
                    infinite: false,
                });
            });
        });
        component.set("v.showspinner","false");    
       
    },
    MyAction : function(component, event, helper) {
        component.get("v.modelNumber");
    },
    gotoDetailesText: function(component, event, helper) {
        var monthArray=component.get("v.CurrentMonth").split(' ');
        var month=monthArray[0];
       // alert('2'+component.get("ServiceName"));
        var detailedTextEcent=$A.get("e.c:MB_Detail_text_Event");  
        detailedTextEcent.setParams({"ServiceName":component.get("v.ServiceName"),"CurrentMonth":component.get("v.CurrentMonth"),"deviceName":component.get("v.deviceName"),"deviceId":component.get("v.deviceId")}).fire();
    }, 
    //This method redirects to previous screen
    gotoDevices:function(component, event, helper) {
        var backEvent=$A.get("e.c:MB_Back_Evt");
        backEvent.setParams({"month":component.get("v.CurrentMonth"),"pagename":"MB_Devices"}).fire();
        
    }
})