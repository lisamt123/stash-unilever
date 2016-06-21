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
       		legend: {fontFamily: "Salesforce Sans",verticalAlign: "center", horizontalAlign: "right",fontSize: 15,},
                        axisY: {title: Domestic}, 
                        axisX: {title: International},
                        data: [	{type: "pie", //change it to column, spline, line, pie, etc
                                indexLabel: "{y}",showInLegend: true, indexLabelFontSize: 15,dataPoints: [{  y: (res.totalDomesticDataUsage),legendText:"Domestic", color:'#4F6A92'},{ y: (res.totalInternationalDataUsage),legendText:"Roaming", color:'#0C8EFF'},]  } ]});            
$("#pie2").CanvasJSChart({axisY: {title: Domestic,}, 
                        axisX: {title: International,},
                        legend :{verticalAlign: "center",horizontalAlign: "right" ,fontSize: 15,}, 
                        data: [{type: "pie", //change it to column, spline, line, pie, etc
                                indexLabel: "{y}",showInLegend: true,indexLabelFontSize: 15,dataPoints: [{ x: 10, y: (res.totalDomesticCallUsage),legendText:"Domestic",color:'#4F6A92' },{ x: 20, y: (res.totalInternationalCallUsage),legendText:"Roaming",color:'#0C8EFF' }]}]});      
 $("#pie3").CanvasJSChart({axisY: {title: Domestic,}, 
                        axisX: {title: International,},
                        legend :{verticalAlign: "center",horizontalAlign: "right" ,fontSize: 15,}, 
                        data: [{type: "pie", //change it to column, spline, line, pie, etc
                                indexLabel: "{y}",showInLegend: true,indexLabelFontSize: 15,dataPoints: [{ x: 50, y: (res.totalDomesticSMSUsage),legendText:"Domestic", color:'#4F6A92'},{ x: 20, y: (res.totalInternationalSMSUsage),legendText:"Roaming", color:'#0C8EFF'},]}]});            
 $("#pie4").CanvasJSChart({axisY: {title: Domestic,}, 
                        axisX: {title: International,},
                        legend :{verticalAlign: "center",horizontalAlign: "right",fontSize: 15,}, 
                        data: [{type: "pie", //change it to column, spline, line, pie, etc
                                indexLabel: "{y}",showInLegend: true,indexLabelFontSize: 15,dataPoints: [{ x: 10, y: (res.totalDomesticIpassUsage),legendText:"Domestic", color:'#4F6A92'},{ x: 20, y: (res.totalInternationalIpassUsage),legendText:"Roaming", color:'#0C8EFF'},]}]}); 
});
		 $A.enqueueAction(action);
        var action1 = component.get("c.getyourCollegueChargeType");
        action1.setParams({"month" : component.get("v.CurrentMonth"),"deviceId" : component.get("v.deviceId")});
        action1.setCallback(this, function(response){
            var res1;
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
               res1= response.getReturnValue(); 
            } 
/*--------------------------------for column or line charts----------------------------------------------------------------------*/        
            $("#column1").CanvasJSChart({axisY: {title: "" ,gridThickness: 0,labelFontSize:15,titleFontSize: 10,labelFontFamily:  "Salesforce Sans"}, 
                        axisX: {title: "",gridThickness: 0,labelFontSize:15,titleFontSize: 10,labelFontFamily:  "Salesforce Sans"},
                        legend :{verticalAlign: "center",horizontalAlign: "right",fontSize: 15,labelFontFamily:  "Salesforce Sans"}, 
                        data: [{type: "column",  indexLabelFontSize: 15,
                            indexLabel: "{y}", dataPoints: [{label:"You",  y: (res1.totalDataUsage),color:'#D72C32',fontSize: 15 },{ label:"Colleague", y: (res1.totalAverageDataUsage),color:'#0C8EFF',fontSize: 15},]}]});
 $("#column2").CanvasJSChart({
                        axisY: {title: "" ,gridThickness: 0,labelFontSize:15,titleFontSize: 10,labelFontFamily:  "Salesforce Sans"}, 
                        axisX: {title:"" ,gridThickness: 0,labelFontSize:15,titleFontSize: 10,labelFontFamily:  "Salesforce Sans"},
                        legend :{verticalAlign: "center",horizontalAlign: "right" ,fontSize: 15,}, 
                        data: [{type: "column",  indexLabelFontSize: 15,
                            indexLabel: "{y}",dataPoints: [{label:"You",  y: (res1.totalCallUsage),color:'#D72C32' },{ label:"Colleague", y: (res1.totalAverageCallUsage),color:'#0C8EFF'},]}]});   
 $("#column3").CanvasJSChart({axisY: {title: "" ,gridThickness: 0,labelFontSize:15,titleFontSize: 10,labelFontFamily:  "Salesforce Sans"}, 
                        axisX: {title: "" ,gridThickness: 0,labelFontSize:15,titleFontSize: 10,labelFontFamily:  "Salesforce Sans"},
                        legend :{verticalAlign: "center",horizontalAlign: "right" ,fontSize: 15,}, 
                        data: [{type: "column",  indexLabelFontSize: 15,
                            indexLabel: "{y}",dataPoints: [{label:"You",  y: (res1.totalMessageUsage),color:'#D72C32' },{ label:"Colleague", y: (res1.totalAverageMessageUsage),color:'#0C8EFF'}]}]});
 $("#column4").CanvasJSChart({axisY: {title: "" ,gridThickness: 0,labelFontSize:15,titleFontSize: 10,labelFontFamily:  "Salesforce Sans"}, 
                        axisX: {title: "" , gridThickness: 0,labelFontSize:15,titleFontSize: 10,labelFontFamily:  "Salesforce Sans"}, 
                        legend :{verticalAlign: "center",horizontalAlign: "right" ,fontSize: 15,}, 
                        data: [{type: "column",  indexLabelFontSize: 15,
                            indexLabel: "{y}",dataPoints: [{label:"Data",  y: (res1.totalIpassUsage),color:'#D72C32' },{ label:"iPass", y: (res1.totalAverageIpassUsage),color:'#0C8EFF'},] } ]});
                                                           
});    
        $A.enqueueAction(action1);
       
    }
})