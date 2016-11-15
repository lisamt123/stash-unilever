trigger AF_Oops_POReport on AF_OOPS_Estimate__c (after insert,after update,before delete) {


Set<id> OopsEstids=new set<id>();
  Boolean deletePOReport=false;
  
  if(!Trigger.isDelete){
  for(AF_OOPS_Estimate__c  eachRecord:Trigger.new )   
    {
    OopsEstids.add(eachRecord.Id);
    }   
    }
    else if(Trigger.isDelete){
    for(AF_OOPS_Estimate__c  eachRecord:Trigger.old )   
    {
    OopsEstids.add(eachRecord.Id);
    }
    deletePOReport = true;
    }
    if(OopsEstids.size()>0){
    AF_GetBaseFeePOData.CreatePOReportFromOopsEstimate(OopsEstids,deletePOReport);
    }
 }