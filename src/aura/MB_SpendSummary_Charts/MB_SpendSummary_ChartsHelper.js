({
	helperMethodforCharts : function(component) {
		/*------------------------------------------charts starts here----------------------------------------------------------*/        
        
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
               
            } 
 /*---------------------------for pie charts-----------------------------------------------------------------------*/        

$("#pie1").CanvasJSChart({ 
                        axisY: { 
                      		  title: Domestic
                        }, 
                        axisX: { 
                        	  title: International
                        },
                        legend :{ 
                              verticalAlign: "center", 
                              horizontalAlign: "right",
                              fontSize: 15,
                        }, 
                        data: [	
                        {
                        type: "pie", //change it to column, spline, line, pie, etc
                                indexLabel: "{y}",
                                showInLegend: true, 
                        dataPoints: [
                        
                        {  y: parseInt(res.totalDomesticDataUsage),legendText:Domestic, color:'#4E6990'},
                                                   
                        { y: parseInt(res.totalInternationalDataUsage),legendText:International, color:'#EEF1F6'},
                                                   
                        ]
                        }
                        ]
                    });            
$("#pie2").CanvasJSChart({ 
                        axisY: { 
                            title: Domestic, 
                        }, 
                        axisX: { 
                            title: International, 
                        },
                        legend :{ 
                            verticalAlign: "center", 
                            horizontalAlign: "right" ,
                            fontSize: 15,
                        }, 
                        data: [	
                            {
                                type: "pie", //change it to column, spline, line, pie, etc
                                indexLabel: "{y}",
                                showInLegend: true,
                                dataPoints: [
                                    
                                    { x: 10, y: parseInt(res.totalDomesticCallUsage),legendText:Domestic,color:'#4E6990' },
                                    { x: 20, y: parseInt(res.totalInternationalCallUsage),legendText:International,color:'#EEF1F6' }                            
                                ]
                            }
                        ]
                    });      
 $("#pie3").CanvasJSChart({ 
                      axisY: { 
                      		  title: Domestic,
                        }, 
                        axisX: { 
                        	  title: International,
                        },
                        legend :{ 
                              verticalAlign: "center", 
                              horizontalAlign: "right" ,
                              fontSize: 15,
                        }, 
                        data: [	
                        {
                                type: "pie", //change it to column, spline, line, pie, etc
                                indexLabel: "{y}",
                                showInLegend: true, 
                        dataPoints: [
                        
                        { x: 50, y: parseInt(res.totalDomesticSMSUsage),legendText:Domestic, color:'#4E6990'},
                                                   
                        { x: 20, y: parseInt(res.totalInternationalSMSUsage),legendText:International, color:'#EEF1F6'},
                                                   
                        ]
                        }
                        ]
                    });            
 $("#pie4").CanvasJSChart({ 
                        axisY: { 
                      		  title: Domestic, 
                        }, 
                        axisX: { 
                        	  title: International, 
                        },
                        legend :{ 
                              verticalAlign: "center", 
                              horizontalAlign: "right",
                              fontSize: 15,
                        }, 
                        data: [	
                        {
                                type: "pie", //change it to column, spline, line, pie, etc
                                indexLabel: "{y}",
                                showInLegend: true, 
                        dataPoints: [
                        
                        { x: 10, y: parseInt(res.totalDomesticIpassUsage),legendText:Domestic, color:'#4E6990'},
                                                   
                        { x: 20, y: parseInt(res.totalInternationalIpassUsage),legendText:International, color:'#EEF1F6'},
                                                   
                        ]
                        }
                        ]
                        });   
       });
		 $A.enqueueAction(action);
 /*--------------------------------for column or line charts----------------------------------------------------------------------*/        
          var action1 = component.get("c.getyourCollegueChargeType");
        action1.setParams({"month" : component.get("v.CurrentMonth")});
        action1.setCallback(this, function(response){
            var res1;
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
               res1= response.getReturnValue(); 
            }    
 $("#column1").CanvasJSChart({ 
                        axisY: { 
                            title: "" ,
                            gridThickness: 0,
                            labelFontSize:10,
                            titleFontSize: 10
                        }, 
                        axisX: { 
                             title: "",
                             gridThickness: 0,
                             labelFontSize:10,
                             titleFontSize: 10
                        },
                        legend :{ 
                            verticalAlign: "center", 
                            horizontalAlign: "right",
                            fontSize: 15,
                        }, 
                        data: [	
                        {	
                        type: "column", //change it to column, spline, line, pie, etc
                            indexLabel: "{y}",
                             
                        dataPoints: [
                             
                                {label:You,  y: parseInt(res1.totalDataUsage) },
                                { label:Colleague, y: parseInt(res1.totalAverageDataUsage)},
                                             
                            
                        ]
                    }
                    ]
                });
 $("#column2").CanvasJSChart({ 
                        axisY: { 
                            title: "" ,
                            gridThickness: 0
                        }, 
                        axisX: { 
                             title:"" ,
                            gridThickness: 0
                        },
                        legend :{ 
                            verticalAlign: "center", 
                            horizontalAlign: "right" ,
                            fontSize: 15,
                        }, 
                        data: [	
                        {
                        type: "column", //change it to column, spline, line, pie, etc
                            indexLabel: "{y}",
                             
                        dataPoints: [
                             
                                {label:You,  y: parseInt(res1.totalCallUsage) },
                                { label:Colleague, y: parseInt(res1.totalAverageCallUsage)},
                                             
                            
                        ]
                    }
                    ]
                });   
 $("#column3").CanvasJSChart({ 
                        axisY: { 
                            title: "" ,
                            gridThickness: 0
                        }, 
                        axisX: { 
                             title: "" ,
                            gridThickness: 0
                        },
                        legend :{ 
                            verticalAlign: "center", 
                            horizontalAlign: "right" ,
                            fontSize: 15,
                        }, 
                        data: [	
                        {
                        type: "column", //change it to column, spline, line, pie, etc
                            indexLabel: "{y}",
                             
                        dataPoints: [
                             
                                {label:You,  y: parseInt(res1.totalMessageUsage) },
                                { label:Colleague, y: parseInt(res1.totalAverageMessageUsage)},
                                             
                            
                        ]
                    }
                    ]
                });
 $("#column4").CanvasJSChart({ 
                        axisY: { 
                            title: "" ,
                            gridThickness: 0
                        }, 
                        axisX: { 
                             title: "" ,
                            gridThickness: 0
                        },
                        legend :{ 
                            verticalAlign: "center", 
                            horizontalAlign: "right" ,
                            fontSize: 15,
                        }, 
                        data: [	
                        {
                        type: "column", //change it to column, spline, line, pie, etc
                            indexLabel: "{y}",
                             
                        dataPoints: [
                             
                                {label:You,  y: parseInt(res1.totalIpassUsage) },
                                { label:Colleague, y: parseInt(res1.totalAverageIpassUsage)},
                                             
                            
                        ]
                    }
                    ]
                });
 /*--------------------------------------------------------------------------------------------------------------*/        
            
 });
		 $A.enqueueAction(action1);
         

	}
/*-------------------------------------------End of charts-------------------------------------------------------*/        
 
})