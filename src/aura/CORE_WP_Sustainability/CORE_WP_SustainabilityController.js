({
    getSustainability : function(component, event, helper) { 
       component.set("v.divWidth",50);
       var action = component.get("c.getSustainibilityValues");
       var workPlaceId=component.get("v.workplaceLocationId"); 
       action.setParams({
			"workPlaceId": workPlaceId
	   });
       action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {
                if(response.getReturnValue()!=''){       
                    component.set("v.sustainabilityDetail",response.getReturnValue());
                    /*var barChartData = {                        
                        labels: [response.getReturnValue().Sustainability_Month1_Label__c,response.getReturnValue().Sustainability_Month2_Label__c,response.getReturnValue().Sustainability_Month3_Label__c, response.getReturnValue().Sustainability_Target_Year_Label__c+"Target Value"],
                        datasets : [
                            {                                
                                fillColor : "red",
                                highlightFill : "yellow",
                                data : [response.getReturnValue().Sustainability_Month1_Value__c,response.getReturnValue().Sustainability_Month2_Value__c,response.getReturnValue().Sustainability_Month3_Value__c,response.getReturnValue().Sustainability_Target_Value__c]
                            }                            
                        ]
                    };
                    var ctx = document.getElementById("canvas").getContext("2d");
                    var chart = new Chart(ctx).HorizontalBar(barChartData, {
                        responsive: true,
                        barShowStroke: false
                    });  */ 
                    
                    var largestValue = Math.max(response.getReturnValue().targetYearValue,response.getReturnValue().firstMonthValue,response.getReturnValue().secondMonthValue,response.getReturnValue().thirdMonthValue);                    
                    
                    var targetYearValue = Math.round(((response.getReturnValue().targetYearValue/largestValue)*100)/2)+"%";
                    var firstMonthValue = Math.round(((response.getReturnValue().firstMonthValue/largestValue)*100)/2)+"%";
                    var secondMonthValue = Math.round(((response.getReturnValue().secondMonthValue/largestValue)*100)/2)+"%";
                    var thirdMonthValue = Math.round(((response.getReturnValue().thirdMonthValue/largestValue)*100)/2)+"%";
                    
                    document.getElementById("targetYearPannel").style.width = targetYearValue;
                    document.getElementById("firstMonthPannel").style.width = firstMonthValue;
                    document.getElementById("secondMonthPannel").style.width = secondMonthValue;
                    document.getElementById("thirdMonthPannel").style.width = thirdMonthValue;
                    //http://marvl.in/f07ieh  Pwd: news
                    document.getElementById("targetYearPannel").style.backgroundColor = "#A8B8D1" ;
                    
                    if(response.getReturnValue().targetYearValue<response.getReturnValue().firstMonthValue) {
                        document.getElementById("firstMonthPannel").style.backgroundColor = response.getReturnValue().monthValueHighColor;
                    } else {
                        document.getElementById("firstMonthPannel").style.backgroundColor = response.getReturnValue().monthValueLowColor;
                    }
                    if(response.getReturnValue().targetYearValue<response.getReturnValue().secondMonthValue) {
                        document.getElementById("secondMonthPannel").style.backgroundColor = response.getReturnValue().monthValueHighColor;
                    } else {
                        document.getElementById("secondMonthPannel").style.backgroundColor = response.getReturnValue().monthValueLowColor;
					}                    
                    if(response.getReturnValue().targetYearValue<response.getReturnValue().thirdMonthValue) {
                        document.getElementById("thirdMonthPannel").style.backgroundColor = response.getReturnValue().monthValueHighColor;
                    } else {
                        document.getElementById("thirdMonthPannel").style.backgroundColor = response.getReturnValue().monthValueLowColor;
                    }    
                    
                }
                else {
                    component.set("v.noDataErrorMessage", true);
                }
        	}                  
        });
        $A.enqueueAction(action);   
    },
    gotoPreviousPage: function(component, event, helper) {         
        var workplaceLocationId=component.get("v.workplaceLocationId");
        var selectEvent = $A.get("e.c:CORE_WP_WorkplaceEvent");
        selectEvent.setParams({"selectedWrokplaceId": workplaceLocationId,"WorkplacePannelType":"CORE_WP_WorkplaceHome"}).fire();
    },
})