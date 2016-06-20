({
	helperMethod : function(component) {
		var action = component.get("c.getInsights"); 
       action.setParams({ "month" : component.get("v.CurrentMonth")});
        action.setCallback(this, function(response){
            var state = response.getState();  
            if (component.isValid() && state === "SUCCESS") {
                res= response.getReturnValue();
            }  
/*--------------------------------------------------------------------------*/       
        var actdata=(res.totalDataUsageIn);
        var avgdata=(res.totalAverageDataUsageIn);
        component.set("v.DataYou",actdata);
        component.set("v.DataColleagues",avgdata);
        var actdata1=component.get("v.DataYou"); 
        var avgdata1=component.get("v.DataColleagues");
        var avgdata2=(avgdata1/ (0.5*avgdata1+actdata1))*100;
        var actdata2=(actdata1/ (0.5*avgdata1+actdata1))*100;
        $('.line_bar_data').width(actdata2+'px');
        $('.line_bars_data').width(avgdata2+'px'); 
/*--------------------------------------------------------------------------*/                 
        var actCalls=(res.totalCallUsageIn);
        var avgCalls=(res.totalAverageCallUsageIn);
        component.set("v.CallsYou",actCalls);
        component.set("v.CallsColleagues",avgCalls);
        var actCalls1=component.get("v.CallsYou"); 
        var avgCalls1=component.get("v.CallsColleagues");
        var avgCalls2=(avgCalls1/ (0.5*avgCalls1+actCalls1))*100;  
        var actCalls2=(actCalls1 / (0.5*avgCalls1+actCalls1))*100;
        $('.line_bar_calls').width(actCalls2+'px');
        $('.line_bars_calls').width(avgCalls2+'px'); 
/*--------------------------------------------------------------------------*/                  
    var actSMS=(res.totalMessageUsageIn);
        var avgSMS=(res.totalAverageMessageUsageIn);
        component.set("v.SMSYou",actSMS);
        component.set("v.SMSColleagues",avgSMS); 
        var actSMS1=component.get("v.SMSYou");
        var avgSMS1=component.get("v.SMSColleagues");
        var avgSMS2=(avgSMS1/ (0.5*avgSMS1+actSMS1))*100;
        var actSMS2=(actSMS1 / (0.5*avgSMS1+actSMS1))*100;
        $('.line_bar_SMS').width(actSMS2+'px');
        $('.line_bars_SMS').width(avgSMS2+'px'); 
/*--------------------------------------------------------------------------*/        
       var actiPass=(res.totalIpassUsageIn);
        var avgiPass=(res.totalAverageIpassUsageIn);  
         component.set("v.iPassYou",actiPass);
         component.set("v.iPassColleagues",avgiPass);
        var actiPass1=component.get("v.iPassYou");
        var avgiPass1=component.get("v.iPassColleagues");
        var avgiPass2=(avgiPass1/ (0.5*avgiPass1+actiPass1))*100;
        var actiPass2=(actiPass1 / (0.5*avgiPass1+actiPass1))*100;
        $('.line_bar_iPass').width(parseInt(actiPass2)+'px');
        $('.line_bars_iPass').width(parseInt(avgiPass2)+'px');       
         });
		 $A.enqueueAction(action);
	}
})