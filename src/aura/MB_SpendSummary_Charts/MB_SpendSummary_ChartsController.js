({  
	doinit : function(component, event, helper) {
        helper.helperMethodforpieCharts(component);
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
     /*This code is for charts and graphs*/
      
       component.set("v.showspinner","false");
},

	MyAction : function(component, event, helper) {
		component.get("v.modelNumber");
	},
    gotoDetailesText: function(component, event, helper) {
        var monthArray=component.get("v.CurrentMonth").split(' ');
        var month=monthArray[0];
        
		var detailedTextEcent=$A.get("e.c:MB_Detail_text_Event");  
        detailedTextEcent.setParams({"CurrentMonth":component.get("v.CurrentMonth"),"deviceName":component.get("v.deviceName"),"deviceId":component.get("v.deviceId")}).fire();
	}, 
    //This method redirects to previous screen
    gotoDevices:function(component, event, helper) {
        var backEvent=$A.get("e.c:MB_Back_Evt");
        backEvent.setParams({"month":component.get("v.CurrentMonth"),"pagename":"MB_Devices"}).fire();
                                                    
    }
})