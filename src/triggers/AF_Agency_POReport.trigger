trigger AF_Agency_POReport on AF_Agency_Estimate__c (after insert,after update,before delete) {
    Set<id> AgencyEstids=new set<id>();
    Boolean deletePOReport=false;

    if(!Trigger.isDelete && !AF_brandEstimatehandlerHelper.testvar){
        system.debug('inside update....');
        for(AF_Agency_Estimate__c  eachRecord:Trigger.new )   
        {
            
            AgencyEstids.add(eachRecord.Id);
            
        }   
    }
    else if(Trigger.isDelete){
        system.debug('inside delete....');
        for(AF_Agency_Estimate__c  eachRecord:Trigger.old )   
        {
            AgencyEstids.add(eachRecord.Id);
        }
        deletePOReport = true;
    }
    if(AgencyEstids.size()>0 && !system.isBatch()){
        AF_GetBaseFeePOData.CreatePOReportFromAgencyEstimate(AgencyEstids,deletePOReport);
    }
    else if(AgencyEstids.size()>0 && system.isBatch()){
    AF_GetBaseFeePOData.BatchcreatePOReportFromAgencyEstimate(AgencyEstids,deletePOReport);
    }

}