({
     doinit : function(component, event, helper) {
        var action = component.get("c.getiPassChargeType");
        action.setParams({ "month" : component.get("v.CurrentMonth"),"UsageType" : component.get("v.UsageType")});
         action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
               var res= response.getReturnValue(); 
                component.set("v.result",res);
            } 
            /*This code is for charts and graphs*/
            helper.helperMethodforpieCharts3(component,res);
        });
         
        $A.enqueueAction(action);
       var action1 = component.get("c.getInsights"); 
       action1.setParams({ "month" : component.get("v.CurrentMonth")});
        action1.setCallback(this, function(response){
            var state = response.getState();  
            if (component.isValid() && state === "SUCCESS") {
                var res= response.getReturnValue();
                component.set("v.Avgresult",res);
            } 
            helper.helperMethodforpieChartsColumn3(component,res);
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
    gotoDevices:function(component, event, helper) {
        var backEvent=$A.get("e.c:MB_Back_Evt");
        backEvent.setParams({"month":component.get("v.CurrentMonth"),"pagename":"MB_Devices"}).fire();
        
    },
     gotoDetailesText: function(component, event, helper) {
        var monthArray=component.get("v.CurrentMonth").split(' ');
        var month=monthArray[0];
        
        var detailedTextEcent=$A.get("e.c:MB_iPass_Detail_Event");  
        detailedTextEcent.setParams({"CurrentMonth":component.get("v.CurrentMonth")}).fire();
    },
})