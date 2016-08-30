({
    doInit : function(component, event, helper) {
        component.set("v.spinnercompClaritySub",true);
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
        var approvalHistory=component.get("v.ApprovalDetail")[0].ApprovalHistory;
        var endCount =[];
        var eCount=0;
        var aCount=0;
        for(var j=0;j<approvalHistory.length; j++)
        {
            if(approvalHistory[j].Role == 'END')
            {
                eCount++;
            }
            if(approvalHistory[j].Role == 'APP')
            {
                aCount++;
            }
        }
        for(var j=0;j<approvalHistory.length; j++)
        {
            if(approvalHistory[j].Role == 'END')
            {
                var val ='Endorser'+eCount;
                approvalHistory[j].Role = val;
                eCount--;
            }
            if(approvalHistory[j].Role == 'APP')
            {
                var val ='Approver'+aCount;
                approvalHistory[j].Role = val;
                aCount--;
            }
        }
        component.set("v.endCount",endCount); 
        if(PreTripDetails.PassengerInfo != undefined || PreTripDetails.PassengerInfo != null ){
            for(var i=0; i<2; i++)
            {  
                Passenger.push(PreTripDetails.PassengerInfo.split(',')[i]);     
            }
        }    
        component.set("v.Passenger",Passenger); 
        if(Currentyear1 != undefined || Currentyear1 != null ){
            for(var i=0; i<2; i++)
            {
                Currentyear.push(Currentyear1.split(',')[i]);
            }
        }
        component.set("v.Currentyear",Currentyear);
        for(var i=0; i<8; i++)
        {
            if(CompanyName != undefined || CompanyName != null ){
                compName.push(CompanyName.split(',')[i]);}
            if(Cop != undefined || Cop != null ){
                copData.push(Cop.split(',')[i]);}
            if(RequestedBy1 != undefined || RequestedBy1 != null ){
                RequestedBy.push(RequestedBy1.split(',')[i]);}
        }
        component.set("v.compName",compName);
        component.set("v.copData",copData);
        component.set("v.RequestedBy",RequestedBy); 
        if(RequestedByLang1 != undefined || RequestedByLang1 != null ){
            for(var i=0; i<7; i++)
            {
                RequestedByLang.push(RequestedByLang1.split(',')[i]);
            }
        }
        component.set("v.spinnercompClaritySub",false);
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