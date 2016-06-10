({
    doInit : function(component, event, helper) {       
        var PreTripDetails= component.get("v.ApprovalDetail")[0].PreTripDetails;
        var Currentyear1= component.get("v.ApprovalDetail")[0].Currentyear1;
        var CompanyName= component.get("v.ApprovalDetail")[0].CompanyName;
        var Cop= component.get("v.ApprovalDetail")[0].Cop;
        var RequestedBy1= component.get("v.ApprovalDetail")[0].RequestedBy;
        var RequestedByLang1= component.get("v.ApprovalDetail")[0].RequestedByLang;
        var Passenger = [];
        var Currentyear = [];
        var compName = [];
        var copData = [];
        var RequestedBy = [];
        var RequestedByLang = [];
        for(var i=0; i<2; i++)
        {
            Passenger.push(PreTripDetails.PassengerInfo.split(',')[i]);
        }
        component.set("v.Passenger",Passenger); 
        for(var i=0; i<2; i++)
        {
            Currentyear.push(Currentyear1.split(',')[i]);
        }
        component.set("v.Currentyear",Currentyear);
        for(var i=0; i<8; i++)
        {
            compName.push(CompanyName.split(',')[i]);
            copData.push(Cop.split(',')[i]);
            RequestedBy.push(RequestedBy1.split(',')[i]);
        }
        component.set("v.compName",compName);
        component.set("v.copData",copData);
        component.set("v.RequestedBy",RequestedBy); 
        for(var i=0; i<7; i++)
        {
            RequestedByLang.push(RequestedByLang1.split(',')[i]);
        }
        component.set("v.RequestedByLang",RequestedByLang);
    },
    gotoPreviousPage : function(component, event, helper) {    
        var approvalDetail = component.get("v.ApprovalDetail");     
        var selectEvent = $A.get("e.c:CORE_CA_DetailsEvent");   
        selectEvent.setParams({"RequestId": approvalDetail[0].RequestId,
                               "ApproverId": approvalDetail[0].ApproverId,
                               "Sourcesystem": approvalDetail[0].RequestType,
                               "sourcePage": component.get("v.sourcePage"),
                               "filterValue": component.get("v.filterValue")}).fire();
    }
})