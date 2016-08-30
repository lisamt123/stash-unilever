({
	doInit : function(component, event, helper) {
        component.set("v.spinnercompline",true);
        var sourceSystem = component.get("v.subDivision");   
        if(sourceSystem == 'Ariba'){
            var action = component.get("c.getAribaLineItemDetailPageData");}
        if(sourceSystem == 'GTES'){
            var action = component.get("c.getGTESLineItemDetailPageData");}
        if(sourceSystem == 'Invoice'){  
            var action = component.get("c.getInvoiceLineItemDetail");}
        action.setParams({
			"LineItemID": component.get("v.lineItemId")
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var arr =[];
                if(sourceSystem == 'Invoice' && response.getReturnValue().IntOrder !=null)
                {
                   for(var i=0; i<2; i++)
                {
                    arr.push(response.getReturnValue().IntOrder.split(',')[i]);
                } 
                }
                component.set("v.LineItemDetail",response.getReturnValue());
                component.set("v.LineItemDetailInternalOrder",arr);
                component.set("v.PricingSuplierDetails",response.getReturnValue().PricingSuplierDetails);
                component.set("v.ExpenseDetails",response.getReturnValue().ExpenseDetails);
                component.set("v.TravelDetails",response.getReturnValue().TravelDetails);
                component.set("v.spinnercompline",false); 
                
            }
        });
        $A.enqueueAction(action); 
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
    showHide : function(component, event, helper) {
        if(event.srcElement.id != "up" && event.srcElement.id != "down")
        {
        var idd =event.srcElement.id+"2";
        var iid =event.srcElement.id+"3";
        var id =event.srcElement.id+"1";
        if(document.getElementById(id).style.display == "none")
        {	
            document.getElementById(id).style.display = "block";
            document.getElementById(iid).style.display = "none";
            document.getElementById(idd).style.display = "block";
        }
        else
        {
            document.getElementById(id).style.display = "none";
            document.getElementById(iid).style.display = "block";
            document.getElementById(idd).style.display = "none";
        }
        }
    },
})