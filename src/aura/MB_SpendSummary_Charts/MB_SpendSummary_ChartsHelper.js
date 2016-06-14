({
	helperMethodforpieCharts : function(component) {
        var Domestic= $A.get("$Label.c.MB_Domestic");
        var International= $A.get("$Label.c.MB_International");
        var You= $A.get("$Label.c.MB_You");
        var Colleague= $A.get("$Label.c.MB_Your_Colle");
        var res;
         console.log("month--"+component.get("v.CurrentMonth")+"id--"+component.get("v.deviceId"));
        var action = component.get("c.getChargeType");
        action.setParams({ "month" : component.get("v.CurrentMonth"),"deviceId" : component.get("v.deviceId")});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                res= response.getReturnValue(); 
                console.log("result length"+res.totalDomesticDataUsage);
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
                              fontSize: 12,
                        }, 
                        data: [	
                        {
                        type: "pie", //change it to column, spline, line, pie, etc
                                indexLabel: "{y}",
                                showInLegend: true, 
                        dataPoints: [
                        
                        {  y: (res.totalDomesticDataUsage),legendText:Domestic, color:'#4F6A92'},
                                                
                        { y: (res.totalInternationalDataUsage),legendText:International, color:'#0C8EFF'},
                                                   
                        ]  } ]
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
                            fontSize: 12,
                        }, 
                        data: [	
                            {
                                type: "pie", //change it to column, spline, line, pie, etc
                                indexLabel: "{y}",
                                showInLegend: true,
                                dataPoints: [
                                    
                                    { x: 10, y: (res.totalDomesticCallUsage),legendText:Domestic,color:'#4F6A92' },
                                    { x: 20, y: (res.totalInternationalCallUsage),legendText:International,color:'#0C8EFF' }                            
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
                              fontSize: 12,
                        }, 
                        data: [	
                        {
                                type: "pie", //change it to column, spline, line, pie, etc
                                indexLabel: "{y}",
                                showInLegend: true, 
                        dataPoints: [
                        
                        { x: 50, y: (res.totalDomesticSMSUsage),legendText:Domestic, color:'#4F6A92'},
                                                   
                        { x: 20, y: (res.totalInternationalSMSUsage),legendText:International, color:'#0C8EFF'},
                       ]}]
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
                              fontSize: 12,
                        }, 
                        data: [	
                        {
                                type: "pie", //change it to column, spline, line, pie, etc
                                indexLabel: "{y}",
                                showInLegend: true, 
                        dataPoints: [
                        { x: 10, y: (res.totalDomesticIpassUsage),legendText:Domestic, color:'#4F6A92'},                          
                        { x: 20, y: (res.totalInternationalIpassUsage),legendText:International, color:'#0C8EFF'},
                                                   
                        ]   }    ]     }); 
});
		 $A.enqueueAction(action);
        var action1 = component.get("c.getyourCollegueChargeType");
        action1.setParams({"month" : component.get("v.CurrentMonth")});
        action1.setCallback(this, function(response){
            var res1;
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
               res1= response.getReturnValue(); 
            } 
/*--------------------------------for column or line charts----------------------------------------------------------------------*/        
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
                                {label:You,  y: (res1.totalDataUsage),color:'#D72C32' },
                                { label:Colleague, y: (res1.totalAverageDataUsage),color:'#0C8EFF'},
                           ]}]
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
                                {label:You,  y: (res1.totalCallUsage),color:'#D72C32' },
                                { label:Colleague, y: (res1.totalAverageCallUsage),color:'#0C8EFF'},
                        ]}]
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
                                {label:You,  y: (res1.totalMessageUsage),color:'#D72C32' },
                                { label:Colleague, y: (res1.totalAverageMessageUsage),color:'#0C8EFF'}                           
                        ]  }   ]
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
                                {label:You,  y: (res1.totalIpassUsage),color:'#D72C32' },
                                { label:Colleague, y: (res1.totalAverageIpassUsage),color:'#0C8EFF'},
                          ] } ]
                });
                                                           
});    
        $A.enqueueAction(action1);
       
    }
})