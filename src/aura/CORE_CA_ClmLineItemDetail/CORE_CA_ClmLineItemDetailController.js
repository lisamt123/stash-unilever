({
	doInit : function(component, event, helper) {
      //  component.set("v.spinnercompline",true);
        var sourceSystem = component.get("v.subDivision");  
        var ApprovalDetail = component.get("v.ApprovalDetail");
        component.set("v.requestName",ApprovalDetail[0].RequestName);
         var lineItemList = component.get("v.lineItemId");
        var lineItemCount = component.set("v.lineItemCount",lineItemList.length);
         var arr = []; 
       var c= component.get("v.count");
        if(isNaN(c))
        {
            c=0;
        }
        var count=c+4;
        
        if(0<lineItemList.length)
        {
            if(lineItemList.length <= count)
            {
                count = lineItemList.length;
                component.set("v.showMoreCount",false);
            }
            for(var i=0; i<count; i++)
        	{
            	arr.push(lineItemList[i]);
        	}
        	component.set("v.count",count);
        }
        if(lineItemList.length==0)
        {
            component.set("v.showMoreCount",false);
            
        }
      //  alert(lineItemList[1].ItemName);
        component.set("v.lineItemList",arr);
    },
    gotoPreviousPage : function(component, event, helper) {    
        var approvalDetail = component.get("v.ApprovalDetail");     
        var selectEvent = $A.get("e.c:CORE_CA_DetailsEvent");
        selectEvent.setParams({"RequestId": approvalDetail[0].RequestId,
                               "ApproverId": approvalDetail[0].ApproverId,
                               "Sourcesystem": approvalDetail[0].RequestType,
                               "sourcePage": component.get("v.sourcePage"),
                               "filterValue": component.get("v.filterValue")}).fire();
    },

})