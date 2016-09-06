({
	loadMore : function(component, a) {
        var filter=component.get("v.filteroptions");
       var pendingData = [];
        for(var k=0; k<a.ExpenseData.length; k++)
        {
            pendingData.push(a.ExpenseData[k]);
        }
       var array = [];
       var arr = []; 
       var c= component.get("v.count");
        if(isNaN(c))
        {
            c=0;
        }
        if(filter != component.get("v.oldFilter"))
        {
            c=0;
        }
        var count=c+5;
        if(filter=='' || filter==undefined || filter=="All")
        {
            for(var l=0; l<pendingData.length; l++)
                {
                        arr.push(pendingData[l]);
                }
            component.set("v.oldFilter", filter);
            component.set("v.dataCount", pendingData.length);
        }
        else
        {
            for(var j=0; j<pendingData.length; j++)
                {
                    if(pendingData[j].ExpenseType==filter)
                    {
                        arr.push(pendingData[j]);
                    }
                }
            component.set("v.oldFilter", filter);
            component.set("v.dataCount", arr.length);
        }
        if(0<arr.length)
        {
            if(arr.length <= count)
            {
                count = arr.length;
                component.set("v.showMoreCount",false);
            }
            for(var i=0; i<count; i++)
        	{
            	array.push(arr[i]);
        	}
        	component.set("v.ApprovalData", array); 
            component.set("v.ApprovalDataCount", "true");
        	component.set("v.count",count);
        }
        if(arr.length==0)
        {
            component.set("v.ApprovalDataCount", "false");
            component.set("v.showMoreCount",false);
            
        }
        component.set("v.spinnercomp",false);  
	},
    
})